local addonName, ns = ...
local Core = ns.Core
local LibSharedMedia = LibStub("LibSharedMedia-3.0")

local DUNGEON_DIFFICULTIES = {
    { id = 1, key = "NORMAL", label = "普通难度", display = "5人普通本" },
    { id = 2, key = "HEROIC", label = "英雄难度", display = "5人英雄本" },
    { id = 23, key = "MYTHIC", label = "史诗难度", display = "5人史诗本" },
}

local RAID_DIFFICULTIES = {
    { key = "NORMAL", label = "普通难度", modernId = 14, legacy10 = 3, legacy25 = 4, display10 = "10人普通团本", display25 = "25人普通团本", displayModern = "普通团本" },
    { key = "HEROIC", label = "英雄难度", modernId = 15, legacy10 = 5, legacy25 = 6, display10 = "10人英雄团本", display25 = "25人英雄团本", displayModern = "英雄团本" },
    { key = "MYTHIC", label = "史诗难度", modernId = 16, legacy10 = 16, legacy25 = 16, display10 = "史诗团本", display25 = "史诗团本", displayModern = "史诗团本" },
}

local RAID_SIZES = {
    { size = 10, label = "10人" },
    { size = 25, label = "25人" },
}

local RAID_DIFFICULTY_BY_KEY = {}
for _, info in ipairs(RAID_DIFFICULTIES) do
    RAID_DIFFICULTY_BY_KEY[info.key] = info
end

local INSTANCE_EVENTS = {
    "PLAYER_DIFFICULTY_CHANGED",
    "PLAYER_ENTERING_WORLD",
    "ZONE_CHANGED_NEW_AREA",
    "GROUP_FORMED",
    "GROUP_LEFT",
    "GROUP_ROSTER_UPDATE",
    "GUILD_PARTY_STATE_UPDATED",
    "UPDATE_INSTANCE_INFO",
    "PARTY_LEADER_CHANGED",
    "GROUP_JOINED",
    "RAID_INSTANCE_WELCOME",
}

local function IDcfg()
    local cfg = Core.db.profile.instanceDifficulty
    if cfg.enabled == nil then cfg.enabled = true end
    if cfg.visible == nil then cfg.visible = cfg.showOnLogin ~= false end
    if cfg.locked == nil then cfg.locked = false end
    if cfg.showOnLogin == nil then cfg.showOnLogin = true end
    if cfg.autoCollapseInInstance == nil then cfg.autoCollapseInInstance = true end
    if cfg.showCenterToast == nil then cfg.showCenterToast = true end
    if cfg.centerToastDuration == nil then cfg.centerToastDuration = 3 end
    if cfg.ttsEnabled == nil then cfg.ttsEnabled = true end
    if cfg.ttsVolume == nil then cfg.ttsVolume = 100 end
    if cfg.announceToChat == nil then cfg.announceToChat = true end
    if cfg.showResetButton == nil then cfg.showResetButton = true end
    if cfg.showTeleportButton == nil then cfg.showTeleportButton = true end
    if cfg.showLeaveButton == nil then cfg.showLeaveButton = true end
    if cfg.frameScale == nil then cfg.frameScale = 1 end
    if cfg.fontSize == nil then cfg.fontSize = 13 end
    if cfg.fontOutline == nil then cfg.fontOutline = true end
    if cfg.normalTextColor == nil then cfg.normalTextColor = { r = 1, g = 0.82, b = 0.25 } end
    if cfg.selectedTextColor == nil then cfg.selectedTextColor = { r = 0.2, g = 1, b = 0.2 } end
    if cfg.orientation == nil then cfg.orientation = "VERTICAL" end
    if cfg.backgroundTexture == nil then cfg.backgroundTexture = "Yuxuan" end
    if cfg.backgroundAlpha == nil then cfg.backgroundAlpha = 0.18 end
    if not cfg.point then
        cfg.point = {
            point = "CENTER",
            relativePoint = "CENTER",
            x = 280,
            y = 0,
        }
    end
    return cfg
end

local function GetGroupChatChannel()
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

local function SendAssistantMessage(message)
    local cfg = IDcfg()
    if not cfg.announceToChat then return end
    local channel = GetGroupChatChannel()
    local sendChatMessage = _G["SendChatMessage"]
    if channel and type(sendChatMessage) == "function" then
        sendChatMessage(message, channel)
    end
end

local function CreateFlatButton(parent, width, height, text, kind)
    local button = CreateFrame("Button", nil, parent)
    button:SetSize(width, height)
    button.fixedWidth = width

    button.kind = kind or "select"
    button.isHovered = false
    button.isSelected = false
    button.baseTextColor = kind == "action" and { 0.25, 1, 1 } or { 1, 0.82, 0.25 }
    button.hoverTextColor = { 1, 0.82, 0 }
    button.selectedTextColor = { 0.2, 1, 0.2 }

    button.text = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    button.text:SetPoint("CENTER")
    button.text:SetText(text or "")
    button.text:SetJustifyH("CENTER")
    button:SetHitRectInsets(-4, -4, -2, -2)

    button:SetScript("OnEnter", function(self)
        self.isHovered = true
        Core:UpdateInstanceDifficultyButtonStyle(self)
    end)
    button:SetScript("OnLeave", function(self)
        self.isHovered = false
        Core:UpdateInstanceDifficultyButtonStyle(self)
    end)

    return button
end

local function SetTextColor(fontString, color)
    if not fontString or not color then return end
    fontString:SetTextColor(color[1] or 1, color[2] or 1, color[3] or 1)
end

local function FormatRaidDisplay(raidKey, raidSize)
    local info = RAID_DIFFICULTY_BY_KEY[raidKey]
    if not info then return "团本" end
    if raidKey == "MYTHIC" then
        return info.displayModern
    end
    if raidSize == 10 then
        return info.display10
    elseif raidSize == 25 then
        return info.display25
    end
    return info.displayModern
end

function Core:UpdateInstanceDifficultyButtonStyle(button)
    if not button or not button.text then return end

    local cfg = IDcfg()
    if button.kind ~= "action" then
        local base = cfg.normalTextColor or { r = 1, g = 0.82, b = 0.25 }
        local selected = cfg.selectedTextColor or { r = 0.2, g = 1, b = 0.2 }
        button.baseTextColor = { base.r or 1, base.g or 0.82, base.b or 0.25 }
        button.selectedTextColor = { selected.r or 0.2, selected.g or 1, selected.b or 0.2 }
    end

    if not button:IsEnabled() then
        SetTextColor(button.text, { 0.45, 0.45, 0.45 })
        button:SetAlpha(0.55)
        return
    end

    local textColor = button.baseTextColor
    local alpha = 0.9

    if button.isSelected then
        textColor = button.selectedTextColor
        alpha = 1
    elseif button.isHovered then
        textColor = button.hoverTextColor
        alpha = 1
    elseif button.kind == "action" then
        alpha = 0.95
    end

    button:SetAlpha(alpha)
    SetTextColor(button.text, textColor)
end

local function UpdateTextButtonWidth(button, minWidth)
    if not button or not button.text then return end
    local width = math.max(button.fixedWidth or 0, minWidth or 42, (button.text:GetStringWidth() or 0) + 12)
    button:SetWidth(width)
end

function Core:CanChangeInstanceDifficulty()
    if not IsInGroup() and not IsInRaid() then
        return true
    end
    return UnitIsGroupLeader("player") and true or false
end

function Core:GetInstanceDifficultyState()
    local inInstance, instanceType = IsInInstance()
    local instanceName, _, difficultyID, difficultyName = GetInstanceInfo()

    local dungeonDiff = GetDungeonDifficultyID and GetDungeonDifficultyID() or 0
    local legacyDiff = GetLegacyRaidDifficultyID and GetLegacyRaidDifficultyID() or 0
    local modernDiff = GetRaidDifficultyID and GetRaidDifficultyID() or 0
    local raidSize = 0
    local raidKey = nil

    if inInstance and instanceType == "party" and difficultyID and difficultyID > 0 then
        dungeonDiff = difficultyID
    end

    local raidSource = 0
    if inInstance and instanceType == "raid" and difficultyID and difficultyID > 0 then
        raidSource = difficultyID
    elseif legacyDiff and legacyDiff > 0 then
        raidSource = legacyDiff
    end

    if raidSource == 3 then
        raidSize = 10
        raidKey = "NORMAL"
    elseif raidSource == 4 then
        raidSize = 25
        raidKey = "NORMAL"
    elseif raidSource == 5 then
        raidSize = 10
        raidKey = "HEROIC"
    elseif raidSource == 6 then
        raidSize = 25
        raidKey = "HEROIC"
    elseif raidSource == 16 then
        raidSize = 20
        raidKey = "MYTHIC"
    elseif modernDiff == 14 then
        raidKey = "NORMAL"
    elseif modernDiff == 15 then
        raidKey = "HEROIC"
    elseif modernDiff == 16 then
        raidKey = "MYTHIC"
        raidSize = 20
    end

    local displayText = ""
    if inInstance and instanceType == "party" then
        for _, info in ipairs(DUNGEON_DIFFICULTIES) do
            if info.id == dungeonDiff then
                displayText = info.display
                break
            end
        end
        if displayText == "" then
            displayText = difficultyName and ("5人" .. difficultyName) or "5人地下城"
        end
    elseif inInstance and instanceType == "raid" then
        displayText = FormatRaidDisplay(raidKey, raidSize)
        if displayText == "团本" and difficultyName and difficultyName ~= "" then
            displayText = difficultyName
        end
    end

    return {
        inInstance = inInstance,
        instanceType = instanceType,
        instanceName = instanceName,
        difficultyID = difficultyID,
        dungeonDiff = dungeonDiff,
        legacyDiff = legacyDiff,
        modernDiff = modernDiff,
        raidSize = raidSize,
        raidKey = raidKey,
        displayText = displayText,
        canCollapse = inInstance and (instanceType == "party" or instanceType == "raid"),
    }
end

function Core:SaveInstanceDifficultyPosition()
    local frame = self.instanceDifficultyFrame
    if not frame then return end

    local centerX, centerY = frame:GetCenter()
    if not centerX or not centerY then return end

    local cfg = IDcfg()
    cfg.point = {
        point = "CENTER",
        relativePoint = "CENTER",
        x = centerX - (UIParent:GetWidth() / 2),
        y = centerY - (UIParent:GetHeight() / 2),
    }
end

function Core:SetInstanceDifficultyCollapsed(collapsed)
    local frame = self.instanceDifficultyFrame
    if not frame then return end

    frame.collapsed = collapsed and true or false
    local isVertical = IDcfg().orientation == "VERTICAL"
    local expandedWidth = isVertical and 300 or 282
    local expandedHeight = isVertical and 152 or 132
    frame:SetSize(frame.collapsed and 236 or expandedWidth, frame.collapsed and 62 or expandedHeight)

    local showExpanded = not frame.collapsed
    local showCollapsed = frame.collapsed

    frame.dungeonHeader:SetShown(showExpanded)
    frame.raidHeader:SetShown(showExpanded)
    frame.raidSizeLabel:SetShown(showExpanded)
    frame.raidDifficultyLabel:SetShown(false)
    frame.titleText:SetShown(false)
    frame.divider:SetShown(showExpanded)
    frame.statusText:SetShown(false)
    frame.resetButton:SetShown(showExpanded and IDcfg().showResetButton)

    for _, button in ipairs(frame.dungeonButtons) do
        button:SetShown(showExpanded)
    end
    for _, button in ipairs(frame.raidSizeButtons) do
        button:SetShown(showExpanded)
    end
    for _, button in ipairs(frame.raidDifficultyButtons) do
        button:SetShown(showExpanded)
    end

    frame.collapsedLabel:SetShown(showCollapsed)
    frame.blessingLeft:SetShown(false)
    frame.blessingRight:SetShown(false)

    frame.resetButton:ClearAllPoints()
    frame.teleportButton:ClearAllPoints()
    frame.leaveButton:ClearAllPoints()

    if showCollapsed then
        frame.teleportButton:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 8)
        frame.leaveButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 8)
        frame.statusText:ClearAllPoints()
        frame.statusText:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -8)
        frame.collapsedLabel:ClearAllPoints()
        frame.collapsedLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -10)
    else
        local actionGap = 10
        local totalWidth = 0
        local shownButtons = {}
        if frame.resetButton:IsShown() then table.insert(shownButtons, frame.resetButton) end
        if frame.teleportButton:IsShown() then table.insert(shownButtons, frame.teleportButton) end
        if frame.leaveButton:IsShown() then table.insert(shownButtons, frame.leaveButton) end
        for index, button in ipairs(shownButtons) do
            totalWidth = totalWidth + button:GetWidth()
            if index > 1 then
                totalWidth = totalWidth + actionGap
            end
        end

        local startX = -(totalWidth / 2)
        local previous
        for _, button in ipairs(shownButtons) do
            if not previous then
                button:SetPoint("BOTTOMLEFT", frame, "BOTTOM", startX, 8)
            else
                button:SetPoint("LEFT", previous, "RIGHT", actionGap, 0)
            end
            previous = button
        end
        frame.statusText:ClearAllPoints()
        frame.statusText:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 28)
    end
end

function Core:ApplyInstanceDifficultyFonts()
    local frame = self.instanceDifficultyFrame
    if not frame then return end

    local cfg = IDcfg()
    local baseSize = math.max(10, math.min(24, cfg.fontSize or 13))
    local outline = cfg.fontOutline and "OUTLINE" or ""

    frame.titleText:SetFont(STANDARD_TEXT_FONT, baseSize + 2, outline)
    frame.dungeonHeader:SetFont(STANDARD_TEXT_FONT, baseSize + 1, outline)
    frame.raidHeader:SetFont(STANDARD_TEXT_FONT, baseSize + 1, outline)
    frame.raidSizeLabel:SetFont(STANDARD_TEXT_FONT, baseSize + 1, outline)
    frame.raidDifficultyLabel:SetFont(STANDARD_TEXT_FONT, math.max(10, baseSize - 1), outline)
    frame.collapsedLabel:SetFont(STANDARD_TEXT_FONT, baseSize + 2, outline)
    frame.blessingLeft:SetFont(STANDARD_TEXT_FONT, baseSize + 1, outline)
    frame.blessingRight:SetFont(STANDARD_TEXT_FONT, baseSize + 1, outline)
    frame.statusText:SetFont(STANDARD_TEXT_FONT, math.max(10, baseSize - 1), outline)

    for _, button in ipairs(frame.allButtons) do
        if button.text then
            button.text:SetFont(STANDARD_TEXT_FONT, baseSize, outline)
            UpdateTextButtonWidth(button, button.kind == "action" and 64 or 44)
        end
    end
end

function Core:ApplyInstanceDifficultyBackground()
    local frame = self.instanceDifficultyFrame
    if not frame or not frame.bg then return end

    local cfg = IDcfg()
    local texturePath = LibSharedMedia and LibSharedMedia.Fetch and
        LibSharedMedia:Fetch("statusbar", cfg.backgroundTexture) or nil
    frame.bg:SetTexture(texturePath or "Interface\\Buttons\\WHITE8x8")
    frame.bg:SetVertexColor(0.03, 0.08, 0.12, math.max(0, math.min(1, tonumber(cfg.backgroundAlpha) or 0.18)))
end

function Core:LayoutInstanceDifficultyFrame()
    local frame = self.instanceDifficultyFrame
    if not frame then return end

    local function LayoutRow(buttons, startX, y, gap)
        local cursor = startX
        for _, button in ipairs(buttons) do
            button:ClearAllPoints()
            button:SetPoint("TOPLEFT", frame, "TOPLEFT", cursor, y)
            cursor = cursor + button:GetWidth() + (gap or 12)
        end
    end

    local function LayoutColumn(buttons, startX, startY, gap)
        local cursor = startY
        for _, button in ipairs(buttons) do
            button:ClearAllPoints()
            button:SetPoint("TOPLEFT", frame, "TOPLEFT", startX, cursor)
            cursor = cursor - (button:GetHeight() + (gap or 6))
        end
    end

    local collapsed = frame.collapsed and true or false
    local orientation = IDcfg().orientation or "VERTICAL"

    if collapsed then
        frame.divider:ClearAllPoints()
        frame.divider:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 30)
        frame.divider:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 30)
        return
    end

    if orientation == "HORIZONTAL" then
        frame.dungeonHeader:SetText("地下城:")
        frame.raidHeader:SetText(" 团队:")
        frame.raidSizeLabel:SetText("人数:")

        local labelLeft = 10
        local labelWidth = 46
        local buttonStart = 58

        frame.dungeonHeader:ClearAllPoints()
        frame.dungeonHeader:SetPoint("TOPLEFT", frame, "TOPLEFT", labelLeft, -12)
        frame.dungeonHeader:SetWidth(labelWidth)
        frame.dungeonHeader:SetJustifyH("RIGHT")
        LayoutRow(frame.dungeonButtons, buttonStart, -10, 8)

        frame.raidHeader:ClearAllPoints()
        frame.raidHeader:SetPoint("TOPLEFT", frame, "TOPLEFT", labelLeft, -40)
        frame.raidHeader:SetWidth(labelWidth)
        frame.raidHeader:SetJustifyH("RIGHT")
        LayoutRow(frame.raidDifficultyButtons, buttonStart, -38, 8)

        frame.raidSizeLabel:ClearAllPoints()
        frame.raidSizeLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", labelLeft, -68)
        frame.raidSizeLabel:SetWidth(labelWidth)
        frame.raidSizeLabel:SetJustifyH("RIGHT")
        LayoutRow(frame.raidSizeButtons, buttonStart, -66, 8)

        frame.divider:ClearAllPoints()
        frame.divider:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 22)
        frame.divider:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 22)
        return
    end

    frame.dungeonHeader:SetText("地下城")
    frame.raidHeader:SetText("团队")
    frame.raidSizeLabel:SetText("人数")

    frame.dungeonHeader:ClearAllPoints()
    frame.dungeonHeader:SetPoint("TOP", frame, "TOPLEFT", 14 + 32, -10)
    frame.dungeonHeader:SetWidth(64)
    frame.dungeonHeader:SetJustifyH("CENTER")
    LayoutColumn(frame.dungeonButtons, 14, -36, 6)

    frame.raidHeader:ClearAllPoints()
    frame.raidHeader:SetPoint("TOP", frame, "TOPLEFT", 118 + 32, -10)
    frame.raidHeader:SetWidth(64)
    frame.raidHeader:SetJustifyH("CENTER")
    LayoutColumn(frame.raidDifficultyButtons, 118, -36, 6)

    frame.raidSizeLabel:ClearAllPoints()
    frame.raidSizeLabel:SetPoint("TOP", frame, "TOPLEFT", 222 + 32, -10)
    frame.raidSizeLabel:SetWidth(64)
    frame.raidSizeLabel:SetJustifyH("CENTER")
    LayoutColumn(frame.raidSizeButtons, 222, -36, 6)

    frame.divider:ClearAllPoints()
    frame.divider:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 22)
    frame.divider:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 22)
end

function Core:CreateInstanceDifficultyToast()
    if self.instanceDifficultyToast then return end

    local toast = CreateFrame("Frame", addonName .. "InstanceDifficultyToast", UIParent)
    toast:SetSize(520, 100)
    toast:SetPoint("CENTER", UIParent, "CENTER", 0, UIParent:GetHeight() * 0.2)
    toast:SetFrameStrata("FULLSCREEN_DIALOG")
    toast.text = toast:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
    toast.text:SetPoint("CENTER")
    toast.text:SetFont(STANDARD_TEXT_FONT, 28, "OUTLINE")
    toast.text:SetTextColor(1, 0.15, 1)
    toast.text:SetShadowOffset(2, -2)
    toast.text:SetShadowColor(0, 0, 0, 1)
    toast:Hide()

    self.instanceDifficultyToast = toast
end

function Core:SpeakInstanceDifficulty(text)
    local cfg = IDcfg()
    if not cfg.ttsEnabled or not text or text == "" or InCombatLockdown() then
        return
    end

    local now = GetTime()
    if self.instanceDifficultyLastSpeech and (now - self.instanceDifficultyLastSpeech) < 5 then
        return
    end

    local volume = math.max(0, math.min(100, tonumber(cfg.ttsVolume) or 100))
    local volumeRatio = volume / 100
    local voiceChat = _G.C_VoiceChat
    local textToSpeech = _G["C_TextToSpeech"]

    C_Timer.After(0.3, function()
        if not Core.db or not Core.db.profile.instanceDifficulty.enabled then return end
        local speakVoice = voiceChat and voiceChat.SpeakText
        local speakTTS = textToSpeech and textToSpeech.SpeakText
        if type(speakVoice) == "function" and Enum and Enum.VoiceTtsDestination then
            local destination = Enum.VoiceTtsDestination.LocalPlayback or Enum.VoiceTtsDestination.RemoteTransmission
            pcall(speakVoice, 0, text, destination, false, volume)
        elseif type(speakTTS) == "function" then
            pcall(speakTTS, text, 0, volumeRatio, 1.0)
        end
    end)

    self.instanceDifficultyLastSpeech = now
end

function Core:ShowInstanceDifficultyToast(text)
    local cfg = IDcfg()
    if not cfg.showCenterToast or not text or text == "" then return end

    self:CreateInstanceDifficultyToast()
    local toast = self.instanceDifficultyToast
    toast.text:SetText(text)
    toast:Show()
    self:SpeakInstanceDifficulty(text)

    local duration = math.max(1, math.min(8, tonumber(cfg.centerToastDuration) or 3))
    if toast.hideTimer then
        toast.hideTimer:Cancel()
    end
    toast.hideTimer = C_Timer.NewTimer(duration, function()
        if toast then
            toast:Hide()
            toast.hideTimer = nil
        end
    end)
end

function Core:UpdateInstanceDifficultyButtons()
    local frame = self.instanceDifficultyFrame
    if not frame then return end

    local state = self:GetInstanceDifficultyState()
    frame.currentState = state
    local canChange = self:CanChangeInstanceDifficulty()

    for _, button in ipairs(frame.dungeonButtons) do
        button.isSelected = button.difficultyId == state.dungeonDiff
        button:SetEnabled(canChange)
        self:UpdateInstanceDifficultyButtonStyle(button)
    end

    for _, button in ipairs(frame.raidSizeButtons) do
        button.isSelected = (state.raidKey ~= "MYTHIC") and button.raidSize == state.raidSize
        button:SetEnabled(canChange)
        self:UpdateInstanceDifficultyButtonStyle(button)
    end

    for _, button in ipairs(frame.raidDifficultyButtons) do
        button.isSelected = button.raidKey == state.raidKey
        button:SetEnabled(canChange)
        self:UpdateInstanceDifficultyButtonStyle(button)
    end

    frame.resetButton:SetEnabled(canChange)
    frame.teleportButton:SetEnabled(IDcfg().showTeleportButton)
    frame.leaveButton:SetEnabled(IDcfg().showLeaveButton)
    self:UpdateInstanceDifficultyButtonStyle(frame.resetButton)
    self:UpdateInstanceDifficultyButtonStyle(frame.teleportButton)
    self:UpdateInstanceDifficultyButtonStyle(frame.leaveButton)

    frame.statusText:SetText("")
    frame.titleText:SetText(state.canCollapse and "副本助手" or "副本难度助手")

    if state.displayText and state.displayText ~= "" then
        frame.collapsedLabel:SetText(state.displayText)
    else
        frame.collapsedLabel:SetText("当前不在副本内")
    end

    if IDcfg().autoCollapseInInstance and state.canCollapse then
        self:SetInstanceDifficultyCollapsed(true)
    else
        self:SetInstanceDifficultyCollapsed(false)
    end
    self:LayoutInstanceDifficultyFrame()
end

function Core:UpdateInstanceDifficultyVisibility()
    local frame = self.instanceDifficultyFrame
    if not frame then return end

    local cfg = IDcfg()
    if not cfg.enabled or not cfg.visible then
        frame:Hide()
        return
    end

    frame:Show()
end

function Core:UpdateInstanceDifficultyEventRegistration()
    if not self.instanceDifficultyEventFrame then return end

    self.instanceDifficultyEventFrame:UnregisterAllEvents()

    local cfg = IDcfg()
    if cfg.enabled then
        for _, eventName in ipairs(INSTANCE_EVENTS) do
            self.instanceDifficultyEventFrame:RegisterEvent(eventName)
        end
        if not self.instanceDifficultyTicker and C_Timer and C_Timer.NewTicker then
            self.instanceDifficultyTicker = C_Timer.NewTicker(1, function()
                if Core.db and Core.db.profile and Core.db.profile.instanceDifficulty and Core.db.profile.instanceDifficulty.enabled then
                    Core:UpdateInstanceDifficultyButtons()
                end
            end)
        end
    elseif self.instanceDifficultyTicker then
        self.instanceDifficultyTicker:Cancel()
        self.instanceDifficultyTicker = nil
    end
end

function Core:AnnounceInstanceDifficultyAction(message)
    if not message or message == "" then return end
    SendAssistantMessage(message)
end

function Core:HandleDungeonDifficultyChange(difficultyId)
    if not self:CanChangeInstanceDifficulty() then
        print("|cFF33FF99雨轩工具箱|r：你没有权限修改难度")
        self:UpdateInstanceDifficultyButtons()
        return
    end

    if SetDungeonDifficultyID then
        SetDungeonDifficultyID(difficultyId)
        for _, info in ipairs(DUNGEON_DIFFICULTIES) do
            if info.id == difficultyId then
                self:AnnounceInstanceDifficultyAction("已切换地下城难度：" .. info.label)
                break
            end
        end
        C_Timer.After(0.2, function() Core:UpdateInstanceDifficultyButtons() end)
    end
end

function Core:HandleRaidSizeChange(raidSize)
    if not self:CanChangeInstanceDifficulty() then
        print("|cFF33FF99雨轩工具箱|r：你没有权限修改难度")
        self:UpdateInstanceDifficultyButtons()
        return
    end

    local state = self:GetInstanceDifficultyState()
    local raidKey = state.raidKey or "HEROIC"
    local info = RAID_DIFFICULTY_BY_KEY[raidKey] or RAID_DIFFICULTY_BY_KEY.HEROIC
    local legacyId = raidKey == "MYTHIC" and 16 or (raidSize == 10 and info.legacy10 or info.legacy25)

    if SetRaidDifficultyID and info.modernId then
        SetRaidDifficultyID(info.modernId)
    end
    if SetLegacyRaidDifficultyID then
        SetLegacyRaidDifficultyID(legacyId)
    end

    self:AnnounceInstanceDifficultyAction("已切换团本人数：" .. raidSize .. "人")
    C_Timer.After(0.2, function() Core:UpdateInstanceDifficultyButtons() end)
end

function Core:HandleRaidDifficultyChange(raidKey)
    if not self:CanChangeInstanceDifficulty() then
        print("|cFF33FF99雨轩工具箱|r：你没有权限修改难度")
        self:UpdateInstanceDifficultyButtons()
        return
    end

    local info = RAID_DIFFICULTY_BY_KEY[raidKey]
    if not info then return end

    local state = self:GetInstanceDifficultyState()
    local raidSize = state.raidSize == 10 and 10 or 25
    local legacyId = raidKey == "MYTHIC" and 16 or (raidSize == 10 and info.legacy10 or info.legacy25)

    if SetRaidDifficultyID and info.modernId then
        SetRaidDifficultyID(info.modernId)
    end
    if SetLegacyRaidDifficultyID then
        SetLegacyRaidDifficultyID(legacyId)
    end

    self:AnnounceInstanceDifficultyAction("已切换团本难度：" .. info.label)
    C_Timer.After(0.2, function() Core:UpdateInstanceDifficultyButtons() end)
end

function Core:ResetCurrentInstances()
    if not self:CanChangeInstanceDifficulty() and (IsInGroup() or IsInRaid()) then
        print("|cFF33FF99雨轩工具箱|r：你没有权限重置副本")
        return
    end

    if ResetInstances then
        ResetInstances()
        self:AnnounceInstanceDifficultyAction("副本已重置")
    end
end

function Core:TeleportInstance()
    if type(LFGTeleport) == "function" then
        local inInstance = IsInInstance()
        LFGTeleport(IsInLFGDungeon())
        self:AnnounceInstanceDifficultyAction(inInstance and "正在传送出副本..." or "正在传送进副本...")
    else
        print("|cFF33FF99雨轩工具箱|r：当前环境不支持传送")
    end
end

function Core:QuickLeaveInstance()
    local inInstance, instanceType = IsInInstance()

    if inInstance then
        if instanceType == "scenario" and C_PartyInfo and C_PartyInfo.DelveTeleportOut and
            ((C_PartyInfo.IsDelveInProgress and C_PartyInfo.IsDelveInProgress()) or
                (C_PartyInfo.IsDelveComplete and C_PartyInfo.IsDelveComplete()) or
                (C_PartyInfo.IsPartyWalkIn and C_PartyInfo.IsPartyWalkIn())) then
            C_PartyInfo.DelveTeleportOut()
            return
        end

        if instanceType == "arena" or instanceType == "pvp" then
            if LeaveBattlefield then
                LeaveBattlefield()
            end
            return
        end

        if C_PartyInfo and C_PartyInfo.LeaveParty and (IsInGroup() or IsInRaid() or IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
            C_PartyInfo.LeaveParty()
            return
        end

        if type(LFGTeleport) == "function" and IsInLFGDungeon() ~= nil then
            LFGTeleport(IsInLFGDungeon())
            return
        end

        if C_PartyInfo and C_PartyInfo.InviteUnit and C_PartyInfo.LeaveParty then
            C_PartyInfo.InviteUnit("123")
            C_Timer.After(1, function()
                if C_PartyInfo and C_PartyInfo.LeaveParty then
                    C_PartyInfo.LeaveParty()
                end
            end)
            return
        end
    else
        if C_PartyInfo and C_PartyInfo.LeaveParty and (IsInGroup() or IsInRaid() or IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
            C_PartyInfo.LeaveParty()
            return
        end
    end

    print("|cFF33FF99雨轩工具箱|r：当前场景无法快速离开")
end

function Core:ToggleInstanceDifficultyFrame(forceVisible)
    local cfg = IDcfg()
    if forceVisible == nil then
        cfg.visible = not cfg.visible
    else
        cfg.visible = forceVisible and true or false
    end
    self:ApplyInstanceDifficultySettings()
end

function Core:ApplyInstanceDifficultySettings()
    local cfg = IDcfg()
    self:CreateInstanceDifficultyFrame()

    local frame = self.instanceDifficultyFrame
    frame:SetScale(math.max(0.7, math.min(1.5, tonumber(cfg.frameScale) or 1)))
    frame:ClearAllPoints()
    frame:SetPoint(cfg.point.point or "CENTER", UIParent, cfg.point.relativePoint or "CENTER", cfg.point.x or 0,
        cfg.point.y or 0)
    frame:SetMovable(not cfg.locked)
    frame:EnableMouse(true)
    self:ApplyInstanceDifficultyBackground()

    frame.resetButton:SetShown(cfg.showResetButton and not frame.collapsed)
    frame.teleportButton:SetShown(cfg.showTeleportButton)
    frame.leaveButton:SetShown(cfg.showLeaveButton)

    self:ApplyInstanceDifficultyFonts()
    self:LayoutInstanceDifficultyFrame()
    self:UpdateInstanceDifficultyEventRegistration()
    self:UpdateInstanceDifficultyButtons()
    self:UpdateInstanceDifficultyVisibility()
end

function Core:HandleInstanceDifficultyEvent(event)
    if not self.db or not self.db.profile or not self.db.profile.instanceDifficulty or not self.db.profile.instanceDifficulty.enabled then
        return
    end

    if event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD" then
        C_Timer.After(0.2, function()
            local state = Core:GetInstanceDifficultyState()
            local instanceKey = state.canCollapse and
                ((state.instanceName or "") .. ":" .. tostring(state.difficultyID or 0)) or nil
            local shouldToast = instanceKey and instanceKey ~= Core.instanceDifficultyLastInstanceKey
            Core.instanceDifficultyLastInstanceKey = instanceKey
            Core:UpdateInstanceDifficultyButtons()
            if shouldToast and state.displayText ~= "" then
                Core:ShowInstanceDifficultyToast(state.displayText)
            end
        end)
        return
    end

    C_Timer.After(0.15, function()
        Core:UpdateInstanceDifficultyButtons()
    end)
end

function Core:CreateInstanceDifficultyFrame()
    if self.instanceDifficultyFrame then return end

    local frame = CreateFrame("Frame", addonName .. "InstanceDifficultyFrame", UIParent)
    frame:SetSize(300, 152)
    frame:SetFrameStrata("MEDIUM")
    frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame.bg = frame:CreateTexture(nil, "BACKGROUND")
    frame.bg:SetAllPoints()

    frame.header = frame:CreateTexture(nil, "ARTWORK")
    frame.header:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -1)
    frame.header:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -1)
    frame.header:SetHeight(1)
    frame.header:SetColorTexture(0.35, 0.75, 1, 0.22)

    frame.divider = frame:CreateTexture(nil, "BORDER")
    frame.divider:SetHeight(1)
    frame.divider:SetColorTexture(0.35, 0.75, 1, 0.18)

    frame:SetScript("OnDragStart", function(self)
        if IDcfg().locked then return end
        self:StartMoving()
    end)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        Core:SaveInstanceDifficultyPosition()
    end)

    frame.titleText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.titleText:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -10)
    frame.titleText:SetText("副本难度助手")
    frame.titleText:SetTextColor(1, 0.84, 0.2)
    frame.titleText:Hide()

    frame.closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    frame.closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -2)
    frame.closeButton:SetScript("OnClick", function()
        Core:ToggleInstanceDifficultyFrame(false)
    end)
    frame.closeButton:Hide()

    frame.dungeonHeader = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.dungeonHeader:SetText("地下城:")
    frame.dungeonHeader:SetTextColor(0.35, 0.85, 1)

    frame.raidHeader = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.raidHeader:SetText(" 团队:")
    frame.raidHeader:SetTextColor(1, 0.78, 0.3)

    frame.raidSizeLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.raidSizeLabel:SetText("人数:")
    frame.raidSizeLabel:SetTextColor(0.45, 1, 0.55)

    frame.raidDifficultyLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    frame.raidDifficultyLabel:SetText("")
    frame.raidDifficultyLabel:SetTextColor(0.75, 0.85, 1)

    frame.collapsedLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    frame.collapsedLabel:SetTextColor(0.2, 1, 0.2)
    frame.collapsedLabel:Hide()

    frame.blessingLeft = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.blessingLeft:SetText("欧气满满")
    frame.blessingLeft:SetTextColor(1, 0.82, 0)
    frame.blessingLeft:Hide()

    frame.blessingRight = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.blessingRight:SetText("所求必揽")
    frame.blessingRight:SetTextColor(1, 0.82, 0)
    frame.blessingRight:Hide()

    frame.statusText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    frame.statusText:SetTextColor(1, 1, 0)

    frame.dungeonButtons = {}
    frame.raidSizeButtons = {}
    frame.raidDifficultyButtons = {}
    frame.allButtons = {}

    for _, info in ipairs(DUNGEON_DIFFICULTIES) do
        local button = CreateFlatButton(frame, 64, 20, info.label)
        button.difficultyId = info.id
        button:SetScript("OnClick", function() Core:HandleDungeonDifficultyChange(info.id) end)
        table.insert(frame.dungeonButtons, button)
        table.insert(frame.allButtons, button)
    end

    for _, info in ipairs(RAID_SIZES) do
        local button = CreateFlatButton(frame, 64, 20, info.label)
        button.raidSize = info.size
        button:SetScript("OnClick", function() Core:HandleRaidSizeChange(info.size) end)
        table.insert(frame.raidSizeButtons, button)
        table.insert(frame.allButtons, button)
    end

    for _, info in ipairs(RAID_DIFFICULTIES) do
        local button = CreateFlatButton(frame, 64, 20, info.label)
        button.raidKey = info.key
        button:SetScript("OnClick", function() Core:HandleRaidDifficultyChange(info.key) end)
        table.insert(frame.raidDifficultyButtons, button)
        table.insert(frame.allButtons, button)
    end

    frame.resetButton = CreateFlatButton(frame, 58, 18, "重置", "action")
    frame.resetButton:SetScript("OnClick", function() Core:ResetCurrentInstances() end)

    frame.teleportButton = CreateFlatButton(frame, 76, 18, "传进/出", "action")
    frame.teleportButton:SetScript("OnClick", function() Core:TeleportInstance() end)

    frame.leaveButton = CreateFlatButton(frame, 58, 18, "退出", "action")
    frame.leaveButton:SetScript("OnClick", function() Core:QuickLeaveInstance() end)

    table.insert(frame.allButtons, frame.resetButton)
    table.insert(frame.allButtons, frame.teleportButton)
    table.insert(frame.allButtons, frame.leaveButton)

    self.instanceDifficultyFrame = frame
    self.instanceDifficultyEventFrame = CreateFrame("Frame")
    self.instanceDifficultyEventFrame:SetScript("OnEvent", function(_, event)
        Core:HandleInstanceDifficultyEvent(event)
    end)

    self:ApplyInstanceDifficultyFonts()
    self:LayoutInstanceDifficultyFrame()
    self:ApplyInstanceDifficultyBackground()
end
