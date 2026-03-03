local _, ns = ...
local Core = ns.Core

local gameFontList = nil

local function collectGameFonts()
    if gameFontList then return gameFontList end

    local seen, result = {}, {}
    local names = {
        "SystemFont_Tiny", "SystemFont_Small", "SystemFont_Med1", "SystemFont_Med2", "SystemFont_Med3",
        "SystemFont_Large", "SystemFont_Huge1", "SystemFont_Outline", "SystemFont_OutlineThick_Huge2",
        "SystemFont_Shadow_Med1", "SystemFont_Shadow_Med2", "SystemFont_Shadow_Large",
        "SystemFont_Shadow_Large_Outline", "GameFontNormal", "GameFontHighlight", "GameFontDisable",
        "GameFontNormalSmall", "GameFontHighlightSmall", "GameFontNormalLarge", "GameFontHighlightLarge",
        "GameFontNormalHuge", "GameFontHighlightHuge", "ChatFontNormal", "QuestFont_Large",
        "NumberFont_Normal_Medium", "NumberFont_Outline_Med", "NumberFont_Outline_Large",
        "NumberFont_Outline_Huge", "GameTooltipText", "GameTooltipTextSmall", "SubZoneTextFont", "PVPInfoTextFont",
    }

    for _, name in ipairs(names) do
        local obj = _G[name]
        if obj and type(obj.GetFont) == "function" then
            local file = obj:GetFont()
            if file and file ~= "" then
                local lower = file:lower()
                if not seen[lower] then
                    seen[lower] = true
                    local display = file:match("([^\\]+)$") or file
                    display = display:gsub("%.[Tt][Tt][Ff]$", "")
                    table.insert(result, { text = display, value = file })
                end
            end
        end
    end

    local fallbacks = {
        { text = "FRIZQT__", value = "Fonts\\FRIZQT__.TTF" },
        { text = "ARIALN",   value = "Fonts\\ARIALN.TTF" },
        { text = "MORPHEUS", value = "Fonts\\MORPHEUS.TTF" },
        { text = "SKURRI",   value = "Fonts\\SKURRI.TTF" },
    }

    for _, fb in ipairs(fallbacks) do
        if not seen[fb.value:lower()] then
            seen[fb.value:lower()] = true
            table.insert(result, fb)
        end
    end

    table.sort(result, function(a, b) return a.text:lower() < b.text:lower() end)
    gameFontList = result
    return result
end

local function createDivider(parent, anchorFrame, yOffset, width)
    local line = parent:CreateTexture(nil, "ARTWORK")
    line:SetHeight(1)
    line:SetWidth(width or 500)
    line:SetPoint("TOPLEFT", anchorFrame, "BOTTOMLEFT", 0, yOffset or -8)
    line:SetColorTexture(1, 0.82, 0, 0.25)
    return line
end

local function createLabel(parent, text, anchorPoint, anchorFrame, anchorTo, x, y)
    local t = parent:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    t:SetPoint(anchorPoint, anchorFrame, anchorTo, x, y)
    t:SetText(text)
    return t
end

local function createSmallLabel(parent, text, anchorPoint, anchorFrame, anchorTo, x, y)
    local t = parent:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    t:SetPoint(anchorPoint, anchorFrame, anchorTo, x, y)
    t:SetText(text)
    t:SetTextColor(0.60, 0.80, 1)
    return t
end

local activeDropdownMenu = nil

local function CreateSimpleDropdown(parent, name, width, options, getValue, setValue)
    local btn = CreateFrame("Button", name, parent, "BackdropTemplate")
    btn:SetSize(width, 26)
    btn:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    btn:SetBackdropColor(0.10, 0.10, 0.10, 0.92)
    btn:SetBackdropBorderColor(0.50, 0.50, 0.50, 0.80)

    btn.label = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    btn.label:SetPoint("LEFT", 8, 0)
    btn.label:SetPoint("RIGHT", -22, 0)
    btn.label:SetJustifyH("LEFT")

    local arrow = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    arrow:SetPoint("RIGHT", -6, 0)
    arrow:SetText("▼")

    local maxVisible, itemHeight = 10, 22
    local totalItems = #options
    local visibleCount = math.min(totalItems, maxVisible)
    local menuHeight = visibleCount * itemHeight + 8

    local menu = CreateFrame("Frame", nil, btn, "BackdropTemplate")
    menu:SetPoint("TOPLEFT", btn, "BOTTOMLEFT", 0, -2)
    menu:SetSize(width, menuHeight)
    menu:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    menu:SetBackdropColor(0.08, 0.08, 0.08, 0.96)
    menu:SetFrameStrata("FULLSCREEN_DIALOG")
    menu:Hide()

    local itemParent
    if totalItems > maxVisible then
        local scrollFrame = CreateFrame("ScrollFrame", nil, menu, "UIPanelScrollFrameTemplate")
        scrollFrame:SetPoint("TOPLEFT", 4, -4)
        scrollFrame:SetPoint("BOTTOMRIGHT", -24, 4)

        local scrollChild = CreateFrame("Frame", nil, scrollFrame)
        scrollChild:SetSize(width - 30, totalItems * itemHeight)
        scrollFrame:SetScrollChild(scrollChild)
        itemParent = scrollChild
    else
        itemParent = menu
    end

    for i, opt in ipairs(options) do
        local item = CreateFrame("Button", nil, itemParent)
        local itemWidth = totalItems > maxVisible and (width - 34) or (width - 8)
        item:SetSize(itemWidth, itemHeight)
        item:SetPoint("TOPLEFT", 4, -(i - 1) * itemHeight - (totalItems > maxVisible and 0 or 4))

        item.bg = item:CreateTexture(nil, "BACKGROUND")
        item.bg:SetAllPoints()
        item.bg:SetColorTexture(0.30, 0.50, 0.80, 0)

        item.text = item:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        item.text:SetPoint("LEFT", 6, 0)
        item.text:SetText(opt.text)

        item:SetScript("OnEnter", function(f) f.bg:SetColorTexture(0.30, 0.50, 0.80, 0.40) end)
        item:SetScript("OnLeave", function(f) f.bg:SetColorTexture(0.30, 0.50, 0.80, 0) end)
        item:SetScript("OnClick", function()
            setValue(opt.value)
            btn.label:SetText(opt.text)
            menu:Hide()
            activeDropdownMenu = nil
        end)
    end

    btn:SetScript("OnClick", function()
        if activeDropdownMenu and activeDropdownMenu ~= menu and activeDropdownMenu:IsShown() then
            activeDropdownMenu:Hide()
        end
        if menu:IsShown() then
            menu:Hide()
            activeDropdownMenu = nil
        else
            menu:Show()
            activeDropdownMenu = menu
        end
    end)

    local function refresh()
        local val = getValue()
        for _, opt in ipairs(options) do
            if opt.value == val then
                btn.label:SetText(opt.text)
                return
            end
        end
        btn.label:SetText(options[1] and options[1].text or "")
    end

    btn.Refresh = refresh
    refresh()
    return btn
end

function Core:SelectTab(tabKey)
    for key, panel in pairs(self.contentPanels) do
        panel:SetShown(key == tabKey)
    end

    for key, tbtn in pairs(self.tabButtons) do
        if key == tabKey then
            tbtn.Text:SetTextColor(1, 0.82, 0)
        else
            tbtn.Text:SetTextColor(1, 1, 1)
        end
    end
end

function Core:RefreshButtonListUI()
    if not self.ui.listContent then return end

    local defs = self:GetAllButtonDefs()
    self.ui.listRows = self.ui.listRows or {}

    for i, def in ipairs(defs) do
        local row = self.ui.listRows[i]
        if not row then
            row = CreateFrame("Button", nil, self.ui.listContent, "BackdropTemplate")
            row:SetSize(500, 22)

            row.colorBar = row:CreateTexture(nil, "ARTWORK")
            row.colorBar:SetSize(4, 18)
            row.colorBar:SetPoint("LEFT", 2, 0)

            row.text = row:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
            row.text:SetPoint("LEFT", row.colorBar, "RIGHT", 6, 0)
            row.text:SetJustifyH("LEFT")
            row.text:SetWidth(470)

            row:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8" })

            row:SetScript("OnEnter", function(r)
                if Core.db.quickChat.selectedButtonKey ~= r.def.key then
                    r:SetBackdropColor(0.25, 0.40, 0.65, 0.30)
                end
            end)
            row:SetScript("OnLeave", function(r)
                if Core.db.quickChat.selectedButtonKey ~= r.def.key then
                    r:SetBackdropColor(0, 0, 0, 0.08)
                end
            end)
            row:SetScript("OnClick", function(r)
                Core.db.quickChat.selectedButtonKey = r.def.key
                Core:RefreshSettingsUI()
            end)

            self.ui.listRows[i] = row
        end

        row.def = def
        row:Show()
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", self.ui.listContent, "TOPLEFT", 0, -(i - 1) * 24)

        local c = self:GetColorForKey(def.key)
        row.colorBar:SetColorTexture(c.r, c.g, c.b, 1)

        local prefix = (def.action == "custom") and "|cFFFF9900[自定义]|r" or "|cFF88BBEE[内置]|r"
        local extra = ""
        if def.action == "custom" and def.command and def.command ~= "" then
            extra = "  |cFF888888" .. def.command .. "|r"
        elseif def.slash then
            extra = "  |cFF888888" .. Core.util.trim(def.slash) .. "|r"
        end
        row.text:SetText(prefix .. " " .. (def.label or "") .. extra)

        if self.db.quickChat.selectedButtonKey == def.key then
            row:SetBackdropColor(0.20, 0.50, 0.85, 0.45)
        else
            row:SetBackdropColor(0, 0, 0, 0.08)
        end
    end

    for i = #defs + 1, #self.ui.listRows do
        self.ui.listRows[i]:Hide()
    end

    local totalHeight = math.max(24, #defs * 24)
    self.ui.listContent:SetHeight(totalHeight)
    if self.ui.listBorder then
        self.ui.listBorder:SetHeight(totalHeight + 8)
    end
end

function Core:RefreshSettingsUI()
    if not self.ui.selectedLabel then return end

    self:RefreshButtonListUI()

    local key = self.db.quickChat.selectedButtonKey
    local def = self:GetDefByKey(key)
    if not def then
        local defs = self:GetAllButtonDefs()
        def = defs[1]
        key = def and def.key or "SAY"
        self.db.quickChat.selectedButtonKey = key
    end

    self.ui.selectedLabel:SetText(def and ("选中: " .. def.label) or "选中: 无")

    if self.ui.colorSwatch and def then
        local c = self:GetColorForKey(def.key)
        self.ui.colorSwatch:SetBackdropColor(c.r, c.g, c.b, 1)
    end

    local isCustom = def and def.action == "custom"
    local custom = isCustom and self:GetCustomByKey(key) or nil

    if self.ui.customLabelEdit then self.ui.customLabelEdit:SetText(custom and custom.label or "") end
    if self.ui.customCmdEdit then self.ui.customCmdEdit:SetText(custom and custom.command or "") end

    if self.ui.editCustomBtn then
        if isCustom and custom then self.ui.editCustomBtn:Enable() else self.ui.editCustomBtn:Disable() end
    end

    if self.ui.deleteBtn then
        if def then self.ui.deleteBtn:Enable() else self.ui.deleteBtn:Disable() end
    end

    if self.ui.moveUpBtn and self.ui.moveDownBtn then
        local idx = Core.util.tableIndexOf(self.db.quickChat.buttonOrder, key)
        if idx then
            self.ui.moveUpBtn:SetEnabled(idx > 1)
            self.ui.moveDownBtn:SetEnabled(idx < #self.db.quickChat.buttonOrder)
        else
            self.ui.moveUpBtn:Disable()
            self.ui.moveDownBtn:Disable()
        end
    end
end

function Core:CreateQuickChatPanel(parent)
    local panel = CreateFrame("Frame", nil, parent)
    panel:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0)
    panel:SetSize(540, 800)

    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 12, -10)
    title:SetText("快捷频道切换")
    title:SetTextColor(1, 0.82, 0)

    local enable = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
    enable:SetPoint("TOPLEFT", title, "BOTTOMLEFT", -2, -10)
    enable.Text:SetText("启用快捷条")
    enable:SetChecked(self.db.quickChat.enabled)
    enable:SetScript("OnClick", function(cb)
        self.db.quickChat.enabled = cb:GetChecked() and true or false
        self:UpdateQuickChatBar()
    end)

    local unlock = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
    unlock:SetPoint("LEFT", enable.Text, "RIGHT", 20, 0)
    unlock.Text:SetText("解锁拖动")
    unlock:SetChecked(self.db.quickChat.unlocked)
    unlock:SetScript("OnClick", function(cb)
        self.db.quickChat.unlocked = cb:GetChecked() and true or false
        self:UpdateQuickChatBarDraggable()
    end)

    local div1 = createDivider(panel, enable, -10, 510)
    local settingsTitle = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    settingsTitle:SetPoint("TOPLEFT", div1, "BOTTOMLEFT", 0, -6)
    settingsTitle:SetText("|cFFFFD700基本设置|r")

    local worldLabel = createLabel(panel, "世界频道名称:", "TOPLEFT", settingsTitle, "BOTTOMLEFT", 0, -12)
    local worldEdit = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
    worldEdit:SetSize(160, 22)
    worldEdit:SetPoint("LEFT", worldLabel, "RIGHT", 8, 0)
    worldEdit:SetAutoFocus(false)
    worldEdit:SetText(self.db.quickChat.worldChannelName or "大脚世界频道")
    worldEdit.cursorOffset = 0
    worldEdit:SetScript("OnEditFocusGained", function(e) e.cursorOffset = 0 end)
    worldEdit:SetScript("OnEnterPressed", function(edit)
        local name = Core.util.trim(edit:GetText())
        if name == "" then name = "大脚世界频道" end
        self.db.quickChat.worldChannelName = name
        edit:ClearFocus()
    end)
    worldEdit:SetScript("OnEscapePressed", function(edit)
        edit:SetText(self.db.quickChat.worldChannelName or "大脚世界频道")
        edit:ClearFocus()
    end)

    createSmallLabel(panel, "左键加入/切换，右键离开", "LEFT", worldEdit, "RIGHT", 8, 0)

    local spacingSlider = CreateFrame("Slider", self.NAME .. "SpacingSlider", panel, "OptionsSliderTemplate")
    spacingSlider:SetPoint("TOPLEFT", worldLabel, "BOTTOMLEFT", 4, -28)
    spacingSlider:SetMinMaxValues(0, 30)
    spacingSlider:SetValueStep(1)
    spacingSlider:SetObeyStepOnDrag(true)
    spacingSlider:SetWidth(230)
    spacingSlider:SetValue(self.db.quickChat.spacing)
    _G[spacingSlider:GetName() .. "Low"]:SetText("0")
    _G[spacingSlider:GetName() .. "High"]:SetText("30")
    _G[spacingSlider:GetName() .. "Text"]:SetText("按钮间隔: " .. tostring(self.db.quickChat.spacing))
    spacingSlider:SetScript("OnValueChanged", function(slider, v)
        local n = math.floor((v or 0) + 0.5)
        self.db.quickChat.spacing = n
        _G[slider:GetName() .. "Text"]:SetText("按钮间隔: " .. tostring(n))
        self:LayoutQuickChatButtons()
    end)

    local fontSizeSlider = CreateFrame("Slider", self.NAME .. "FontSizeSlider", panel, "OptionsSliderTemplate")
    fontSizeSlider:SetPoint("TOPLEFT", spacingSlider, "BOTTOMLEFT", 0, -26)
    fontSizeSlider:SetMinMaxValues(10, 32)
    fontSizeSlider:SetValueStep(1)
    fontSizeSlider:SetObeyStepOnDrag(true)
    fontSizeSlider:SetWidth(230)
    fontSizeSlider:SetValue(self.db.quickChat.fontSize)
    _G[fontSizeSlider:GetName() .. "Low"]:SetText("10")
    _G[fontSizeSlider:GetName() .. "High"]:SetText("32")
    _G[fontSizeSlider:GetName() .. "Text"]:SetText("文字大小: " .. tostring(self.db.quickChat.fontSize))
    fontSizeSlider:SetScript("OnValueChanged", function(slider, v)
        local n = math.floor((v or 0) + 0.5)
        self.db.quickChat.fontSize = n
        _G[slider:GetName() .. "Text"]:SetText("文字大小: " .. tostring(n))
        self:LayoutQuickChatButtons()
    end)

    local fontLabel = createLabel(panel, "字体:", "TOPLEFT", fontSizeSlider, "BOTTOMLEFT", -4, -18)
    local fontDropdown = CreateSimpleDropdown(
        panel,
        self.NAME .. "FontDropdown",
        230,
        collectGameFonts(),
        function() return self.db.quickChat.font end,
        function(value)
            self.db.quickChat.font = value
            self:LayoutQuickChatButtons()
        end
    )
    fontDropdown:SetPoint("LEFT", fontLabel, "RIGHT", 8, 0)

    local div2 = createDivider(panel, fontLabel, -14, 510)
    local btnMgrTitle = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    btnMgrTitle:SetPoint("TOPLEFT", div2, "BOTTOMLEFT", 0, -6)
    btnMgrTitle:SetText("|cFFFFD700按钮管理|r")

    local listBorder = CreateFrame("Frame", nil, panel, "BackdropTemplate")
    listBorder:SetPoint("TOPLEFT", btnMgrTitle, "BOTTOMLEFT", 0, -8)
    listBorder:SetSize(510, 200)
    listBorder:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    listBorder:SetBackdropColor(0, 0, 0, 0.25)

    local listContent = CreateFrame("Frame", nil, listBorder)
    listContent:SetPoint("TOPLEFT", 4, -4)
    listContent:SetSize(500, 200)

    local selectedLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    selectedLabel:SetPoint("TOPLEFT", listBorder, "BOTTOMLEFT", 2, -8)
    selectedLabel:SetText("选中: -")

    local moveUpBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    moveUpBtn:SetSize(70, 22)
    moveUpBtn:SetPoint("TOPLEFT", selectedLabel, "BOTTOMLEFT", 0, -6)
    moveUpBtn:SetText("▲ 上移")

    local moveDownBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    moveDownBtn:SetSize(70, 22)
    moveDownBtn:SetPoint("LEFT", moveUpBtn, "RIGHT", 4, 0)
    moveDownBtn:SetText("▼ 下移")

    local swatch = CreateFrame("Button", nil, panel, "BackdropTemplate")
    swatch:SetSize(36, 22)
    swatch:SetPoint("LEFT", moveDownBtn, "RIGHT", 10, 0)
    swatch:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 2, right = 2, top = 2, bottom = 2 },
    })

    local swatchTip = createSmallLabel(panel, "颜色", "LEFT", swatch, "RIGHT", 4, 0)

    local deleteBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    deleteBtn:SetSize(60, 22)
    deleteBtn:SetPoint("LEFT", swatchTip, "RIGHT", 10, 0)
    deleteBtn:SetText("删除")

    local restoreBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    restoreBtn:SetSize(96, 22)
    restoreBtn:SetPoint("LEFT", deleteBtn, "RIGHT", 4, 0)
    restoreBtn:SetText("恢复内置按钮")

    moveUpBtn:SetScript("OnClick", function()
        local key, order = self.db.quickChat.selectedButtonKey, self.db.quickChat.buttonOrder
        local idx = Core.util.tableIndexOf(order, key)
        if idx and idx > 1 then
            order[idx], order[idx - 1] = order[idx - 1], order[idx]
            self:UpdateQuickChatBar()
            self:RefreshSettingsUI()
        end
    end)

    moveDownBtn:SetScript("OnClick", function()
        local key, order = self.db.quickChat.selectedButtonKey, self.db.quickChat.buttonOrder
        local idx = Core.util.tableIndexOf(order, key)
        if idx and idx < #order then
            order[idx], order[idx + 1] = order[idx + 1], order[idx]
            self:UpdateQuickChatBar()
            self:RefreshSettingsUI()
        end
    end)

    swatch:SetScript("OnClick", function()
        local key = self.db.quickChat.selectedButtonKey
        if not key or key == "" then return end

        local c = self:GetColorForKey(key)
        local old = Core.util.cloneColor(c)
        ColorPickerFrame:SetupColorPickerAndShow({
            r = c.r,
            g = c.g,
            b = c.b,
            hasOpacity = false,
            swatchFunc = function()
                local r, g, b = ColorPickerFrame:GetColorRGB()
                c.r, c.g, c.b = r, g, b
                self:RefreshSettingsUI()
                self:LayoutQuickChatButtons()
            end,
            cancelFunc = function()
                c.r, c.g, c.b = old.r, old.g, old.b
                self:RefreshSettingsUI()
                self:LayoutQuickChatButtons()
            end,
        })
    end)

    deleteBtn:SetScript("OnClick", function()
        local key = self.db.quickChat.selectedButtonKey
        if not key or key == "" then return end

        Core.util.tableRemoveValue(self.db.quickChat.buttonOrder, key)
        if key:find("^CUSTOM_") then
            local _, idx = self:GetCustomByKey(key)
            if idx then table.remove(self.db.quickChat.customButtons, idx) end
            self.db.quickChat.buttonColors[key] = nil
        end

        local defs = self:GetAllButtonDefs()
        self.db.quickChat.selectedButtonKey = defs[1] and defs[1].key or ""

        self:UpdateQuickChatBar()
        self:RefreshSettingsUI()
    end)

    restoreBtn:SetScript("OnClick", function()
        local order = self.db.quickChat.buttonOrder
        local insertPos, restored = 0, 0

        for i, key in ipairs(order) do
            if self.CONSTANTS.BUILTIN_LOOKUP[key] then
                insertPos = i
            end
        end

        for _, def in ipairs(self.CONSTANTS.BUILTIN_BUTTONS) do
            if not Core.util.tableContains(order, def.key) then
                insertPos = insertPos + 1
                table.insert(order, insertPos, def.key)
                if not self.db.quickChat.buttonColors[def.key] then
                    self.db.quickChat.buttonColors[def.key] = Core.util.cloneColor(
                        self.CONSTANTS.DEFAULT_BUTTON_COLORS[def.key] or { r = 1, g = 1, b = 1 })
                end
                restored = restored + 1
            end
        end

        if restored > 0 then
            print("|cFF33FF99雨轩工具箱|r丨已恢复 " .. restored .. " 个内置按钮")
        else
            print("|cFF33FF99雨轩工具箱|r丨所有内置按钮已存在")
        end

        self:UpdateQuickChatBar()
        self:RefreshSettingsUI()
    end)

    local div3 = createDivider(panel, moveUpBtn, -10, 510)
    local customTitle = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    customTitle:SetPoint("TOPLEFT", div3, "BOTTOMLEFT", 0, -6)
    customTitle:SetText("|cFFFFD700自定义按钮|r")

    local newLabel = createLabel(panel, "按钮文字:", "TOPLEFT", customTitle, "BOTTOMLEFT", 0, -12)

    local customLabelEdit = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
    customLabelEdit:SetSize(120, 22)
    customLabelEdit:SetPoint("LEFT", newLabel, "RIGHT", 6, 0)
    customLabelEdit:SetAutoFocus(false)
    customLabelEdit.cursorOffset = 0
    customLabelEdit:SetScript("OnEditFocusGained", function(e) e.cursorOffset = 0 end)

    local cmdLabel = createLabel(panel, "指令:", "LEFT", customLabelEdit, "RIGHT", 14, 0)

    local customCmdEdit = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
    customCmdEdit:SetSize(170, 22)
    customCmdEdit:SetPoint("LEFT", cmdLabel, "RIGHT", 6, 0)
    customCmdEdit:SetAutoFocus(false)
    customCmdEdit.cursorOffset = 0
    customCmdEdit:SetScript("OnEditFocusGained", function(e) e.cursorOffset = 0 end)

    local addBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    addBtn:SetSize(90, 22)
    addBtn:SetPoint("TOPLEFT", newLabel, "BOTTOMLEFT", 0, -8)
    addBtn:SetText("添加新按钮")

    local editCustomBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    editCustomBtn:SetSize(80, 22)
    editCustomBtn:SetPoint("LEFT", addBtn, "RIGHT", 8, 0)
    editCustomBtn:SetText("保存修改")

    addBtn:SetScript("OnClick", function()
        local label = Core.util.trim(customLabelEdit:GetText())
        local cmd = Core.util.trim(customCmdEdit:GetText())
        if label == "" then
            print("|cFF33FF99雨轩工具箱|r丨请填写按钮文字")
            return
        end
        if cmd == "" then
            print("|cFF33FF99雨轩工具箱|r丨请填写指令")
            return
        end

        local id = self.db.quickChat.nextCustomId
        self.db.quickChat.nextCustomId = id + 1

        table.insert(self.db.quickChat.customButtons, { id = id, label = label, command = cmd })

        local key = "CUSTOM_" .. tostring(id)
        self.db.quickChat.buttonColors[key] = Core.util.cloneColor({ r = 1, g = 0.82, b = 0 })
        table.insert(self.db.quickChat.buttonOrder, key)
        self.db.quickChat.selectedButtonKey = key

        customLabelEdit:SetText("")
        customCmdEdit:SetText("")

        self:UpdateQuickChatBar()
        self:RefreshSettingsUI()
    end)

    editCustomBtn:SetScript("OnClick", function()
        local key = self.db.quickChat.selectedButtonKey
        local custom = self:GetCustomByKey(key)
        if not custom then return end

        local label = Core.util.trim(customLabelEdit:GetText())
        local cmd = Core.util.trim(customCmdEdit:GetText())
        if label == "" or cmd == "" then
            print("|cFF33FF99雨轩工具箱|r丨按钮文字和指令都不能为空")
            return
        end

        custom.label = label
        custom.command = cmd
        self:UpdateQuickChatBar()
        self:RefreshSettingsUI()
    end)

    local tips = createSmallLabel(panel, "", "TOPLEFT", addBtn, "BOTTOMLEFT", 0, -14)
    tips:SetText("提示: 内置按钮=切换聊天频道 | 世界按钮左键加入/切换、右键离开 | 骰子=/roll | 自定义=执行指令")
    tips:SetWidth(500)
    tips:SetWordWrap(true)

    self.ui.selectedLabel = selectedLabel
    self.ui.colorSwatch = swatch
    self.ui.listContent = listContent
    self.ui.listBorder = listBorder
    self.ui.listRows = {}
    self.ui.customLabelEdit = customLabelEdit
    self.ui.customCmdEdit = customCmdEdit
    self.ui.editCustomBtn = editCustomBtn
    self.ui.deleteBtn = deleteBtn
    self.ui.moveUpBtn = moveUpBtn
    self.ui.moveDownBtn = moveDownBtn

    self:RefreshSettingsUI()

    return panel
end

function Core:CreateSettingsWindow()
    if self.settingsFrame then return end

    local frame = CreateFrame("Frame", self.NAME .. "Settings", UIParent, "BasicFrameTemplateWithInset")
    frame:SetSize(760, 530)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("DIALOG")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame.TitleText:SetText("雨轩工具箱  |cFF888888v" .. self.VERSION .. "|r")
    frame:Hide()

    local left = CreateFrame("Frame", nil, frame, "InsetFrameTemplate3")
    left:SetPoint("TOPLEFT", 10, -28)
    left:SetPoint("BOTTOMLEFT", 10, 10)
    left:SetWidth(140)

    local tabTitle = left:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    tabTitle:SetPoint("TOPLEFT", 12, -12)
    tabTitle:SetText("功能列表")
    tabTitle:SetTextColor(0.80, 0.80, 0.80)

    local quickTab = CreateFrame("Button", nil, left, "UIPanelButtonTemplate")
    quickTab:SetSize(120, 26)
    quickTab:SetPoint("TOPLEFT", tabTitle, "BOTTOMLEFT", 0, -10)
    quickTab:SetText("快捷频道")
    quickTab:SetScript("OnClick", function() Core:SelectTab("quickChat") end)

    self.tabButtons.quickChat = quickTab

    local right = CreateFrame("Frame", nil, frame, "InsetFrameTemplate3")
    right:SetPoint("TOPLEFT", left, "TOPRIGHT", 8, 0)
    right:SetPoint("BOTTOMRIGHT", -10, 10)

    local rightScroll = CreateFrame("ScrollFrame", nil, right, "UIPanelScrollFrameTemplate")
    rightScroll:SetPoint("TOPLEFT", 6, -6)
    rightScroll:SetPoint("BOTTOMRIGHT", -26, 6)

    local rightContent = CreateFrame("Frame", nil, rightScroll)
    rightContent:SetSize(560, 800)
    rightScroll:SetScrollChild(rightContent)

    right:SetScript("OnSizeChanged", function(_, w)
        rightContent:SetWidth(math.max(520, (w or 560) - 38))
    end)

    self.contentPanels.quickChat = self:CreateQuickChatPanel(rightContent)

    self.settingsFrame = frame
    self:SelectTab("quickChat")
end

function Core:ToggleSettingsWindow()
    if not self.settingsFrame then
        self:CreateSettingsWindow()
    end

    if self.settingsFrame:IsShown() then
        self.settingsFrame:Hide()
    else
        self:RefreshSettingsUI()
        self.settingsFrame:Show()
    end
end
