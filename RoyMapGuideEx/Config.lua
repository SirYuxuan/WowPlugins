local addonName, ns = ...
local mainCategory
local floor = math.floor

local EXPORT_HEADER = "RMG_CUSTOM_V3"
local DEFAULT_CUSTOM_COLOR = { r = 0.2, g = 1, b = 0.73 }

-- ========================================================================================================================
-- 事件分发器
-- ========================================================================================================================
local eventFrame = CreateFrame("Frame")
local eventHandlers = {}

function ns.RegisterEventHandler(event, handler)
    if not eventHandlers[event] then
        eventHandlers[event] = {}
        eventFrame:RegisterEvent(event)
    end
    table.insert(eventHandlers[event], handler)
end

eventFrame:SetScript("OnEvent", function(_, event, ...)
    local handlers = eventHandlers[event]
    if handlers then
        for _, handler in ipairs(handlers) do
            handler(...)
        end
    end
end)

-- ========================================================================================================================
-- 选项表
-- ========================================================================================================================
local subCategories = {
    ["地图增强"] = { name = "地图增强" },
    ["坐标扩展"] = { name = "坐标扩展" },
    ["坐标导入导出"] = { name = "坐标导入导出" },
}
local order = { "地图增强", "坐标扩展", "坐标导入导出" }

--------------------------------------------------------------------------------
-- 选项函数
--------------------------------------------------------------------------------
local markerTypeOptions = function()
    local container = Settings.CreateControlTextContainer()
    container:Add("TEXT", "文本标记")
    container:Add("ICON", "图标标记")
    return container:GetData()
end

local textOutlineOptions = function()
    local container = Settings.CreateControlTextContainer()
    container:Add("", "无")
    container:Add("OUTLINE", "细轮廓")
    return container:GetData()
end

local iconGlowOptions = function()
    local container = Settings.CreateControlTextContainer()
    container:Add("", "无")
    container:Add("GLOW", "外发光")
    return container:GetData()
end

local function encodeCoord(x, y)
    if not x or not y then return nil end
    local xPart = floor(x * 10000 + 0.5)
    local yPart = floor(y * 10000 + 0.5)
    return xPart * 10000 + yPart
end

local function clampColor(v)
    v = tonumber(v) or 0
    if v < 0 then return 0 end
    if v > 1 then return 1 end
    return v
end

local function cloneColor(color)
    color = color or DEFAULT_CUSTOM_COLOR
    return {
        r = clampColor(color.r),
        g = clampColor(color.g),
        b = clampColor(color.b),
    }
end

local function getMarkerCustomColor(marker)
    if marker and type(marker.customColor) == "table" then
        return cloneColor(marker.customColor)
    end
    return cloneColor(DEFAULT_CUSTOM_COLOR)
end

local function toHexColorString(color)
    local r = floor(clampColor(color.r) * 255 + 0.5)
    local g = floor(clampColor(color.g) * 255 + 0.5)
    local b = floor(clampColor(color.b) * 255 + 0.5)
    return string.format("%02X%02X%02X", r, g, b)
end

local function fromHexColorString(hex)
    if type(hex) ~= "string" then
        return cloneColor(DEFAULT_CUSTOM_COLOR)
    end
    local h = hex:match("^#?(%x%x%x%x%x%x)$")
    if not h then
        return cloneColor(DEFAULT_CUSTOM_COLOR)
    end
    return {
        r = tonumber(h:sub(1, 2), 16) / 255,
        g = tonumber(h:sub(3, 4), 16) / 255,
        b = tonumber(h:sub(5, 6), 16) / 255,
    }
end

local function escapeField(str)
    str = tostring(str or "")
    return (str:gsub("%%", "%%25"):gsub("\n", "%%0A"):gsub("|", "%%7C"))
end

local function unescapeField(str)
    str = tostring(str or "")
    return (str:gsub("%%(%x%x)", function(hex)
        return string.char(tonumber(hex, 16) or 0)
    end))
end

local function base64Encode(data)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data = tostring(data or "")
    return ((data:gsub('.', function(x)
        local r, byte = '', x:byte()
        for i = 8, 1, -1 do
            r = r .. ((byte % 2 ^ i - byte % 2 ^ (i - 1) > 0) and '1' or '0')
        end
        return r
    end) .. '0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if #x < 6 then return '' end
        local c = 0
        for i = 1, 6 do
            c = c + ((x:sub(i, i) == '1') and 2 ^ (6 - i) or 0)
        end
        return b:sub(c + 1, c + 1)
    end) .. ({ '', '==', '=' })[#data % 3 + 1])
end

local function base64Decode(data)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data = tostring(data or ""):gsub('%s', '')
    if data == "" then return "" end

    data = data:gsub('[^' .. b .. '=]', '')
    return (data:gsub('.', function(x)
        if x == '=' then return '' end
        local f = (b:find(x, 1, true) or 1) - 1
        local r = ''
        for i = 6, 1, -1 do
            r = r .. ((f % 2 ^ i - f % 2 ^ (i - 1) > 0) and '1' or '0')
        end
        return r
    end):gsub('%d%d%d%d%d%d%d%d', function(x)
        local c = 0
        for i = 1, 8 do
            c = c + ((x:sub(i, i) == '1') and 2 ^ (8 - i) or 0)
        end
        return string.char(c)
    end))
end

local function ensureCustomMarkerDB()
    RoyMapGuideDB = RoyMapGuideDB or {}
    RoyMapGuideDB.customMarkers = RoyMapGuideDB.customMarkers or {}
    RoyMapGuideDB.customMarkerLastColor = RoyMapGuideDB.customMarkerLastColor or cloneColor(DEFAULT_CUSTOM_COLOR)
end

local function refreshMapMarkers()
    if ns and ns.ToggleMapMarkers then
        ns:ToggleMapMarkers()
    end
end

local function addCustomMarker(mapID, coord, title, customColor, note)
    ensureCustomMarkerDB()
    RoyMapGuideDB.customMarkers[mapID] = RoyMapGuideDB.customMarkers[mapID] or {}
    table.insert(RoyMapGuideDB.customMarkers[mapID], {
        coord = coord,
        text = title,
        title = title,
        note = note or "",
        isCustom = true,
        customColor = cloneColor(customColor),
    })
end

local function exportCustomMarkers()
    ensureCustomMarkerDB()
    local lines = {}
    local ids = {}

    for mapID in pairs(RoyMapGuideDB.customMarkers) do
        if tonumber(mapID) then
            table.insert(ids, tonumber(mapID))
        end
    end
    table.sort(ids)

    for _, mapID in ipairs(ids) do
        local list = RoyMapGuideDB.customMarkers[mapID]
        if type(list) == "table" then
            for _, marker in ipairs(list) do
                if marker and marker.coord and marker.title then
                    local color = getMarkerCustomColor(marker)
                    table.insert(lines,
                        string.format("%d|%d|%s|%s|%s", mapID, marker.coord, toHexColorString(color),
                            escapeField(marker.title), escapeField(marker.note or "")))
                end
            end
        end
    end

    local payload = table.concat(lines, "\n")
    return base64Encode(payload)
end

local function importCustomMarkers(text)
    ensureCustomMarkerDB()
    local imported = 0
    local input = tostring(text or "")
    local payload = base64Decode(input)
    if payload == "" then
        payload = input
    end

    for line in payload:gmatch("[^\r\n]+") do
        if line ~= "" and line ~= EXPORT_HEADER and line ~= "RMG_CUSTOM_V2" and line ~= "RMG_CUSTOM_V1" then
            local mapID, coord, colorHex, titleEscaped, noteEscaped = line:match("^(%d+)|(%d+)|([#%x]+)|([^|]*)|?(.*)$")
            mapID = tonumber(mapID)
            coord = tonumber(coord)
            local title = titleEscaped and strtrim(unescapeField(titleEscaped)) or ""
            local note = noteEscaped and unescapeField(noteEscaped) or ""

            if mapID and coord and title ~= "" then
                addCustomMarker(mapID, coord, title, fromHexColorString(colorHex), note)
                imported = imported + 1
            end
        end
    end

    return imported
end

local function removeCustomMarker(mapID, index)
    ensureCustomMarkerDB()
    local list = RoyMapGuideDB.customMarkers[mapID]
    if type(list) ~= "table" then return false end
    if not list[index] then return false end

    table.remove(list, index)
    if #list == 0 then
        RoyMapGuideDB.customMarkers[mapID] = nil
    end
    return true
end

local function decodeCoord(coord)
    if not coord then return 0, 0 end
    local x = floor(coord / 10000) / 100
    local y = (coord % 10000) / 100
    return x, y
end

local function getMapNameByID(mapID)
    local mapInfo = C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(mapID)
    return (mapInfo and mapInfo.name) or ("MapID " .. tostring(mapID))
end

local function GetCurrentPlayerMapCoord()
    local mapID = C_Map.GetBestMapForUnit("player")
    if not mapID and WorldMapFrame then
        mapID = WorldMapFrame:GetMapID()
    end
    if not mapID then return nil, nil, nil end

    local pos = C_Map.GetPlayerMapPosition(mapID, "player")
    if not pos then return mapID, nil, nil end

    return mapID, pos.x, pos.y
end

local function CreateImportExportPanel(parentFrame)
    local title = parentFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("坐标导入导出")
    title:SetTextColor(1, 0.82, 0)

    local statusText = parentFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    statusText:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -10)
    statusText:SetText("")
    statusText:SetTextColor(0.6, 0.9, 1)

    local exportBtn = CreateFrame("Button", nil, parentFrame, "UIPanelButtonTemplate")
    exportBtn:SetSize(100, 24)
    exportBtn:SetPoint("TOPLEFT", statusText, "BOTTOMLEFT", 0, -6)
    exportBtn:SetText("导出")

    local importBtn = CreateFrame("Button", nil, parentFrame, "UIPanelButtonTemplate")
    importBtn:SetSize(100, 24)
    importBtn:SetPoint("LEFT", exportBtn, "RIGHT", 8, 0)
    importBtn:SetText("导入")

    local ioScroll = CreateFrame("ScrollFrame", nil, parentFrame, "InputScrollFrameTemplate")
    ioScroll:SetPoint("TOPLEFT", exportBtn, "BOTTOMLEFT", -6, -10)
    ioScroll:SetSize(620, 360)

    local ioEdit = ioScroll.EditBox
    ioEdit:SetAutoFocus(false)
    ioEdit:SetMultiLine(true)
    ioEdit:SetFontObject(GameFontHighlightSmall)
    ioEdit:SetWidth(600)
    ioEdit.cursorOffset = 0
    ioEdit:SetScript("OnEscapePressed", function(self)
        self:ClearFocus()
    end)

    exportBtn:SetScript("OnClick", function()
        ioEdit:SetText(exportCustomMarkers())
        ioEdit:HighlightText()
        statusText:SetText("导出完成")
        statusText:SetTextColor(0.3, 1, 0.4)
    end)

    importBtn:SetScript("OnClick", function()
        local importedCount = importCustomMarkers(ioEdit:GetText())
        if importedCount > 0 then
            refreshMapMarkers()
            statusText:SetText("导入成功：" .. importedCount .. " 条")
            statusText:SetTextColor(0.3, 1, 0.4)
        else
            statusText:SetText("未导入任何条目")
            statusText:SetTextColor(1, 0.3, 0.3)
        end
    end)
end

local quickAddFrame
local refreshCustomMarkerPanel
local function ShowQuickAddPopup()
    ensureCustomMarkerDB()

    if not quickAddFrame then
        quickAddFrame = CreateFrame("Frame", addonName .. "QuickAddFrame", UIParent, "BasicFrameTemplateWithInset")
        quickAddFrame:SetSize(360, 230)
        quickAddFrame:SetPoint("CENTER")
        quickAddFrame:SetFrameStrata("DIALOG")
        quickAddFrame:SetMovable(true)
        quickAddFrame:EnableMouse(true)
        quickAddFrame:RegisterForDrag("LeftButton")
        quickAddFrame:SetScript("OnDragStart", quickAddFrame.StartMoving)
        quickAddFrame:SetScript("OnDragStop", quickAddFrame.StopMovingOrSizing)

        if quickAddFrame.TitleText then
            quickAddFrame.TitleText:SetText("快速添加坐标")
        end

        quickAddFrame.title = nil

        local titleLabel = quickAddFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        titleLabel:SetPoint("TOPLEFT", 14, -38)
        titleLabel:SetText("标题")

        quickAddFrame.titleEdit = CreateFrame("EditBox", nil, quickAddFrame, "InputBoxTemplate")
        quickAddFrame.titleEdit:SetAutoFocus(false)
        quickAddFrame.titleEdit:SetSize(320, 24)
        quickAddFrame.titleEdit:SetPoint("TOPLEFT", titleLabel, "BOTTOMLEFT", 0, -6)
        quickAddFrame.titleEdit.cursorOffset = 0

        local noteLabel = quickAddFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        noteLabel:SetPoint("TOPLEFT", quickAddFrame.titleEdit, "BOTTOMLEFT", 0, -12)
        noteLabel:SetText("备注")

        quickAddFrame.noteEdit = CreateFrame("EditBox", nil, quickAddFrame, "InputBoxTemplate")
        quickAddFrame.noteEdit:SetAutoFocus(false)
        quickAddFrame.noteEdit:SetSize(320, 24)
        quickAddFrame.noteEdit:SetPoint("TOPLEFT", noteLabel, "BOTTOMLEFT", 0, -6)
        quickAddFrame.noteEdit.cursorOffset = 0

        local colorLabel = quickAddFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        colorLabel:SetPoint("TOPLEFT", quickAddFrame.noteEdit, "BOTTOMLEFT", 0, -14)
        colorLabel:SetText("颜色")

        quickAddFrame.color = cloneColor(RoyMapGuideDB.customMarkerLastColor or DEFAULT_CUSTOM_COLOR)
        quickAddFrame.swatch = CreateFrame("Button", nil, quickAddFrame, "BackdropTemplate")
        quickAddFrame.swatch:SetSize(30, 18)
        quickAddFrame.swatch:SetPoint("LEFT", colorLabel, "RIGHT", 8, 0)
        quickAddFrame.swatch:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8X8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 12,
            insets = { left = 2, right = 2, top = 2, bottom = 2 }
        })

        quickAddFrame.colorText = quickAddFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
        quickAddFrame.colorText:SetPoint("LEFT", quickAddFrame.swatch, "RIGHT", 8, 0)

        local function refreshPopupColor()
            quickAddFrame.swatch:SetBackdropColor(quickAddFrame.color.r, quickAddFrame.color.g, quickAddFrame.color.b, 1)
            quickAddFrame.colorText:SetText("#" .. toHexColorString(quickAddFrame.color))
        end

        quickAddFrame.swatch:SetScript("OnClick", function()
            if not ColorPickerFrame then return end
            local oldColor = cloneColor(quickAddFrame.color)
            if ColorPickerFrame.SetupColorPickerAndShow then
                ColorPickerFrame:SetupColorPickerAndShow({
                    r = quickAddFrame.color.r,
                    g = quickAddFrame.color.g,
                    b = quickAddFrame.color.b,
                    hasOpacity = false,
                    swatchFunc = function()
                        local r, g, b = ColorPickerFrame:GetColorRGB()
                        quickAddFrame.color = { r = r, g = g, b = b }
                        refreshPopupColor()
                    end,
                    cancelFunc = function()
                        quickAddFrame.color = cloneColor(oldColor)
                        refreshPopupColor()
                    end,
                })
            end
        end)

        quickAddFrame.status = quickAddFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
        quickAddFrame.status:SetPoint("TOPLEFT", colorLabel, "BOTTOMLEFT", 0, -16)
        quickAddFrame.status:SetText("")

        local saveBtn = CreateFrame("Button", nil, quickAddFrame, "UIPanelButtonTemplate")
        saveBtn:SetSize(120, 24)
        saveBtn:SetPoint("BOTTOM", quickAddFrame, "BOTTOM", -64, 12)
        saveBtn:SetText("保存")

        local closeBtn = CreateFrame("Button", nil, quickAddFrame, "UIPanelButtonTemplate")
        closeBtn:SetSize(120, 24)
        closeBtn:SetPoint("LEFT", saveBtn, "RIGHT", 8, 0)
        closeBtn:SetText("关闭")
        closeBtn:SetScript("OnClick", function()
            quickAddFrame:Hide()
        end)

        saveBtn:SetScript("OnClick", function()
            local markerTitle = strtrim(quickAddFrame.titleEdit:GetText() or "")
            if markerTitle == "" then
                quickAddFrame.status:SetText("请输入标题")
                return
            end

            local mapID, x, y = GetCurrentPlayerMapCoord()
            if not mapID or not x or not y then
                quickAddFrame.status:SetText("无法获取当前坐标")
                return
            end

            local markerNote = strtrim(quickAddFrame.noteEdit:GetText() or "")
            addCustomMarker(mapID, encodeCoord(x, y), markerTitle, quickAddFrame.color, markerNote)
            RoyMapGuideDB.customMarkerLastColor = cloneColor(quickAddFrame.color)
            refreshMapMarkers()
            if refreshCustomMarkerPanel then
                refreshCustomMarkerPanel()
            end
            print(string.format("|cFF33FF99RoyMapGuide|r丨自定义“%s”添加成功", markerTitle))
            quickAddFrame.status:SetText("已保存")
            quickAddFrame:Hide()
        end)

        refreshPopupColor()
    end

    quickAddFrame.titleEdit:SetText("")
    quickAddFrame.noteEdit:SetText("")
    quickAddFrame.status:SetText("")
    quickAddFrame:Show()
end

local function CreateCustomMarkerPanel(parentFrame)
    local title = parentFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("自定义坐标扩展")
    title:SetTextColor(1, 0.82, 0)

    local tip = parentFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    tip:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    tip:SetText("填写标题与备注后保存，支持编码导入导出")
    tip:SetTextColor(0.6, 0.8, 1)

    local mapInfoText = parentFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    mapInfoText:SetPoint("TOPLEFT", tip, "BOTTOMLEFT", 0, -12)
    mapInfoText:SetText("当前地图：-")

    local coordInfoText = parentFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    coordInfoText:SetPoint("TOPLEFT", mapInfoText, "BOTTOMLEFT", 0, -6)
    coordInfoText:SetText("当前坐标：-")

    local statusText = parentFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    statusText:SetPoint("TOPLEFT", coordInfoText, "BOTTOMLEFT", 0, -8)
    statusText:SetText("")
    statusText:SetTextColor(0.6, 0.9, 1)

    local titleLabel = parentFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    titleLabel:SetPoint("TOPLEFT", statusText, "BOTTOMLEFT", 0, -12)
    titleLabel:SetText("标题")

    local titleEdit = CreateFrame("EditBox", nil, parentFrame, "InputBoxTemplate")
    titleEdit:SetAutoFocus(false)
    titleEdit:SetSize(200, 24)
    titleEdit:SetPoint("LEFT", titleLabel, "RIGHT", 10, 0)
    titleEdit:SetText("")
    titleEdit.cursorOffset = 0

    local noteLabel = parentFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    noteLabel:SetPoint("LEFT", titleEdit, "RIGHT", 14, 0)
    noteLabel:SetText("备注")

    local noteEdit = CreateFrame("EditBox", nil, parentFrame, "InputBoxTemplate")
    noteEdit:SetAutoFocus(false)
    noteEdit:SetSize(220, 24)
    noteEdit:SetPoint("LEFT", noteLabel, "RIGHT", 10, 0)
    noteEdit:SetText("")
    noteEdit.cursorOffset = 0

    local colorLabel = parentFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    colorLabel:SetPoint("TOPLEFT", titleLabel, "BOTTOMLEFT", 0, -16)
    colorLabel:SetText("自定义颜色")

    local colorSwatch = CreateFrame("Button", nil, parentFrame, "BackdropTemplate")
    colorSwatch:SetSize(30, 18)
    colorSwatch:SetPoint("LEFT", colorLabel, "RIGHT", 10, 0)
    colorSwatch:EnableMouse(true)
    colorSwatch:RegisterForClicks("LeftButtonUp")
    colorSwatch:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })

    local colorSwatchText = parentFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    colorSwatchText:SetPoint("LEFT", colorSwatch, "RIGHT", 10, 0)

    local selectedColor = cloneColor(RoyMapGuideDB.customMarkerLastColor or DEFAULT_CUSTOM_COLOR)
    local currentMapID
    local currentCoord

    local function setStatus(text, r, g, b)
        statusText:SetText(text or "")
        statusText:SetTextColor(r or 0.6, g or 0.9, b or 1)
    end

    local function updateSwatch()
        colorSwatch:SetBackdropColor(selectedColor.r, selectedColor.g, selectedColor.b, 1)
        colorSwatchText:SetText("#" .. toHexColorString(selectedColor))
    end

    local function updateCurrentPosition()
        local mapID, x, y = GetCurrentPlayerMapCoord()

        if not mapID then
            currentMapID = nil
            currentCoord = nil
            mapInfoText:SetText("当前地图：无法获取")
            coordInfoText:SetText("当前坐标：无法获取")
            setStatus("请在可获取坐标的地图中使用", 1, 0.3, 0.3)
            return
        end

        local mapName = getMapNameByID(mapID)
        if not x or not y then
            currentMapID = mapID
            currentCoord = nil
            mapInfoText:SetText("当前地图：" .. mapName .. "（" .. mapID .. "）")
            coordInfoText:SetText("当前坐标：无法获取")
            setStatus("无法读取当前位置，请移动后重试", 1, 0.3, 0.3)
            return
        end

        currentMapID = mapID
        currentCoord = encodeCoord(x, y)
        mapInfoText:SetText("当前地图：" .. mapName .. "（" .. mapID .. "）")
        coordInfoText:SetText(string.format("当前坐标：%.2f, %.2f", x * 100, y * 100))
        setStatus("坐标已刷新")
    end

    local function openColorPicker()
        local oldColor = cloneColor(selectedColor)

        if not ColorPickerFrame then
            setStatus("当前环境无法打开颜色选择器", 1, 0.3, 0.3)
            return
        end

        if ColorPickerFrame.SetupColorPickerAndShow then
            local info = {
                r = selectedColor.r,
                g = selectedColor.g,
                b = selectedColor.b,
                hasOpacity = false,
                swatchFunc = function()
                    local r, g, b = ColorPickerFrame:GetColorRGB()
                    selectedColor = { r = r, g = g, b = b }
                    RoyMapGuideDB.customMarkerLastColor = cloneColor(selectedColor)
                    updateSwatch()
                end,
                cancelFunc = function()
                    selectedColor = cloneColor(oldColor)
                    RoyMapGuideDB.customMarkerLastColor = cloneColor(selectedColor)
                    updateSwatch()
                end,
            }
            ColorPickerFrame:SetupColorPickerAndShow(info)
            return
        end

        ColorPickerFrame.hasOpacity = false
        ColorPickerFrame.previousValues = oldColor
        ColorPickerFrame.func = function()
            local r, g, b = ColorPickerFrame:GetColorRGB()
            selectedColor = { r = r, g = g, b = b }
            RoyMapGuideDB.customMarkerLastColor = cloneColor(selectedColor)
            updateSwatch()
        end
        ColorPickerFrame.cancelFunc = function(previous)
            selectedColor = cloneColor(previous or oldColor)
            RoyMapGuideDB.customMarkerLastColor = cloneColor(selectedColor)
            updateSwatch()
        end
        ColorPickerFrame:SetColorRGB(selectedColor.r, selectedColor.g, selectedColor.b)
        ColorPickerFrame:Hide()
        ColorPickerFrame:Show()
    end

    colorSwatch:SetScript("OnClick", openColorPicker)

    local saveBtn = CreateFrame("Button", nil, parentFrame, "UIPanelButtonTemplate")
    saveBtn:SetSize(130, 24)
    saveBtn:SetPoint("TOPLEFT", colorLabel, "BOTTOMLEFT", 0, -16)
    saveBtn:SetText("保存并生效")

    local historyTitle = parentFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    historyTitle:SetPoint("TOPLEFT", saveBtn, "BOTTOMLEFT", 0, -16)
    historyTitle:SetText("历史坐标（可移除）")
    historyTitle:SetTextColor(1, 0.82, 0)

    local historyPageText = parentFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    historyPageText:SetPoint("LEFT", historyTitle, "RIGHT", 12, 0)
    historyPageText:SetText("")

    local prevBtn = CreateFrame("Button", nil, parentFrame, "UIPanelButtonTemplate")
    prevBtn:SetSize(60, 20)
    prevBtn:SetPoint("LEFT", historyPageText, "RIGHT", 8, 0)
    prevBtn:SetText("上一页")

    local nextBtn = CreateFrame("Button", nil, parentFrame, "UIPanelButtonTemplate")
    nextBtn:SetSize(60, 20)
    nextBtn:SetPoint("LEFT", prevBtn, "RIGHT", 6, 0)
    nextBtn:SetText("下一页")

    local visibleRows = 7
    local rowHeight = 36
    local historyRows = {}
    local historyEntries = {}
    local historyOffset = 0

    for i = 1, visibleRows do
        local row = CreateFrame("Frame", nil, parentFrame)
        row:SetSize(560, rowHeight)
        row:SetPoint("TOPLEFT", historyTitle, "BOTTOMLEFT", 0, -(i - 1) * rowHeight - 6)

        row.bg = row:CreateTexture(nil, "BACKGROUND")
        row.bg:SetAllPoints()
        if i % 2 == 0 then
            row.bg:SetColorTexture(0.08, 0.08, 0.08, 0.45)
        else
            row.bg:SetColorTexture(0.04, 0.04, 0.04, 0.45)
        end

        row.border = row:CreateTexture(nil, "BORDER")
        row.border:SetPoint("TOPLEFT", 0, 0)
        row.border:SetPoint("BOTTOMRIGHT", 0, 0)
        row.border:SetColorTexture(0.3, 0.3, 0.3, 0.3)

        row.colorBar = row:CreateTexture(nil, "ARTWORK")
        row.colorBar:SetSize(4, rowHeight - 4)
        row.colorBar:SetPoint("LEFT", 2, 0)

        row.titleText = row:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
        row.titleText:SetPoint("TOPLEFT", 10, -6)
        row.titleText:SetWidth(475)
        row.titleText:SetJustifyH("LEFT")

        row.detailText = row:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
        row.detailText:SetPoint("TOPLEFT", row.titleText, "BOTTOMLEFT", 0, -2)
        row.detailText:SetWidth(475)
        row.detailText:SetJustifyH("LEFT")

        row.removeBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
        row.removeBtn:SetSize(56, 18)
        row.removeBtn:SetPoint("RIGHT", 0, 0)
        row.removeBtn:SetText("移除")

        historyRows[i] = row
    end

    local function rebuildHistoryEntries()
        historyEntries = {}
        ensureCustomMarkerDB()

        for mapID, list in pairs(RoyMapGuideDB.customMarkers) do
            if type(list) == "table" then
                for idx, marker in ipairs(list) do
                    if marker and marker.coord and marker.title then
                        table.insert(historyEntries, {
                            mapID = tonumber(mapID),
                            index = idx,
                            title = marker.title,
                            note = marker.note or "",
                            coord = marker.coord,
                            colorHex = toHexColorString(getMarkerCustomColor(marker)),
                        })
                    end
                end
            end
        end

        table.sort(historyEntries, function(a, b)
            if a.mapID == b.mapID then
                return a.index > b.index
            end
            return a.mapID > b.mapID
        end)
    end

    local function refreshHistoryList()
        rebuildHistoryEntries()

        local total = #historyEntries
        local pageCount = math.max(1, math.ceil(total / visibleRows))
        local currentPage = math.floor(historyOffset / visibleRows) + 1
        if currentPage > pageCount then
            currentPage = pageCount
            historyOffset = (currentPage - 1) * visibleRows
        end

        historyPageText:SetText(string.format("%d/%d（共%d条）", currentPage, pageCount, total))
        prevBtn:SetEnabled(currentPage > 1)
        nextBtn:SetEnabled(currentPage < pageCount)

        for i = 1, visibleRows do
            local row = historyRows[i]
            local entry = historyEntries[historyOffset + i]

            if entry then
                local x, y = decodeCoord(entry.coord)
                local mapName = getMapNameByID(entry.mapID)
                row.colorBar:SetColorTexture(fromHexColorString(entry.colorHex).r, fromHexColorString(entry.colorHex).g,
                    fromHexColorString(entry.colorHex).b, 1)
                row.titleText:SetText(string.format("[%s] %s", mapName, entry.title))
                local detailLine = string.format("坐标 %.2f, %.2f   颜色 #%s", x, y, entry.colorHex)
                if entry.note and entry.note ~= "" then
                    detailLine = detailLine .. "   备注: " .. entry.note
                end
                row.detailText:SetText(detailLine)
                row:Show()
                row.removeBtn:SetScript("OnClick", function()
                    if removeCustomMarker(entry.mapID, entry.index) then
                        refreshMapMarkers()
                        setStatus("已移除：" .. entry.title, 1, 0.82, 0.2)
                        refreshHistoryList()
                    end
                end)
            else
                row.titleText:SetText("")
                row.detailText:SetText("")
                row.removeBtn:SetScript("OnClick", nil)
                row:Hide()
            end
        end
    end

    refreshCustomMarkerPanel = function()
        updateCurrentPosition()
        refreshHistoryList()
    end

    prevBtn:SetScript("OnClick", function()
        historyOffset = math.max(0, historyOffset - visibleRows)
        refreshHistoryList()
    end)

    nextBtn:SetScript("OnClick", function()
        historyOffset = historyOffset + visibleRows
        refreshHistoryList()
    end)

    saveBtn:SetScript("OnClick", function()
        updateCurrentPosition()

        local markerTitle = strtrim(titleEdit:GetText() or "")
        if markerTitle == "" then
            setStatus("请先输入标题", 1, 0.3, 0.3)
            return
        end

        if not currentMapID or not currentCoord then
            setStatus("无法保存：当前地图或坐标不可用", 1, 0.3, 0.3)
            return
        end

        local markerNote = strtrim(noteEdit:GetText() or "")
        addCustomMarker(currentMapID, currentCoord, markerTitle, selectedColor, markerNote)
        RoyMapGuideDB.customMarkerLastColor = cloneColor(selectedColor)
        refreshMapMarkers()
        setStatus("已保存并生效", 0.3, 1, 0.4)
        refreshHistoryList()
    end)

    updateSwatch()
    refreshCustomMarkerPanel()
end

-- ========================================================================================================================
-- 数据表
-- ========================================================================================================================
local DB = {
    --------------------------------------------------------------------------------
    -- 地图增强模块
    --------------------------------------------------------------------------------
    -- 全地图NPC标记
    { var = "MapMarkersTitle", label = "全地图NPC标记", default = false, category = "地图增强", type = "SectionHeader" },
    { var = "enableMapMarkers", label = "启用全地图NPC标记", default = false, category = "地图增强", type = "CheckBox" },
    { var = "globalMarkerSize", label = "全局标记大小", default = 14, category = "地图增强", type = "Slider", min = 8, max = 20, step = 1 },
    { var = "mapMarkerType", label = "标记显示类型", default = "TEXT", category = "地图增强", type = "DropDown", options = markerTypeOptions },
    { var = "mapMarkerTextOutline", label = "文本标记样式", default = "OUTLINE", category = "地图增强", type = "DropDown", options = textOutlineOptions },
    { var = "mapMarkerIconGlow", label = "图标标记样式", default = "", category = "地图增强", type = "DropDown", options = iconGlowOptions },
    { var = "mapMarkerTooltips", label = "鼠标提示", default = false, tooltip = "显示标记的额外提示信息", category = "地图增强", type = "CheckBox" },
    { var = "mapMarkerProfessionFilter", label = "专业过滤", default = false, tooltip = "只显示你学习的专业，钓鱼烹饪考古除外", category = "地图增强", type = "CheckBox" },
    -- 标记类型
    { var = "MapMarkersTitle", label = "标记类型", default = false, category = "地图增强", type = "SectionHeader" },
    { var = "mapMarkersPortal", label = "传送", default = true, tooltip = "传送/通道", category = "地图增强", type = "CheckBox" },
    { var = "mapMarkersInn", label = "旅店", default = true, category = "地图增强", type = "CheckBox" },
    { var = "mapMarkersOfficial", label = "商业", default = true, tooltip = "拍卖/银行/黑市", category = "地图增强", type = "CheckBox" },
    { var = "mapMarkersProfession", label = "专业", default = true, category = "地图增强", type = "CheckBox" },
    { var = "mapMarkersService", label = "服务", default = true, tooltip = "理发/幻化/商栈/物品升级/订单/地下堡总部", category = "地图增强", type = "CheckBox" },
    { var = "mapMarkersStable", label = "兽栏", default = true, category = "地图增强", type = "CheckBox" },
    { var = "mapMarkersCollection", label = "藏品", default = true, tooltip = "坐骑/玩具/宠物/家宅装饰", category = "地图增强", type = "CheckBox" },
    { var = "mapMarkersVendor", label = "通用商人", default = true, tooltip = "普通商人/公会商人/外观商人/传家宝商人", category = "地图增强", type = "CheckBox" },
    { var = "mapMarkersUnique", label = "特殊商人", default = true, tooltip = "墨黑药水/焰火/礼服/要塞图纸/埃匹希斯水晶/黄金挑战/服役勋章/海岛/格里伏塔/社交名媛/冰冻宝珠/变形术/血商/橙装/古怪硬币/盟约升级/青铜锭/血腥硬币/元素涌流/可乐罐", category = "地图增强", type = "CheckBox" },
    { var = "mapMarkersSpecial", label = "特殊功能", default = true, tooltip = "马戏团专业任务/传送门训练师/克罗米/经验锁定/动画/场景战役/R币/拆解机/盟约功能/化生台/幻形讲坛", category = "地图增强", type = "CheckBox" },
    { var = "mapMarkersQuartermaster", label = "军需官", default = true, tooltip = "声望军需官/盟约军需官", category = "地图增强", type = "CheckBox" },
    { var = "mapMarkersPvp", label = "PVP相关", default = true, tooltip = "pvp商人/pvp坐骑/木桩", category = "地图增强", type = "CheckBox" },
    { var = "mapMarkersInstance", label = "副本", default = true, category = "地图增强", type = "CheckBox" },
    { var = "mapMarkersDelve", label = "地下堡", default = true, category = "地图增强", type = "CheckBox" },
    -- 联盟
    { var = "allianceTitle", label = "联盟", default = false, category = "地图增强", type = "SectionHeader" },
    { CheckBoxvar = "showStormwind", Slidervar = "scaleStormwind", CheckBoxLabel = "暴风城", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 0.8, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showIronforge", Slidervar = "scaleIronforge", CheckBoxLabel = "铁炉堡", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 0.8, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showDarnassus", Slidervar = "scaleDarnassus", CheckBoxLabel = "达纳苏斯", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 0.8, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showExodar", Slidervar = "scaleExodar", CheckBoxLabel = "埃索达", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 0.8, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showGilneas", Slidervar = "scaleGilneas", CheckBoxLabel = "吉尔尼斯", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 0.8, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showStormshield", Slidervar = "scaleStormshield", CheckBoxLabel = "暴风之盾", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 0.8, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showBoralus", Slidervar = "scaleBoralus", CheckBoxLabel = "伯拉勒斯", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 1, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showBelamath", Slidervar = "scaleBelamath", CheckBoxLabel = "贝拉梅斯", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 1, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    -- 部落
    { var = "hordeTitle", label = "部落", default = false, category = "地图增强", type = "SectionHeader" },
    { CheckBoxvar = "showOrgrimmar", Slidervar = "scaleOrgrimmar", CheckBoxLabel = "奥格瑞玛", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 0.7, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showThunderBluff", Slidervar = "scaleThunderBluff", CheckBoxLabel = "雷霆崖", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 0.8, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showUndercity", Slidervar = "scaleUndercity", CheckBoxLabel = "幽暗城", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 0.8, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showWarspear", Slidervar = "scaleWarspear", CheckBoxLabel = "战争之矛", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 0.8, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showDazaralor", Slidervar = "scaleDazaralor", CheckBoxLabel = "达萨罗", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 1, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    -- 中立城市
    { var = "neutralTitle", label = "中立", default = false, category = "地图增强", type = "SectionHeader" },
    { CheckBoxvar = "showShattrath", Slidervar = "scaleShattrath", CheckBoxLabel = "沙塔斯", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 0.8, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showDalaranNorthrend", Slidervar = "scaleDalaranNorthrend", CheckBoxLabel = "达拉然（诺森德）", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 0.8, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showDalaranLegion", Slidervar = "scaleDalaranLegion", CheckBoxLabel = "达拉然（破碎群岛）", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 0.8, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showOribos", Slidervar = "scaleOribos", CheckBoxLabel = "奥利波斯", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 0.8, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showSanctumofDomination", Slidervar = "scaleSanctumofDomination", CheckBoxLabel = "兵主之座", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 0.8, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showSinfall", Slidervar = "scaleSinfall", CheckBoxLabel = "堕罪堡", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 0.8, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showHeartoftheForest", Slidervar = "scaleHeartoftheForest", CheckBoxLabel = "森林之心", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 0.8, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showElysianHold", Slidervar = "scaleElysianHold", CheckBoxLabel = "极乐堡", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 0.8, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showValdrakken", Slidervar = "scaleValdrakken", CheckBoxLabel = "瓦德拉肯", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 1.2, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showDornogal", Slidervar = "scaleDornogal", CheckBoxLabel = "多恩诺嘉尔", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 1.2, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showCityofThreads", Slidervar = "scaleCityofThreads", CheckBoxLabel = "千丝之城", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 1.2, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showUndermine", Slidervar = "scaleUndermine", CheckBoxLabel = "安德麦", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 1.2, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showTazavesh", Slidervar = "scaleTazavesh", CheckBoxLabel = "塔扎维什", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 0.8, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showSilvermoonCityMidnight", Slidervar = "scaleSilvermoonCityMidnight", CheckBoxLabel = "银月城（至暗之夜）", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 1.1, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    -- 地图区域
    { var = "regionsTitle", label = "区域", default = false, category = "地图增强", type = "SectionHeader" },
    { CheckBoxvar = "showDarkmoonfaire", Slidervar = "scaleDarkmoonfaire", CheckBoxLabel = "暗月马戏团", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 0.7, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showIsleofDorn", Slidervar = "scaleIsleofDorn", CheckBoxLabel = "多恩岛", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 1.2, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showTheRingingDeeps", Slidervar = "scaleTheRingingDeeps", CheckBoxLabel = "喧鸣深窟", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 1.2, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showHallowfall", Slidervar = "scaleHallowfall", CheckBoxLabel = "陨圣峪", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 1.2, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showAzjKahet", Slidervar = "scaleAzjKahet", CheckBoxLabel = "艾基-卡赫特", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 1.2, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showKAresh", Slidervar = "scaleKAresh", CheckBoxLabel = "卡雷什", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 1.2, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showEversongWoods", Slidervar = "scaleEversongWoods", CheckBoxLabel = "永歌森林", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 1.2, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showVoidstorm", Slidervar = "scaleVoidstorm", CheckBoxLabel = "虚影风暴", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 1.2, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showIsleofQuelDanas", Slidervar = "scaleIsleofQuelDanas", CheckBoxLabel = "奎尔丹纳斯岛", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 1.2, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showZulAman", Slidervar = "scaleZulAman", CheckBoxLabel = "祖阿曼", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 1.2, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 },
    { CheckBoxvar = "showHarandar", Slidervar = "scaleHarandar", CheckBoxLabel = "哈籁恩达尔", SliderLabel = "", CheckBoxDefault = true, SliderDefault = 1.2, category = "地图增强", type = "CheckBoxSlider", min = 0.5, max = 2, step = 0.1 }
}

-- ========================================================================================================================
-- 回调函数
-- ========================================================================================================================
local callbackMap = {
    --------------------------------------------------------------------------------
    -- 地图增强模块回调
    --------------------------------------------------------------------------------
    -- 全地图NPC标记回调
    ["enableMapMarkers"] = function() ns:ToggleMapMarkers() end,
    ["globalMarkerSize"] = function() ns:ToggleMapMarkers() end,
    ["mapMarkerType"] = function() ns:ToggleMapMarkers() end,
    ["mapMarkerTextOutline"] = function() ns:ToggleMapMarkers() end,
    ["mapMarkerIconGlow"] = function() ns:ToggleMapMarkers() end,
    ["mapMarkerTooltips"] = function() ns:ToggleMapMarkers() end,
    ["mapMarkerProfessionFilter"] = function() ns:ToggleMapMarkers() end,
    -- 地图标记开关回调
    ["mapMarkersPortal"] = function() ns:ToggleMapMarkers() end,
    ["mapMarkersInn"] = function() ns:ToggleMapMarkers() end,
    ["mapMarkersOfficial"] = function() ns:ToggleMapMarkers() end,
    ["mapMarkersProfession"] = function() ns:ToggleMapMarkers() end,
    ["mapMarkersService"] = function() ns:ToggleMapMarkers() end,
    ["mapMarkersStable"] = function() ns:ToggleMapMarkers() end,
    ["mapMarkersCollection"] = function() ns:ToggleMapMarkers() end,
    ["mapMarkersVendor"] = function() ns:ToggleMapMarkers() end,
    ["mapMarkersUnique"] = function() ns:ToggleMapMarkers() end,
    ["mapMarkersSpecial"] = function() ns:ToggleMapMarkers() end,
    ["mapMarkersQuartermaster"] = function() ns:ToggleMapMarkers() end,
    ["mapMarkersPvp"] = function() ns:ToggleMapMarkers() end,
    ["mapMarkersInstance"] = function() ns:ToggleMapMarkers() end,
    ["mapMarkersDelve"] = function() ns:ToggleMapMarkers() end,
    -- 联盟
    ["showStormwind"] = function() ns:ToggleMapMarkers() end,
    ["scaleStormwind"] = function() ns:ToggleMapMarkers() end,
    ["showIronforge"] = function() ns:ToggleMapMarkers() end,
    ["scaleIronforge"] = function() ns:ToggleMapMarkers() end,
    ["showDarnassus"] = function() ns:ToggleMapMarkers() end,
    ["scaleDarnassus"] = function() ns:ToggleMapMarkers() end,
    ["showExodar"] = function() ns:ToggleMapMarkers() end,
    ["scaleExodar"] = function() ns:ToggleMapMarkers() end,
    ["showGilneas"] = function() ns:ToggleMapMarkers() end,
    ["scaleGilneas"] = function() ns:ToggleMapMarkers() end,
    ["showStormshield"] = function() ns:ToggleMapMarkers() end,
    ["scaleStormshield"] = function() ns:ToggleMapMarkers() end,
    ["showBoralus"] = function() ns:ToggleMapMarkers() end,
    ["scaleBoralus"] = function() ns:ToggleMapMarkers() end,
    ["showBelamath"] = function() ns:ToggleMapMarkers() end,
    ["scaleBelamath"] = function() ns:ToggleMapMarkers() end,
    -- 部落
    ["showOrgrimmar"] = function() ns:ToggleMapMarkers() end,
    ["scaleOrgrimmar"] = function() ns:ToggleMapMarkers() end,
    ["showThunderBluff"] = function() ns:ToggleMapMarkers() end,
    ["scaleThunderBluff"] = function() ns:ToggleMapMarkers() end,
    ["showUndercity"] = function() ns:ToggleMapMarkers() end,
    ["scaleUndercity"] = function() ns:ToggleMapMarkers() end,
    ["showWarspear"] = function() ns:ToggleMapMarkers() end,
    ["scaleWarspear"] = function() ns:ToggleMapMarkers() end,
    ["showDazaralor"] = function() ns:ToggleMapMarkers() end,
    ["scaleDazaralor"] = function() ns:ToggleMapMarkers() end,
    -- 中立城市
    ["showShattrath"] = function() ns:ToggleMapMarkers() end,
    ["scaleShattrath"] = function() ns:ToggleMapMarkers() end,
    ["showDalaranNorthrend"] = function() ns:ToggleMapMarkers() end,
    ["scaleDalaranNorthrend"] = function() ns:ToggleMapMarkers() end,
    ["showDalaranLegion"] = function() ns:ToggleMapMarkers() end,
    ["scaleDalaranLegion"] = function() ns:ToggleMapMarkers() end,
    ["showOribos"] = function() ns:ToggleMapMarkers() end,
    ["scaleOribos"] = function() ns:ToggleMapMarkers() end,
    ["showSanctumofDomination"] = function() ns:ToggleMapMarkers() end,
    ["scaleSanctumofDomination"] = function() ns:ToggleMapMarkers() end,
    ["showSinfall"] = function() ns:ToggleMapMarkers() end,
    ["scaleSinfall"] = function() ns:ToggleMapMarkers() end,
    ["showHeartoftheForest"] = function() ns:ToggleMapMarkers() end,
    ["scaleHeartoftheForest"] = function() ns:ToggleMapMarkers() end,
    ["showElysianHold"] = function() ns:ToggleMapMarkers() end,
    ["scaleElysianHold"] = function() ns:ToggleMapMarkers() end,
    ["showValdrakken"] = function() ns:ToggleMapMarkers() end,
    ["scaleValdrakken"] = function() ns:ToggleMapMarkers() end,
    ["showDornogal"] = function() ns:ToggleMapMarkers() end,
    ["scaleDornogal"] = function() ns:ToggleMapMarkers() end,
    ["showCityofThreads"] = function() ns:ToggleMapMarkers() end,
    ["scaleCityofThreads"] = function() ns:ToggleMapMarkers() end,
    ["showUndermine"] = function() ns:ToggleMapMarkers() end,
    ["scaleUndermine"] = function() ns:ToggleMapMarkers() end,
    ["showTazavesh"] = function() ns:ToggleMapMarkers() end,
    ["scaleTazavesh"] = function() ns:ToggleMapMarkers() end,
    ["showSilvermoonCityMidnight"] = function() ns:ToggleMapMarkers() end,
    ["scaleSilvermoonCityMidnight"] = function() ns:ToggleMapMarkers() end,
    -- 地图区域
    ["showDarkmoonfaire"] = function() ns:ToggleMapMarkers() end,
    ["scaleDarkmoonfaire"] = function() ns:ToggleMapMarkers() end,
    ["showIsleofDorn"] = function() ns:ToggleMapMarkers() end,
    ["scaleIsleofDorn"] = function() ns:ToggleMapMarkers() end,
    ["showTheRingingDeeps"] = function() ns:ToggleMapMarkers() end,
    ["scaleTheRingingDeeps"] = function() ns:ToggleMapMarkers() end,
    ["showHallowfall"] = function() ns:ToggleMapMarkers() end,
    ["scaleHallowfall"] = function() ns:ToggleMapMarkers() end,
    ["showAzjKahet"] = function() ns:ToggleMapMarkers() end,
    ["scaleAzjKahet"] = function() ns:ToggleMapMarkers() end,
    ["showKAresh"] = function() ns:ToggleMapMarkers() end,
    ["scaleKAresh"] = function() ns:ToggleMapMarkers() end,
    ["showEversongWoods"] = function() ns:ToggleMapMarkers() end,
    ["scaleEversongWoods"] = function() ns:ToggleMapMarkers() end,
    ["showVoidstorm"] = function() ns:ToggleMapMarkers() end,
    ["scaleVoidstorm"] = function() ns:ToggleMapMarkers() end,
    ["showIsleofQuelDanas"] = function() ns:ToggleMapMarkers() end,
    ["scaleIsleofQuelDanas"] = function() ns:ToggleMapMarkers() end,
    ["showZulAman"] = function() ns:ToggleMapMarkers() end,
    ["scaleZulAman"] = function() ns:ToggleMapMarkers() end,
    ["showHarandar"] = function() ns:ToggleMapMarkers() end,
    ["scaleHarandar"] = function() ns:ToggleMapMarkers() end,
}

-- ========================================================================================================================
-- 回调函数分发器
-- ========================================================================================================================
local function OnSettingChanged(setting, value)
    local variable = setting:GetVariable()

    -- 直接查找映射
    local callback = callbackMap[variable]
    if callback then
        callback(value)
    end
end

-- ========================================================================================================================
-- 斜杠命令
-- ========================================================================================================================
SLASH_RoyMapGuide1 = "/rmg"
SLASH_RoyMapGuideQuickAdd1 = "/yxpin"
SlashCmdList["RoyMapGuide"] = function()
    if Settings and mainCategory then
        Settings.OpenToCategory(mainCategory:GetID())
    end
end

SlashCmdList["RoyMapGuideQuickAdd"] = function()
    ShowQuickAddPopup()
end

-- ========================================================================================================================
-- 数据初始化
-- ========================================================================================================================
local function initializeSettings()
    -- 确保数据库存在
    RoyMapGuideDB = RoyMapGuideDB or {}

    -- 统一初始化所有配置变量
    for _, entry in ipairs(DB) do
        -- 处理普通变量
        if entry.var and RoyMapGuideDB[entry.var] == nil then
            RoyMapGuideDB[entry.var] = entry.default
        end

        -- 处理复合控件的各个部分
        if entry.CheckBoxvar and RoyMapGuideDB[entry.CheckBoxvar] == nil then
            RoyMapGuideDB[entry.CheckBoxvar] = entry.CheckBoxDefault
        end

        if entry.Slidervar and RoyMapGuideDB[entry.Slidervar] == nil then
            RoyMapGuideDB[entry.Slidervar] = entry.SliderDefault
        end

        if entry.DropDownvar and RoyMapGuideDB[entry.DropDownvar] == nil then
            RoyMapGuideDB[entry.DropDownvar] = entry.DropDownDefault
        end
    end

    ensureCustomMarkerDB()

    --------------------------------------------------------------------------------
    -- 创建设置界面
    --------------------------------------------------------------------------------
    local MainSettingFrame = CreateFrame("Frame")

    -- 创建标题
    local header = MainSettingFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    header:SetPoint("TOP", 0, -20)
    header:SetText("RoyMapGuide")
    header:SetTextColor(1, 0.8, 0)

    local subtitle = MainSettingFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    subtitle:SetPoint("TOP", header, "BOTTOM", 0, -10)
    subtitle:SetText("常用功能合集")
    subtitle:SetTextColor(0.6, 0.8, 1)

    -- 注册主设置类别
    mainCategory = Settings.RegisterCanvasLayoutCategory(MainSettingFrame, "RoyMapGuide")
    Settings.RegisterAddOnCategory(mainCategory)

    -- 注册子类别
    for k, v in ipairs(order) do
        local category = subCategories[v]
        if v == "坐标扩展" and Settings.RegisterCanvasLayoutSubcategory then
            local customFrame = CreateFrame("Frame")
            CreateCustomMarkerPanel(customFrame)
            category.handle = Settings.RegisterCanvasLayoutSubcategory(mainCategory, customFrame, category.name)
            category.layout = nil
        elseif v == "坐标导入导出" and Settings.RegisterCanvasLayoutSubcategory then
            local ioFrame = CreateFrame("Frame")
            CreateImportExportPanel(ioFrame)
            category.handle = Settings.RegisterCanvasLayoutSubcategory(mainCategory, ioFrame, category.name)
            category.layout = nil
        else
            category.handle, category.layout = Settings.RegisterVerticalLayoutSubcategory(mainCategory, category.name)
        end
    end

    --------------------------------------------------------------------------------
    -- 通用创建函数
    --------------------------------------------------------------------------------
    local function createSliderOptions(entry)
        local options = Settings.CreateSliderOptions(entry.min, entry.max, entry.step)
        options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, function(value)
            if entry.step and entry.step < 1 then
                return string.format("%.1f", value)
            else
                return string.format("%.0f", value)
            end
        end)
        return options
    end

    local function createSetting(category, variable, variableType, label, default, getFunc, setFunc)
        local setting = Settings.RegisterProxySetting(category, variable, variableType, label, default, getFunc, setFunc)
        setting:SetValueChangedCallback(OnSettingChanged)
        return setting
    end

    --------------------------------------------------------------------------------
    -- 创建设置项
    --------------------------------------------------------------------------------
    for _, entry in ipairs(DB) do
        local catInfo = subCategories[entry.category]
        if not catInfo then return end

        if entry.type == "CheckBox" then
            -- 勾选框
            local setting = createSetting(
                catInfo.handle, entry.var, type(entry.default),
                entry.label, entry.default,
                function() return RoyMapGuideDB[entry.var] end,
                function(value) RoyMapGuideDB[entry.var] = value end
            )
            Settings.CreateCheckbox(catInfo.handle, setting, entry.tooltip)
        elseif entry.type == "Slider" then
            -- 滑动条
            local setting = createSetting(
                catInfo.handle, entry.var, type(entry.default),
                entry.label, entry.default,
                function() return RoyMapGuideDB[entry.var] end,
                function(value) RoyMapGuideDB[entry.var] = value end
            )
            local options = createSliderOptions(entry)
            Settings.CreateSlider(catInfo.handle, setting, options, entry.tooltip)
        elseif entry.type == "DropDown" then
            -- 下拉菜单
            local setting = createSetting(
                catInfo.handle, entry.var, type(entry.default),
                entry.label, entry.default,
                function() return RoyMapGuideDB[entry.var] end,
                function(value) RoyMapGuideDB[entry.var] = value end
            )
            Settings.CreateDropdown(catInfo.handle, setting, entry.options, entry.tooltip)
        elseif entry.type == "CheckBoxSlider" then
            -- 勾选框+滑动条组合
            local cbSetting = createSetting(
                catInfo.handle, entry.CheckBoxvar, type(entry.CheckBoxDefault),
                entry.CheckBoxLabel, entry.CheckBoxDefault,
                function() return RoyMapGuideDB[entry.CheckBoxvar] end,
                function(value) RoyMapGuideDB[entry.CheckBoxvar] = value end
            )

            local sliderSetting = createSetting(
                catInfo.handle, entry.Slidervar, type(entry.SliderDefault),
                entry.SliderLabel, entry.SliderDefault,
                function() return RoyMapGuideDB[entry.Slidervar] end,
                function(value) RoyMapGuideDB[entry.Slidervar] = value end
            )

            local options = createSliderOptions(entry)
            local initializer = CreateSettingsCheckboxSliderInitializer(
                cbSetting, entry.CheckBoxLabel, entry.CheckBoxTooltip,
                sliderSetting, options, entry.SliderLabel, entry.SliderTooltip
            )
            catInfo.layout:AddInitializer(initializer)
        elseif entry.type == "CheckBoxDropDown" then
            -- 勾选框+下拉菜单组合
            local cbSetting = createSetting(
                catInfo.handle, entry.CheckBoxvar, type(entry.CheckBoxDefault),
                entry.CheckBoxLabel, entry.CheckBoxDefault,
                function() return RoyMapGuideDB[entry.CheckBoxvar] end,
                function(value) RoyMapGuideDB[entry.CheckBoxvar] = value end
            )

            local dropdownSetting = createSetting(
                catInfo.handle, entry.DropDownvar, type(entry.DropDownDefault),
                entry.DropDownLabel, entry.DropDownDefault,
                function() return RoyMapGuideDB[entry.DropDownvar] end,
                function(value) RoyMapGuideDB[entry.DropDownvar] = value end
            )

            local initializer = CreateSettingsCheckboxDropdownInitializer(
                cbSetting, entry.CheckBoxLabel, entry.CheckBoxTooltip,
                dropdownSetting, entry.options, entry.DropDownLabel, entry.DropDownTooltip
            )
            catInfo.layout:AddInitializer(initializer)
        elseif entry.type == "SectionHeader" then
            -- 分组标题
            local initializer = CreateSettingsListSectionHeaderInitializer(entry.label)
            catInfo.layout:AddInitializer(initializer)
        end
    end
end

-- ========================================================================================================================
-- 事件处理
-- ========================================================================================================================
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, addon)
    if addon == addonName then
        initializeSettings()
    end
end)
