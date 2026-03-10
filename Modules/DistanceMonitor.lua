local addonName, ns = ...
local Core = ns.Core
local LibSharedMedia = LibStub("LibSharedMedia-3.0")
local LibRangeCheck = LibStub("LibRangeCheck-3.0", true)

local ROW_HEIGHT = 30
local DEFAULT_UPDATE_INTERVAL = 0.2

local EXACT_UNIT_TOKENS = {
    "player",
    "party1", "party2", "party3", "party4",
}

for index = 1, 40 do
    EXACT_UNIT_TOKENS[#EXACT_UNIT_TOKENS + 1] = "raid" .. index
end

local function DMcfg()
    local profile = Core.db.profile
    profile.distanceMonitor = profile.distanceMonitor or {}
    local cfg = profile.distanceMonitor

    if cfg.enabled == nil then cfg.enabled = false end
    if cfg.locked == nil then cfg.locked = true end
    if cfg.font == nil or cfg.font == "" then cfg.font = "Friz Quadrata TT" end
    if cfg.fontSize == nil then cfg.fontSize = 14 end
    if cfg.updateInterval == nil then cfg.updateInterval = DEFAULT_UPDATE_INTERVAL end
    if cfg.rangeSeparator == nil or cfg.rangeSeparator == "" then cfg.rangeSeparator = " - " end
    if cfg.showBackground == nil then cfg.showBackground = true end
    if cfg.showBorder == nil then cfg.showBorder = true end
    if type(cfg.backgroundColor) ~= "table" then
        cfg.backgroundColor = { r = 0, g = 0, b = 0, a = 0.32 }
    elseif cfg.backgroundColor.a == nil then
        cfg.backgroundColor.a = 0.32
    end
    if type(cfg.borderColor) ~= "table" then
        cfg.borderColor = { r = 0, g = 0.6, b = 1, a = 0.45 }
    elseif cfg.borderColor.a == nil then
        cfg.borderColor.a = 0.45
    end
    if not cfg.point then
        cfg.point = {
            point = "CENTER",
            relativePoint = "CENTER",
            x = -220,
            y = -20,
        }
    end

    return cfg
end

local function CreateSimpleOutline(parent, layer, thickness)
    local border = {}
    local size = thickness or 1

    border.top = parent:CreateTexture(nil, layer or "BORDER")
    border.top:SetPoint("TOPLEFT", parent, "TOPLEFT", -size, size)
    border.top:SetPoint("TOPRIGHT", parent, "TOPRIGHT", size, size)
    border.top:SetHeight(size)

    border.bottom = parent:CreateTexture(nil, layer or "BORDER")
    border.bottom:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", -size, -size)
    border.bottom:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", size, -size)
    border.bottom:SetHeight(size)

    border.left = parent:CreateTexture(nil, layer or "BORDER")
    border.left:SetPoint("TOPLEFT", parent, "TOPLEFT", -size, size)
    border.left:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", -size, -size)
    border.left:SetWidth(size)

    border.right = parent:CreateTexture(nil, layer or "BORDER")
    border.right:SetPoint("TOPRIGHT", parent, "TOPRIGHT", size, size)
    border.right:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", size, -size)
    border.right:SetWidth(size)

    return border
end

local function SetSimpleOutlineColor(border, r, g, b, a)
    if type(border) ~= "table" then return end
    for _, edge in pairs(border) do
        edge:SetColorTexture(r or 0, g or 0, b or 0, a or 0)
    end
end

local function ResolveExactUnitToken(unit)
    if type(UnitExists) ~= "function" or not UnitExists(unit) then
        return nil
    end

    if UnitIsUnit and UnitIsUnit(unit, "player") then
        return "player"
    end

    if type(UnitGUID) ~= "function" then
        return unit
    end

    local unitGuid = UnitGUID(unit)
    if not unitGuid then
        return unit
    end

    for _, token in ipairs(EXACT_UNIT_TOKENS) do
        if UnitExists(token) and UnitGUID(token) == unitGuid then
            return token
        end
    end

    return unit
end

local function GetExactDistance(unit)
    if type(UnitExists) ~= "function" or not UnitExists(unit) then
        return nil
    end

    local exactUnit = ResolveExactUnitToken(unit)
    if not exactUnit then
        return nil
    end

    if type(UnitDistanceSquared) == "function" then
        local squaredDistance, checkedDistance = UnitDistanceSquared(exactUnit)
        if checkedDistance and type(squaredDistance) == "number" and squaredDistance >= 0 then
            return math.sqrt(squaredDistance)
        end
    end

    if type(UnitPosition) ~= "function" then
        return nil
    end

    local px, py, pz, pMap = UnitPosition("player")
    local ux, uy, uz, uMap = UnitPosition(exactUnit)
    if not (px and py and ux and uy) then
        return nil
    end

    if pMap and uMap and pMap ~= uMap then
        return nil
    end

    local dx = px - ux
    local dy = py - uy
    local dz = ((pz or 0) - (uz or 0))
    local distance = math.sqrt(dx * dx + dy * dy + dz * dz)
    if distance >= 0 then
        return distance
    end

    return nil
end

local function GetRangeCheckText(unit)
    if not LibRangeCheck or type(LibRangeCheck.GetRange) ~= "function" then
        return nil, nil
    end

    local separator = DMcfg().rangeSeparator
    if type(separator) ~= "string" or separator == "" then
        separator = " - "
    end

    local minRange, maxRange = LibRangeCheck:GetRange(unit)
    if not minRange then
        return nil, nil
    end

    if maxRange then
        if minRange <= 0 then
            return maxRange, string.format("≤%d", maxRange)
        end

        return minRange, string.format("%d%s%d", minRange, separator, maxRange)
    end

    return minRange, string.format("%d+", minRange)
end

local function GetDistanceInfo(unit)
    local exactDistance = GetExactDistance(unit)
    if exactDistance then
        return exactDistance, true, string.format("%.1f", exactDistance)
    end

    local fallbackDistance, fallbackText = GetRangeCheckText(unit)
    if fallbackDistance then
        return fallbackDistance, false, fallbackText
    end

    return nil, false, "--"
end

local function GetDistanceColor(distance)
    if not distance then
        return 0.7, 0.7, 0.7
    elseif distance <= 8 then
        return 0.2, 1, 0.35
    elseif distance <= 15 then
        return 1, 0.9, 0.2
    elseif distance <= 30 then
        return 1, 0.55, 0.2
    else
        return 1, 0.2, 0.2
    end
end

function Core:SaveDistanceMonitorPosition()
    if not self.distanceMonitorFrame then return end
    local point, _, relativePoint, x, y = self.distanceMonitorFrame:GetPoint(1)
    local pos = DMcfg().point
    pos.point = point or "CENTER"
    pos.relativePoint = relativePoint or "CENTER"
    pos.x = math.floor((x or 0) + 0.5)
    pos.y = math.floor((y or 0) + 0.5)
end

function Core:UpdateDistanceMonitorVisibility()
    if not self.distanceMonitorFrame then return end
    if DMcfg().enabled and type(UnitExists) == "function" and UnitExists("target") then
        self.distanceMonitorFrame:Show()
    else
        self.distanceMonitorFrame:Hide()
    end
end

function Core:UpdateDistanceMonitorLayout()
    if not self.distanceMonitorFrame then return end

    local cfg = DMcfg()
    local frame = self.distanceMonitorFrame
    local fontPath = LibSharedMedia:Fetch("font", cfg.font) or STANDARD_TEXT_FONT

    frame:SetMovable(not cfg.locked)
    frame.text:SetFont(fontPath, cfg.fontSize or 14, "OUTLINE")
    frame.text:SetPoint("LEFT", frame, "LEFT", 10, 0)
    frame.text:SetPoint("RIGHT", frame, "RIGHT", -10, 0)

    local width = math.max(160, math.ceil(frame.text:GetStringWidth() + 24))
    frame:SetSize(width, ROW_HEIGHT)

    if cfg.showBackground then
        local bg = cfg.backgroundColor or { r = 0, g = 0, b = 0, a = 0.32 }
        frame.bg:SetColorTexture(bg.r or 0, bg.g or 0, bg.b or 0, bg.a or 0.32)
    else
        frame.bg:SetColorTexture(0, 0, 0, 0)
    end

    if cfg.showBorder then
        local border = cfg.borderColor or { r = 0, g = 0.6, b = 1, a = 0.45 }
        SetSimpleOutlineColor(frame.border, border.r or 0, border.g or 0.6, border.b or 1, border.a or 0.45)
    else
        SetSimpleOutlineColor(frame.border, 0, 0, 0, 0)
    end
end

function Core:RefreshDistanceMonitor()
    if not self.distanceMonitorFrame then return end

    local frame = self.distanceMonitorFrame
    if type(UnitExists) == "function" and UnitExists("target") then
        local distance, _, rangeText = GetDistanceInfo("target")
        local r, g, b = GetDistanceColor(distance)
        frame.text:SetText(rangeText)
        frame.text:SetTextColor(r, g, b, 1)
    else
        frame.text:SetText("--")
        frame.text:SetTextColor(0.7, 0.7, 0.7, 1)
    end

    self:UpdateDistanceMonitorLayout()
    self:UpdateDistanceMonitorVisibility()
end

function Core:ApplyDistanceMonitorSettings()
    if not self.distanceMonitorFrame then return end
    self:RefreshDistanceMonitor()
end

function Core:CreateDistanceMonitorFrame()
    if self.distanceMonitorFrame then return end

    local cfg = DMcfg()
    local frame = CreateFrame("Frame", addonName .. "DistanceMonitorFrame", UIParent)
    frame:SetFrameStrata("MEDIUM")
    frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")

    frame.bg = frame:CreateTexture(nil, "BACKGROUND")
    frame.bg:SetAllPoints(frame)
    frame.border = CreateSimpleOutline(frame, "BORDER", 1)

    frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.text:SetJustifyH("LEFT")
    frame.text:SetPoint("LEFT", frame, "LEFT", 10, 0)
    frame.text:SetPoint("RIGHT", frame, "RIGHT", -10, 0)

    local pos = cfg.point
    frame:SetPoint(pos.point or "CENTER", UIParent, pos.relativePoint or "CENTER", pos.x or -220, pos.y or -20)

    frame:SetScript("OnDragStart", function(self)
        if DMcfg().locked then return end
        self:StartMoving()
    end)

    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        Core:SaveDistanceMonitorPosition()
    end)

    frame:SetSize(180, ROW_HEIGHT)

    frame:SetScript("OnEvent", function(_, event)
        if event == "PLAYER_ENTERING_WORLD"
            or event == "PLAYER_TARGET_CHANGED"
            or event == "PLAYER_FOCUS_CHANGED"
            or event == "UPDATE_MOUSEOVER_UNIT"
            or event == "GROUP_ROSTER_UPDATE"
            or event == "ZONE_CHANGED_NEW_AREA"
            or event == "ZONE_CHANGED"
            or event == "ZONE_CHANGED_INDOORS"
            or event == "PLAYER_STARTED_MOVING"
            or event == "PLAYER_STOPPED_MOVING"
            or event == "NEW_WMO_CHUNK" then
            Core:RefreshDistanceMonitor()
        end
    end)
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:RegisterEvent("PLAYER_TARGET_CHANGED")
    frame:RegisterEvent("PLAYER_FOCUS_CHANGED")
    frame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
    frame:RegisterEvent("GROUP_ROSTER_UPDATE")
    frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    frame:RegisterEvent("ZONE_CHANGED")
    frame:RegisterEvent("ZONE_CHANGED_INDOORS")
    frame:RegisterEvent("PLAYER_STARTED_MOVING")
    frame:RegisterEvent("PLAYER_STOPPED_MOVING")
    frame:RegisterEvent("NEW_WMO_CHUNK")

    frame:SetScript("OnUpdate", function(self, elapsed)
        self._elapsed = (self._elapsed or 0) + elapsed
        local interval = math.max(0.05, math.min(1, tonumber(DMcfg().updateInterval) or DEFAULT_UPDATE_INTERVAL))
        if self._elapsed >= interval then
            self._elapsed = 0
            Core:RefreshDistanceMonitor()
        end
    end)

    self.distanceMonitorFrame = frame
    self:ApplyDistanceMonitorSettings()
end
