local _, ns = ...
local Core = ns.Core
local util = ns.util
local LibSharedMedia = LibStub("LibSharedMedia-3.0")

-- ═══════════════════════════════════════════════════
--  QuickChat Constants
-- ═══════════════════════════════════════════════════

Core.CONSTANTS = {
    BUILTIN_BUTTONS = {
        { key = "SAY", label = "说", action = "switch", slash = "/s " },
        { key = "YELL", label = "喊话", action = "switch", slash = "/y " },
        { key = "PARTY", label = "小队", action = "switch", slash = "/p " },
        { key = "INSTANCE_CHAT", label = "副本", action = "switch", slash = "/i " },
        { key = "RAID", label = "团队", action = "switch", slash = "/raid " },
        { key = "GUILD", label = "公会", action = "switch", slash = "/g " },
        { key = "WORLD", label = "世界", action = "world" },
        { key = "DICE", label = "骰子", action = "dice" },
    },
    DEFAULT_BUTTON_COLORS = {
        SAY           = { r = 1.00, g = 1.00, b = 1.00 },
        YELL          = { r = 1.00, g = 0.25, b = 0.25 },
        PARTY         = { r = 0.66, g = 0.66, b = 1.00 },
        INSTANCE_CHAT = { r = 1.00, g = 0.50, b = 0.20 },
        RAID          = { r = 1.00, g = 0.50, b = 0.00 },
        GUILD         = { r = 0.25, g = 1.00, b = 0.25 },
        WORLD         = { r = 0.30, g = 0.95, b = 1.00 },
        DICE          = { r = 1.00, g = 0.82, b = 0.00 },
    },
}

Core.CONSTANTS.BUILTIN_LOOKUP = {}
Core.CONSTANTS.DEFAULT_ORDER = {}
for _, def in ipairs(Core.CONSTANTS.BUILTIN_BUTTONS) do
    Core.CONSTANTS.BUILTIN_LOOKUP[def.key] = def
    table.insert(Core.CONSTANTS.DEFAULT_ORDER, def.key)
end

-- ═══════════════════════════════════════════════════
--  QuickChat Channel helpers
-- ═══════════════════════════════════════════════════

function Core:OpenChatWithSlash(slashText)
    if not ChatFrame_OpenChat then return end
    ChatFrame_OpenChat(slashText or "", DEFAULT_CHAT_FRAME)
end

function Core:GetWorldChannelInfo()
    local channelName = util.trim(self.db.profile.quickChat.worldChannelName)
    if channelName == "" then channelName = "大脚世界频道" end
    local id, name = GetChannelName(channelName)
    return id or 0, name or channelName, channelName
end

function Core:JoinWorldChannel()
    local id, _, channelName = self:GetWorldChannelInfo()
    if id > 0 then
        self:OpenChatWithSlash("/" .. tostring(id) .. " ")
        return
    end
    local frameId = (DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.GetID and DEFAULT_CHAT_FRAME:GetID()) or 1
    JoinChannelByName(channelName, nil, frameId, false)
    print("|cFF33FF99雨轩工具箱|r丨正在加入 |cFF00FFFF" .. channelName .. "|r ...")
    C_Timer.After(0.6, function()
        local newId = GetChannelName(channelName)
        if newId and newId > 0 then
            Core:OpenChatWithSlash("/" .. tostring(newId) .. " ")
            print("|cFF33FF99雨轩工具箱|r丨已加入 |cFF00FFFF" .. channelName .. "|r (频道 " .. newId .. ")")
        else
            print("|cFF33FF99雨轩工具箱|r丨|cFFFF4444加入频道失败，请检查频道名称|r")
        end
    end)
end

function Core:LeaveWorldChannel()
    local id, _, channelName = self:GetWorldChannelInfo()
    if id > 0 then
        LeaveChannelByName(channelName)
        print("|cFF33FF99雨轩工具箱|r丨已离开 |cFF00FFFF" .. channelName .. "|r")
    else
        print("|cFF33FF99雨轩工具箱|r丨当前未加入 |cFF00FFFF" .. channelName .. "|r")
    end
end

function Core:HandleButtonClick(def, mouseButton)
    if not def then return end
    if def.action == "dice" then
        RandomRoll(1, 100)
        return
    end
    if def.action == "switch" then
        self:OpenChatWithSlash(def.slash or "")
        return
    end
    if def.action == "world" then
        if mouseButton == "RightButton" then
            self:LeaveWorldChannel()
        else
            self:JoinWorldChannel()
        end
        return
    end
    if def.action == "custom" then
        local cmd = util.trim(def.command)
        if cmd == "" then
            print("|cFF33FF99雨轩工具箱|r丨自定义按钮未设置指令")
            return
        end
        if cmd:sub(1, 1) ~= "/" then cmd = "/" .. cmd end
        self:OpenChatWithSlash(cmd .. " ")
    end
end

-- ═══════════════════════════════════════════════════
--  Button data helpers
-- ═══════════════════════════════════════════════════

function Core:GetAllButtonDefs()
    local defs = {}
    local cfg = self.db.profile.quickChat

    for _, key in ipairs(cfg.buttonOrder) do
        if self.CONSTANTS.BUILTIN_LOOKUP[key] then
            table.insert(defs, self.CONSTANTS.BUILTIN_LOOKUP[key])
        else
            for _, custom in ipairs(cfg.customButtons) do
                local ckey = "CUSTOM_" .. tostring(custom.id)
                if ckey == key then
                    local label = util.trim(custom.label)
                    if label ~= "" then
                        table.insert(defs, {
                            key = ckey,
                            label = label,
                            action = "custom",
                            command = util.trim(custom.command),
                        })
                    end
                    break
                end
            end
        end
    end

    self.quickChatDefs = defs
    return defs
end

function Core:GetColorForKey(key)
    local colors = self.db.profile.quickChat.buttonColors
    if not colors[key] then
        colors[key] = util.cloneColor({ r = 1, g = 1, b = 1 })
    end
    return colors[key]
end

function Core:GetDefByKey(key)
    for _, def in ipairs(self.quickChatDefs or {}) do
        if def.key == key then return def end
    end
    return nil
end

function Core:GetCustomByKey(key)
    if not key or not key:find("^CUSTOM_") then return nil, nil end
    local id = tonumber(key:gsub("^CUSTOM_", ""))
    if not id then return nil, nil end
    for i, custom in ipairs(self.db.profile.quickChat.customButtons) do
        if tonumber(custom.id) == id then
            return custom, i
        end
    end
    return nil, nil
end

function Core:EnsureQuickChatData()
    local cfg = self.db.profile.quickChat
    cfg.buttonColors = cfg.buttonColors or {}
    cfg.customButtons = cfg.customButtons or {}
    cfg.buttonOrder = cfg.buttonOrder or {}

    if #cfg.buttonOrder == 0 then
        for _, key in ipairs(self.CONSTANTS.DEFAULT_ORDER) do
            table.insert(cfg.buttonOrder, key)
        end
        for _, custom in ipairs(cfg.customButtons) do
            local ckey = "CUSTOM_" .. tostring(custom.id)
            if not util.tableContains(cfg.buttonOrder, ckey) then
                table.insert(cfg.buttonOrder, ckey)
            end
        end
    end

    for _, def in ipairs(self.CONSTANTS.BUILTIN_BUTTONS) do
        if not cfg.buttonColors[def.key] then
            cfg.buttonColors[def.key] = util.cloneColor(
                self.CONSTANTS.DEFAULT_BUTTON_COLORS[def.key] or { r = 1, g = 1, b = 1 })
        end
    end

    for _, custom in ipairs(cfg.customButtons) do
        local ckey = "CUSTOM_" .. tostring(custom.id)
        cfg.buttonColors[ckey] = cfg.buttonColors[ckey] or util.cloneColor({ r = 1, g = 0.82, b = 0 })
    end

    cfg.nextCustomId = tonumber(cfg.nextCustomId) or 1
end

-- ═══════════════════════════════════════════════════
--  QuickChat Bar dragging & position
-- ═══════════════════════════════════════════════════

function Core:UpdateQuickChatBarDraggable()
    if not self.barFrame then return end
    local unlocked = self.db.profile.quickChat.unlocked and self.db.profile.quickChat.enabled
    self.barFrame:SetMovable(unlocked)
    self.barFrame:EnableMouse(unlocked)
    if self.barFrame.bg then
        if unlocked then
            self.barFrame.bg:SetColorTexture(0, 0.6, 1, 0.18)
        else
            self.barFrame.bg:SetColorTexture(0, 0, 0, 0)
        end
    end
end

function Core:SaveBarPosition()
    if not self.barFrame then return end
    local point, _, relativePoint, x, y = self.barFrame:GetPoint(1)
    self.db.profile.quickChat.barPoint.point = point or "CENTER"
    self.db.profile.quickChat.barPoint.relativePoint = relativePoint or "CENTER"
    self.db.profile.quickChat.barPoint.x = math.floor((x or 0) + 0.5)
    self.db.profile.quickChat.barPoint.y = math.floor((y or 0) + 0.5)
end

-- ═══════════════════════════════════════════════════
--  Button layout
-- ═══════════════════════════════════════════════════

function Core:LayoutQuickChatButtons()
    if not self.barFrame then return end
    self:BuildOrReuseButtonFrames()

    local cfg = self.db.profile.quickChat
    local spacing = tonumber(cfg.spacing) or 10
    local fontSize = tonumber(cfg.fontSize) or 14
    local fontPath = LibSharedMedia:Fetch("font", cfg.font) or STANDARD_TEXT_FONT

    local totalWidth = 0
    local maxHeight = 0
    local shownIndex = 0

    for i = 1, #self.quickChatButtons do
        local btn = self.quickChatButtons[i]
        if btn:IsShown() and btn.def then
            shownIndex = shownIndex + 1

            local fs = btn.textFS
            fs:SetFont(fontPath, fontSize, "OUTLINE")
            local c = self:GetColorForKey(btn.def.key)
            fs:SetTextColor(c.r, c.g, c.b, 1)

            local w = math.ceil(fs:GetStringWidth() + 14)
            local h = math.ceil(fs:GetStringHeight() + 10)
            btn:SetSize(w, h)

            btn:ClearAllPoints()
            if shownIndex == 1 then
                btn:SetPoint("LEFT", self.barFrame, "LEFT", 0, 0)
            else
                local prev
                for j = i - 1, 1, -1 do
                    if self.quickChatButtons[j]:IsShown() then
                        prev = self.quickChatButtons[j]
                        break
                    end
                end
                if prev then
                    btn:SetPoint("LEFT", prev, "RIGHT", spacing, 0)
                else
                    btn:SetPoint("LEFT", self.barFrame, "LEFT", 0, 0)
                end
            end

            totalWidth = totalWidth + w + (shownIndex > 1 and spacing or 0)
            if h > maxHeight then maxHeight = h end
        end
    end

    self.barFrame:SetSize(math.max(40, totalWidth), math.max(22, maxHeight))
end

function Core:BuildOrReuseButtonFrames()
    local defs = self:GetAllButtonDefs()

    for i, def in ipairs(defs) do
        local btn = self.quickChatButtons[i]
        if not btn then
            btn = CreateFrame("Button", nil, self.barFrame)
            btn:RegisterForClicks("AnyUp")
            btn.textFS = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            btn.textFS:SetPoint("CENTER")

            btn:SetScript("OnClick", function(button, mouseButton)
                Core:HandleButtonClick(button.def, mouseButton)
            end)

            btn:SetScript("OnEnter", function(button)
                button.textFS:SetAlpha(0.7)
                if button.def and button.def.action == "world" then
                    if Core.SetTooltipAnchor then
                        Core:SetTooltipAnchor(GameTooltip, button, "ANCHOR_TOP")
                    else
                        GameTooltip:SetOwner(button, "ANCHOR_TOP")
                    end
                    GameTooltip:AddLine("世界频道", 1, 0.82, 0)
                    GameTooltip:AddLine(" ")
                    GameTooltip:AddLine("左键: 加入并切换到世界频道", 0.75, 1, 0.75)
                    GameTooltip:AddLine("右键: 离开世界频道", 1, 0.7, 0.7)
                    local chId = Core:GetWorldChannelInfo()
                    if chId > 0 then
                        GameTooltip:AddLine(" ")
                        GameTooltip:AddLine("已加入 (频道 " .. chId .. ")", 0.6, 1, 0.6)
                    else
                        GameTooltip:AddLine(" ")
                        GameTooltip:AddLine("未加入", 0.65, 0.65, 0.65)
                    end
                    GameTooltip:Show()
                end
            end)

            btn:SetScript("OnLeave", function(button)
                button.textFS:SetAlpha(1)
                GameTooltip:Hide()
            end)

            self.quickChatButtons[i] = btn
        end

        btn.def = def
        btn.textFS:SetText(def.label)
        btn:Show()
    end

    for i = #defs + 1, #self.quickChatButtons do
        self.quickChatButtons[i]:Hide()
    end
end

-- ═══════════════════════════════════════════════════
--  Bar creation & update
-- ═══════════════════════════════════════════════════

function Core:UpdateQuickChatBar()
    if not self.barFrame then return end
    if self.db.profile.quickChat.enabled then
        self.barFrame:Show()
        self:LayoutQuickChatButtons()
    else
        self.barFrame:Hide()
    end
    self:UpdateQuickChatBarDraggable()
end

function Core:CreateQuickChatBar()
    if self.barFrame then return end

    local f = CreateFrame("Frame", self.NAME .. "QuickChatBar", UIParent)
    f:SetFrameStrata("LOW")

    f.bg = f:CreateTexture(nil, "BACKGROUND")
    f.bg:SetAllPoints(f)

    local pt = self.db.profile.quickChat.barPoint
    f:SetPoint(pt.point or "CENTER", UIParent, pt.relativePoint or "CENTER", pt.x or 0, pt.y or -180)

    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(frame)
        local cfg = Core.db.profile.quickChat
        if not (cfg.enabled and cfg.unlocked) then return end
        frame:StartMoving()
    end)

    f:SetScript("OnDragStop", function(frame)
        frame:StopMovingOrSizing()
        Core:SaveBarPosition()
    end)

    f:SetClampedToScreen(true)
    f:SetMovable(true)

    self.barFrame = f
    self:UpdateQuickChatBar()
end
