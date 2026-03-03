local _, ns = ...
local Core = ns.Core

function Core:GetWorldChannelInfo()
    local channelName = Core.util.trim(self.db.quickChat.worldChannelName)
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
        local cmd = Core.util.trim(def.command)
        if cmd == "" then
            print("|cFF33FF99雨轩工具箱|r丨自定义按钮未设置指令")
            return
        end
        if cmd:sub(1, 1) ~= "/" then
            cmd = "/" .. cmd
        end
        self:OpenChatWithSlash(cmd .. " ")
    end
end

function Core:UpdateQuickChatBarDraggable()
    if not self.barFrame then return end

    local unlocked = self.db.quickChat.unlocked and self.db.quickChat.enabled
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
    self.db.quickChat.barPoint.point = point or "CENTER"
    self.db.quickChat.barPoint.relativePoint = relativePoint or "CENTER"
    self.db.quickChat.barPoint.x = math.floor((x or 0) + 0.5)
    self.db.quickChat.barPoint.y = math.floor((y or 0) + 0.5)
end

function Core:LayoutQuickChatButtons()
    if not self.barFrame then return end

    self:BuildOrReuseButtonFrames()

    local cfg = self.db.quickChat
    local spacing = tonumber(cfg.spacing) or 10
    local fontSize = tonumber(cfg.fontSize) or 14

    local totalWidth = 0
    local maxHeight = 0
    local shownIndex = 0

    for i = 1, #self.quickChatButtons do
        local btn = self.quickChatButtons[i]
        if btn:IsShown() and btn.def then
            shownIndex = shownIndex + 1

            local fs = btn.textFS
            fs:SetFont(cfg.font, fontSize, "OUTLINE")
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
                    GameTooltip:SetOwner(button, "ANCHOR_TOP")
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

function Core:UpdateQuickChatBar()
    if not self.barFrame then return end
    if self.db.quickChat.enabled then
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
    f:SetFrameStrata("HIGH")

    f.bg = f:CreateTexture(nil, "BACKGROUND")
    f.bg:SetAllPoints(f)

    local pt = self.db.quickChat.barPoint
    f:SetPoint(pt.point or "CENTER", UIParent, pt.relativePoint or "CENTER", pt.x or 0, pt.y or -180)

    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(frame)
        local current = Core.db
        if not (current.quickChat.enabled and current.quickChat.unlocked) then return end
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
