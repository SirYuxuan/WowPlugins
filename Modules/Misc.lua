-- ============================================================
-- Modules/Misc.lua
-- 雨轩工具箱 · 杂项综合模块
--
-- 包含以下子功能（未来可进一步拆分）：
--   · 专精/天赋信息条（InfoBar）
--   · 任务助手（QuestTools）
--   · 团队标记条（RaidMarkers）
--   · 升级提示（LevelingTip）
--   · 地下堡快速离开（DelveQuickLeave）
--   · 收益计时器（Timer）
--   · 系统调节（Tooltip/目标箭头/NPC时间）
-- ============================================================
local addonName, ns = ...
local Core = ns.Core
local LibSharedMedia = LibStub("LibSharedMedia-3.0")
local band = bit and bit.band   -- 位运算：按位与（用于 NPC GUID 解析）
local rshift = bit and bit.rshift  -- 位运算：右移（用于 NPC GUID 解析）

local INFOBAR_PADDING_X = 10
local INFOBAR_PADDING_Y = 8
local INFOBAR_SPACING = 18
local ICON_SIZE_BAR = 16 -- 展示条上的图标大小
local INFOBAR_TALENT_MAX_CHARS = 10
local DELVE_QUICK_LEAVE_DEFAULT_SIZE = 40
local DELVE_QUICK_LEAVE_MIN_SIZE = 24
local DELVE_QUICK_LEAVE_MAX_SIZE = 72
local DELVE_QUICK_LEAVE_ICON = "Interface\\Icons\\spell_arcane_teleportdalaran"
local RAID_MARKERS_DEFAULT_SIZE = 28
local RAID_MARKERS_MIN_SIZE = 20
local RAID_MARKERS_MAX_SIZE = 48
local RAID_MARKERS_DEFAULT_SPACING = 6
local RAID_MARKERS_DEFAULT_COUNTDOWN = 6
local RAID_MARKERS_BUTTON_PADDING = 4
local RAID_MARKERS_BUTTON_BORDER = 1
local MENU_WIDTH = 220
local MENU_TITLE_HEIGHT = 24
local MENU_ITEM_HEIGHT = 22
local MENU_PADDING = 8
local DURABILITY_SLOTS = {
    [1]  = "头部",
    [3]  = "肩部",
    [5]  = "胸部",
    [6]  = "腰部",
    [7]  = "腿部",
    [8]  = "脚部",
    [9]  = "手腕",
    [10] = "手部",
    [16] = "主手",
    [17] = "副手",
}

local RAID_TARGET_BUTTONS = {
    { key = "STAR", index = 1, label = "星星", texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_1" },
    { key = "CIRCLE", index = 2, label = "大饼", texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_2" },
    { key = "DIAMOND", index = 3, label = "钻石", texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_3" },
    { key = "TRIANGLE", index = 4, label = "三角", texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_4" },
    { key = "MOON", index = 5, label = "月亮", texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_5" },
    { key = "SQUARE", index = 6, label = "方块", texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_6" },
    { key = "CROSS", index = 7, label = "叉叉", texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_7" },
    { key = "SKULL", index = 8, label = "骷髅", texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_8" },
}

local RAID_ACTION_BUTTONS = {
    {
        key = "CLEAR",
        label = "清",
        texture = "Interface\\Buttons\\UI-GroupLoot-Pass-Up",
        tooltipTitle = "清除标记",
        tooltipText = "清除当前目标的团队标记。",
    },
    {
        key = "READY",
        label = "就",
        texture = "Interface\\RaidFrame\\ReadyCheck-Ready",
        tooltipTitle = "团队就位",
        tooltipText = "发起就位确认。",
    },
    {
        key = "COUNTDOWN",
        label = "倒",
        texture = nil,
        tooltipTitle = "倒计时",
        tooltipText = "按设定秒数发起团队倒计时。",
    },
}

local function MIcfg()
    local cfg = Core.db.profile.misc
    if cfg.questToolsEnabled == nil then
        cfg.questToolsEnabled = (cfg.autoAnnounceQuest or cfg.autoQuestTurnIn) and true or false
    end
    if cfg.questToolsLocked == nil then
        cfg.questToolsLocked = true
    end
    if cfg.autoAnnounceQuest == nil then
        cfg.autoAnnounceQuest = cfg.announceQuestAccept or cfg.announceQuestTurnIn or false
    end
    if cfg.barSpacing == nil then
        cfg.barSpacing = INFOBAR_SPACING
    end
    if cfg.questToolsSpacing == nil then
        cfg.questToolsSpacing = INFOBAR_SPACING
    end
    if cfg.levelingTipHideAtMaxLevel == nil then
        cfg.levelingTipHideAtMaxLevel = true
    end
    if cfg.infoBarOrientation ~= "VERTICAL" then
        cfg.infoBarOrientation = "HORIZONTAL"
    end
    if cfg.questToolsOrientation ~= "VERTICAL" then
        cfg.questToolsOrientation = "HORIZONTAL"
    end
    if cfg.raidMarkersEnabled == nil then
        cfg.raidMarkersEnabled = false
    end
    if cfg.raidMarkersLocked == nil then
        cfg.raidMarkersLocked = true
    end
    if cfg.raidMarkersOrientation ~= "VERTICAL" then
        cfg.raidMarkersOrientation = "HORIZONTAL"
    end
    if cfg.raidMarkersSpacing == nil then
        cfg.raidMarkersSpacing = RAID_MARKERS_DEFAULT_SPACING
    end
    if cfg.raidMarkersIconSize == nil then
        cfg.raidMarkersIconSize = RAID_MARKERS_DEFAULT_SIZE
    end
    if cfg.raidMarkersCountdown == nil then
        cfg.raidMarkersCountdown = RAID_MARKERS_DEFAULT_COUNTDOWN
    end
    if cfg.raidMarkersShowBackground == nil then
        cfg.raidMarkersShowBackground = true
    end
    if cfg.raidMarkersShowBorder == nil then
        cfg.raidMarkersShowBorder = true
    end
    if type(cfg.raidMarkersBackgroundColor) ~= "table" then
        cfg.raidMarkersBackgroundColor = { r = 0, g = 0, b = 0, a = 0.35 }
    elseif cfg.raidMarkersBackgroundColor.a == nil then
        cfg.raidMarkersBackgroundColor.a = 0.35
    end
    if type(cfg.raidMarkersBorderColor) ~= "table" then
        cfg.raidMarkersBorderColor = { r = 0, g = 0.6, b = 1, a = 0.45 }
    elseif cfg.raidMarkersBorderColor.a == nil then
        cfg.raidMarkersBorderColor.a = 0.45
    end
    if type(cfg.textColor) ~= "table" then
        cfg.textColor = { r = 1, g = 1, b = 1 }
    end
    if not cfg.questToolsFont or cfg.questToolsFont == "" then
        cfg.questToolsFont = cfg.font or "Friz Quadrata TT"
    end
    if not cfg.questToolsFontSize then
        cfg.questToolsFontSize = cfg.fontSize or 13
    end
    if type(cfg.questToolsTextColor) ~= "table" then
        cfg.questToolsTextColor = { r = 1, g = 1, b = 1 }
    end
    if not cfg.questToolsPoint then
        cfg.questToolsPoint = {
            point = "CENTER",
            relativePoint = "CENTER",
            x = 0,
            y = -110,
        }
    end
    if not cfg.raidMarkersPoint then
        cfg.raidMarkersPoint = {
            point = "CENTER",
            relativePoint = "CENTER",
            x = 0,
            y = -30,
        }
    end
    if cfg.delveQuickLeaveEnabled == nil then
        cfg.delveQuickLeaveEnabled = false
    end
    if cfg.delveQuickLeaveLocked == nil then
        cfg.delveQuickLeaveLocked = true
    end
    if cfg.delveQuickLeaveIconSize == nil then
        cfg.delveQuickLeaveIconSize = DELVE_QUICK_LEAVE_DEFAULT_SIZE
    end
    if not cfg.delveQuickLeaveIconPreset or cfg.delveQuickLeaveIconPreset == "" then
        cfg.delveQuickLeaveIconPreset = DELVE_QUICK_LEAVE_ICON
    end
    if cfg.delveQuickLeaveCustomIcon == nil then
        cfg.delveQuickLeaveCustomIcon = ""
    end
    if not cfg.delveQuickLeavePoint then
        cfg.delveQuickLeavePoint = {
            point = "CENTER",
            relativePoint = "CENTER",
            x = 180,
            y = -20,
        }
    end
    if not cfg.announceTemplate or cfg.announceTemplate == "" then
        cfg.announceTemplate = "|cFF33FF99【雨轩工具箱】|r |cFFFFFF00{action}|r：{quest}"
    end
    return cfg
end

local function IsFunctionAvailable(tbl, key)
    return type(tbl) == "table" and type(tbl[key]) == "function"
end

local function Defer(callback)
    if not callback then return end
    if C_Timer and C_Timer.After then
        C_Timer.After(0, callback)
    else
        callback()
    end
end

local function Utf8Truncate(text, maxChars)
    if type(text) ~= "string" or text == "" or not maxChars or maxChars < 1 then
        return text or ""
    end

    local count = 0
    local lastByte = 0
    for startPos, codepoint in text:gmatch("()([%z\1-\127\194-\244][\128-\191]*)") do
        count = count + 1
        lastByte = startPos + #codepoint - 1
        if count >= maxChars then
            if lastByte < #text then
                return text:sub(1, lastByte) .. "..."
            end
            return text
        end
    end

    return text
end

local function RGBToHex(r, g, b)
    local rr = math.floor(math.max(0, math.min(1, tonumber(r) or 1)) * 255 + 0.5)
    local gg = math.floor(math.max(0, math.min(1, tonumber(g) or 1)) * 255 + 0.5)
    local bb = math.floor(math.max(0, math.min(1, tonumber(b) or 1)) * 255 + 0.5)
    return string.format("%02X%02X%02X", rr, gg, bb)
end

local function GetInfoBarTextColorHex()
    local color = MIcfg().textColor or {}
    return RGBToHex(color.r, color.g, color.b)
end

local function GetQuestToolsTextColorHex()
    local color = MIcfg().questToolsTextColor or {}
    return RGBToHex(color.r, color.g, color.b)
end

local function GetVisibleInfoBarButtons(frame, cfg)
    local buttons = {}
    if frame.specButton then
        table.insert(buttons, frame.specButton)
    end
    if frame.durabilityButton then
        table.insert(buttons, frame.durabilityButton)
    end
    return buttons
end

local function GetVisibleQuestToolsButtons(frame)
    local buttons = {}
    if frame.announceButton then
        table.insert(buttons, frame.announceButton)
    end
    if frame.turnInButton then
        table.insert(buttons, frame.turnInButton)
    end
    return buttons
end

local function GetVisibleRaidMarkersButtons(frame)
    local buttons = {}
    if not frame or not frame.buttons then
        return buttons
    end

    for _, button in ipairs(frame.buttons) do
        table.insert(buttons, button)
    end

    return buttons
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

local function SetRaidMarkerButtonHoverTarget(button, targetScale)
    if not button then return end
    button._hoverTargetScale = targetScale or 1
    if button._hoverAnimating then
        return
    end

    button._hoverAnimating = true
    button:SetScript("OnUpdate", function(self, elapsed)
        local current = self._hoverScale or 1
        local target = self._hoverTargetScale or 1
        local nextScale = current + (target - current) * math.min(1, elapsed * 7)

        if math.abs(target - nextScale) < 0.01 then
            nextScale = target
        end

        self._hoverScale = nextScale
        self:SetScale(nextScale)

        if nextScale == target then
            self._hoverAnimating = false
            self:SetScript("OnUpdate", nil)
        end
    end)
end

local function GetRaidMarkerMacroText(buttonInfo, countdownSeconds)
    if not buttonInfo or not buttonInfo.key then
        return nil, nil
    end

    if buttonInfo.index then
        return "/tm 0\n/tm " .. tostring(buttonInfo.index), "/tm 0"
    end

    if buttonInfo.key == "CLEAR" then
        return "/tm 0", nil
    elseif buttonInfo.key == "READY" then
        return "/readycheck", nil
    elseif buttonInfo.key == "COUNTDOWN" then
        local seconds = math.max(3, math.min(15, tonumber(countdownSeconds) or RAID_MARKERS_DEFAULT_COUNTDOWN))
        return
            "/run if C_PartyInfo and C_PartyInfo.DoCountdown then C_PartyInfo.DoCountdown(" ..
            seconds .. ") elseif DoCountdown then DoCountdown(" .. seconds .. ") end", nil
    end

    return nil, nil
end

function Core:ScheduleAutoQuestSweep(onlyCompleted, remainingPasses)
    if not self.ProcessAutoQuestDialogs then
        return
    end

    local passes = tonumber(remainingPasses) or 12
    if passes <= 0 then
        return
    end

    if not (C_Timer and C_Timer.After) then
        self:ProcessAutoQuestDialogs(onlyCompleted)
        return
    end

    C_Timer.After(0.15, function()
        if not Core or not Core.ProcessAutoQuestDialogs then
            return
        end

        local handled = Core:ProcessAutoQuestDialogs(onlyCompleted)
        if handled then
            Core:ScheduleAutoQuestSweep(onlyCompleted, passes - 1)
        end
    end)
end

local function GetConfiguredDelveQuickLeaveIcon()
    local cfg = MIcfg()
    local icon = cfg.delveQuickLeaveCustomIcon

    if type(icon) == "string" then
        icon = icon:match("^%s*(.-)%s*$")
    end

    if not icon or icon == "" then
        icon = cfg.delveQuickLeaveIconPreset
    end

    if not icon or icon == "" then
        icon = DELVE_QUICK_LEAVE_ICON
    end

    if type(icon) == "string" and icon:match("^%d+$") then
        return tonumber(icon)
    end

    return icon
end

local function FormatMoneyDelta(copper)
    local amount = tonumber(copper) or 0
    local prefix = amount >= 0 and "+" or "-"
    amount = math.abs(math.floor(amount))

    if GetMoneyString then
        return prefix .. GetMoneyString(amount, true)
    end

    local gold = math.floor(amount / 10000)
    local silver = math.floor((amount % 10000) / 100)
    local bronze = amount % 100
    return string.format("%s%dg %ds %dc", prefix, gold, silver, bronze)
end

local function FormatElapsedTime(seconds)
    local total = math.max(0, math.floor(tonumber(seconds) or 0))
    local hours = math.floor(total / 3600)
    local minutes = math.floor((total % 3600) / 60)
    local secs = total % 60

    if hours > 0 then
        return string.format("%02d:%02d:%02d", hours, minutes, secs)
    end
    return string.format("%02d:%02d", minutes, secs)
end


local function GetPlayerMaxLevelSafe()
    if type(GetMaxPlayerLevel) == "function" then
        local maxLevel = GetMaxPlayerLevel()
        if type(maxLevel) == "number" and maxLevel > 0 then
            return maxLevel
        end
    end
    local fallbackMaxLevel = _G and rawget(_G, "MAX_PLAYER_LEVEL")
    if type(fallbackMaxLevel) == "number" and fallbackMaxLevel > 0 then
        return fallbackMaxLevel
    end
    return 80
end

local function ProcessLegacyGreetingQuests(selectCompletedOnly)
    if type(GetNumActiveQuests) == "function" and type(SelectActiveQuest) == "function" then
        local activeCount = GetNumActiveQuests() or 0
        for index = 1, activeCount do
            local _, isComplete = GetActiveTitle(index)
            if isComplete then
                SelectActiveQuest(index)
                return true
            end
        end
    end

    if not selectCompletedOnly and type(GetNumAvailableQuests) == "function" and type(SelectAvailableQuest) == "function" then
        local availableCount = GetNumAvailableQuests() or 0
        if availableCount > 0 then
            SelectAvailableQuest(1)
            return true
        end
    end

    return false
end

local function GetGossipQuestIdentifier(info)
    if type(info) ~= "table" then
        return nil
    end
    return info.questID or info.id or info.index
end

local function IsGossipQuestComplete(info)
    if type(info) ~= "table" then
        return false
    end
    if info.isComplete ~= nil then
        return info.isComplete == true
    end
    if info.questID and C_QuestLog and C_QuestLog.IsComplete then
        return C_QuestLog.IsComplete(info.questID) == true
    end
    return false
end

-- ═══════════════════════════════════════════════════
--  全局 Tooltip 跟随鼠标 Hook
-- ═══════════════════════════════════════════════════
local globalTooltipHooked = false
local tooltipVisibilityHooked = false
local tooltipNPCAliveHooked = false
local tooltipHealthBarHooked = false
local npcPhaseAlertReady = false
local NPC_TIME_FORMAT = "%H:%M, %d.%m"
local TARGET_ARROW_SYMBOL = "▼"
local TARGET_ARROW_BASE_OFFSET = 24
local TARGET_ARROW_BOB_RANGE = 10
local TARGET_ARROW_BOB_SPEED = 3.2
local TOOLTIP_FRAME_NAMES = {
    "GameTooltip",
    "ItemRefTooltip",
    "ItemRefShoppingTooltip1",
    "ItemRefShoppingTooltip2",
    "ShoppingTooltip1",
    "ShoppingTooltip2",
    "EmbeddedItemTooltip",
    "WorldMapTooltip",
    "FriendsTooltip",
}

local function SAcfg()
    return Core.db.profile.systemAdjust
end

local npcTimeFormatter = CreateFromMixins(SecondsFormatterMixin)
npcTimeFormatter:Init(1, SecondsFormatter.Abbreviation.Truncate)

local function AddColoredDoubleLine(tooltip, leftText, rightText, leftColor, rightColor, wrap)
    leftColor = leftColor or NORMAL_FONT_COLOR
    rightColor = rightColor or HIGHLIGHT_FONT_COLOR
    if wrap == nil then
        wrap = true
    end
    tooltip:AddDoubleLine(
        leftText,
        rightText,
        leftColor.r or 1,
        leftColor.g or 1,
        leftColor.b or 1,
        rightColor.r or 1,
        rightColor.g or 1,
        rightColor.b or 1,
        wrap
    )
end

local function PrintPhaseAlert()
    local chatFrame = _G["DEFAULT_CHAT_FRAME"]
    if chatFrame and chatFrame.AddMessage then
        chatFrame:AddMessage(string.format("|cff9BFFA8 # %s New Connection|r", date("%H:%M")))
    end
end

local function DecodeNPCSpawnInfo(guid)
    if type(guid) ~= "string" or not band or not rshift then
        return nil
    end

    local unitType, _, serverID, _, layerUID, unitID = strsplit("-", guid)
    if unitType ~= "Creature" and unitType ~= "Vehicle" then
        return nil
    end

    local rawTime = tonumber(strsub(guid, -6), 16)
    local indexValue = tonumber(strsub(guid, -10, -6), 16)
    if not rawTime or not indexValue then
        return nil
    end

    local serverTime = GetServerTime()
    local spawnTime = (serverTime - (serverTime % 2 ^ 23)) + band(rawTime, 0x7fffff)
    if spawnTime > serverTime then
        spawnTime = spawnTime - ((2 ^ 23) - 1)
    end

    local spawnIndex = rshift(band(indexValue, 0xffff8), 3)

    return {
        serverID = serverID,
        layerUID = layerUID,
        unitID = unitID,
        spawnIndex = spawnIndex,
        spawnTime = spawnTime,
        serverTime = serverTime,
        aliveSeconds = math.max(0, serverTime - spawnTime),
    }
end

function Core:AppendNPCAliveTimeToTooltip(tooltip)
    local cfg = self.db and self.db.profile and self.db.profile.systemAdjust
    if not cfg or not cfg.showNPCAliveTime then return end
    if not tooltip or type(tooltip.GetUnit) ~= "function" then return end
    if cfg.npcTimeUseModifier and not IsModifierKeyDown() then return end

    local _, unit = tooltip:GetUnit()
    if not unit or not UnitExists(unit) or UnitIsPlayer(unit) or UnitIsDead(unit) then
        return
    end

    local guid = UnitGUID(unit)
    local info = DecodeNPCSpawnInfo(guid)
    if not info then return end

    if cfg.npcTimeShowCurrentTime then
        AddColoredDoubleLine(tooltip, "当前时间", date(NPC_TIME_FORMAT, info.serverTime))
    end

    AddColoredDoubleLine(
        tooltip,
        "NPC存活时间",
        npcTimeFormatter:Format(info.aliveSeconds, false) .. " (" .. date(NPC_TIME_FORMAT, info.spawnTime) .. ")"
    )

    if cfg.npcTimeShowLayer and info.serverID and info.layerUID then
        AddColoredDoubleLine(tooltip, "位面层", tostring(info.serverID) .. "-" .. tostring(info.layerUID))
    end

    if cfg.npcTimeShowNPCID and info.unitID then
        AddColoredDoubleLine(tooltip, "NPC ID", tostring(info.unitID))
        if info.spawnIndex and info.spawnIndex > 0 then
            AddColoredDoubleLine(tooltip, "Index", tostring(info.spawnIndex))
        end
    end

    tooltip:Show()
end

function Core:ApplyNPCTooltipHook()
    if tooltipNPCAliveHooked then return end
    tooltipNPCAliveHooked = true
    local tooltipDataProcessor = _G["TooltipDataProcessor"]

    local function HookTooltipUnit(tooltip)
        Core:AppendNPCAliveTimeToTooltip(tooltip)
    end

    if tooltipDataProcessor and Enum and Enum.TooltipDataType and tooltipDataProcessor.AddTooltipPostCall then
        tooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, HookTooltipUnit)
        return
    end

    for _, frameName in ipairs(TOOLTIP_FRAME_NAMES) do
        local tooltip = _G[frameName]
        if tooltip and tooltip.HookScript and tooltip.HasScript and tooltip:HasScript("OnTooltipSetUnit") then
            tooltip:HookScript("OnTooltipSetUnit", HookTooltipUnit)
        end
    end
end

local function EnsureOpaqueTooltipBackground(frame)
    if not frame or frame.YuXuanOpaqueBackground then return end

    local bg = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
    bg:SetAllPoints(frame)
    bg:SetColorTexture(0, 0, 0, 1)
    bg:Hide()

    frame.YuXuanOpaqueBackground = bg
end

function Core:ApplyTooltipBackgroundOpacity()
    local cfg = self.db and self.db.profile and self.db.profile.systemAdjust
    local enabled = cfg and cfg.opaqueTooltipBackground

    for _, frameName in ipairs(TOOLTIP_FRAME_NAMES) do
        local tooltip = _G[frameName]
        if tooltip then
            EnsureOpaqueTooltipBackground(tooltip)
            if tooltip.YuXuanOpaqueBackground then
                tooltip.YuXuanOpaqueBackground:SetShown(enabled)
            end
        end
    end
end

function Core:ApplyTooltipHealthBarVisibility()
    local cfg = self.db and self.db.profile and self.db.profile.systemAdjust
    local showHealthBar = cfg and cfg.showTooltipHealthBar
    local statusBar = _G["GameTooltipStatusBar"]
    if not statusBar then return end

    if not tooltipHealthBarHooked and statusBar.HookScript then
        tooltipHealthBarHooked = true
        statusBar:HookScript("OnShow", function(bar)
            local currentCfg = Core.db and Core.db.profile and Core.db.profile.systemAdjust
            if currentCfg and not currentCfg.showTooltipHealthBar then
                bar:Hide()
            end
        end)
    end

    if showHealthBar then
        statusBar:Show()
    else
        statusBar:Hide()
    end
end

function Core:CreateTargetArrowFrame()
    if self.targetArrowFrame then return end

    local frame = CreateFrame("Frame", addonName .. "TargetArrowFrame", UIParent)
    frame:SetSize(40, 40)
    frame:SetFrameStrata("HIGH")
    frame:SetIgnoreParentScale(true)
    frame:Hide()

    -- 使用 Arrow.tga 贴图作为箭头，支持颜色自定义
    frame.arrow = frame:CreateTexture(nil, "OVERLAY")
    frame.arrow:SetAllPoints(frame)
    frame.arrow:SetTexture("Interface\\AddOns\\" .. addonName .. "\\Resource\\Texture\\Arrow")
    frame.arrow:SetVertexColor(1, 0.12, 0.12, 0.95)

    frame:SetScript("OnUpdate", function(self, elapsed)
        self._animTime = (self._animTime or 0) + elapsed
        if not self.anchorFrame or not self.anchorFrame:IsShown() then
            self:Hide()
            return
        end

        local bob = math.sin((self._animTime or 0) * TARGET_ARROW_BOB_SPEED) * TARGET_ARROW_BOB_RANGE
        self:ClearAllPoints()
        self:SetPoint("BOTTOM", self.anchorFrame, "TOP", 0, TARGET_ARROW_BASE_OFFSET + bob)
    end)

    self.targetArrowFrame = frame
end

local function TargetArrowPassesFilter(cfg)
    local anyChecked = cfg.targetArrowShowEnemy or cfg.targetArrowShowFriendly
        or cfg.targetArrowShowNeutral or cfg.targetArrowShowPet or cfg.targetArrowShowCritter
    if not anyChecked then return false end

    if cfg.targetArrowShowPet then
        if UnitIsUnit and UnitIsUnit("target", "pet") then
            return true
        end
        local creatureType = UnitCreatureType and UnitCreatureType("target") or ""
        if creatureType == "Pet" then
            return true
        end
    end

    if cfg.targetArrowShowCritter then
        local creatureType = UnitCreatureType and UnitCreatureType("target") or ""
        if creatureType == "Critter" then
            return true
        end
    end

    -- UnitReaction 返回 1-8，1-4 敌对，5 中立，6-8 友好
    local reaction = UnitReaction and UnitReaction("player", "target")
    if reaction then
        if cfg.targetArrowShowEnemy and reaction <= 4 then return true end
        if cfg.targetArrowShowNeutral and reaction == 5 then return true end
        if cfg.targetArrowShowFriendly and reaction >= 6 then return true end
    else
        if cfg.targetArrowShowFriendly then return true end
    end

    return false
end

function Core:UpdateTargetArrowVisibility()
    self:CreateTargetArrowFrame()

    local cfg = SAcfg()
    local frame = self.targetArrowFrame
    if not cfg.targetArrowEnabled then
        frame.anchorFrame = nil
        frame:Hide()
        return
    end

    local targetExists = UnitExists and UnitExists("target")
    if not targetExists then
        frame.anchorFrame = nil
        frame:Hide()
        return
    end

    if not TargetArrowPassesFilter(cfg) then
        frame.anchorFrame = nil
        frame:Hide()
        return
    end

    local nameplate = C_NamePlate and C_NamePlate.GetNamePlateForUnit and
    C_NamePlate.GetNamePlateForUnit("target", false)
    local anchor = nameplate and (nameplate.UnitFrame or nameplate)
    if not anchor or not anchor:IsShown() then
        frame.anchorFrame = nil
        frame:Hide()
        return
    end

    frame.anchorFrame = anchor
    frame:Show()
end

function Core:ApplyTargetArrowSettings()
    local cfg = SAcfg()
    self:CreateTargetArrowFrame()

    local size = math.max(12, math.min(64, tonumber(cfg.targetArrowSize) or 28))
    local frame = self.targetArrowFrame
    frame:SetSize(size, size)

    -- 应用颜色配置到箭头贴图（默认红色）
    if frame.arrow then
        local color = cfg.targetArrowColor or { r = 1, g = 0.12, b = 0.12, a = 0.95 }
        frame.arrow:SetVertexColor(color.r or 1, color.g or 0.12, color.b or 0.12, color.a or 0.95)
    end

    self:UpdateTargetArrowVisibility()
end

function Core:ApplySystemAdjustSettings()
    local cfg = SAcfg()

    if cfg.combatDamageTextScale == nil then
        cfg.combatDamageTextScale = 3
    end
    cfg.combatDamageTextScale = math.max(1, math.min(20, tonumber(cfg.combatDamageTextScale) or 3))

    if cfg.opaqueTooltipBackground == nil then
        cfg.opaqueTooltipBackground = false
    end
    if cfg.showTooltipHealthBar == nil then
        cfg.showTooltipHealthBar = false
    end
    if cfg.targetArrowEnabled == nil then
        cfg.targetArrowEnabled = false
    end
    if cfg.targetArrowSize == nil then
        cfg.targetArrowSize = 28
    end
    if cfg.targetArrowColor == nil then
        cfg.targetArrowColor = { r = 1, g = 0.12, b = 0.12, a = 0.95 }
    end
    if cfg.targetArrowShowEnemy == nil then
        cfg.targetArrowShowEnemy = true
    end
    if cfg.targetArrowShowFriendly == nil then
        cfg.targetArrowShowFriendly = false
    end
    if cfg.targetArrowShowNeutral == nil then
        cfg.targetArrowShowNeutral = true
    end
    if cfg.targetArrowShowPet == nil then
        cfg.targetArrowShowPet = false
    end
    if cfg.targetArrowShowCritter == nil then
        cfg.targetArrowShowCritter = false
    end
    if cfg.showNPCAliveTime == nil then
        cfg.showNPCAliveTime = false
    end
    if cfg.npcTimeShowCurrentTime == nil then
        cfg.npcTimeShowCurrentTime = false
    end
    if cfg.npcTimeShowLayer == nil then
        cfg.npcTimeShowLayer = false
    end
    if cfg.npcTimeShowNPCID == nil then
        cfg.npcTimeShowNPCID = false
    end
    if cfg.npcTimeUseModifier == nil then
        cfg.npcTimeUseModifier = false
    end
    if cfg.npcTimeShowPhaseAlert == nil then
        cfg.npcTimeShowPhaseAlert = false
    end

    if SetCVar then
        SetCVar("floatingCombatTextCombatDamageDirectionalScale_V2", tostring(cfg.combatDamageTextScale))
    end

    self:ApplyTooltipBackgroundOpacity()
    self:ApplyTooltipHealthBarVisibility()
    self:ApplyTargetArrowSettings()
    self:ApplyNPCTooltipHook()
    self:UpdateMiscEventRegistration()
end

function Core:ApplyGlobalTooltipHook()
    if globalTooltipHooked then return end
    globalTooltipHooked = true

    -- Hook GameTooltip_SetDefaultAnchor（全局函数），不会导致递归
    -- 此函数在系统需要显示默认位置 tooltip 时调用
    hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
        local cfg = Core.db and Core.db.profile and Core.db.profile.misc
        if not cfg or cfg.disableAllTooltips or not cfg.tooltipFollowCursor then return end
        tooltip:SetOwner(parent, "ANCHOR_CURSOR_RIGHT")
    end)
end

function Core:ApplyTooltipVisibilityHook()
    if tooltipVisibilityHooked then return end
    tooltipVisibilityHooked = true

    local function HideTooltipIfDisabled(self)
        local cfg = Core.db and Core.db.profile and Core.db.profile.misc
        if cfg and cfg.disableAllTooltips then
            self:Hide()
        end
    end

    for _, frameName in ipairs(TOOLTIP_FRAME_NAMES) do
        local tooltip = _G[frameName]
        if tooltip and tooltip.HookScript then
            tooltip:HookScript("OnShow", HideTooltipIfDisabled)
        end
    end
end

function Core:UpdateTooltipVisibility()
    self:ApplyTooltipVisibilityHook()

    local cfg = MIcfg()
    if not cfg.disableAllTooltips then return end

    for _, frameName in ipairs(TOOLTIP_FRAME_NAMES) do
        local tooltip = _G[frameName]
        if tooltip and tooltip.Hide then
            tooltip:Hide()
        end
    end
end

function Core:SetTooltipAnchor(tooltip, owner, fallbackAnchor)
    if not tooltip then return end
    local cfg = self.db and self.db.profile and self.db.profile.misc
    if cfg and cfg.disableAllTooltips then
        tooltip:Hide()
        return
    end
    if cfg and cfg.tooltipFollowCursor then
        tooltip:SetOwner(owner or UIParent, "ANCHOR_CURSOR_RIGHT")
    else
        tooltip:SetOwner(owner or UIParent, fallbackAnchor or "ANCHOR_RIGHT")
    end
end

-- ═══════════════════════════════════════════════════
--  任务通报 / 自动交接
-- ═══════════════════════════════════════════════════

function Core:GetQuestAnnounceChannel()
    if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
        return "INSTANCE_CHAT"
    end
    if IsInRaid() then
        return "RAID"
    end
    if IsInGroup() then
        return "PARTY"
    end
    return nil
end

function Core:GetQuestNameByID(questID)
    if not questID then return nil end
    if C_QuestLog and C_QuestLog.GetTitleForQuestID then
        local title = C_QuestLog.GetTitleForQuestID(questID)
        if title and title ~= "" then return title end
    end
    if C_TaskQuest and C_TaskQuest.GetQuestInfoByQuestID then
        local info = C_TaskQuest.GetQuestInfoByQuestID(questID)
        if info and info.title and info.title ~= "" then
            return info.title
        end
    end
    local logIndex = C_QuestLog and C_QuestLog.GetLogIndexForQuestID and C_QuestLog.GetLogIndexForQuestID(questID)
    if logIndex and logIndex > 0 then
        local title = GetQuestLogTitle(logIndex)
        if title and title ~= "" then return title end
    end
    return tostring(questID)
end

function Core:GetQuestLinkByID(questID)
    if not questID then return nil end
    if GetQuestLink then
        local questLink = GetQuestLink(questID)
        if questLink and questLink ~= "" then
            -- 去掉 questLink 自带颜色层，仅保留超链接本体，方便聊天里安全发送且仍可点击
            questLink = questLink:gsub("|c%x%x%x%x%x%x%x%x", "")
            questLink = questLink:gsub("|r", "")
            return questLink
        end
    end
    return nil
end

function Core:GetQuestAnnounceTextByID(questID)
    -- 实测通过 SendChatMessage 发送 quest hyperlink 不稳定，优先使用纯任务名保证稳定输出
    return self:GetQuestNameByID(questID)
end

function Core:FormatQuestAnnounce(actionText, questName)
    local template = MIcfg().announceTemplate or "|cFF33FF99【雨轩工具箱】|r |cFFFFFF00{action}|r：{quest}"
    local msg = template
    msg = msg:gsub("{action}", actionText or "")
    msg = msg:gsub("{quest}", questName or "")
    msg = msg:gsub("{newline}", "\n")
    return msg
end

function Core:SanitizeChatMessage(msg)
    if not msg or msg == "" then return "" end
    -- 频道聊天里自定义颜色码容易触发 Invalid escape code；
    -- 这里保留超链接（|Hquest...|h），仅去掉颜色码/材质码并移除换行。
    msg = msg:gsub("\r", " ")
    msg = msg:gsub("\n", " ")
    msg = msg:gsub("|c%x%x%x%x%x%x%x%x", "")
    msg = msg:gsub("|r", "")
    msg = msg:gsub("|T.-|t", "")
    return msg
end

function Core:AnnounceQuest(actionText, questID)
    if not MIcfg().autoAnnounceQuest then return end
    local questText = self:GetQuestAnnounceTextByID(questID)
    if not questText or questText == "" then return end
    local msg = self:FormatQuestAnnounce(actionText, questText)
    local channel = self:GetQuestAnnounceChannel()
    if channel then
        SendChatMessage(self:SanitizeChatMessage(msg), channel)
    else
        -- 不在队伍中时本地输出（保留颜色和链接）
        print(msg)
    end
end

function Core:HandleMiscQuestEvent(event, ...)
    local cfg = MIcfg()

    if event == "QUEST_ACCEPTED" then
        local questID = select(2, ...) or select(1, ...)
        self:AnnounceQuest("任务已接取", questID)
        return
    end

    if event == "QUEST_TURNED_IN" then
        local questID = ...
        self:AnnounceQuest("任务已完成", questID)
        return
    end

    if not cfg.autoQuestTurnIn then return end

    if event == "QUEST_DETAIL" then
        if AcceptQuest then
            AcceptQuest()
        end
        self:ScheduleAutoQuestSweep(false)
    elseif event == "QUEST_PROGRESS" then
        if IsQuestCompletable and IsQuestCompletable() and CompleteQuest then
            CompleteQuest()
        end
        self:ScheduleAutoQuestSweep(true)
    elseif event == "QUEST_COMPLETE" then
        local numChoices = GetNumQuestChoices and GetNumQuestChoices() or 0
        if GetQuestReward then
            GetQuestReward(math.max(1, numChoices))
        end
        self:ScheduleAutoQuestSweep(false)
    elseif event == "GOSSIP_SHOW" or event == "QUEST_GREETING" then
        self:ProcessAutoQuestDialogs(false)
        self:ScheduleAutoQuestSweep(false)
    end
end

function Core:ProcessAutoQuestDialogs(onlyCompleted)
    local cfg = MIcfg()
    if not cfg.autoQuestTurnIn then
        return false
    end

    if C_GossipInfo then
        if type(C_GossipInfo.GetActiveQuests) == "function" and type(C_GossipInfo.SelectActiveQuest) == "function" then
            local activeQuests = C_GossipInfo.GetActiveQuests() or {}
            for _, info in ipairs(activeQuests) do
                if IsGossipQuestComplete(info) then
                    local questIdentifier = GetGossipQuestIdentifier(info)
                    if questIdentifier then
                        C_GossipInfo.SelectActiveQuest(questIdentifier)
                        return true
                    end
                end
            end
        end

        if not onlyCompleted and type(C_GossipInfo.GetAvailableQuests) == "function"
            and type(C_GossipInfo.SelectAvailableQuest) == "function" then
            local availableQuests = C_GossipInfo.GetAvailableQuests() or {}
            local firstQuest = availableQuests[1]
            local questIdentifier = GetGossipQuestIdentifier(firstQuest)
            if questIdentifier then
                C_GossipInfo.SelectAvailableQuest(questIdentifier)
                return true
            end
        end
    end

    return ProcessLegacyGreetingQuests(onlyCompleted)
end

function Core:UpdateMiscEventRegistration()
    if not self.miscEventFrame then return end
    self.miscEventFrame:UnregisterAllEvents()

    local cfg = MIcfg()
    local systemCfg = Core.db and Core.db.profile and Core.db.profile.systemAdjust
    if cfg.questToolsEnabled and cfg.autoAnnounceQuest then
        self.miscEventFrame:RegisterEvent("QUEST_ACCEPTED")
        self.miscEventFrame:RegisterEvent("QUEST_TURNED_IN")
    end

    if cfg.questToolsEnabled and cfg.autoQuestTurnIn then
        self.miscEventFrame:RegisterEvent("QUEST_DETAIL")
        self.miscEventFrame:RegisterEvent("QUEST_PROGRESS")
        self.miscEventFrame:RegisterEvent("QUEST_COMPLETE")
        self.miscEventFrame:RegisterEvent("GOSSIP_SHOW")
        self.miscEventFrame:RegisterEvent("QUEST_GREETING")
    end

    self.miscEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    self.miscEventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    self.miscEventFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
    self.miscEventFrame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
    self.miscEventFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
    self.miscEventFrame:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED")
    self.miscEventFrame:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
    self.miscEventFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
    self.miscEventFrame:RegisterEvent("WALK_IN_DATA_UPDATE")
    self.miscEventFrame:RegisterEvent("ACTIVE_DELVE_DATA_UPDATE")

    if cfg.levelingTipEnabled then
        self.miscEventFrame:RegisterEvent("PLAYER_XP_UPDATE")
        self.miscEventFrame:RegisterEvent("PLAYER_LEVEL_UP")
    end

    if systemCfg and systemCfg.targetArrowEnabled then
        self.miscEventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
        self.miscEventFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
        self.miscEventFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
    end

    if systemCfg and systemCfg.npcTimeShowPhaseAlert then
        self.miscEventFrame:RegisterEvent("CONSOLE_MESSAGE")
    end
end

function Core:SaveMiscBarPosition()
    if not self.miscFrame then return end
    local point, _, relativePoint, x, y = self.miscFrame:GetPoint(1)
    local pos = MIcfg().barPoint
    pos.point = point or "CENTER"
    pos.relativePoint = relativePoint or "CENTER"
    pos.x = math.floor((x or 0) + 0.5)
    pos.y = math.floor((y or 0) + 0.5)
end

function Core:SaveQuestToolsPosition()
    if not self.questToolsFrame then return end
    local point, _, relativePoint, x, y = self.questToolsFrame:GetPoint(1)
    local pos = MIcfg().questToolsPoint
    pos.point = point or "CENTER"
    pos.relativePoint = relativePoint or "CENTER"
    pos.x = math.floor((x or 0) + 0.5)
    pos.y = math.floor((y or 0) + 0.5)
end

function Core:SaveRaidMarkersPosition()
    if not self.raidMarkersFrame then return end
    local point, _, relativePoint, x, y = self.raidMarkersFrame:GetPoint(1)
    local pos = MIcfg().raidMarkersPoint
    pos.point = point or "CENTER"
    pos.relativePoint = relativePoint or "CENTER"
    pos.x = math.floor((x or 0) + 0.5)
    pos.y = math.floor((y or 0) + 0.5)
end

function Core:SaveDelveQuickLeavePosition()
    if not self.delveQuickLeaveButton then return end
    local point, _, relativePoint, x, y = self.delveQuickLeaveButton:GetPoint(1)
    local pos = MIcfg().delveQuickLeavePoint
    pos.point = point or "CENTER"
    pos.relativePoint = relativePoint or "CENTER"
    pos.x = math.floor((x or 0) + 0.5)
    pos.y = math.floor((y or 0) + 0.5)
end

function Core:EnsureDelveQuickLeaveButtonOnScreen()
    local button = self.delveQuickLeaveButton
    if not button then return end

    local centerX, centerY = button:GetCenter()
    if not centerX or not centerY then return end

    local screenWidth = UIParent:GetWidth() or 0
    local screenHeight = UIParent:GetHeight() or 0
    if screenWidth <= 0 or screenHeight <= 0 then return end

    if centerX < 0 or centerX > screenWidth or centerY < 0 or centerY > screenHeight then
        local pos = MIcfg().delveQuickLeavePoint
        pos.point = "CENTER"
        pos.relativePoint = "CENTER"
        pos.x = 180
        pos.y = -20

        button:ClearAllPoints()
        button:SetPoint(pos.point, UIParent, pos.relativePoint, pos.x, pos.y)
    end
end

function Core:IsInDelve()
    if IsFunctionAvailable(C_PartyInfo, "IsDelveInProgress") and C_PartyInfo.IsDelveInProgress() then
        return true
    end

    if IsFunctionAvailable(C_PartyInfo, "IsDelveComplete") and C_PartyInfo.IsDelveComplete() then
        return true
    end

    if IsFunctionAvailable(C_PartyInfo, "IsPartyWalkIn") and C_PartyInfo.IsPartyWalkIn() then
        return true
    end

    local inInstance, instanceType = IsInInstance()
    if not inInstance then
        return false
    end

    if instanceType == "scenario" then
        return true
    end

    return false
end

function Core:IsInHomeOrInstanceGroup()
    if type(IsInGroup) ~= "function" then
        return false
    end

    if IsInGroup() then
        return true
    end

    if type(LE_PARTY_CATEGORY_HOME) == "number" and IsInGroup(LE_PARTY_CATEGORY_HOME) then
        return true
    end

    if type(LE_PARTY_CATEGORY_INSTANCE) == "number" and IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
        return true
    end

    return false
end

function Core:CanUseRaidLeaderAction()
    if not self:IsInHomeOrInstanceGroup() then
        return false, "需要先加入队伍或团队。"
    end

    if type(IsInRaid) == "function" and IsInRaid() then
        local isLeader = type(UnitIsGroupLeader) == "function" and UnitIsGroupLeader("player")
        local isAssistant = type(UnitIsGroupAssistant) == "function" and UnitIsGroupAssistant("player")
        if not isLeader and not isAssistant then
            return false, "团队中需要队长或助理权限。"
        end
    end

    return true
end

function Core:PrintMiscMessage(message)
    if type(print) == "function" then
        print("|cFF33FF99雨轩工具箱|r：" .. (message or ""))
    end
end

function Core:SetCurrentTargetRaidMarker(index)
    local canUse, reason = self:CanUseRaidLeaderAction()
    if not canUse then
        self:PrintMiscMessage(reason)
        return false
    end

    if type(UnitExists) == "function" and not UnitExists("target") then
        self:PrintMiscMessage("请先选中一个目标。")
        return false
    end

    local markerIndex = tonumber(index) or 0

    if type(SetRaidTarget) == "function" then
        SetRaidTarget("target", markerIndex)
    elseif type(SetRaidTargetIcon) == "function" then
        SetRaidTargetIcon("target", markerIndex)
    else
        self:PrintMiscMessage("当前版本不支持设置团队标记。")
        return false
    end

    if type(GetRaidTargetIndex) == "function" then
        local appliedIndex = GetRaidTargetIndex("target") or 0
        if appliedIndex ~= markerIndex then
            if markerIndex == 0 then
                self:PrintMiscMessage("未能清除标记，请确认你有队长/助理权限。")
            else
                self:PrintMiscMessage("未能设置标记，请确认你有队长/助理权限，且当前在队伍或团队中。")
            end
            return false
        end
    end

    return true
end

function Core:StartRaidReadyCheck()
    local canUse, reason = self:CanUseRaidLeaderAction()
    if not canUse then
        self:PrintMiscMessage(reason)
        return
    end

    if type(DoReadyCheck) == "function" then
        DoReadyCheck()
    else
        self:PrintMiscMessage("当前版本不支持团队就位。")
    end
end

function Core:StartRaidCountdown()
    local canUse, reason = self:CanUseRaidLeaderAction()
    if not canUse then
        self:PrintMiscMessage(reason)
        return
    end

    local seconds = math.max(3, math.min(15, tonumber(MIcfg().raidMarkersCountdown) or RAID_MARKERS_DEFAULT_COUNTDOWN))
    if IsFunctionAvailable(C_PartyInfo, "DoCountdown") then
        C_PartyInfo.DoCountdown(seconds)
        return
    end

    if type(DoCountdown) == "function" then
        DoCountdown(seconds)
        return
    end

    self:PrintMiscMessage("当前版本不支持团队倒计时。")
end

function Core:LeaveDelve()
    if IsFunctionAvailable(C_PartyInfo, "DelveTeleportOut") then
        C_PartyInfo.DelveTeleportOut()
        return
    end
    if type(ConfirmOrLeaveParty) == "function" then
        ConfirmOrLeaveParty()
        return
    end
    if type(LFGTeleport) == "function" then
        LFGTeleport(true)
        return
    end
    if IsFunctionAvailable(C_PartyInfo, "LeaveParty") then
        C_PartyInfo.LeaveParty(LE_PARTY_CATEGORY_INSTANCE)
    end
end

-- ═══════════════════════════════════════════════════
--  专精 / 天赋
-- ═══════════════════════════════════════════════════

function Core:HideMiscPopupMenu()
    if CloseDropDownMenus then
        CloseDropDownMenus()
    end
    self.miscPopupMenuType = nil
    self.miscPopupAnchor = nil
end

function Core:GetOrCreateMiscPopupMenu()
    if self.miscPopupMenu then
        return self.miscPopupMenu
    end
    local menu = CreateFrame("Frame", addonName .. "MiscPopupMenu", UIParent, "UIDropDownMenuTemplate")
    menu.displayMode = "MENU"
    self.miscPopupMenu = menu
    return menu
end

function Core:ShowMiscPopupMenu(anchor, menuType, title, entries, onSelect)
    local menu = self:GetOrCreateMiscPopupMenu()
    if UIDROPDOWNMENU_OPEN_MENU == menu and self.miscPopupMenuType == menuType and self.miscPopupAnchor == anchor then
        self:HideMiscPopupMenu()
        return
    end

    self.miscPopupMenuType = menuType
    self.miscPopupAnchor = anchor

    UIDropDownMenu_Initialize(menu, function(_, level)
        if level ~= 1 then return end

        local titleInfo = UIDropDownMenu_CreateInfo()
        titleInfo.text = title
        titleInfo.isTitle = true
        titleInfo.notCheckable = true
        UIDropDownMenu_AddButton(titleInfo, level)

        for _, entry in ipairs(entries) do
            local info = UIDropDownMenu_CreateInfo()
            local itemText = entry.name or ""
            if entry.icon then
                if menuType == "spec" then
                    itemText = string.format("   |T%s:14:14:0:0|t %s", entry.icon, itemText)
                else
                    itemText = string.format("  |T%s:14:14:0:0|t %s", entry.icon, itemText)
                end
            else
                local textGap = menuType == "talent" and "  " or "    "
                itemText = textGap .. itemText
            end
            info.text = itemText
            info.checked = entry.checked or entry.active or false
            info.disabled = not not entry.disabled
            info.keepShownOnClick = false
            info.func = function()
                if entry.current or (menuType ~= "talent" and entry.active) or not onSelect then
                    Core:HideMiscPopupMenu()
                    return
                end

                if menuType == "talent" then
                    Defer(function()
                        onSelect(entry)
                    end)
                else
                    onSelect(entry)
                end
                Core:HideMiscPopupMenu()
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end, "MENU")

    ToggleDropDownMenu(1, nil, menu, anchor, 0, 0)
end

function Core:GetSpecializationEntries()
    local entries = {}
    local currentIndex = GetSpecialization and GetSpecialization()
    local numSpecs = GetNumSpecializations and GetNumSpecializations() or 0

    for specIndex = 1, numSpecs do
        local specID, specName, _, specIcon = GetSpecializationInfo(specIndex)
        table.insert(entries, {
            index = specIndex,
            id = specID,
            name = specName or ("专精" .. specIndex),
            icon = specIcon,
            active = specIndex == currentIndex,
        })
    end

    return entries
end

function Core:GetCurrentSpecIcon()
    local specIndex = GetSpecialization and GetSpecialization()
    if not specIndex then return nil end
    local _, _, _, specIcon = GetSpecializationInfo(specIndex)
    return specIcon
end

function Core:GetCurrentSpecializationName()
    local specIndex = GetSpecialization and GetSpecialization()
    if not specIndex then
        return "未激活专精", nil
    end
    local _, specName, _, specIcon = GetSpecializationInfo(specIndex)
    return specName or "未激活专精", specIcon
end

function Core:GetTalentLoadouts()
    local entries = {}
    if not IsFunctionAvailable(C_ClassTalents, "GetConfigIDsBySpecID") then
        return entries
    end

    local specIndex = GetSpecialization and GetSpecialization()
    if not specIndex then return entries end

    local specID = GetSpecializationInfo(specIndex)
    if not specID then return entries end

    local state = self:GetTalentLoadoutState()
    local activeConfigID = state.activeConfigID
    local displayConfigID = state.displayConfigID or activeConfigID
    local selectedConfigID = state.selectedConfigID

    local configIDs = C_ClassTalents.GetConfigIDsBySpecID(specID) or {}
    for _, configID in ipairs(configIDs) do
        local name = "方案" .. tostring(configID)
        if C_Traits and C_Traits.GetConfigInfo then
            local info = C_Traits.GetConfigInfo(configID)
            if info and info.name and info.name ~= "" then
                name = info.name
            end
        end

        table.insert(entries, {
            id = configID,
            name = name,
            active = configID == displayConfigID,
            checked = configID == displayConfigID,
            current = configID == activeConfigID,
            selected = configID == selectedConfigID,
        })
    end

    return entries
end

function Core:GetTalentLoadoutState()
    local specIndex = GetSpecialization and GetSpecialization()
    if not specIndex then
        return {
            activeConfigID = nil,
            selectedConfigID = nil,
            displayConfigID = nil,
        }
    end

    local specID = GetSpecializationInfo(specIndex)
    local activeConfigID = nil
    local selectedConfigID = nil
    local savedConfigIDs = {}

    if specID and IsFunctionAvailable(C_ClassTalents, "GetConfigIDsBySpecID") then
        local configIDs = C_ClassTalents.GetConfigIDsBySpecID(specID) or {}
        for _, configID in ipairs(configIDs) do
            savedConfigIDs[configID] = true
        end
    end

    if IsFunctionAvailable(C_ClassTalents, "GetActiveConfigID") then
        activeConfigID = C_ClassTalents.GetActiveConfigID()
        if activeConfigID and not savedConfigIDs[activeConfigID] then
            activeConfigID = nil
        end
    end

    if specID and IsFunctionAvailable(C_ClassTalents, "GetLastSelectedSavedConfigID") then
        selectedConfigID = C_ClassTalents.GetLastSelectedSavedConfigID(specID)
        if selectedConfigID and not savedConfigIDs[selectedConfigID] then
            selectedConfigID = nil
        end
    end

    local displayConfigID = nil
    if selectedConfigID and savedConfigIDs[selectedConfigID] then
        displayConfigID = selectedConfigID
    elseif activeConfigID and savedConfigIDs[activeConfigID] then
        displayConfigID = activeConfigID
    else
        displayConfigID = selectedConfigID or activeConfigID
    end

    return {
        activeConfigID = activeConfigID,
        selectedConfigID = selectedConfigID,
        displayConfigID = displayConfigID,
    }
end

function Core:GetCurrentTalentLoadoutName()
    local state = self:GetTalentLoadoutState()
    local function GetConfigName(configID)
        if not configID or not C_Traits or not C_Traits.GetConfigInfo then return nil end
        local info = C_Traits.GetConfigInfo(configID)
        if info and info.name and info.name ~= "" then
            return info.name
        end
        return nil
    end

    local displayName = GetConfigName(state.displayConfigID)

    if displayName then
        return displayName
    end

    local activeName = GetConfigName(state.activeConfigID)
    if activeName then
        return activeName
    end

    local selectedName = GetConfigName(state.selectedConfigID)
    if selectedName then
        return selectedName
    end

    local loadouts = self:GetTalentLoadouts()
    if #loadouts > 0 then
        return loadouts[1].name
    end
    return "未命名天赋"
end

function Core:EnsureTalentUILoaded()
    if PlayerSpellsFrame then return true end
    if PlayerSpellsFrame_LoadUI then
        PlayerSpellsFrame_LoadUI()
    elseif C_AddOns and C_AddOns.LoadAddOn then
        pcall(C_AddOns.LoadAddOn, "Blizzard_ClassTalentUI")
    end
    return not not PlayerSpellsFrame
end

function Core:GetSelectedTalentLoadoutID()
    return self:GetTalentLoadoutState().selectedConfigID
end

function Core:GetActiveTalentConfigID()
    local state = self:GetTalentLoadoutState()
    return state.activeConfigID
end

function Core:ApplyTalentLoadout(configID)
    self:EnsureTalentUILoaded()
    if PlayerSpellsFrame and PlayerSpellsFrame.TalentsFrame and PlayerSpellsFrame.TalentsFrame.LoadConfigByPredicate then
        local targetID = configID
        PlayerSpellsFrame.TalentsFrame:LoadConfigByPredicate(function(_, candidateID)
            return candidateID == targetID
        end)
        return true
    end

    if IsFunctionAvailable(C_ClassTalents, "LoadConfig") then
        local result, changeError = C_ClassTalents.LoadConfig(configID, true)
        local errorResult = Enum and Enum.LoadConfigResult and Enum.LoadConfigResult.Error or 0
        if result == errorResult then
            print("|cFF33FF99雨轩工具箱|r丨切换天赋失败：" .. tostring(changeError or "未知错误"))
            return false
        end
        return true
    end

    return false
end

function Core:SwitchSpecialization(specIndex)
    if InCombatLockdown and InCombatLockdown() then
        print("|cFF33FF99雨轩工具箱|r丨战斗中无法切换专精")
        return
    end
    local SetSpec = (C_SpecializationInfo and C_SpecializationInfo.SetSpecialization) or SetSpecialization
    if not specIndex or not SetSpec then return end
    if GetSpecialization and GetSpecialization() == specIndex then return end
    SetSpec(specIndex)
end

function Core:SwitchTalentLoadout(configID)
    if InCombatLockdown and InCombatLockdown() then
        print("|cFF33FF99雨轩工具箱|r丨战斗中无法切换天赋")
        return
    end
    if not configID then return end
    if self:GetActiveTalentConfigID() == configID then return end

    self:ApplyTalentLoadout(configID)
    Defer(function()
        if Core:GetActiveTalentConfigID() ~= configID then
            Core:ApplyTalentLoadout(configID)
        end
    end)
end

function Core:ShowSpecMenu(anchor)
    self:ShowMiscPopupMenu(anchor, "spec", "切换专精", self:GetSpecializationEntries(), function(entry)
        Core:SwitchSpecialization(entry.index)
    end)
end

function Core:ShowTalentMenu(anchor)
    self:EnsureTalentUILoaded()
    local entries = self:GetTalentLoadouts()
    if #entries == 0 then
        entries = {
            { name = "当前专精没有可用方案", active = true },
        }
    end
    self:ShowMiscPopupMenu(anchor, "talent", "切换天赋方案", entries, function(entry)
        if entry.id then
            Core:SwitchTalentLoadout(entry.id)
        end
    end)
end

-- ═══════════════════════════════════════════════════
--  耐久度
-- ═══════════════════════════════════════════════════

function Core:GetDurabilityEntries()
    local entries = {}
    local totalCurrent, totalMax = 0, 0

    for slotID, slotName in pairs(DURABILITY_SLOTS) do
        local current, maximum = GetInventoryItemDurability(slotID)
        if current and maximum and maximum > 0 then
            totalCurrent = totalCurrent + current
            totalMax = totalMax + maximum

            local percent = (current / maximum) * 100
            local itemLink = GetInventoryItemLink("player", slotID)
            local itemName = slotName
            local itemIcon = nil
            if itemLink then
                local iName, _, _, _, _, _, _, _, _, iTexture = GetItemInfo(itemLink)
                if iName and iName ~= "" then itemName = iName end
                itemIcon = iTexture
            end
            if not itemIcon then
                itemIcon = GetInventoryItemTexture("player", slotID)
            end
            table.insert(entries, {
                slot = slotID,
                slotName = slotName,
                itemName = itemName,
                icon = itemIcon,
                percent = percent,
            })
        end
    end

    table.sort(entries, function(a, b)
        return a.percent < b.percent
    end)

    local overall = 100
    if totalMax > 0 then
        overall = math.floor((totalCurrent / totalMax) * 100 + 0.5)
    end

    return overall, entries
end

function Core:OpenCharacterFrame()
    if not ToggleCharacter then return end
    ToggleCharacter("PaperDollFrame")
end

function Core:ToggleQuestAnnounce()
    local cfg = MIcfg()
    if not cfg.questToolsEnabled then return end
    cfg.autoAnnounceQuest = not cfg.autoAnnounceQuest
    self:ApplyMiscSettings()
end

function Core:ToggleQuestTurnIn()
    local cfg = MIcfg()
    if not cfg.questToolsEnabled then return end
    cfg.autoQuestTurnIn = not cfg.autoQuestTurnIn
    self:ApplyMiscSettings()
end

function Core:RefreshTimerWindow()
    local frame = self.timerFrame
    if not frame then return end

    local session = self.timerSession or {}
    local isRunning = session.running == true
    local elapsed = session.elapsed or 0
    if isRunning and session.startedAt then
        elapsed = GetTime() - session.startedAt
    end

    frame.statusValue:SetText(isRunning and "进行中" or "已停止")
    frame.elapsedValue:SetText(FormatElapsedTime(elapsed))
    frame.moneyValue:SetText(FormatMoneyDelta(session.moneyDelta or 0))

    if session.xpSupported == false then
        frame.xpValue:SetText("当前角色无经验条")
    else
        frame.xpValue:SetText(string.format("+%d", session.xpDelta or 0))
    end

    frame.startButton:Enable()
    frame.stopButton:SetEnabled(isRunning)
end

function Core:UpdateTimerMoneyDelta()
    local session = self.timerSession
    if not session or not session.running then return end

    local currentMoney = GetMoney and GetMoney() or 0
    session.moneyDelta = currentMoney - (session.startMoney or currentMoney)
end

function Core:UpdateTimerXPDelta()
    local session = self.timerSession
    if not session or not session.running then return end

    local currentXPMax = UnitXPMax and UnitXPMax("player") or 0
    local currentXP = UnitXP and UnitXP("player") or 0
    local currentLevel = UnitLevel and UnitLevel("player") or 0

    if not currentXPMax or currentXPMax <= 0 then
        session.xpSupported = false
        session.prevXP = currentXP or 0
        session.prevXPMax = currentXPMax or 0
        session.prevLevel = currentLevel or 0
        return
    end

    session.xpSupported = true

    local prevXP = session.prevXP or currentXP
    local prevXPMax = session.prevXPMax or currentXPMax
    local prevLevel = session.prevLevel or currentLevel

    if currentLevel > prevLevel then
        session.xpDelta = (session.xpDelta or 0) + math.max(0, (prevXPMax or 0) - (prevXP or 0)) + currentXP
    elseif currentXP >= prevXP then
        session.xpDelta = (session.xpDelta or 0) + (currentXP - prevXP)
    elseif currentXP < prevXP then
        session.xpDelta = (session.xpDelta or 0) + currentXP
    end

    session.prevXP = currentXP
    session.prevXPMax = currentXPMax
    session.prevLevel = currentLevel
end

function Core:HandleTimerTrackingEvent(event, ...)
    local session = self.timerSession
    if not session or not session.running then return end

    if event == "PLAYER_MONEY" then
        self:UpdateTimerMoneyDelta()
    elseif event == "PLAYER_XP_UPDATE" then
        local unit = ...
        if unit == "player" then
            self:UpdateTimerXPDelta()
        end
    elseif event == "PLAYER_LEVEL_UP" then
        self:UpdateTimerXPDelta()
    end

    self:RefreshTimerWindow()
end

function Core:StartTimerTracking()
    local currentMoney = GetMoney and GetMoney() or 0
    local currentXP = UnitXP and UnitXP("player") or 0
    local currentXPMax = UnitXPMax and UnitXPMax("player") or 0
    local currentLevel = UnitLevel and UnitLevel("player") or 0

    self.timerSession = {
        running = true,
        startedAt = GetTime(),
        elapsed = 0,
        startMoney = currentMoney,
        moneyDelta = 0,
        xpDelta = 0,
        xpSupported = currentXPMax and currentXPMax > 0,
        prevXP = currentXP,
        prevXPMax = currentXPMax,
        prevLevel = currentLevel,
    }

    if self.timerFrame then
        self.timerFrame:RegisterEvent("PLAYER_MONEY")
        self.timerFrame:RegisterEvent("PLAYER_XP_UPDATE")
        self.timerFrame:RegisterEvent("PLAYER_LEVEL_UP")
    end

    self:RefreshTimerWindow()
end

function Core:StopTimerTracking()
    local session = self.timerSession
    if not session or not session.running then
        self:RefreshTimerWindow()
        return
    end

    self:UpdateTimerMoneyDelta()
    self:UpdateTimerXPDelta()

    session.elapsed = GetTime() - (session.startedAt or GetTime())
    session.running = false

    if self.timerFrame then
        self.timerFrame:UnregisterEvent("PLAYER_MONEY")
        self.timerFrame:UnregisterEvent("PLAYER_XP_UPDATE")
        self.timerFrame:UnregisterEvent("PLAYER_LEVEL_UP")
    end

    self:RefreshTimerWindow()
end

function Core:ToggleTimerWindow()
    if not self.timerFrame then
        self:CreateTimerWindow()
    end

    if self.timerFrame:IsShown() then
        self.timerFrame:Hide()
    else
        self.timerFrame:Show()
        self:RefreshTimerWindow()
    end
end

function Core:ResetLevelingTipTracking()
    local currentXP = UnitXP and UnitXP("player") or 0
    local currentXPMax = UnitXPMax and UnitXPMax("player") or 0
    local currentLevel = UnitLevel and UnitLevel("player") or 0

    self.levelingTipState = {
        startedAt = GetTime(),
        totalXP = 0,
        prevXP = currentXP,
        prevXPMax = currentXPMax,
        prevLevel = currentLevel,
        xpSupported = currentXPMax and currentXPMax > 0,
    }
end

function Core:UpdateLevelingTipTracking()
    local cfg = MIcfg()
    if not cfg.levelingTipEnabled then return end

    if not self.levelingTipState then
        self:ResetLevelingTipTracking()
    end

    local state = self.levelingTipState
    local currentXP = UnitXP and UnitXP("player") or 0
    local currentXPMax = UnitXPMax and UnitXPMax("player") or 0
    local currentLevel = UnitLevel and UnitLevel("player") or 0

    if not currentXPMax or currentXPMax <= 0 then
        state.xpSupported = false
        state.prevXP = currentXP or 0
        state.prevXPMax = currentXPMax or 0
        state.prevLevel = currentLevel or 0
        return
    end

    state.xpSupported = true

    local prevXP = state.prevXP or currentXP
    local prevXPMax = state.prevXPMax or currentXPMax
    local prevLevel = state.prevLevel or currentLevel

    if currentLevel > prevLevel then
        state.totalXP = (state.totalXP or 0) + math.max(0, (prevXPMax or 0) - (prevXP or 0)) + currentXP
    elseif currentXP >= prevXP then
        state.totalXP = (state.totalXP or 0) + (currentXP - prevXP)
    elseif currentXP < prevXP then
        state.totalXP = (state.totalXP or 0) + currentXP
    end

    state.prevXP = currentXP
    state.prevXPMax = currentXPMax
    state.prevLevel = currentLevel
end

function Core:GetLevelingTipMetrics()
    local state = self.levelingTipState
    local currentXP = UnitXP and UnitXP("player") or 0
    local currentXPMax = UnitXPMax and UnitXPMax("player") or 0
    local currentLevel = UnitLevel and UnitLevel("player") or 0
    local maxLevel = GetPlayerMaxLevelSafe()

    if not state then
        self:ResetLevelingTipTracking()
        state = self.levelingTipState
    end

    if not currentXPMax or currentXPMax <= 0 or currentLevel >= maxLevel then
        return {
            supported = false,
            currentLevel = currentLevel,
            maxLevel = maxLevel,
        }
    end

    local elapsed = math.max(0, GetTime() - (state.startedAt or GetTime()))
    local xpPerMinute = 0
    if elapsed > 0 and (state.totalXP or 0) > 0 then
        xpPerMinute = (state.totalXP / elapsed) * 60
    end

    local remainingXP = math.max(0, currentXPMax - currentXP)
    local secondsPerXP = xpPerMinute > 0 and (60 / xpPerMinute) or nil
    local levelETA = secondsPerXP and (remainingXP * secondsPerXP) or nil

    local levelsRemaining = math.max(0, maxLevel - currentLevel)
    local approxMaxRemainingXP = remainingXP
    if levelsRemaining > 1 then
        approxMaxRemainingXP = approxMaxRemainingXP + (levelsRemaining - 1) * currentXPMax
    end
    local maxETA = secondsPerXP and (approxMaxRemainingXP * secondsPerXP) or nil

    return {
        supported = true,
        currentLevel = currentLevel,
        maxLevel = maxLevel,
        xpPerMinute = xpPerMinute,
        remainingXP = remainingXP,
        levelETA = levelETA,
        maxETA = maxETA,
    }
end

function Core:RefreshLevelingTipFrame()
    local frame = self.levelingTipFrame
    if not frame then return end

    local cfg = MIcfg()
    local fontPath = LibSharedMedia:Fetch("font", cfg.levelingTipFont) or STANDARD_TEXT_FONT
    local fontSize = cfg.levelingTipFontSize or 13
    local metrics = self:GetLevelingTipMetrics()
    local labels = {
        xpPerMinute = frame.xpPerMinuteLine,
        remainingXP = frame.remainingXPLine,
        levelETA = frame.levelETALine,
        maxETA = frame.maxETALine,
    }
    local order = {
        { key = "xpPerMinute", enabled = cfg.levelingTipShowXPPerMinute, text = "每分钟经验：统计中..." },
        { key = "remainingXP", enabled = cfg.levelingTipShowRemainingXP, text = "距离升级：统计中..." },
        { key = "levelETA", enabled = cfg.levelingTipShowLevelETA, text = "预计升级：统计中..." },
        { key = "maxETA", enabled = cfg.levelingTipShowMaxETA, text = "预计满级：统计中..." },
    }

    if not metrics.supported then
        if metrics.currentLevel and metrics.maxLevel and metrics.currentLevel >= metrics.maxLevel then
            order[1].text = "每分钟经验：已满级"
            order[2].text = "距离升级：已满级"
            order[3].text = "预计升级：已满级"
            order[4].text = "预计满级：已达成"
        else
            order[1].text = "每分钟经验：当前不可用"
            order[2].text = "距离升级：当前不可用"
            order[3].text = "预计升级：当前不可用"
            order[4].text = "预计满级：当前不可用"
        end
    else
        order[1].text = string.format("每分钟经验：%d", math.floor((metrics.xpPerMinute or 0) + 0.5))
        order[2].text = string.format("距离升级：%d", metrics.remainingXP or 0)
        order[3].text = metrics.levelETA and ("预计升级还需：" .. FormatElapsedTime(metrics.levelETA)) or "预计升级：统计中..."
        order[4].text = metrics.maxETA and ("预计满级还需：" .. FormatElapsedTime(metrics.maxETA)) or "预计满级：统计中..."
    end

    local visibleLines = {}
    local yOffset = -8
    local maxWidth = 0
    local totalHeight = 0

    for _, item in ipairs(order) do
        local line = labels[item.key]
        line:SetFont(fontPath, fontSize, "OUTLINE")
        if item.enabled then
            line:SetText(item.text)
            line:Show()
            line:ClearAllPoints()
            line:SetPoint("TOPLEFT", frame, "TOPLEFT", 12, yOffset)
            yOffset = yOffset - math.ceil(line:GetStringHeight() + 6)
            totalHeight = totalHeight + math.ceil(line:GetStringHeight() + 6)
            maxWidth = math.max(maxWidth, math.ceil(line:GetStringWidth()))
            table.insert(visibleLines, line)
        else
            line:Hide()
        end
    end

    frame:SetSize(math.max(170, maxWidth + 24), math.max(32, totalHeight + 16))
    frame:SetMovable(not cfg.levelingTipLocked)
    if cfg.levelingTipLocked then
        frame.bg:SetColorTexture(0, 0, 0, 0)
    else
        frame.bg:SetColorTexture(0, 0.6, 1, 0.12)
    end
end

function Core:UpdateLevelingTipVisibility()
    if not self.levelingTipFrame then return end
    local cfg = MIcfg()
    local currentLevel = UnitLevel and UnitLevel("player") or 0
    local maxLevel = GetPlayerMaxLevelSafe()
    if cfg.levelingTipHideAtMaxLevel == nil then
        cfg.levelingTipHideAtMaxLevel = true
    end

    if cfg.levelingTipEnabled and not (cfg.levelingTipHideAtMaxLevel and currentLevel >= maxLevel) then
        self.levelingTipFrame:Show()
    else
        self.levelingTipFrame:Hide()
    end
end

function Core:SaveLevelingTipPosition()
    if not self.levelingTipFrame then return end
    local point, _, relativePoint, x, y = self.levelingTipFrame:GetPoint(1)
    local pos = MIcfg().levelingTipPoint
    pos.point = point or "CENTER"
    pos.relativePoint = relativePoint or "CENTER"
    pos.x = math.floor((x or 0) + 0.5)
    pos.y = math.floor((y or 0) + 0.5)
end

-- ═══════════════════════════════════════════════════
--  耐久度闪烁动画
-- ═══════════════════════════════════════════════════
local flashElapsed = 0
local flashVisible = true
local FLASH_INTERVAL = 0.5
local statePollElapsed = 0
local STATE_POLL_INTERVAL = 1.0

local function UpdateDurabilityFlash(dt)
    flashElapsed = flashElapsed + dt
    if flashElapsed >= FLASH_INTERVAL then
        flashElapsed = flashElapsed - FLASH_INTERVAL
        flashVisible = not flashVisible
    end
end

-- ═══════════════════════════════════════════════════
--  展示条布局
-- ═══════════════════════════════════════════════════

function Core:UpdateMiscBarLayout()
    if not self.miscFrame then return end
    local cfg = MIcfg()
    local frame = self.miscFrame
    local barSpacing = math.max(1, math.min(300, tonumber(cfg.barSpacing) or INFOBAR_SPACING))
    local fontPath = LibSharedMedia:Fetch("font", cfg.font) or STANDARD_TEXT_FONT
    local fontSize = cfg.fontSize
    local textColor = cfg.textColor or { r = 1, g = 1, b = 1 }
    local labelHex = GetInfoBarTextColorHex()

    frame.specButton.text:SetFont(fontPath, fontSize, "OUTLINE")
    frame.durabilityButton.text:SetFont(fontPath, fontSize, "OUTLINE")

    -- 专精图标
    local specName, specIcon = self:GetCurrentSpecializationName()
    local talentName = Utf8Truncate(self:GetCurrentTalentLoadoutName(), INFOBAR_TALENT_MAX_CHARS)
    local specText = string.format("%s / %s", specName, talentName)

    if specIcon and frame.specButton.icon then
        frame.specButton.icon:SetTexture(specIcon)
        frame.specButton.icon:Show()
        frame.specButton.text:SetPoint("LEFT", frame.specButton.icon, "RIGHT", 4, 0)
    else
        if frame.specButton.icon then
            frame.specButton.icon:Hide()
        end
        frame.specButton.text:SetPoint("LEFT", frame.specButton, "LEFT", INFOBAR_PADDING_X, 0)
    end
    frame.specButton.text:SetText(specText)
    frame.specButton.text:SetTextColor(textColor.r or 1, textColor.g or 1, textColor.b or 1, 1)

    -- 耐久度：标签白色，百分比按阈值着色
    local durabilityPercent = select(1, self:GetDurabilityEntries())
    local pctColorCode
    if durabilityPercent > 60 then
        pctColorCode = "|cFF33FF33" -- 绿色
    elseif durabilityPercent > 30 then
        pctColorCode = "|cFFFFDD33" -- 黄色
    else
        pctColorCode = "|cFFFF3333" -- 红色
    end
    local durabilityText = string.format("|cFF%s耐久度：|r%s%d%%|r", labelHex, pctColorCode, durabilityPercent)
    frame.durabilityButton.text:SetText(durabilityText)
    frame.durabilityButton.text:SetTextColor(1, 1, 1, 1)

    -- <60% 闪烁（通过透明度交替）
    if durabilityPercent < 60 then
        frame.durabilityButton.text:SetAlpha(flashVisible and 1 or 0.3)
    else
        frame.durabilityButton.text:SetAlpha(1)
    end

    -- 尺寸计算
    local iconOffset = (specIcon and (ICON_SIZE_BAR + 4)) or 0
    local specWidth = math.max(120,
        math.ceil(frame.specButton.text:GetStringWidth() + iconOffset + INFOBAR_PADDING_X * 2))
    local durabilityWidth = math.max(100, math.ceil(frame.durabilityButton.text:GetStringWidth() + INFOBAR_PADDING_X * 2))
    local height = math.max(26, math.ceil(frame.specButton.text:GetStringHeight() + INFOBAR_PADDING_Y * 2))

    frame.specButton:SetSize(specWidth, height)
    frame.durabilityButton:SetSize(durabilityWidth, height)

    local buttons = GetVisibleInfoBarButtons(frame, cfg)
    local totalWidth = 0
    local totalHeight = 0

    for index, button in ipairs(buttons) do
        button:ClearAllPoints()
        if cfg.infoBarOrientation == "VERTICAL" then
            if index == 1 then
                button:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
            else
                button:SetPoint("TOPLEFT", buttons[index - 1], "BOTTOMLEFT", 0, -barSpacing)
            end
            totalWidth = math.max(totalWidth, button:GetWidth())
            totalHeight = totalHeight + button:GetHeight() + (index > 1 and barSpacing or 0)
        else
            if index == 1 then
                button:SetPoint("LEFT", frame, "LEFT", 0, 0)
            else
                button:SetPoint("LEFT", buttons[index - 1], "RIGHT", barSpacing, 0)
            end
            totalWidth = totalWidth + button:GetWidth() + (index > 1 and barSpacing or 0)
            totalHeight = math.max(totalHeight, button:GetHeight())
        end
    end

    frame:SetSize(math.max(totalWidth, 1), math.max(totalHeight, height))

    if frame.specButton.icon then
        frame.specButton.icon:SetSize(ICON_SIZE_BAR, ICON_SIZE_BAR)
    end

    if cfg.infoBarLocked then
        frame.bg:SetColorTexture(0, 0, 0, 0)
        frame.specButton.bg:SetColorTexture(0, 0, 0, 0)
        frame.durabilityButton.bg:SetColorTexture(0, 0, 0, 0)
    else
        frame.bg:SetColorTexture(0, 0.6, 1, 0.12)
        frame.specButton.bg:SetColorTexture(0, 0, 0, 0.28)
        frame.durabilityButton.bg:SetColorTexture(0, 0, 0, 0.28)
    end
end

function Core:UpdateQuestToolsLayout()
    if not self.questToolsFrame then return end

    local cfg = MIcfg()
    local frame = self.questToolsFrame
    local spacing = math.max(1, math.min(300, tonumber(cfg.questToolsSpacing) or INFOBAR_SPACING))
    local fontPath = LibSharedMedia:Fetch("font", cfg.questToolsFont) or STANDARD_TEXT_FONT
    local fontSize = cfg.questToolsFontSize or 13
    local color = cfg.questToolsTextColor or { r = 1, g = 1, b = 1 }
    local labelHex = GetQuestToolsTextColorHex()

    frame.announceButton.text:SetFont(fontPath, fontSize, "OUTLINE")
    frame.turnInButton.text:SetFont(fontPath, fontSize, "OUTLINE")

    local announceState = cfg.autoAnnounceQuest and "|cFF33FF33开|r" or "|cFFFF5555关|r"
    local turnInState = cfg.autoQuestTurnIn and "|cFF33FF33开|r" or "|cFFFF5555关|r"
    frame.announceButton.text:SetText(string.format("|cFF%s任务通报：|r%s", labelHex, announceState))
    frame.turnInButton.text:SetText(string.format("|cFF%s自动交接：|r%s", labelHex, turnInState))
    frame.announceButton.text:SetTextColor(1, 1, 1, 1)
    frame.turnInButton.text:SetTextColor(1, 1, 1, 1)

    local height = math.max(26, math.ceil(frame.announceButton.text:GetStringHeight() + INFOBAR_PADDING_Y * 2))
    local announceWidth = math.max(118, math.ceil(frame.announceButton.text:GetStringWidth() + INFOBAR_PADDING_X * 2))
    local turnInWidth = math.max(118, math.ceil(frame.turnInButton.text:GetStringWidth() + INFOBAR_PADDING_X * 2))

    frame.announceButton:SetSize(announceWidth, height)
    frame.turnInButton:SetSize(turnInWidth, height)

    local buttons = GetVisibleQuestToolsButtons(frame)
    local totalWidth = 0
    local totalHeight = 0

    for index, button in ipairs(buttons) do
        button:ClearAllPoints()
        if cfg.questToolsOrientation == "VERTICAL" then
            if index == 1 then
                button:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
            else
                button:SetPoint("TOPLEFT", buttons[index - 1], "BOTTOMLEFT", 0, -spacing)
            end
            totalWidth = math.max(totalWidth, button:GetWidth())
            totalHeight = totalHeight + button:GetHeight() + (index > 1 and spacing or 0)
        else
            if index == 1 then
                button:SetPoint("LEFT", frame, "LEFT", 0, 0)
            else
                button:SetPoint("LEFT", buttons[index - 1], "RIGHT", spacing, 0)
            end
            totalWidth = totalWidth + button:GetWidth() + (index > 1 and spacing or 0)
            totalHeight = math.max(totalHeight, button:GetHeight())
        end
    end

    frame:SetSize(math.max(totalWidth, 1), math.max(totalHeight, height))
    frame:SetMovable(not cfg.questToolsLocked)

    if cfg.questToolsLocked then
        frame.bg:SetColorTexture(0, 0, 0, 0)
        frame.announceButton.bg:SetColorTexture(0, 0, 0, 0)
        frame.turnInButton.bg:SetColorTexture(0, 0, 0, 0)
    else
        frame.bg:SetColorTexture(0, 0.6, 1, 0.12)
        frame.announceButton.bg:SetColorTexture(0, 0, 0, 0.28)
        frame.turnInButton.bg:SetColorTexture(0, 0, 0, 0.28)
    end
end

function Core:UpdateQuestToolsVisibility()
    if not self.questToolsFrame then return end
    if MIcfg().questToolsEnabled then
        self.questToolsFrame:Show()
    else
        self.questToolsFrame:Hide()
    end
end

function Core:UpdateMiscBarVisibility()
    if not self.miscFrame then return end
    if MIcfg().infoBarEnabled then
        self.miscFrame:Show()
    else
        self.miscFrame:Hide()
    end
end

function Core:UpdateRaidMarkersLayout()
    if not self.raidMarkersFrame then return end

    local cfg = MIcfg()
    local frame = self.raidMarkersFrame
    local buttons = GetVisibleRaidMarkersButtons(frame)
    local spacing = math.max(0, math.min(40, tonumber(cfg.raidMarkersSpacing) or RAID_MARKERS_DEFAULT_SPACING))
    local iconSize = math.max(RAID_MARKERS_MIN_SIZE, math.min(RAID_MARKERS_MAX_SIZE,
        tonumber(cfg.raidMarkersIconSize) or RAID_MARKERS_DEFAULT_SIZE))
    local buttonSize = iconSize + RAID_MARKERS_BUTTON_PADDING * 2
    local fontPath = LibSharedMedia:Fetch("font", cfg.font) or STANDARD_TEXT_FONT
    local textSize = math.max(11, math.floor(iconSize * 0.45))
    local bgColor = cfg.raidMarkersBackgroundColor or { r = 0, g = 0, b = 0, a = 0.35 }
    local borderColor = cfg.raidMarkersBorderColor or { r = 0, g = 0.6, b = 1, a = 0.45 }
    local totalWidth = 0
    local totalHeight = 0

    for index, button in ipairs(buttons) do
        button:ClearAllPoints()
        button:SetSize(buttonSize, buttonSize)

        if not InCombatLockdown or not InCombatLockdown() then
            local macro1, macro2 = GetRaidMarkerMacroText(button.buttonInfo, cfg.raidMarkersCountdown)
            if macro1 then
                button:SetAttribute("type1", "macro")
                button:SetAttribute("macrotext1", macro1)
            end
            if macro2 then
                button:SetAttribute("type2", "macro")
                button:SetAttribute("macrotext2", macro2)
            else
                button:SetAttribute("type2", nil)
                button:SetAttribute("macrotext2", nil)
            end
        end

        if button.icon then
            button.icon:ClearAllPoints()
            button.icon:SetPoint("CENTER", button, "CENTER", 0, 0)
            button.icon:SetSize(iconSize, iconSize)
            if button.iconTexture then
                button.icon:SetTexture(button.iconTexture)
                button.icon:Show()
            else
                button.icon:SetTexture(nil)
                button.icon:Hide()
            end
        end

        if button.label then
            button.label:SetFont(fontPath, textSize, "OUTLINE")
            button.label:SetText(button.textValue or "")
            if (not button.iconTexture) and button.textValue and button.textValue ~= "" then
                button.label:Show()
            else
                button.label:Hide()
            end
        end

        if cfg.raidMarkersOrientation == "VERTICAL" then
            if index == 1 then
                button:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
            else
                button:SetPoint("TOPLEFT", buttons[index - 1], "BOTTOMLEFT", 0, -spacing)
            end
            totalWidth = math.max(totalWidth, buttonSize)
            totalHeight = totalHeight + buttonSize + (index > 1 and spacing or 0)
        else
            if index == 1 then
                button:SetPoint("LEFT", frame, "LEFT", 0, 0)
            else
                button:SetPoint("LEFT", buttons[index - 1], "RIGHT", spacing, 0)
            end
            totalWidth = totalWidth + buttonSize + (index > 1 and spacing or 0)
            totalHeight = math.max(totalHeight, buttonSize)
        end

        if cfg.raidMarkersShowBackground then
            button.bg:SetColorTexture(bgColor.r or 0, bgColor.g or 0, bgColor.b or 0, bgColor.a or 0.35)
        else
            button.bg:SetColorTexture(0, 0, 0, 0)
        end
    end

    frame:SetSize(math.max(totalWidth, 1), math.max(totalHeight, 1))
    frame:SetMovable(not cfg.raidMarkersLocked)

    if cfg.raidMarkersShowBackground then
        frame.bg:SetColorTexture(bgColor.r or 0, bgColor.g or 0, bgColor.b or 0,
            math.min((bgColor.a or 0.35) * 0.55, 0.4))
    else
        frame.bg:SetColorTexture(0, 0, 0, 0)
    end

    if cfg.raidMarkersShowBorder then
        SetSimpleOutlineColor(frame.border, borderColor.r or 0, borderColor.g or 0.6, borderColor.b or 1,
            borderColor.a or 0.45)
    else
        SetSimpleOutlineColor(frame.border, 0, 0, 0, 0)
    end
end

function Core:UpdateRaidMarkersVisibility()
    if not self.raidMarkersFrame then return end
    if MIcfg().raidMarkersEnabled then
        self.raidMarkersFrame:Show()
    else
        self.raidMarkersFrame:Hide()
    end
end

function Core:UpdateDelveQuickLeaveButton()
    if not self.delveQuickLeaveButton then return end
    local cfg = MIcfg()
    local button = self.delveQuickLeaveButton
    local size = math.max(DELVE_QUICK_LEAVE_MIN_SIZE,
        math.min(DELVE_QUICK_LEAVE_MAX_SIZE, tonumber(cfg.delveQuickLeaveIconSize) or DELVE_QUICK_LEAVE_DEFAULT_SIZE))

    button:SetSize(size, size)
    button.icon:SetTexture(GetConfiguredDelveQuickLeaveIcon())

    if cfg.delveQuickLeaveLocked then
        button.bg:SetColorTexture(0, 0, 0, 0)
        button.border:SetColorTexture(0, 0, 0, 0)
    else
        button.bg:SetColorTexture(0, 0, 0, 0.32)
        button.border:SetColorTexture(0, 0.6, 1, 0.45)
    end

    button:SetMovable(not cfg.delveQuickLeaveLocked)
    button:EnableMouse(true)
    self:EnsureDelveQuickLeaveButtonOnScreen()
end

function Core:UpdateDelveQuickLeaveVisibility()
    if not self.delveQuickLeaveButton then return end
    local cfg = MIcfg()
    if cfg.delveQuickLeaveEnabled and self:IsInDelve() then
        self.delveQuickLeaveButton:Show()
    else
        self.delveQuickLeaveButton:Hide()
    end
end

function Core:ApplyMiscSettings()
    local cfg = MIcfg()

    if self.miscFrame then
        self.miscFrame:SetMovable(not cfg.infoBarLocked)
        self.miscFrame:EnableMouse(true)
        self:HideMiscPopupMenu()
        self:UpdateMiscBarLayout()
        self:UpdateMiscBarVisibility()
    end

    if self.questToolsFrame then
        self.questToolsFrame:SetMovable(not cfg.questToolsLocked)
        self.questToolsFrame:EnableMouse(true)
        self:UpdateQuestToolsLayout()
        self:UpdateQuestToolsVisibility()
    end

    if self.raidMarkersFrame then
        self.raidMarkersFrame:SetMovable(not cfg.raidMarkersLocked)
        self.raidMarkersFrame:EnableMouse(true)
        self:UpdateRaidMarkersLayout()
        self:UpdateRaidMarkersVisibility()
    end

    if self.levelingTipFrame then
        if cfg.levelingTipEnabled and not self.levelingTipState then
            self:ResetLevelingTipTracking()
        end
        self.levelingTipFrame:SetMovable(not cfg.levelingTipLocked)
        self.levelingTipFrame:EnableMouse(true)
        self:RefreshLevelingTipFrame()
        self:UpdateLevelingTipVisibility()
    end

    self:UpdateDelveQuickLeaveButton()
    self:UpdateDelveQuickLeaveVisibility()
    self:UpdateMiscEventRegistration()
    self:ApplyGlobalTooltipHook()
    self:UpdateTooltipVisibility()
    self:ApplySystemAdjustSettings()
end

-- ═══════════════════════════════════════════════════
--  信息条创建
-- ═══════════════════════════════════════════════════

function Core:CreateMiscBar()
    if self.miscFrame then return end

    local frame = CreateFrame("Frame", addonName .. "MiscInfoBar", UIParent)
    frame:SetFrameStrata("LOW")
    frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")

    frame.bg = frame:CreateTexture(nil, "BACKGROUND")
    frame.bg:SetAllPoints(frame)

    local pos = MIcfg().barPoint
    frame:SetPoint(pos.point or "CENTER", UIParent, pos.relativePoint or "CENTER", pos.x or 0, pos.y or -150)

    frame:SetScript("OnDragStart", function(self)
        if MIcfg().infoBarLocked then return end
        Core:HideMiscPopupMenu()
        self:StartMoving()
    end)

    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        Core:SaveMiscBarPosition()
    end)

    -- ── 创建按钮 ──
    local function CreateSectionButton(parent, withIcon)
        local button = CreateFrame("Button", nil, parent)
        button:RegisterForClicks("AnyUp")
        button:RegisterForDrag("LeftButton")
        button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")

        button.bg = button:CreateTexture(nil, "BACKGROUND")
        button.bg:SetAllPoints(button)

        if withIcon then
            button.icon = button:CreateTexture(nil, "ARTWORK")
            button.icon:SetSize(ICON_SIZE_BAR, ICON_SIZE_BAR)
            button.icon:SetPoint("LEFT", button, "LEFT", 4, 0)

            button.text = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            button.text:SetPoint("LEFT", button.icon, "RIGHT", 4, 0)
        else
            button.text = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            button.text:SetPoint("CENTER")
        end

        button:SetScript("OnDragStart", function()
            if MIcfg().infoBarLocked then return end
            Core:HideMiscPopupMenu()
            parent:StartMoving()
        end)

        button:SetScript("OnDragStop", function()
            if MIcfg().infoBarLocked then return end
            parent:StopMovingOrSizing()
            Core:SaveMiscBarPosition()
        end)

        return button
    end

    frame.specButton = CreateSectionButton(frame, true) -- 带图标
    frame.durabilityButton = CreateSectionButton(frame, false)

    -- ── 专精按钮：提示 ──
    frame.specButton:SetScript("OnEnter", function(self)
        Core:SetTooltipAnchor(GameTooltip, self, "ANCHOR_BOTTOM")
        GameTooltip:AddLine("专精 / 天赋", 1, 0.82, 0)
        GameTooltip:AddLine(" ")
        for _, entry in ipairs(Core:GetSpecializationEntries()) do
            local prefix = entry.active and "|cFF33FF99●|r " or "○ "
            local iconStr = entry.icon and ("|T" .. entry.icon .. ":16:16:0:0|t ") or ""
            GameTooltip:AddLine(iconStr .. prefix .. entry.name,
                entry.active and 0.2 or 1, 1, entry.active and 0.6 or 1)
        end
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("天赋方案", 1, 0.82, 0)
        local loadouts = Core:GetTalentLoadouts()
        if #loadouts == 0 then
            GameTooltip:AddLine("未读取到方案列表", 0.7, 0.7, 0.7)
        else
            for _, entry in ipairs(loadouts) do
                local prefix = entry.active and "|cFF33FF99●|r " or "○ "
                GameTooltip:AddLine(prefix .. entry.name,
                    entry.active and 0.2 or 1, 1, entry.active and 0.6 or 1)
            end
        end
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("左键：切换专精", 0.75, 1, 0.75)
        GameTooltip:AddLine("右键：切换天赋方案", 0.75, 1, 0.75)
        GameTooltip:Show()
    end)
    frame.specButton:SetScript("OnLeave", function() GameTooltip:Hide() end)

    -- ── 专精按钮：点击 ──
    frame.specButton:SetScript("OnClick", function(self, button)
        GameTooltip:Hide()
        if button == "RightButton" then
            Core:ShowTalentMenu(self)
        else
            Core:ShowSpecMenu(self)
        end
    end)

    -- ── 耐久按钮：提示（显示所有装备含图标，无修理价格） ──
    frame.durabilityButton:SetScript("OnEnter", function(self)
        Core:SetTooltipAnchor(GameTooltip, self, "ANCHOR_BOTTOM")
        local overall, entries = Core:GetDurabilityEntries()
        GameTooltip:AddLine("耐久度", 1, 0.82, 0)
        GameTooltip:AddLine(string.format("当前平均耐久：%d%%", overall), 1, 1, 1)
        GameTooltip:AddLine(" ")
        if #entries == 0 then
            GameTooltip:AddLine("无耐久度装备", 0.7, 0.7, 0.7)
        else
            for _, entry in ipairs(entries) do
                local pct = math.floor(entry.percent + 0.5)
                local iconStr = entry.icon and ("|T" .. entry.icon .. ":16:16:0:0|t ") or ""
                local r, g, b = 0.6, 1, 0.6
                if pct < 30 then
                    r, g, b = 1, 0.2, 0.2
                elseif pct < 50 then
                    r, g, b = 1, 0.85, 0.2
                elseif pct < 100 then
                    r, g, b = 1, 0.85, 0.4
                end
                GameTooltip:AddLine(string.format("%s%s %d%%", iconStr, entry.itemName, pct), r, g, b)
            end
        end
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("点击打开角色界面", 0.75, 1, 0.75)
        GameTooltip:Show()
    end)
    frame.durabilityButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
    frame.durabilityButton:SetScript("OnClick", function(_, button)
        if button == "LeftButton" then
            Core:OpenCharacterFrame()
        end
    end)

    self.miscFrame = frame
    self:CreateQuestToolsFrame()
    self:CreateRaidMarkersFrame()
    self:CreateLevelingTipFrame()
    self:CreateDelveQuickLeaveButton()

    -- ── 事件帧 ──
    self.miscEventFrame = CreateFrame("Frame")
    self.miscEventFrame:SetScript("OnEvent", function(_, event, ...)
        if event == "PLAYER_ENTERING_WORLD"
            or event == "ZONE_CHANGED_NEW_AREA"
            or event == "WALK_IN_DATA_UPDATE"
            or event == "ACTIVE_DELVE_DATA_UPDATE"
            or event == "PLAYER_SPECIALIZATION_CHANGED"
            or event == "ACTIVE_TALENT_GROUP_CHANGED"
            or event == "TRAIT_CONFIG_UPDATED"
            or event == "TRAIT_CONFIG_LIST_UPDATED"
            or event == "UPDATE_INVENTORY_DURABILITY"
            or event == "PLAYER_EQUIPMENT_CHANGED" then
            Core:UpdateMiscBarLayout()
            Core:RefreshLevelingTipFrame()
            Core:UpdateDelveQuickLeaveVisibility()
            return
        end

        if event == "CONSOLE_MESSAGE" then
            local message = ...
            local cfg = Core.db and Core.db.profile and Core.db.profile.systemAdjust
            if cfg and cfg.npcTimeShowPhaseAlert and npcPhaseAlertReady and type(message) == "string" and string.find(string.lower(message), "new connection", 1, true) then
                PrintPhaseAlert()
            end
            return
        end

        if event == "PLAYER_TARGET_CHANGED" or event == "NAME_PLATE_UNIT_ADDED" or event == "NAME_PLATE_UNIT_REMOVED" then
            Core:UpdateTargetArrowVisibility()
            return
        end

        if event == "PLAYER_XP_UPDATE" then
            local unit = ...
            if unit == "player" then
                Core:UpdateLevelingTipTracking()
                Core:RefreshLevelingTipFrame()
                Core:UpdateLevelingTipVisibility()
            end
            return
        end

        if event == "PLAYER_LEVEL_UP" then
            Core:UpdateLevelingTipTracking()
            Core:RefreshLevelingTipFrame()
            Core:UpdateLevelingTipVisibility()
            return
        end

        Core:HandleMiscQuestEvent(event, ...)
    end)

    if C_Timer and C_Timer.After then
        C_Timer.After(1, function()
            npcPhaseAlertReady = true
        end)
    else
        npcPhaseAlertReady = true
    end

    -- ── 闪烁定时器 ──
    frame:SetScript("OnUpdate", function(_, dt)
        statePollElapsed = statePollElapsed + dt
        local durabilityPercent = select(1, Core:GetDurabilityEntries())
        if durabilityPercent < 60 then
            UpdateDurabilityFlash(dt)
            Core:UpdateMiscBarLayout()
        else
            -- 重置闪烁状态
            flashVisible = true
            flashElapsed = 0
        end

        if statePollElapsed >= STATE_POLL_INTERVAL then
            statePollElapsed = statePollElapsed - STATE_POLL_INTERVAL
            Core:UpdateMiscBarLayout()
            Core:UpdateDelveQuickLeaveVisibility()
        end
    end)

    self:ApplyMiscSettings()
end

function Core:CreateQuestToolsFrame()
    if self.questToolsFrame then return end

    local cfg = MIcfg()
    local frame = CreateFrame("Frame", addonName .. "QuestToolsFrame", UIParent)
    frame:SetFrameStrata("LOW")
    frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")

    frame.bg = frame:CreateTexture(nil, "BACKGROUND")
    frame.bg:SetAllPoints(frame)

    local pos = cfg.questToolsPoint
    frame:SetPoint(pos.point or "CENTER", UIParent, pos.relativePoint or "CENTER", pos.x or 0, pos.y or -110)

    frame:SetScript("OnDragStart", function(self)
        if MIcfg().questToolsLocked then return end
        self:StartMoving()
    end)

    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        Core:SaveQuestToolsPosition()
    end)

    local function CreateQuestButton(parent)
        local button = CreateFrame("Button", nil, parent)
        button:RegisterForClicks("AnyUp")
        button:RegisterForDrag("LeftButton")
        button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")

        button.bg = button:CreateTexture(nil, "BACKGROUND")
        button.bg:SetAllPoints(button)

        button.text = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        button.text:SetPoint("CENTER")

        button:SetScript("OnDragStart", function()
            if MIcfg().questToolsLocked then return end
            parent:StartMoving()
        end)

        button:SetScript("OnDragStop", function()
            if MIcfg().questToolsLocked then return end
            parent:StopMovingOrSizing()
            Core:SaveQuestToolsPosition()
        end)

        return button
    end

    frame.announceButton = CreateQuestButton(frame)
    frame.turnInButton = CreateQuestButton(frame)

    frame.announceButton:SetScript("OnEnter", function(self)
        Core:SetTooltipAnchor(GameTooltip, self, "ANCHOR_BOTTOM")
        GameTooltip:AddLine("任务通报", 1, 0.82, 0)
        GameTooltip:AddLine(MIcfg().autoAnnounceQuest and "当前：已开启" or "当前：已关闭", 1, 1, 1)
        GameTooltip:AddLine("点击切换接取/完成任务时的聊天通报。", 0.75, 1, 0.75)
        GameTooltip:Show()
    end)
    frame.announceButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
    frame.announceButton:SetScript("OnClick", function(_, button)
        if button == "LeftButton" then
            Core:ToggleQuestAnnounce()
        end
    end)

    frame.turnInButton:SetScript("OnEnter", function(self)
        Core:SetTooltipAnchor(GameTooltip, self, "ANCHOR_BOTTOM")
        GameTooltip:AddLine("自动交接", 1, 0.82, 0)
        GameTooltip:AddLine(MIcfg().autoQuestTurnIn and "当前：已开启" or "当前：已关闭", 1, 1, 1)
        GameTooltip:AddLine("点击切换自动接任务、交任务和领奖。", 0.75, 1, 0.75)
        GameTooltip:Show()
    end)
    frame.turnInButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
    frame.turnInButton:SetScript("OnClick", function(_, button)
        if button == "LeftButton" then
            Core:ToggleQuestTurnIn()
        end
    end)

    self.questToolsFrame = frame
    self:UpdateQuestToolsLayout()
    self:UpdateQuestToolsVisibility()
end

function Core:CreateRaidMarkersFrame()
    if self.raidMarkersFrame then return end

    local cfg = MIcfg()
    local frame = CreateFrame("Frame", addonName .. "RaidMarkersFrame", UIParent)
    frame:SetFrameStrata("MEDIUM")
    frame:SetToplevel(true)
    frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")

    frame.bg = frame:CreateTexture(nil, "BACKGROUND")
    frame.bg:SetAllPoints(frame)

    frame.border = CreateSimpleOutline(frame, "BORDER", RAID_MARKERS_BUTTON_BORDER)

    local pos = cfg.raidMarkersPoint
    frame:SetPoint(pos.point or "CENTER", UIParent, pos.relativePoint or "CENTER", pos.x or 0, pos.y or -30)

    frame:SetScript("OnDragStart", function(self)
        if MIcfg().raidMarkersLocked then return end
        self:StartMoving()
    end)

    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        Core:SaveRaidMarkersPosition()
    end)

    local function CreateMarkerButton(parent)
        local button = CreateFrame("Button", nil, parent, "SecureActionButtonTemplate")
        button:RegisterForClicks("AnyDown", "AnyUp")
        button:RegisterForDrag("LeftButton")
        button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
        button:SetScale(1)
        button._hoverScale = 1
        button._hoverTargetScale = 1

        button.bg = button:CreateTexture(nil, "BACKGROUND")
        button.bg:SetAllPoints(button)

        button.icon = button:CreateTexture(nil, "ARTWORK")
        button.icon:SetPoint("CENTER")

        button.label = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        button.label:SetPoint("CENTER")

        button:SetScript("OnDragStart", function()
            if MIcfg().raidMarkersLocked then return end
            parent:StartMoving()
        end)

        button:SetScript("OnDragStop", function()
            if MIcfg().raidMarkersLocked then return end
            parent:StopMovingOrSizing()
            Core:SaveRaidMarkersPosition()
        end)

        button:HookScript("OnEnter", function(self)
            SetRaidMarkerButtonHoverTarget(self, 1.12)
        end)

        button:HookScript("OnLeave", function(self)
            SetRaidMarkerButtonHoverTarget(self, 1)
        end)

        return button
    end

    frame.buttons = {}

    for _, info in ipairs(RAID_TARGET_BUTTONS) do
        local button = CreateMarkerButton(frame)
        button.buttonInfo = info
        button.tooltipTitle = info.label
        button.tooltipText = "给当前目标设置团队标记。"
        button.iconTexture = info.texture
        button.textValue = nil
        button.icon:SetTexture(info.texture)
        button.icon:Show()
        button.label:Hide()

        button:SetScript("OnEnter", function(self)
            Core:SetTooltipAnchor(GameTooltip, self, "ANCHOR_BOTTOM")
            GameTooltip:AddLine(self.tooltipTitle or "团队标记", 1, 0.82, 0)
            GameTooltip:AddLine(self.tooltipText or "", 1, 1, 1)
            GameTooltip:AddLine("左键设置，右键清除。", 0.75, 1, 0.75)
            GameTooltip:Show()
        end)
        button:SetScript("OnLeave", function() GameTooltip:Hide() end)
        table.insert(frame.buttons, button)
    end

    for _, info in ipairs(RAID_ACTION_BUTTONS) do
        local button = CreateMarkerButton(frame)
        button.buttonInfo = info
        button.textValue = info.label
        button.iconTexture = info.texture
        button.tooltipTitle = info.tooltipTitle
        button.tooltipText = info.tooltipText
        if info.texture then
            button.icon:SetTexture(info.texture)
            button.icon:Show()
            button.label:Hide()
        else
            button.icon:SetTexture(nil)
            button.icon:Hide()
            button.label:Show()
        end

        button:SetScript("OnEnter", function(self)
            Core:SetTooltipAnchor(GameTooltip, self, "ANCHOR_BOTTOM")
            GameTooltip:AddLine(self.tooltipTitle or "团队功能", 1, 0.82, 0)
            GameTooltip:AddLine(self.tooltipText or "", 1, 1, 1)
            if info.key == "COUNTDOWN" then
                GameTooltip:AddLine(string.format("当前秒数：%d 秒", math.max(3, math.min(15,
                    tonumber(MIcfg().raidMarkersCountdown) or RAID_MARKERS_DEFAULT_COUNTDOWN))), 0.75, 1, 0.75)
            elseif info.key == "CLEAR" then
                GameTooltip:AddLine("右键团队标记按钮也能直接清除。", 0.75, 1, 0.75)
            end
            GameTooltip:Show()
        end)
        button:SetScript("OnLeave", function() GameTooltip:Hide() end)
        table.insert(frame.buttons, button)
    end

    self.raidMarkersFrame = frame
    self:UpdateRaidMarkersLayout()
    self:UpdateRaidMarkersVisibility()
end

function Core:CreateTimerWindow()
    if self.timerFrame then return end

    local frame = CreateFrame("Frame", addonName .. "TimerWindow", UIParent, "BasicFrameTemplateWithInset")
    frame:SetSize(280, 190)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    frame:SetMovable(true)
    frame:SetClampedToScreen(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:Hide()

    frame:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)

    frame:SetScript("OnEvent", function(_, event, ...)
        Core:HandleTimerTrackingEvent(event, ...)
    end)

    frame:SetScript("OnUpdate", function(_, _)
        local session = Core.timerSession
        if session and session.running then
            Core:RefreshTimerWindow()
        end
    end)

    if frame.TitleText then
        frame.TitleText:SetText("收益计时")
    end

    local function CreateLabelRow(parent, label, yOffset)
        local rowLabel = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        rowLabel:SetPoint("TOPLEFT", parent, "TOPLEFT", 16, yOffset)
        rowLabel:SetText(label)

        local rowValue = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        rowValue:SetPoint("LEFT", rowLabel, "RIGHT", 12, 0)
        rowValue:SetJustifyH("LEFT")
        rowValue:SetText("")

        return rowValue
    end

    frame.statusValue = CreateLabelRow(frame, "状态：", -38)
    frame.elapsedValue = CreateLabelRow(frame, "时长：", -64)
    frame.moneyValue = CreateLabelRow(frame, "金币变化：", -90)
    frame.xpValue = CreateLabelRow(frame, "经验变化：", -116)

    frame.startButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    frame.startButton:SetSize(100, 24)
    frame.startButton:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 22, 18)
    frame.startButton:SetText("开始")
    frame.startButton:SetScript("OnClick", function()
        Core:StartTimerTracking()
    end)

    frame.stopButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    frame.stopButton:SetSize(100, 24)
    frame.stopButton:SetPoint("LEFT", frame.startButton, "RIGHT", 20, 0)
    frame.stopButton:SetText("停止")
    frame.stopButton:SetScript("OnClick", function()
        Core:StopTimerTracking()
    end)

    self.timerFrame = frame
    self:RefreshTimerWindow()
end

function Core:CreateLevelingTipFrame()
    if self.levelingTipFrame then return end

    local cfg = MIcfg()
    local frame = CreateFrame("Frame", addonName .. "LevelingTipFrame", UIParent)
    frame:SetFrameStrata("LOW")
    frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")

    frame.bg = frame:CreateTexture(nil, "BACKGROUND")
    frame.bg:SetAllPoints(frame)

    local pos = cfg.levelingTipPoint
    frame:SetPoint(pos.point or "CENTER", UIParent, pos.relativePoint or "CENTER", pos.x or 0, pos.y or -70)

    frame:SetScript("OnDragStart", function(self)
        if MIcfg().levelingTipLocked then return end
        self:StartMoving()
    end)

    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        Core:SaveLevelingTipPosition()
    end)

    local function CreateLine(parent)
        local fs = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        fs:SetJustifyH("LEFT")
        fs:SetPoint("TOPLEFT", parent, "TOPLEFT", 12, -8)
        return fs
    end

    frame.xpPerMinuteLine = CreateLine(frame)
    frame.remainingXPLine = CreateLine(frame)
    frame.levelETALine = CreateLine(frame)
    frame.maxETALine = CreateLine(frame)

    frame:SetScript("OnUpdate", function(_, elapsed)
        frame._tick = (frame._tick or 0) + elapsed
        if frame._tick >= 1 then
            frame._tick = 0
            if MIcfg().levelingTipEnabled then
                Core:RefreshLevelingTipFrame()
            end
        end
    end)

    self.levelingTipFrame = frame
    if cfg.levelingTipEnabled then
        self:ResetLevelingTipTracking()
    end
    self:RefreshLevelingTipFrame()
    self:UpdateLevelingTipVisibility()
end

function Core:CreateDelveQuickLeaveButton()
    if self.delveQuickLeaveButton then return end

    local button = CreateFrame("Button", addonName .. "DelveQuickLeaveButton", UIParent)
    button:SetFrameStrata("MEDIUM")
    button:SetToplevel(true)
    button:SetClampedToScreen(true)
    button:SetMovable(true)
    button:EnableMouse(true)
    button:RegisterForDrag("LeftButton")
    button:RegisterForClicks("LeftButtonUp")

    button.bg = button:CreateTexture(nil, "BACKGROUND")
    button.bg:SetAllPoints(button)

    button.border = button:CreateTexture(nil, "BORDER")
    button.border:SetPoint("TOPLEFT", button, "TOPLEFT", -1, 1)
    button.border:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 1, -1)

    button.icon = button:CreateTexture(nil, "ARTWORK")
    button.icon:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
    button.icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
    button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    button.highlight = button:CreateTexture(nil, "HIGHLIGHT")
    button.highlight:SetAllPoints(button)
    button.highlight:SetColorTexture(1, 1, 1, 0.14)

    local pos = MIcfg().delveQuickLeavePoint
    button:SetPoint(pos.point or "CENTER", UIParent, pos.relativePoint or "CENTER", pos.x or 180, pos.y or -20)

    button:SetScript("OnDragStart", function(self)
        if MIcfg().delveQuickLeaveLocked then return end
        self:StartMoving()
    end)

    button:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        Core:SaveDelveQuickLeavePosition()
    end)

    button:SetScript("OnEnter", function(self)
        Core:SetTooltipAnchor(GameTooltip, self, "ANCHOR_RIGHT")
        GameTooltip:AddLine("快速离开地下堡", 1, 0.82, 0)
        GameTooltip:AddLine("点击后尝试离开当前地下堡。", 1, 1, 1)
        if not MIcfg().delveQuickLeaveLocked then
            GameTooltip:AddLine("拖动图标可调整位置。", 0.75, 1, 0.75)
        end
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function() GameTooltip:Hide() end)
    button:SetScript("OnClick", function(_, buttonName)
        if buttonName == "LeftButton" then
            Core:LeaveDelve()
        end
    end)

    self.delveQuickLeaveButton = button
    self:UpdateDelveQuickLeaveButton()
    self:UpdateDelveQuickLeaveVisibility()
end
