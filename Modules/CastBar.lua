local _, ns = ...
local Core = ns.Core
local util = ns.util
local LibSharedMedia = LibStub("LibSharedMedia-3.0")

-- ═══════════════════════════════════════════════════
--  CastBar Module
--  (Adapted from PhoenixCastBars for YuXuanToolbox)
-- ═══════════════════════════════════════════════════

local BAR_UNITS = { player = "player", target = "target", focus = "focus" }
local POLL_INTERVAL = 0.10
local END_GRACE_SECONDS = 0.05
local TEXT_UPDATE_INTERVAL = 0.05
local GCD_SPELL_ID = 61304
local MIN_GCD_DURATION = 0.5
local NAMEPLATE_MAX = 40

local EVENTS = {
    "UNIT_SPELLCAST_START",
    "UNIT_SPELLCAST_STOP",
    "UNIT_SPELLCAST_FAILED",
    "UNIT_SPELLCAST_INTERRUPTED",
    "UNIT_SPELLCAST_DELAYED",
    "UNIT_SPELLCAST_SENT",
    "UNIT_SPELLCAST_CHANNEL_START",
    "UNIT_SPELLCAST_CHANNEL_STOP",
    "UNIT_SPELLCAST_CHANNEL_UPDATE",
    "UNIT_SPELLCAST_EMPOWER_START",
    "UNIT_SPELLCAST_EMPOWER_UPDATE",
    "UNIT_SPELLCAST_EMPOWER_STOP",
    "PLAYER_TARGET_CHANGED",
    "PLAYER_FOCUS_CHANGED",
    "PLAYER_ENTERING_WORLD",
    "VEHICLE_UPDATE",
}

-- ─── Config helpers ────────────────────────────────

local function CB()
    return Core.db.profile.castBar
end

local function BarDB(key)
    local cfg = CB()
    return cfg.bars and cfg.bars[key] or {}
end

local function IsBarEnabled(key)
    local bdb = BarDB(key)
    return bdb.enabled ~= false
end

-- ─── Safe helpers ──────────────────────────────────

local function SafeNow() return GetTime() end

local function TrySetTexture(obj, path)
    if not obj then return end
    pcall(function() obj:SetTexture(path) end)
end

local function TrySetFont(fs, font, size, flags)
    if not fs then return end
    pcall(function() fs:SetFont(font, size, flags) end)
end

local function TrySetText(fs, s)
    if not fs then return end
    pcall(function() fs:SetText(s or "") end)
end

local function TrySetStatusBarTexture(sb, tex)
    if not sb then return end
    pcall(function() sb:SetStatusBarTexture(tex) end)
end

local function TrySetMinMax(sb, a, b)
    if not sb then return end
    pcall(function() sb:SetMinMaxValues(a, b) end)
end

local function TrySetValue(sb, v)
    if not sb then return end
    pcall(function() sb:SetValue(v) end)
end

-- ─── Texture/Font resolution ───────────────────────

local function ResolveLSM(mediatype, key)
    if not key or key == "" then return nil end
    local ok, path = pcall(function() return LibSharedMedia:Fetch(mediatype, key) end)
    if ok and type(path) == "string" and path ~= "" then return path end
    return nil
end

local function ResolveTexturePath(cfg)
    local path = ResolveLSM("statusbar", cfg.texture)
    if path then return path end
    return "Interface\\TARGETINGFRAME\\UI-StatusBar"
end

local function ResolveFontPath(cfg)
    local path = ResolveLSM("font", cfg.font)
    if path then return path end
    return "Fonts\\FRIZQT__.TTF"
end

-- ─── Nameplate resolution ──────────────────────────

local function ResolveNameplateForUnit(unitToken)
    if not UnitExists(unitToken) then return unitToken end
    if not UnitIsEnemy("player", unitToken) then return unitToken end
    for i = 1, NAMEPLATE_MAX do
        local u = "nameplate" .. i
        if UnitExists(u) and UnitIsUnit(u, unitToken) then return u end
    end
    return unitToken
end

local function GetEffectiveUnit(f, unitHint)
    if f.key == "target" then
        if f._effectiveUnit and f._effectiveUnitActive then
            if UnitExists(f._effectiveUnit) and UnitExists("target") and UnitIsUnit(f._effectiveUnit, "target") then
                return f._effectiveUnit
            end
        end
        local u = ResolveNameplateForUnit("target")
        f._effectiveUnit = u
        return u
    elseif f.key == "focus" then
        if f._effectiveUnit and f._effectiveUnitActive then
            if UnitExists(f._effectiveUnit) and UnitExists("focus") and UnitIsUnit(f._effectiveUnit, "focus") then
                return f._effectiveUnit
            end
        end
        local u = ResolveNameplateForUnit("focus")
        f._effectiveUnit = u
        return u
    end
    if type(unitHint) == "string" and unitHint ~= "" then return unitHint end
    return BAR_UNITS[f.key] or "player"
end

-- ─── Backdrop ──────────────────────────────────────

local function CreateBackdrop(parent)
    local bg = CreateFrame("Frame", nil, parent, BackdropTemplateMixin and "BackdropTemplate" or nil)
    bg:SetPoint("TOPLEFT", parent, "TOPLEFT", -2, 2)
    bg:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 2, -2)
    bg:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    bg:SetBackdropColor(0.06, 0.06, 0.08, 0.85)
    bg:SetBackdropBorderColor(0.20, 0.20, 0.25, 0.95)
    return bg
end

-- ─── Create cast bar frame ─────────────────────────

local function CreateCastBarFrame(key)
    local container = CreateFrame("Frame", "YuXuanCastBar_Container_" .. key, UIParent)
    container:SetSize(260, 32)
    container:Hide()

    local f = CreateFrame("Frame", "YuXuanCastBar_" .. key, container)
    f:SetPoint("CENTER", container, "CENTER", 0, 0)
    f.key = key
    f.unit = BAR_UNITS[key]
    f.container = container
    f._latencySent = {}
    f._latency = 0
    f._pollElapsed = 0
    f._textElapsed = 0
    f._effectiveUnit = nil
    f._effectiveUnitActive = false
    f._endGraceUntil = nil
    f._state = nil

    f.bg = CreateBackdrop(f)

    f.bar = CreateFrame("StatusBar", nil, f)
    f.bar:SetAllPoints(f)
    TrySetMinMax(f.bar, 0, 1)
    TrySetValue(f.bar, 0)

    f.bar.bgTex = f.bar:CreateTexture(nil, "BACKGROUND")
    f.bar.bgTex:SetAllPoints(f.bar)
    f.bar.bgTex:SetTexture("Interface\\Buttons\\WHITE8x8")
    f.bar.bgTex:SetVertexColor(0, 0, 0, 0.35)

    -- Spark
    f.spark = f.bar:CreateTexture(nil, "OVERLAY")
    f.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
    f.spark:SetWidth(12)
    f.spark:SetBlendMode("ADD")
    f.spark:SetAlpha(0.85)
    f.spark:Hide()

    -- Latency safe zone
    f.safeZone = f.bar:CreateTexture(nil, "OVERLAY")
    f.safeZone:SetColorTexture(1, 0, 0, 0.35)
    f.safeZone:SetPoint("TOPRIGHT")
    f.safeZone:SetPoint("BOTTOMRIGHT")
    f.safeZone:Hide()

    -- Icon
    f.icon = f:CreateTexture(nil, "OVERLAY")
    f.icon:SetPoint("RIGHT", f, "LEFT", -6, 0)
    f.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    f.icon:Hide()

    -- Shield (not interruptible indicator)
    f.shield = f:CreateTexture(nil, "OVERLAY")
    f.shield:SetAllPoints(f.icon)
    f.shield:SetDrawLayer("OVERLAY", 7)
    f.shield:SetAtlas("nameplates-InterruptShield")
    f.shield:Hide()

    -- Text overlay
    f.textOverlay = CreateFrame("Frame", nil, f)
    f.textOverlay:SetAllPoints(f)
    f.textOverlay:SetFrameLevel(f:GetFrameLevel() + 20)

    f.spellText = f.textOverlay:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    f.spellText:SetJustifyH("LEFT")
    f.spellText:SetPoint("LEFT", f.bar, "LEFT", 6, 0)

    f.timeText = f.textOverlay:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    f.timeText:SetJustifyH("RIGHT")
    f.timeText:SetPoint("RIGHT", f.bar, "RIGHT", -6, 0)

    f.dragText = f.textOverlay:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    f.dragText:SetPoint("CENTER", f, "CENTER", 0, 0)
    f.dragText:SetTextColor(1, 1, 1, 0.6)
    f.dragText:Hide()

    -- Make container movable
    container:SetMovable(true)
    container:SetClampedToScreen(true)
    container:EnableMouse(false)
    container:RegisterForDrag()

    return f
end

-- ─── Visual helpers ────────────────────────────────

local function UpdateVisualSizes(f)
    local h = f:GetHeight()
    if type(h) ~= "number" or h <= 0 then h = 16 end
    local w = f:GetWidth()
    if type(w) ~= "number" or w <= 0 then w = 260 end
    if f.container then f.container:SetSize(w, h) end
    if f.icon then f.icon:SetSize(h + 2, h + 2) end
    if f.spark then f.spark:SetHeight(h) end
end

local function ApplyAppearance(f)
    local cfg = CB()
    local bdb = BarDB(f.key)

    if f.container then
        f.container:ClearAllPoints()
        f.container:SetPoint(bdb.point or "CENTER", UIParent, bdb.relPoint or "CENTER", bdb.x or 0, bdb.y or 0)
        f.container:SetAlpha(bdb.alpha or 1)
    end

    f:SetSize(bdb.width or 240, bdb.height or 16)
    f:SetScale(bdb.scale or 1)
    UpdateVisualSizes(f)

    local texPath = ResolveTexturePath(cfg)
    local fontPath = ResolveFontPath(cfg)
    local fontSize = cfg.fontSize or 12
    local flags = cfg.outline or "OUTLINE"
    if flags == "NONE" then flags = "" end

    TrySetStatusBarTexture(f.bar, texPath)
    TrySetFont(f.spellText, fontPath, fontSize, flags)
    TrySetFont(f.timeText, fontPath, fontSize, flags)
    if f.dragText then TrySetFont(f.dragText, fontPath, fontSize + 2, flags) end
end

local function ApplyCastBarColor(f)
    if not f or not f.bar then return end
    local cfg = CB()
    local st = f._state
    if not st then return end

    -- Non-interruptible target cast: red override
    if f.key == "target" and TargetFrameSpellBar and TargetFrameSpellBar.showShield == true then
        f.bar:SetStatusBarColor(0.85, 0.15, 0.15, 1)
        return
    end

    if st.kind == "channel" then
        local c = cfg.colorChannel or { r = 0.35, g = 0.90, b = 0.55, a = 1.0 }
        f.bar:SetStatusBarColor(c.r or 0.35, c.g or 0.90, c.b or 0.55, c.a or 1)
    elseif st.kind == "gcd" then
        f.bar:SetStatusBarColor(0.8, 0.8, 0.8, 0.6)
    else
        local c = cfg.colorCast or { r = 0.24, g = 0.56, b = 0.95, a = 1.0 }
        f.bar:SetStatusBarColor(c.r or 0.24, c.g or 0.56, c.b or 0.95, c.a or 1)
    end
end

-- ─── State management ──────────────────────────────

local function ResetState(f, forceHide)
    f._state = nil
    f._endGraceUntil = nil
    f._effectiveUnitActive = false
    f._textElapsed = 0
    TrySetMinMax(f.bar, 0, 1)
    TrySetValue(f.bar, 0)
    TrySetText(f.timeText, "")
    TrySetText(f.spellText, "")
    TrySetTexture(f.icon, nil)
    f.icon:Hide()
    if f.spark then f.spark:Hide() end
    if f.shield then f.shield:Hide() end
    if forceHide and CB().locked and not f.isMover then
        if f.container then f.container:Hide() end
        f:Hide()
    end
end

local function EnsureVisible(f)
    if f.container and not f.container:IsShown() then f.container:Show() end
    if not f:IsShown() then f:Show() end
end

-- ─── Cast reading ──────────────────────────────────

local function ReadUnitCast(unit)
    local name, _, texture, startMS, endMS = UnitCastingInfo(unit)
    local kind = "cast"
    if not name then
        name, _, texture, startMS, endMS = UnitChannelInfo(unit)
        if name then kind = "channel" end
    end
    if not name or not startMS or not endMS then return nil end
    local ok, startSec, endSec = pcall(function()
        return startMS / 1000, endMS / 1000
    end)
    if not ok then return nil end
    return kind, name, texture, startSec, endSec
end

local function SetIcon(f, texture)
    local bdb = BarDB(f.key)
    if bdb.showIcon == false then
        TrySetTexture(f.icon, nil)
        f.icon:Hide()
        return
    end
    if texture then
        TrySetTexture(f.icon, texture)
        f.icon:Show()
    else
        TrySetTexture(f.icon, nil)
        f.icon:Hide()
    end
end

local function SetTexts(f, name, remaining)
    local bdb = BarDB(f.key)
    if bdb.showSpellName ~= false then
        TrySetText(f.spellText, name or "")
    else
        TrySetText(f.spellText, "")
    end
    if bdb.showTime ~= true then
        TrySetText(f.timeText, "")
        return
    end
    if type(remaining) == "number" then
        pcall(function() f.timeText:SetFormattedText("%.1f", remaining) end)
    else
        TrySetText(f.timeText, "")
    end
end

-- ─── Cast bar logic ────────────────────────────────

local FrameOnUpdate -- forward declare

local function ShouldStillBeCasting(unit)
    return UnitCastingInfo(unit) ~= nil or UnitChannelInfo(unit) ~= nil
end

local function StartOrRefreshFromUnit(f, unitHint)
    local unit = GetEffectiveUnit(f, unitHint)
    local kind, name, texture, startSec, endSec = ReadUnitCast(unit)
    if not kind then return false end

    if (f.key == "target" or f.key == "focus") and unit ~= BAR_UNITS[f.key] then
        f._effectiveUnitActive = true
        f._effectiveUnit = unit
    end

    ApplyAppearance(f)
    SetIcon(f, texture)

    local st = f._state or {}
    f._state = st
    st.kind = kind
    st.unit = unit
    st.name = name
    st.texture = texture
    st.startSec = startSec
    st.endSec = endSec

    ApplyCastBarColor(f)

    local dur = endSec - startSec
    if dur <= 0 then dur = 1.5 end
    st.durationSec = dur

    TrySetMinMax(f.bar, 0, dur)
    if kind == "channel" then
        TrySetValue(f.bar, dur)
    else
        TrySetValue(f.bar, 0)
    end

    local bdb = BarDB(f.key)
    if bdb.showSpellName ~= false then
        TrySetText(f.spellText, name or "")
    else
        TrySetText(f.spellText, "")
    end

    f._pollElapsed = 0
    f._textElapsed = 0
    f._endGraceUntil = nil

    EnsureVisible(f)
    f:SetScript("OnUpdate", FrameOnUpdate)
    return true
end

local function StopIfReallyStopped(f, unitHint)
    if not f or not f._state then return end
    local unit = GetEffectiveUnit(f, unitHint or f._state.unit)
    local now = SafeNow()
    if f._endGraceUntil and now < f._endGraceUntil then return end
    if ShouldStillBeCasting(unit) then return end
    ResetState(f, true)
end

local function RefreshFrame(f, unitHint)
    if not f then return end
    if f.key and not IsBarEnabled(f.key) then
        ResetState(f, true)
        return
    end
    local unit = GetEffectiveUnit(f, unitHint)
    if not StartOrRefreshFromUnit(f, unit) then
        if f._state then
            f._endGraceUntil = SafeNow() + END_GRACE_SECONDS
            StopIfReallyStopped(f, unit)
        else
            ResetState(f, true)
        end
    end
end

FrameOnUpdate = function(f, elapsed)
    if not f or not f._state then
        f:SetScript("OnUpdate", nil)
        return
    end

    local st = f._state
    local now = SafeNow()

    -- Poll for unit changes / cast end
    f._pollElapsed = (f._pollElapsed or 0) + (elapsed or 0)
    if f._pollElapsed >= POLL_INTERVAL then
        f._pollElapsed = 0
        if f.key == "target" or f.key == "focus" then
            local u = GetEffectiveUnit(f, f.key)
            if u ~= st.unit then
                StartOrRefreshFromUnit(f, u)
                return
            end
        end
        StopIfReallyStopped(f, st.unit)
    end

    if not f._state then return end

    local remaining, elapsedSec
    if st.startSec and st.endSec then
        remaining = st.endSec - now
        elapsedSec = now - st.startSec
    end

    if not remaining or not elapsedSec then
        StopIfReallyStopped(f, st.unit)
        return
    end

    local dur = st.durationSec or 1
    remaining = math.max(0, math.min(remaining, dur))
    elapsedSec = math.max(0, math.min(elapsedSec, dur))

    if st.kind == "channel" then
        TrySetValue(f.bar, remaining)
    else
        TrySetValue(f.bar, elapsedSec)
    end

    -- Latency safe zone (player only)
    local bdb = BarDB(f.key)
    if f.key == "player" and f._latency and f._latency > 0 and dur > 0 then
        if bdb.showLatency ~= false then
            local latency = math.min(f._latency, dur)
            local ratio = latency / dur
            local width = f.bar:GetWidth()
            f.safeZone:SetWidth(width * ratio)
            f.safeZone:Show()
        else
            f.safeZone:Hide()
        end
    else
        f.safeZone:Hide()
    end

    -- Interrupt shield (target only)
    if f.key == "target" and TargetFrameSpellBar and f.shield and f.icon then
        local showShield = TargetFrameSpellBar.showShield == true
        if showShield then
            f.icon:Hide()
            f.shield:Show()
        else
            f.shield:Hide()
            if bdb.showIcon ~= false then f.icon:Show() end
        end
    end

    -- Spark
    if f.spark and f.bar then
        if bdb.showSpark ~= false then
            local tex = f.bar:GetStatusBarTexture()
            if tex then
                f.spark:ClearAllPoints()
                f.spark:SetPoint("CENTER", tex, "RIGHT", 0, 0)
                f.spark:Show()
            end
        else
            f.spark:Hide()
        end
    end

    -- Time text
    f._textElapsed = (f._textElapsed or 0) + (elapsed or 0)
    if f._textElapsed >= TEXT_UPDATE_INTERVAL then
        f._textElapsed = 0
        if bdb.showTime == true then
            local ok, s = pcall(string.format, "%.1f", remaining)
            if ok then TrySetText(f.timeText, s) else TrySetText(f.timeText, "") end
        else
            TrySetText(f.timeText, "")
        end
    end
end

-- ─── GCD bar ───────────────────────────────────────

local function GCD_OnUpdate(f, elapsed)
    if not f or not f._state then
        f:SetScript("OnUpdate", nil)
        return
    end
    local st = f._state
    local now = GetTime()
    if st.endSec and now >= st.endSec then
        if f.container then f.container:Hide() end
        f:Hide()
        f._state = nil
        f:SetScript("OnUpdate", nil)
        return
    end
    if f.bar and st.startSec then
        local elapsedTime = now - st.startSec
        f.bar:SetValue(elapsedTime)
        local bdb = BarDB("gcd")
        if f.spark and bdb.showSpark ~= false then
            local tex = f.bar:GetStatusBarTexture()
            if tex then
                f.spark:ClearAllPoints()
                f.spark:SetPoint("CENTER", tex, "RIGHT", 0, 0)
                f.spark:Show()
            end
        elseif f.spark then
            f.spark:Hide()
        end
    end
end

local function StartGCDBar(f)
    if not f or f.key ~= "gcd" then return end
    if not IsBarEnabled("gcd") then return end
    local cooldownInfo = C_Spell.GetSpellCooldown(GCD_SPELL_ID)
    if not cooldownInfo or not cooldownInfo.startTime or cooldownInfo.startTime == 0
        or not cooldownInfo.duration or cooldownInfo.duration == 0 then
        return
    end
    local start = cooldownInfo.startTime
    local duration = cooldownInfo.duration
    local now = GetTime()
    local endTime = start + duration
    if duration < MIN_GCD_DURATION or endTime <= now then return end

    ApplyAppearance(f)

    local st = f._state or {}
    f._state = st
    st.kind = "gcd"
    st.unit = "player"
    st.name = "GCD"
    st.startSec = start
    st.endSec = endTime
    st.durationSec = duration

    ApplyCastBarColor(f)

    if f.spellText then f.spellText:SetText("") end
    if f.bar then
        f.bar:SetMinMaxValues(0, duration)
        f.bar:SetValue(0)
    end

    f._pollElapsed = 0
    f._textElapsed = 0
    EnsureVisible(f)
    f:SetScript("OnUpdate", GCD_OnUpdate)
end

-- ─── Blizzard bar suppression ──────────────────────

local _blizzBarSnapshots = {}

local function SnapshotBar(bar)
    if not bar or _blizzBarSnapshots[bar] then return end
    local shown = bar:IsShown()
    local alpha = bar:GetAlpha()
    _blizzBarSnapshots[bar] = { shown = shown, alpha = alpha }
end

local function SuppressBar(bar)
    if not bar then return end
    SnapshotBar(bar)
    bar:SetAlpha(0)
    bar:Hide()
end

local function RestoreBar(bar)
    if not bar then return end
    local s = _blizzBarSnapshots[bar]
    if s then
        bar:SetAlpha(s.alpha)
        if s.shown then bar:Show() end
        _blizzBarSnapshots[bar] = nil
    else
        bar:SetAlpha(1)
    end
end

local function UpdateBlizzardCastBars()
    local cfg = CB()
    -- Player cast bars
    local playerBars = {}
    if PlayerCastingBarFrame then table.insert(playerBars, PlayerCastingBarFrame) end
    if PetCastingBarFrame then table.insert(playerBars, PetCastingBarFrame) end

    if cfg.hideBlizzardPlayer and IsBarEnabled("player") then
        for _, b in ipairs(playerBars) do SuppressBar(b) end
    else
        for _, b in ipairs(playerBars) do RestoreBar(b) end
    end

    -- Target cast bars
    local targetBar = TargetFrameSpellBar or (TargetFrame and TargetFrame.spellbar)
    if cfg.hideBlizzardTarget and IsBarEnabled("target") then
        if targetBar then SuppressBar(targetBar) end
    else
        if targetBar then RestoreBar(targetBar) end
    end

    -- Focus cast bar
    local focusBar = FocusFrameSpellBar or (FocusFrame and FocusFrame.spellbar)
    if cfg.hideBlizzardTarget and IsBarEnabled("focus") then
        if focusBar then SuppressBar(focusBar) end
    else
        if focusBar then RestoreBar(focusBar) end
    end
end

-- ─── Mover mode ────────────────────────────────────

local function EnableDragging(f)
    if f._dragEnabled then return end
    f._dragEnabled = true
    local frame = f.container or f
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self)
        if CB().locked then return end
        pcall(function() self:StartMoving() end)
    end)
    frame:SetScript("OnDragStop", function(self)
        pcall(function() self:StopMovingOrSizing() end)
        Core:SaveCastBarPosition(f)
    end)
end

local function DisableDragging(f)
    if not f._dragEnabled then return end
    f._dragEnabled = nil
    local frame = f.container or f
    frame:RegisterForDrag()
    frame:EnableMouse(false)
    frame:SetScript("OnDragStart", nil)
    frame:SetScript("OnDragStop", nil)
end

local function ShowMover(f)
    f.isMover = true
    EnsureVisible(f)
    TrySetMinMax(f.bar, 0, 1)
    TrySetValue(f.bar, 0.75)
    TrySetText(f.spellText, "")
    TrySetText(f.timeText, "")
    f.icon:Hide()
    if f.spark then f.spark:Hide() end
    if f.dragText then
        local labels = { player = "玩家", target = "目标", focus = "焦点", gcd = "GCD" }
        f.dragText:SetText(labels[f.key] or f.key)
        f.dragText:Show()
    end
    ApplyAppearance(f)
    -- Set a neutral color for mover
    if f.bar then f.bar:SetStatusBarColor(0.4, 0.6, 1.0, 0.8) end
end

local function HideMover(f)
    f.isMover = false
    if f.dragText then f.dragText:Hide() end
    if CB().locked and not f._state then
        if f.container then f.container:Hide() end
        f:Hide()
    end
end

-- ─── Public API ────────────────────────────────────

function Core:SaveCastBarPosition(f)
    if not f or not f.key then return end
    local cfg = self.db.profile.castBar
    cfg.bars = cfg.bars or {}
    cfg.bars[f.key] = cfg.bars[f.key] or {}
    local bdb = cfg.bars[f.key]
    local frame = f.container or f
    local point, _, relPoint, x, y = frame:GetPoint(1)
    if not point then return end
    bdb.point = point
    bdb.relPoint = relPoint or point
    bdb.x = math.floor(x + 0.5)
    bdb.y = math.floor(y + 0.5)
end

function Core:CreateCastBars()
    if self.castBarEventFrame then return end

    -- Create bars
    for key in pairs(BAR_UNITS) do
        if not self.castBars[key] then
            self.castBars[key] = CreateCastBarFrame(key)
            ApplyAppearance(self.castBars[key])
        end
    end
    if not self.castBars.gcd then
        self.castBars.gcd = CreateCastBarFrame("gcd")
        ApplyAppearance(self.castBars.gcd)
    end

    -- Event frame
    local ef = CreateFrame("Frame")
    for _, e in ipairs(EVENTS) do
        ef:RegisterEvent(e)
    end
    ef:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

    local function RefreshAllMatching(unitEvent)
        if not unitEvent then return end
        for key, f in pairs(self.castBars) do
            if f and key ~= "gcd" then
                local eff = GetEffectiveUnit(f, key)
                if unitEvent == f.unit or unitEvent == eff or unitEvent == f._effectiveUnit then
                    RefreshFrame(f, key)
                end
            end
        end
    end

    ef:SetScript("OnEvent", function(_, event, unit, ...)
        if event == "PLAYER_TARGET_CHANGED" then
            local f = self.castBars.target
            if f then
                f._effectiveUnit = nil
                f._effectiveUnitActive = false
                f._endGraceUntil = nil
                RefreshFrame(f, "target")
            end
            return
        end
        if event == "PLAYER_FOCUS_CHANGED" then
            local f = self.castBars.focus
            if f then
                f._effectiveUnit = nil
                f._effectiveUnitActive = false
                f._endGraceUntil = nil
                RefreshFrame(f, "focus")
            end
            return
        end
        if event == "PLAYER_ENTERING_WORLD" or event == "VEHICLE_UPDATE" then
            local f = self.castBars.player
            if f then RefreshFrame(f, "player") end
            return
        end
        if event == "UNIT_SPELLCAST_SUCCEEDED" and unit == "player" then
            local f = self.castBars.gcd
            if f then StartGCDBar(f) end
        end
        if event == "UNIT_SPELLCAST_SENT" and unit == "player" then
            local castGUID = select(2, ...)
            local f = self.castBars.player
            if f and castGUID and type(castGUID) == "string" then
                f._latencySent[castGUID] = GetTime()
            end
            return
        end
        if event == "UNIT_SPELLCAST_START" and unit == "player" then
            local castGUID = ...
            local f = self.castBars.player
            if f and castGUID then
                local sent = f._latencySent[castGUID]
                if sent then
                    f._latency = GetTime() - sent
                    f._latencySent[castGUID] = nil
                end
            end
        end
        -- 打断或失败时立即隐藏，跳过宽限期（修复闪烁）
        if event == "UNIT_SPELLCAST_FAILED"
            or event == "UNIT_SPELLCAST_INTERRUPTED" then
            if unit then
                for key, f in pairs(self.castBars) do
                    if f and key ~= "gcd" then
                        local eff = GetEffectiveUnit(f, key)
                        if unit == f.unit or unit == eff or unit == f._effectiveUnit then
                            ResetState(f, true)
                        end
                    end
                end
            end
            return
        end
        if unit then
            RefreshAllMatching(unit)
        end
    end)

    self.castBarEventFrame = ef

    -- Initial refresh
    for key, f in pairs(self.castBars) do
        if f and key ~= "gcd" then
            RefreshFrame(f, key)
        end
    end

    -- Blizzard suppression watcher
    local watcher = CreateFrame("Frame")
    watcher:RegisterEvent("PLAYER_ENTERING_WORLD")
    watcher:RegisterEvent("UI_SCALE_CHANGED")
    watcher:RegisterEvent("ADDON_LOADED")
    watcher:RegisterEvent("PLAYER_TARGET_CHANGED")
    watcher:RegisterEvent("PLAYER_FOCUS_CHANGED")
    watcher:RegisterUnitEvent("UNIT_SPELLCAST_START", "player", "vehicle", "target", "focus")
    watcher:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "player", "vehicle", "target", "focus")
    watcher:SetScript("OnEvent", function(_, ev, arg1)
        if ev ~= "ADDON_LOADED" or (type(arg1) == "string" and arg1:match("^Blizzard_")) then
            UpdateBlizzardCastBars()
        end
    end)
end

function Core:ApplyCastBarSettings()
    if not self.castBars then return end
    local cfg = self.db.profile.castBar

    for _, f in pairs(self.castBars) do
        local key = f and f.key
        if key and not IsBarEnabled(key) then
            ResetState(f, true)
        else
            ApplyAppearance(f)
            if f._state then ApplyCastBarColor(f) end
            if cfg.locked and not f._state and not f.isMover then
                if f.container then f.container:Hide() end
                f:Hide()
            end
        end
    end

    -- Mover mode
    if not cfg.locked then
        for _, f in pairs(self.castBars) do
            if f.key and IsBarEnabled(f.key) then
                ShowMover(f)
                EnableDragging(f)
            end
        end
    else
        for _, f in pairs(self.castBars) do
            DisableDragging(f)
            HideMover(f)
        end
    end

    UpdateBlizzardCastBars()
end
