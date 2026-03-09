local addonName, ns = ...
local Core = ns.Core
local LibSharedMedia = LibStub("LibSharedMedia-3.0")

local INFOBAR_PADDING_X = 10
local INFOBAR_PADDING_Y = 8
local INFOBAR_SPACING = 18
local ICON_SIZE_BAR = 16 -- 展示条上的图标大小
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

local function MIcfg()
    local cfg = Core.db.profile.misc
    if cfg.autoAnnounceQuest == nil then
        cfg.autoAnnounceQuest = cfg.announceQuestAccept or cfg.announceQuestTurnIn or false
    end
    if cfg.barSpacing == nil then
        cfg.barSpacing = INFOBAR_SPACING
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

-- ═══════════════════════════════════════════════════
--  全局 Tooltip 跟随鼠标 Hook
-- ═══════════════════════════════════════════════════
local globalTooltipHooked = false

function Core:ApplyGlobalTooltipHook()
    if globalTooltipHooked then return end
    globalTooltipHooked = true

    -- Hook GameTooltip_SetDefaultAnchor（全局函数），不会导致递归
    -- 此函数在系统需要显示默认位置 tooltip 时调用
    hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
        local cfg = Core.db and Core.db.profile and Core.db.profile.misc
        if not cfg or not cfg.tooltipFollowCursor then return end
        tooltip:SetOwner(parent, "ANCHOR_CURSOR_RIGHT")
    end)
end

function Core:SetTooltipAnchor(tooltip, owner, fallbackAnchor)
    if not tooltip then return end
    local cfg = self.db and self.db.profile and self.db.profile.misc
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
    elseif event == "QUEST_PROGRESS" then
        if IsQuestCompletable and IsQuestCompletable() and CompleteQuest then
            CompleteQuest()
        end
    elseif event == "QUEST_COMPLETE" then
        local numChoices = GetNumQuestChoices and GetNumQuestChoices() or 0
        if numChoices <= 1 and GetQuestReward then
            GetQuestReward(math.max(1, numChoices))
        end
    end
end

function Core:UpdateMiscEventRegistration()
    if not self.miscEventFrame then return end
    self.miscEventFrame:UnregisterAllEvents()

    local cfg = MIcfg()
    if cfg.autoAnnounceQuest then
        self.miscEventFrame:RegisterEvent("QUEST_ACCEPTED")
        self.miscEventFrame:RegisterEvent("QUEST_TURNED_IN")
    end

    if cfg.autoQuestTurnIn then
        self.miscEventFrame:RegisterEvent("QUEST_DETAIL")
        self.miscEventFrame:RegisterEvent("QUEST_PROGRESS")
        self.miscEventFrame:RegisterEvent("QUEST_COMPLETE")
    end

    self.miscEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    self.miscEventFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
    self.miscEventFrame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
    self.miscEventFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
    self.miscEventFrame:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED")
    self.miscEventFrame:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
    self.miscEventFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
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

    frame.specButton.text:SetFont(fontPath, fontSize, "OUTLINE")
    frame.durabilityButton.text:SetFont(fontPath, fontSize, "OUTLINE")

    -- 专精图标
    local specName, specIcon = self:GetCurrentSpecializationName()
    local talentName = self:GetCurrentTalentLoadoutName()
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
    local durabilityText = string.format("|cFFFFFFFF耐久度：|r%s%d%%|r", pctColorCode, durabilityPercent)
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
    frame:SetSize(specWidth + durabilityWidth + barSpacing, height)

    frame.specButton:ClearAllPoints()
    frame.specButton:SetPoint("LEFT", frame, "LEFT", 0, 0)
    frame.durabilityButton:ClearAllPoints()
    frame.durabilityButton:SetPoint("LEFT", frame.specButton, "RIGHT", barSpacing, 0)

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

function Core:UpdateMiscBarVisibility()
    if not self.miscFrame then return end
    if MIcfg().infoBarEnabled then
        self.miscFrame:Show()
    else
        self.miscFrame:Hide()
    end
end

function Core:ApplyMiscSettings()
    if not self.miscFrame then return end
    local cfg = MIcfg()

    self.miscFrame:SetMovable(not cfg.infoBarLocked)
    self.miscFrame:EnableMouse(true)
    self:HideMiscPopupMenu()
    self:UpdateMiscBarLayout()
    self:UpdateMiscBarVisibility()
    self:UpdateMiscEventRegistration()
    self:ApplyGlobalTooltipHook()
end

-- ═══════════════════════════════════════════════════
--  展示条创建
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

    -- ── 事件帧 ──
    self.miscEventFrame = CreateFrame("Frame")
    self.miscEventFrame:SetScript("OnEvent", function(_, event, ...)
        if event == "PLAYER_ENTERING_WORLD"
            or event == "PLAYER_SPECIALIZATION_CHANGED"
            or event == "ACTIVE_TALENT_GROUP_CHANGED"
            or event == "TRAIT_CONFIG_UPDATED"
            or event == "TRAIT_CONFIG_LIST_UPDATED"
            or event == "UPDATE_INVENTORY_DURABILITY"
            or event == "PLAYER_EQUIPMENT_CHANGED" then
            Core:UpdateMiscBarLayout()
            return
        end

        Core:HandleMiscQuestEvent(event, ...)
    end)

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
        end
    end)

    self.miscFrame = frame
    self:ApplyMiscSettings()
end
