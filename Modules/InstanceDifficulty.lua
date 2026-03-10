local addonName, ns = ...
local Core = ns.Core

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
    local button = CreateFrame("Button", nil, parent, "BackdropTemplate")
    button:SetSize(width, height)
    button:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
    })

    button.kind = kind or "select"
    button.isHovered = false
    button.isSelected = false
    button.baseTextColor = kind == "action" and { 0.25, 1, 1 } or { 1, 0.35, 0.35 }
    button.hoverTextColor = { 1, 0.82, 0 }
    button.selectedTextColor = { 0.2, 1, 0.2 }

    button.text = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    button.text:SetPoint("CENTER")
    button.text:SetText(text or "")

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

    if not button:IsEnabled() then
        button:SetBackdropColor(0.08, 0.08, 0.08, 0.6)
        button:SetBackdropBorderColor(0.18, 0.18, 0.18, 0.8)
        SetTextColor(button.text, { 0.45, 0.45, 0.45 })
        return
    end

    local textColor = button.baseTextColor
    local bgColor = { 0.08, 0.08, 0.08, 0.85 }
    local borderColor = { 0.22, 0.22, 0.22, 1 }

    if button.isSelected then
        textColor = button.selectedTextColor
        bgColor = { 0.08, 0.18, 0.08, 0.92 }
        borderColor = { 0.18, 0.7, 0.18, 1 }
    elseif button.isHovered then
        textColor = button.hoverTextColor
        bgColor = { 0.15, 0.15, 0.15, 0.92 }
        borderColor = { 0.8, 0.65, 0.15, 1 }
    elseif button.kind == "action" then
        bgColor = { 0.08, 0.12, 0.16, 0.92 }
        borderColor = { 0.16, 0.5, 0.65, 1 }
    end

    button:SetBackdropColor(bgColor[1], bgColor[2], bgColor[3], bgColor[4])
    button:SetBackdropBorderColor(borderColor[1], borderColor[2], borderColor[3], borderColor[4])
    SetTextColor(button.text, textColor)
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
    frame:SetHeight(frame.collapsed and 108 or 214)

    local showExpanded = not frame.collapsed
    local showCollapsed = frame.collapsed

    frame.dungeonHeader:SetShown(showExpanded)
    frame.raidHeader:SetShown(showExpanded)
    frame.titleText:SetShown(true)
    frame.divider:SetShown(showExpanded)
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
    frame.blessingLeft:SetShown(showCollapsed)
    frame.blessingRight:SetShown(showCollapsed)

    frame.teleportButton:ClearAllPoints()
    frame.leaveButton:ClearAllPoints()

    if showCollapsed then
        frame.teleportButton:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 14, 12)
        frame.leaveButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -14, 12)
        frame.statusText:ClearAllPoints()
        frame.statusText:SetPoint("TOP", frame, "TOP", 0, -34)
    else
        frame.teleportButton:SetPoint("BOTTOM", frame, "BOTTOM", 0, 12)
        frame.leaveButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -14, 12)
        frame.resetButton:ClearAllPoints()
        frame.resetButton:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 14, 12)
        frame.statusText:ClearAllPoints()
        frame.statusText:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -14, -14)
    end
end

function Core:ApplyInstanceDifficultyFonts()
    local frame = self.instanceDifficultyFrame
    if not frame then return end

    local cfg = IDcfg()
    local baseSize = math.max(10, math.min(24, cfg.fontSize or 13))

    frame.titleText:SetFont(STANDARD_TEXT_FONT, baseSize + 2, "OUTLINE")
    frame.dungeonHeader:SetFont(STANDARD_TEXT_FONT, baseSize + 1, "OUTLINE")
    frame.raidHeader:SetFont(STANDARD_TEXT_FONT, baseSize + 1, "OUTLINE")
    frame.collapsedLabel:SetFont(STANDARD_TEXT_FONT, baseSize + 2, "OUTLINE")
    frame.blessingLeft:SetFont(STANDARD_TEXT_FONT, baseSize + 1, "OUTLINE")
    frame.blessingRight:SetFont(STANDARD_TEXT_FONT, baseSize + 1, "OUTLINE")
    frame.statusText:SetFont(STANDARD_TEXT_FONT, math.max(10, baseSize - 1), "OUTLINE")

    for _, button in ipairs(frame.allButtons) do
        if button.text then
            button.text:SetFont(STANDARD_TEXT_FONT, baseSize, "OUTLINE")
        end
    end
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

    local statusText
    if canChange then
        statusText = "当前：可修改难度"
    elseif IsInGroup() or IsInRaid() then
        statusText = "当前：队员只读（队长可修改）"
    else
        statusText = "当前：单人模式"
    end
    frame.statusText:SetText(statusText)
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

    frame.resetButton:SetShown(cfg.showResetButton and not frame.collapsed)
    frame.teleportButton:SetShown(cfg.showTeleportButton)
    frame.leaveButton:SetShown(cfg.showLeaveButton)

    self:ApplyInstanceDifficultyFonts()
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

    local frame = CreateFrame("Frame", addonName .. "InstanceDifficultyFrame", UIParent, "BackdropTemplate")
    frame:SetSize(330, 214)
    frame:SetFrameStrata("MEDIUM")
    frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    frame:SetBackdropColor(0.03, 0.04, 0.05, 0.88)
    frame:SetBackdropBorderColor(0, 0.55, 0.9, 0.32)

    frame.header = frame:CreateTexture(nil, "ARTWORK")
    frame.header:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1)
    frame.header:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -1)
    frame.header:SetHeight(28)
    frame.header:SetColorTexture(0.08, 0.16, 0.24, 0.96)

    frame.divider = frame:CreateTexture(nil, "BORDER")
    frame.divider:SetPoint("TOPLEFT", frame, "TOPLEFT", 14, -64)
    frame.divider:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -14, -64)
    frame.divider:SetHeight(1)
    frame.divider:SetColorTexture(0, 0.55, 0.9, 0.22)

    frame:SetScript("OnDragStart", function(self)
        if IDcfg().locked then return end
        self:StartMoving()
    end)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        Core:SaveInstanceDifficultyPosition()
    end)

    frame.titleText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.titleText:SetPoint("TOPLEFT", frame, "TOPLEFT", 14, -8)
    frame.titleText:SetText("副本难度助手")
    frame.titleText:SetTextColor(1, 0.84, 0.2)

    frame.closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    frame.closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -2)
    frame.closeButton:SetScript("OnClick", function()
        Core:ToggleInstanceDifficultyFrame(false)
    end)

    frame.dungeonHeader = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.dungeonHeader:SetPoint("TOPLEFT", frame, "TOPLEFT", 14, -46)
    frame.dungeonHeader:SetText("地下城难度")
    frame.dungeonHeader:SetTextColor(1, 0.82, 0)

    frame.raidHeader = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.raidHeader:SetPoint("TOPLEFT", frame, "TOPLEFT", 178, -46)
    frame.raidHeader:SetText("团本难度")
    frame.raidHeader:SetTextColor(1, 0.82, 0)

    frame.collapsedLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    frame.collapsedLabel:SetPoint("TOP", frame, "TOP", 0, -42)
    frame.collapsedLabel:SetTextColor(0.2, 1, 0.2)
    frame.collapsedLabel:Hide()

    frame.blessingLeft = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.blessingLeft:SetPoint("TOPLEFT", frame, "TOPLEFT", 18, -68)
    frame.blessingLeft:SetText("欧气满满")
    frame.blessingLeft:SetTextColor(1, 0.82, 0)
    frame.blessingLeft:Hide()

    frame.blessingRight = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.blessingRight:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -18, -68)
    frame.blessingRight:SetText("所求必揽")
    frame.blessingRight:SetTextColor(1, 0.82, 0)
    frame.blessingRight:Hide()

    frame.statusText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    frame.statusText:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -14, -14)
    frame.statusText:SetTextColor(1, 1, 0)

    frame.dungeonButtons = {}
    frame.raidSizeButtons = {}
    frame.raidDifficultyButtons = {}
    frame.allButtons = {}

    for index, info in ipairs(DUNGEON_DIFFICULTIES) do
        local button = CreateFlatButton(frame, 136, 24, info.label)
        button:SetPoint("TOPLEFT", frame, "TOPLEFT", 14, -70 - (index - 1) * 28)
        button.difficultyId = info.id
        button:SetScript("OnClick", function() Core:HandleDungeonDifficultyChange(info.id) end)
        table.insert(frame.dungeonButtons, button)
        table.insert(frame.allButtons, button)
    end

    for index, info in ipairs(RAID_SIZES) do
        local button = CreateFlatButton(frame, 62, 22, info.label)
        button:SetPoint("TOPLEFT", frame, "TOPLEFT", 178 + (index - 1) * 68, -70)
        button.raidSize = info.size
        button:SetScript("OnClick", function() Core:HandleRaidSizeChange(info.size) end)
        table.insert(frame.raidSizeButtons, button)
        table.insert(frame.allButtons, button)
    end

    for index, info in ipairs(RAID_DIFFICULTIES) do
        local button = CreateFlatButton(frame, 136, 24, info.label)
        button:SetPoint("TOPLEFT", frame, "TOPLEFT", 178, -98 - (index - 1) * 28)
        button.raidKey = info.key
        button:SetScript("OnClick", function() Core:HandleRaidDifficultyChange(info.key) end)
        table.insert(frame.raidDifficultyButtons, button)
        table.insert(frame.allButtons, button)
    end

    frame.resetButton = CreateFlatButton(frame, 92, 24, "重置副本", "action")
    frame.resetButton:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 14, 12)
    frame.resetButton:SetScript("OnClick", function() Core:ResetCurrentInstances() end)

    frame.teleportButton = CreateFlatButton(frame, 92, 24, "传进/出副本", "action")
    frame.teleportButton:SetPoint("BOTTOM", frame, "BOTTOM", 0, 12)
    frame.teleportButton:SetScript("OnClick", function() Core:TeleportInstance() end)

    frame.leaveButton = CreateFlatButton(frame, 92, 24, "一键退出", "action")
    frame.leaveButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -14, 12)
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
end
