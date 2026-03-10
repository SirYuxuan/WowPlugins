local addonName, ns = ...
local Core = ns.Core
local LibSharedMedia = LibStub("LibSharedMedia-3.0")

local function CBcfg()
    local profile = Core.db.profile
    profile.chatBeautify = profile.chatBeautify or {}
    local cfg = profile.chatBeautify

    if cfg.enabled == nil then cfg.enabled = false end
    if not cfg.font or cfg.font == "" then cfg.font = "Friz Quadrata TT" end
    if cfg.fontSize == nil then cfg.fontSize = 13 end
    if cfg.backgroundAlpha == nil then cfg.backgroundAlpha = 0.12 end
    if cfg.editBoxAlpha == nil then cfg.editBoxAlpha = 0.18 end
    if cfg.hideMenuButton == nil then cfg.hideMenuButton = true end
    if cfg.hideChannelButtons == nil then cfg.hideChannelButtons = true end
    if cfg.hideQuickJoinButton == nil then cfg.hideQuickJoinButton = true end
    if cfg.tabAlpha == nil then cfg.tabAlpha = 0.75 end

    return cfg
end

local function EnsureHiddenParent(self)
    self.chatBeautifyHiddenParent = self.chatBeautifyHiddenParent or
        CreateFrame("Frame", addonName .. "ChatBeautifyHiddenParent", UIParent)
    self.chatBeautifyHiddenParent:Hide()
    return self.chatBeautifyHiddenParent
end

local function SetObjectHidden(self, obj, hide)
    if not obj then return end

    if hide then
        if obj.GetParent and obj.SetParent and not obj.__YuXuanOriginalParent then
            obj.__YuXuanOriginalParent = obj:GetParent()
        end

        if obj.SetParent then
            pcall(obj.SetParent, obj, EnsureHiddenParent(self))
        end

        if obj.Hide then
            pcall(obj.Hide, obj)
        end

        if obj.SetAlpha then
            pcall(obj.SetAlpha, obj, 0)
        end
    else
        if obj.SetParent and obj.__YuXuanOriginalParent then
            pcall(obj.SetParent, obj, obj.__YuXuanOriginalParent)
        end

        if obj.SetAlpha then
            pcall(obj.SetAlpha, obj, 1)
        end

        if obj.Show then
            pcall(obj.Show, obj)
        end
    end
end

local function SaveFramePoints(frame, key)
    if frame[key] then return end

    frame[key] = {}
    for index = 1, frame:GetNumPoints() do
        local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint(index)
        table.insert(frame[key], {
            point = point,
            relativeTo = relativeTo,
            relativePoint = relativePoint,
            xOfs = xOfs,
            yOfs = yOfs,
        })
    end
end

local function RestoreFramePoints(frame, key)
    local points = frame[key]
    if not points or #points == 0 then return end

    frame:ClearAllPoints()
    for _, info in ipairs(points) do
        frame:SetPoint(info.point, info.relativeTo, info.relativePoint, info.xOfs, info.yOfs)
    end
end

local function StyleChatButtonFrame(frame, cfg)
    local buttonFrame = _G[frame:GetName() .. "ButtonFrame"]
    if not buttonFrame then return end

    if not buttonFrame.__YuXuanOriginalWidth then
        buttonFrame.__YuXuanOriginalWidth = buttonFrame:GetWidth()
    end

    SaveFramePoints(buttonFrame, "__YuXuanOriginalPoints")

    if not frame.__YuXuanOriginalClampInsets and frame.GetClampRectInsets then
        local left, right, top, bottom = frame:GetClampRectInsets()
        frame.__YuXuanOriginalClampInsets = {
            left = left,
            right = right,
            top = top,
            bottom = bottom,
        }
    end

    local children = {
        buttonFrame.TopButton,
        buttonFrame.BottomButton,
        buttonFrame.UpButton,
        buttonFrame.DownButton,
        buttonFrame.MinimizeButton,
    }

    local shouldCollapse = cfg.enabled and cfg.hideChannelButtons

    if shouldCollapse then
        buttonFrame:ClearAllPoints()
        buttonFrame:SetPoint("TOPLEFT", frame, "TOPRIGHT", 0, 0)
        buttonFrame:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", 0, 0)
        buttonFrame:EnableMouse(false)
        buttonFrame:SetAlpha(0)
        buttonFrame:SetWidth(1)

        if frame.SetClampRectInsets then
            frame:SetClampRectInsets(0, 0, 0, 0)
        end

        for _, child in ipairs(children) do
            if child then
                child:Hide()
                child:EnableMouse(false)
            end
        end

        for _, region in ipairs({ buttonFrame:GetRegions() }) do
            if region and region.SetAlpha then
                region:SetAlpha(0)
            end
        end
    else
        RestoreFramePoints(buttonFrame, "__YuXuanOriginalPoints")
        buttonFrame:SetWidth(buttonFrame.__YuXuanOriginalWidth or 32)
        buttonFrame:SetAlpha(1)
        buttonFrame:EnableMouse(true)

        if frame.SetClampRectInsets and frame.__YuXuanOriginalClampInsets then
            local insets = frame.__YuXuanOriginalClampInsets
            frame:SetClampRectInsets(insets.left or 0, insets.right or 0, insets.top or 0, insets.bottom or 0)
        end

        for _, child in ipairs(children) do
            if child then
                child:Show()
                child:EnableMouse(true)
            end
        end

        for _, region in ipairs({ buttonFrame:GetRegions() }) do
            if region and region.SetAlpha then
                region:SetAlpha(1)
            end
        end
    end
end

local function ApplyChatTabStyle(frame, tab, cfg)
    if not tab then return end

    local alpha = math.max(0, math.min(1, tonumber(cfg.tabAlpha) or 0.75))
    local isSelected = SELECTED_CHAT_FRAME == frame
    tab:SetAlpha(cfg.enabled and alpha or 1)

    local tabName = tab:GetName()
    if not tabName then return end

    local textureNames = {
        "Left", "Middle", "Right",
        "SelectedLeft", "SelectedMiddle", "SelectedRight",
        "HighlightLeft", "HighlightMiddle", "HighlightRight",
        "Glow", "ConversationIcon",
    }

    for _, suffix in ipairs(textureNames) do
        local region = _G[tabName .. suffix]
        if region and region.SetAlpha then
            region:SetAlpha(cfg.enabled and 0 or 1)
        end
    end

    if not tab.YuXuanBackground then
        local bg = tab:CreateTexture(nil, "BACKGROUND")
        bg:SetPoint("TOPLEFT", tab, "TOPLEFT", -6, -1)
        bg:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT", 6, 2)
        bg:SetColorTexture(0, 0, 0, 0.18)
        tab.YuXuanBackground = bg
    end

    tab.YuXuanBackground:SetShown(cfg.enabled)
    if cfg.enabled then
        if isSelected then
            tab.YuXuanBackground:SetColorTexture(0.08, 0.08, 0.08, 0.32)
        else
            tab.YuXuanBackground:SetColorTexture(0, 0, 0, 0.18)
        end
    else
        tab.YuXuanBackground:SetColorTexture(0, 0, 0, 0)
    end

    local text = _G[tabName .. "Text"]
    if text then
        if text.SetAlpha then
            text:SetAlpha(1)
        end

        if text.SetTextColor then
            if cfg.enabled and isSelected then
                text:SetTextColor(1, 0.82, 0.2)
            elseif cfg.enabled then
                text:SetTextColor(0.9, 0.9, 0.9)
            else
                text:SetTextColor(1, 1, 1)
            end
        end
    end
end

local function ApplyEditBoxStyle(frame, cfg)
    local editBox = _G[frame:GetName() .. "EditBox"]
    if not editBox then return end

    SaveFramePoints(editBox, "__YuXuanOriginalPoints")

    local regionNames = {
        "Left", "Mid", "Right",
        "FocusLeft", "FocusMid", "FocusRight",
    }

    local editBoxName = editBox:GetName()
    if editBoxName then
        for _, suffix in ipairs(regionNames) do
            local region = _G[editBoxName .. suffix]
            if region and region.SetAlpha then
                region:SetAlpha(cfg.enabled and 0 or 1)
            end
        end
    end

    if not editBox.YuXuanBackground then
        local bg = editBox:CreateTexture(nil, "BACKGROUND")
        bg:SetPoint("TOPLEFT", editBox, "TOPLEFT", -4, 2)
        bg:SetPoint("BOTTOMRIGHT", editBox, "BOTTOMRIGHT", 4, -2)
        bg:SetColorTexture(0, 0, 0, 0.18)
        editBox.YuXuanBackground = bg
    end

    editBox.YuXuanBackground:SetColorTexture(0, 0, 0, math.max(0, math.min(0.8, tonumber(cfg.editBoxAlpha) or 0.18)))
    editBox.YuXuanBackground:SetShown(cfg.enabled)

    if cfg.enabled then
        editBox:ClearAllPoints()
        editBox:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", -2, 6)
        editBox:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 2, 6)
    else
        RestoreFramePoints(editBox, "__YuXuanOriginalPoints")
    end
end

local function ApplyChatFrameStyle(frame, cfg)
    if not frame then return end

    local fontPath = LibSharedMedia and LibSharedMedia.Fetch and LibSharedMedia:Fetch("font", cfg.font) or
        STANDARD_TEXT_FONT
    if not fontPath or fontPath == "" then
        fontPath = STANDARD_TEXT_FONT
    end

    if frame.GetFont and not frame.__YuXuanOriginalFont then
        local originalFont, originalSize, originalFlags = frame:GetFont()
        frame.__YuXuanOriginalFont = {
            path = originalFont,
            size = originalSize,
            flags = originalFlags,
        }
    end

    if frame.SetFont then
        if cfg.enabled then
            pcall(frame.SetFont, frame, fontPath, tonumber(cfg.fontSize) or 13)
        elseif frame.__YuXuanOriginalFont and frame.__YuXuanOriginalFont.path then
            pcall(frame.SetFont, frame, frame.__YuXuanOriginalFont.path, frame.__YuXuanOriginalFont.size,
                frame.__YuXuanOriginalFont.flags)
        end
    end

    if not frame.YuXuanBackground then
        local bg = frame:CreateTexture(nil, "BACKGROUND")
        bg:SetPoint("TOPLEFT", frame, "TOPLEFT", -6, 6)
        bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 6, -6)
        bg:SetColorTexture(0, 0, 0, 0.12)
        frame.YuXuanBackground = bg
    end

    frame.YuXuanBackground:SetColorTexture(0, 0, 0, math.max(0, math.min(0.8, tonumber(cfg.backgroundAlpha) or 0.12)))
    frame.YuXuanBackground:SetShown(cfg.enabled)

    StyleChatButtonFrame(frame, cfg)

    local tab = _G[frame:GetName() .. "Tab"]
    ApplyChatTabStyle(frame, tab, cfg)
    ApplyEditBoxStyle(frame, cfg)
end

function Core:ApplyChatBeautifySettings()
    if not self.db or not self.db.profile then return end

    local cfg = CBcfg()
    local chatCount = NUM_CHAT_WINDOWS or 10

    for index = 1, chatCount do
        local frame = _G["ChatFrame" .. index]
        ApplyChatFrameStyle(frame, cfg)
    end

    SetObjectHidden(self, _G.ChatFrameMenuButton, cfg.enabled and cfg.hideMenuButton)
    SetObjectHidden(self, _G.QuickJoinToastButton, cfg.enabled and cfg.hideQuickJoinButton)
end

function Core:EnsureChatBeautifyController()
    if self.chatBeautifyController then return end

    local frame = CreateFrame("Frame")
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:RegisterEvent("UPDATE_CHAT_WINDOWS")
    frame:RegisterEvent("UPDATE_FLOATING_CHAT_WINDOWS")
    frame:SetScript("OnEvent", function()
        if Core and Core.ApplyChatBeautifySettings then
            Core:ApplyChatBeautifySettings()
        end
    end)

    self.chatBeautifyController = frame
end

Core:EnsureChatBeautifyController()
