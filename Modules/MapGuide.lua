local addonName, ns = ...
local Core = ns.Core

-- ========================================================================================================================
-- 全地图NPC标记模块
-- ========================================================================================================================
local COMPENSATION_FACTOR = 0.08
local MARKER_FRAME_STRATA = "MEDIUM"
local MARKER_FRAME_LEVEL = 2200
local GLOW_ATLAS = "GearEnchant_IconBorder"
local GLOW_COLOR = { r = 1, g = 1, b = 1, a = 1 }
local GLOW_BLEND_MODE = "ADD"
local GLOW_SCALE = 1.3
local floor = math.floor

local EXPORT_HEADER = "RMG_CUSTOM_V3"
local DEFAULT_CUSTOM_COLOR = { r = 0.2, g = 1, b = 0.73 }

-- 数据库导入
local MARKER_DATABASE = ns.MAP_GUIDE_DATA or {}
if not next(MARKER_DATABASE) then
    print("|cFF33FF99雨轩工具箱|r丨地图标记数据加载失败")
end

-- ─── 配置快捷引用 ──────────────────────────────────
local function cfg()
    return Core.db and Core.db.profile.mapGuide
end

local function globalDB()
    return Core.db and Core.db.global
end

-- ─── 颜色定义表 ────────────────────────────────────
local COLOR_TABLE = {
    ["portal"]        = { r = 0, g = 0.87, b = 1 },
    ["inn"]           = { r = 0, g = 1, b = 0 },
    ["official"]      = { r = 1, g = 1, b = 0 },
    ["profession"]    = { r = 1, g = 1, b = 1 },
    ["service"]       = { r = 1, g = 0, b = 1 },
    ["stable"]        = { r = 1, g = 0.6, b = 0 },
    ["collection"]    = { r = 1, g = 0.53, b = 0.8 },
    ["vendor"]        = { r = 0.67, g = 0.2, b = 1 },
    ["unique"]        = { r = 0.2, g = 0.4, b = 1 },
    ["special"]       = { r = 0, g = 1, b = 0.73 },
    ["quartermaster"] = { r = 1, g = 0.31, b = 0 },
    ["pvp"]           = { r = 1, g = 0.25, b = 0.25 },
    ["instance"]      = { r = 1, g = 0, b = 0.33 },
    ["delve"]         = { r = 0.47, g = 0.47, b = 1 },
}

-- 专业映射表
local PROFESSION_TO_SKILLLINE = {
    ["Archaeology"]    = 794,
    ["Alchemy"]        = 171,
    ["Blacksmithing"]  = 164,
    ["Cooking"]        = 185,
    ["Enchanting"]     = 333,
    ["Engineering"]    = 202,
    ["Fishing"]        = 356,
    ["Herbalism"]      = 182,
    ["Inscription"]    = 773,
    ["Jewelcrafting"]  = 755,
    ["Leatherworking"] = 165,
    ["Mining"]         = 186,
    ["Skinning"]       = 393,
    ["Tailoring"]      = 197,
}

-- ========================================================================================================================
-- 颜色/编码 工具
-- ========================================================================================================================
local function clampColor(v)
    v = tonumber(v) or 0
    if v < 0 then return 0 end
    if v > 1 then return 1 end
    return v
end

local function cloneColor(color)
    color = color or DEFAULT_CUSTOM_COLOR
    return { r = clampColor(color.r), g = clampColor(color.g), b = clampColor(color.b) }
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
    if type(hex) ~= "string" then return cloneColor(DEFAULT_CUSTOM_COLOR) end
    local h = hex:match("^#?(%x%x%x%x%x%x)$")
    if not h then return cloneColor(DEFAULT_CUSTOM_COLOR) end
    return {
        r = tonumber(h:sub(1, 2), 16) / 255,
        g = tonumber(h:sub(3, 4), 16) / 255,
        b = tonumber(h:sub(5, 6), 16) / 255,
    }
end

local function encodeCoord(x, y)
    if not x or not y then return nil end
    local xPart = floor(x * 10000 + 0.5)
    local yPart = floor(y * 10000 + 0.5)
    return xPart * 10000 + yPart
end

local function decodeCoord(coord)
    if not coord then return 0, 0 end
    local x = floor(coord / 10000) / 100
    local y = (coord % 10000) / 100
    return x, y
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
    local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    data = tostring(data or "")
    return ((data:gsub(".", function(x)
        local r, byte = "", x:byte()
        for i = 8, 1, -1 do
            r = r .. ((byte % 2 ^ i - byte % 2 ^ (i - 1) > 0) and "1" or "0")
        end
        return r
    end) .. "0000"):gsub("%d%d%d?%d?%d?%d?", function(x)
        if #x < 6 then return "" end
        local c = 0
        for i = 1, 6 do
            c = c + ((x:sub(i, i) == "1") and 2 ^ (6 - i) or 0)
        end
        return b:sub(c + 1, c + 1)
    end) .. ({ "", "==", "=" })[#data % 3 + 1])
end

local function base64Decode(data)
    local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    data = tostring(data or ""):gsub("%s", "")
    if data == "" then return "" end
    data = data:gsub("[^" .. b .. "=]", "")
    return (data:gsub(".", function(x)
        if x == "=" then return "" end
        local f = (b:find(x, 1, true) or 1) - 1
        local r = ""
        for i = 6, 1, -1 do
            r = r .. ((f % 2 ^ i - f % 2 ^ (i - 1) > 0) and "1" or "0")
        end
        return r
    end):gsub("%d%d%d%d%d%d%d%d", function(x)
        local c = 0
        for i = 1, 8 do
            c = c + ((x:sub(i, i) == "1") and 2 ^ (8 - i) or 0)
        end
        return string.char(c)
    end))
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

-- ========================================================================================================================
-- 自定义标记 CRUD
-- ========================================================================================================================
local function ensureCustomMarkerDB()
    if not Core.db then return end
    if not Core.db.global.customMarkers then Core.db.global.customMarkers = {} end
    if not Core.db.global.customMarkerLastColor then
        Core.db.global.customMarkerLastColor = cloneColor(DEFAULT_CUSTOM_COLOR)
    end
end

local function refreshMapMarkers()
    if Core.ToggleMapMarkers then Core:ToggleMapMarkers() end
end

local function addCustomMarker(mapID, coord, title, customColor, note)
    ensureCustomMarkerDB()
    local g = globalDB()
    g.customMarkers[mapID] = g.customMarkers[mapID] or {}
    table.insert(g.customMarkers[mapID], {
        coord = coord,
        text = title,
        title = title,
        note = note or "",
        isCustom = true,
        customColor = cloneColor(customColor),
    })
end

local function removeCustomMarker(mapID, index)
    ensureCustomMarkerDB()
    local g = globalDB()
    local list = g.customMarkers[mapID]
    if type(list) ~= "table" then return false end
    if not list[index] then return false end
    table.remove(list, index)
    if #list == 0 then g.customMarkers[mapID] = nil end
    return true
end

local function exportCustomMarkers()
    ensureCustomMarkerDB()
    local g = globalDB()
    local lines, ids = {}, {}
    for mapID in pairs(g.customMarkers) do
        if tonumber(mapID) then table.insert(ids, tonumber(mapID)) end
    end
    table.sort(ids)
    for _, mapID in ipairs(ids) do
        local list = g.customMarkers[mapID]
        if type(list) == "table" then
            for _, marker in ipairs(list) do
                if marker and marker.coord and marker.title then
                    local color = getMarkerCustomColor(marker)
                    table.insert(lines,
                        string.format("%d|%d|%s|%s|%s", mapID, marker.coord,
                            toHexColorString(color), escapeField(marker.title), escapeField(marker.note or "")))
                end
            end
        end
    end
    return base64Encode(table.concat(lines, "\n"))
end

local function importCustomMarkers(text)
    ensureCustomMarkerDB()
    local imported = 0
    local input = tostring(text or "")
    local payload = base64Decode(input)
    if payload == "" then payload = input end
    for line in payload:gmatch("[^\r\n]+") do
        if line ~= "" and line ~= EXPORT_HEADER and line ~= "RMG_CUSTOM_V2" and line ~= "RMG_CUSTOM_V1" then
            local mapID, coord, colorHex, titleEsc, noteEsc = line:match("^(%d+)|(%d+)|([#%x]+)|([^|]*)|?(.*)$")
            mapID = tonumber(mapID)
            coord = tonumber(coord)
            local title = titleEsc and strtrim(unescapeField(titleEsc)) or ""
            local note = noteEsc and unescapeField(noteEsc) or ""
            if mapID and coord and title ~= "" then
                addCustomMarker(mapID, coord, title, fromHexColorString(colorHex), note)
                imported = imported + 1
            end
        end
    end
    return imported
end

-- ========================================================================================================================
-- MapMarkers 核心对象
-- ========================================================================================================================
local MapMarkers = {
    activeMarkers = {},
    playerProfessions = {},
    professionEventFrame = nil,
    professionLastUpdate = 0,
    markerPool = { frames = {}, currentMarkerType = nil },
    poolConfig = { maxKeep = 80, cleanupOnHide = true },
}

local quickWaypointInput
local quickWaypointHolder
local quickWaypointExtraArea
local quickWaypointButton

--------------------------------------------------------------------------------
-- 工具函数
--------------------------------------------------------------------------------
function MapMarkers:GetXY(coord)
    if not coord then return 0, 0 end
    local x = floor(coord / 10000) / 10000
    local y = (coord % 10000) / 10000
    return x, y
end

function MapMarkers:GetMapScaleFactor()
    if not WorldMapFrame.ScrollContainer or not WorldMapFrame.ScrollContainer.Child then return 1.0 end
    local mapScale = WorldMapFrame.ScrollContainer.Child:GetScale()
    if not mapScale or mapScale == 0 then return 1.0 end
    return (1 / mapScale) ^ 0.7
end

function MapMarkers:GetGlobalSize()
    local c = cfg()
    return c and c.globalMarkerSize or 14
end

--------------------------------------------------------------------------------
-- 专业系统
--------------------------------------------------------------------------------
function MapMarkers:UpdatePlayerProfessions()
    self.playerProfessions = {}
    local professions = { GetProfessions() }
    for i = 1, 6 do
        if professions[i] then
            local _, _, _, _, _, _, skillLine = GetProfessionInfo(professions[i])
            if skillLine then self.playerProfessions[skillLine] = true end
        end
    end
    self.professionLastUpdate = GetTime()
end

function MapMarkers:InitializeProfessions()
    self:UpdatePlayerProfessions()
    self.professionEventFrame = CreateFrame("Frame")
    self.professionEventFrame:RegisterEvent("SKILL_LINES_CHANGED")
    self.professionEventFrame:SetScript("OnEvent", function()
        self:UpdatePlayerProfessions()
        self:UpdateMapMarkers()
    end)
end

function MapMarkers:ShouldShowByProfession(marker)
    local c = cfg()
    if not c or not c.mapMarkerProfessionFilter then return true end
    if not marker.type then return true end
    local types = type(marker.type) == "table" and marker.type or { marker.type }
    for _, profType in ipairs(types) do
        local skillLine = PROFESSION_TO_SKILLLINE[profType]
        if skillLine and self.playerProfessions[skillLine] then return true end
    end
    return false
end

--------------------------------------------------------------------------------
-- 类型/城市过滤
--------------------------------------------------------------------------------
function MapMarkers:ShouldShowByType(marker)
    local c = cfg()
    if not c then return true end
    local typeSwitches = {
        portal        = c.mapMarkersPortal,
        inn           = c.mapMarkersInn,
        official      = c.mapMarkersOfficial,
        profession    = c.mapMarkersProfession,
        service       = c.mapMarkersService,
        stable        = c.mapMarkersStable,
        collection    = c.mapMarkersCollection,
        vendor        = c.mapMarkersVendor,
        unique        = c.mapMarkersUnique,
        special       = c.mapMarkersSpecial,
        quartermaster = c.mapMarkersQuartermaster,
        pvp           = c.mapMarkersPvp,
        instance      = c.mapMarkersInstance,
        delve         = c.mapMarkersDelve,
    }
    if marker.tags and #marker.tags > 0 then
        local checked = {}
        for _, tag in ipairs(marker.tags) do
            if not checked[tag] then
                checked[tag] = true
                local sv = typeSwitches[tag]
                if sv == nil or sv == true then return true end
            end
        end
        return false
    end
    if not marker.color then return true end
    local sv = typeSwitches[marker.color]
    return sv == nil or sv == true
end

function MapMarkers:CleanupObjectPool()
    local maxKeep = self.poolConfig.maxKeep
    while #self.markerPool.frames > maxKeep do
        table.remove(self.markerPool.frames, 1)
    end
end

function MapMarkers:ShouldShowByCity(mapData)
    if not mapData or not mapData.group then return true end
    local c = cfg()
    if not c then return true end
    local key = "show" .. mapData.group
    return c[key] ~= false
end

function MapMarkers:GetCityScale(mapData)
    if not mapData or not mapData.group then return 1.0 end
    local c = cfg()
    if not c then return 1.0 end
    local scale = c["scale" .. mapData.group]
    if scale and type(scale) == "number" then return scale end
    return 1.0
end

function MapMarkers:GetMarkers(mapData, mapID)
    local markers = {}
    if mapData then
        for i = 1, #mapData do
            local item = mapData[i]
            if type(item) == "table" and item.coord then
                table.insert(markers, item)
            end
        end
    end
    local g = globalDB()
    if g and g.customMarkers and mapID then
        local customList = g.customMarkers[mapID]
        if type(customList) == "table" then
            for _, item in ipairs(customList) do
                if type(item) == "table" and item.coord then
                    item.isCustom = true
                    if item.note == nil and item.info then item.note = item.info end
                    table.insert(markers, item)
                end
            end
        end
    end
    return markers
end

--------------------------------------------------------------------------------
-- 鼠标提示
--------------------------------------------------------------------------------
function MapMarkers:AddMarkerTooltip(frame, marker)
    local baseColor = marker.customColor or COLOR_TABLE[marker.color] or { r = 1, g = 1, b = 1 }
    local detailText = marker.info
    if marker.isCustom then
        detailText = marker.note or ""
        if detailText == "" then detailText = "自定义坐标" end
    end
    local titleText = marker.title or marker.text or "标记"

    frame:SetScript("OnEnter", function(self)
        if self.fontString then
            self.fontString:SetTextColor(math.min(baseColor.r + 0.25, 1), math.min(baseColor.g + 0.25, 1),
                math.min(baseColor.b + 0.25, 1), 1)
        elseif self.texture then
            self.texture:SetVertexColor(1, 0.95, 0.65, 1)
        end
        local c = cfg()
        if not c or c.mapMarkerTooltips ~= false then
            if Core.SetTooltipAnchor then
                Core:SetTooltipAnchor(GameTooltip, self, "ANCHOR_RIGHT")
            else
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            end
            GameTooltip:SetText(titleText, 1, 0.82, 0)
            if detailText and detailText ~= "" then
                GameTooltip:AddLine(detailText, 1, 1, 1, true)
            end
            GameTooltip:Show()
        end
    end)
    frame:SetScript("OnLeave", function(self)
        if self.fontString then
            self.fontString:SetTextColor(baseColor.r, baseColor.g, baseColor.b, 1)
        elseif self.texture then
            self.texture:SetVertexColor(1, 1, 1, 1)
        end
        GameTooltip:Hide()
    end)
end

function MapMarkers:AddMarkerClickHandler(frame, marker)
    if not marker or not marker.coord then
        frame:SetScript("OnMouseUp", nil)
        frame:SetMouseClickEnabled(false)
        return
    end
    frame:SetMouseClickEnabled(true)
    frame:SetScript("OnMouseUp", function(_, button)
        if button ~= "LeftButton" then return end
        local mapID = WorldMapFrame and WorldMapFrame:GetMapID()
        if not mapID then return end
        local x, y = self:GetXY(marker.coord)
        if not x or not y then return end
        local waypoint = UiMapPoint.CreateFromCoordinates(mapID, x, y)
        if not waypoint then return end
        C_Map.SetUserWaypoint(waypoint)
        if C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then
            C_SuperTrack.SetSuperTrackedUserWaypoint(true)
        end
    end)
end

--------------------------------------------------------------------------------
-- 对象池
--------------------------------------------------------------------------------
function MapMarkers:GetMarkerFromPool()
    if #self.markerPool.frames > 0 then
        local frame = table.remove(self.markerPool.frames)
        frame:Show()
        return frame
    end
    return nil
end

function MapMarkers:ReturnMarkerToPool(frame)
    if not frame then return end
    frame:Hide()
    frame:ClearAllPoints()
    frame:SetParent(nil)
    frame:SetScale(1)
    frame:SetScript("OnEnter", nil)
    frame:SetScript("OnLeave", nil)
    frame:SetScript("OnMouseUp", nil)
    if frame.fontString then
        frame.fontString:SetText(""); frame.fontString:Hide()
    end
    if frame.texture then
        frame.texture:SetTexture(nil); frame.texture:Hide()
    end
    if frame.Glow then frame.Glow:Hide() end
    table.insert(self.markerPool.frames, frame)
end

--------------------------------------------------------------------------------
-- 创建标记
--------------------------------------------------------------------------------
function MapMarkers:CreateTextMarker(parent, marker, mapWidth, mapHeight, cityScale)
    cityScale = cityScale or 1.0
    local textFrame = self:GetMarkerFromPool()
    local isReused = textFrame ~= nil
    if not textFrame then
        textFrame = CreateFrame("Frame", nil, parent)
        textFrame:SetFrameStrata(MARKER_FRAME_STRATA)
        textFrame:SetFrameLevel(MARKER_FRAME_LEVEL)
        textFrame.fontString = textFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    else
        textFrame:SetParent(parent)
        textFrame:SetFrameStrata(MARKER_FRAME_STRATA)
        textFrame:SetFrameLevel(MARKER_FRAME_LEVEL)
    end
    local fontString = textFrame.fontString
    if not fontString then
        textFrame.fontString = textFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        fontString = textFrame.fontString
    end
    fontString:Show()

    local x, y = self:GetXY(marker.coord)
    local reverseScale = self:GetMapScaleFactor()
    local finalTextSize = self:GetGlobalSize() * cityScale * reverseScale
    local fontPath = GameFontNormal:GetFont()
    local c = cfg()
    local outlineStyle = c and c.mapMarkerTextOutline or ""
    fontString:SetFont(fontPath, finalTextSize, outlineStyle)
    fontString:SetShadowOffset(0, 0)
    fontString:SetText(marker.text or "")
    local color = marker.customColor or COLOR_TABLE[marker.color] or { r = 1, g = 1, b = 1 }
    fontString:SetTextColor(color.r, color.g, color.b, 1)
    if textFrame.texture then textFrame.texture:Hide() end

    local textWidth = fontString:GetStringWidth()
    local textHeight = fontString:GetStringHeight()
    textFrame:SetSize(textWidth, textHeight)

    local posX = x * mapWidth
    local posY = -y * mapHeight
    local offsetX = (marker.offsetX or 0) * reverseScale
    local offsetY = (marker.offsetY or 0) * reverseScale
    local textAnchor = marker.textA or "CENTER"

    textFrame:ClearAllPoints()
    fontString:ClearAllPoints()
    if textAnchor == "CENTER" then
        fontString:SetPoint("CENTER", textFrame, "CENTER", 0, 0)
        fontString:SetJustifyH("CENTER")
        textFrame:SetPoint("CENTER", parent, "TOPLEFT", posX + offsetX, posY + offsetY)
    elseif textAnchor == "RIGHT" then
        fontString:SetPoint("LEFT", textFrame, "LEFT", 0, 0)
        fontString:SetJustifyH("LEFT")
        textFrame:SetPoint("LEFT", parent, "TOPLEFT", posX - textWidth * COMPENSATION_FACTOR + offsetX, posY + offsetY)
    elseif textAnchor == "LEFT" then
        fontString:SetPoint("RIGHT", textFrame, "RIGHT", 0, 0)
        fontString:SetJustifyH("RIGHT")
        textFrame:SetPoint("RIGHT", parent, "TOPLEFT", posX + textWidth * COMPENSATION_FACTOR + offsetX, posY + offsetY)
    end

    self:AddMarkerTooltip(textFrame, marker)
    self:AddMarkerClickHandler(textFrame, marker)
    textFrame:EnableMouse(true)

    if not isReused then textFrame.markerData = {} end
    textFrame.markerData.coord = marker.coord
    textFrame.markerData.offsetX = marker.offsetX
    textFrame.markerData.offsetY = marker.offsetY
    textFrame.markerData.cityScale = cityScale
    textFrame.markerData.text = marker.text
    textFrame.markerData.color = marker.color
    textFrame.markerData.customColor = marker.customColor
    textFrame.markerData.textA = marker.textA
    textFrame.markerData.isIcon = false
    return textFrame
end

function MapMarkers:CreateIconMarker(parent, marker, mapWidth, mapHeight, cityScale)
    cityScale = cityScale or 1.0
    local iconFrame = self:GetMarkerFromPool()
    local isReused = iconFrame ~= nil
    if not iconFrame then
        iconFrame = CreateFrame("Frame", nil, parent)
    else
        iconFrame:SetParent(parent)
    end
    iconFrame:SetFrameStrata(MARKER_FRAME_STRATA)
    iconFrame:SetFrameLevel(MARKER_FRAME_LEVEL)

    local x, y = self:GetXY(marker.coord)
    local reverseScale = self:GetMapScaleFactor()
    local finalIconSize = self:GetGlobalSize() * cityScale * 1.5 * reverseScale
    iconFrame:SetSize(finalIconSize, finalIconSize)

    if not iconFrame.texture then
        iconFrame.texture = iconFrame:CreateTexture(nil, "ARTWORK")
        iconFrame.texture:SetAllPoints()
    end
    iconFrame.texture:Show()
    iconFrame.texture:SetTexture(marker.icon or 134414)

    local c = cfg()
    local glowEnabled = c and c.mapMarkerIconGlow == "GLOW"
    if glowEnabled then
        if not iconFrame.Glow then
            local glow = iconFrame:CreateTexture(nil, "BACKGROUND", nil, -1)
            glow:SetAtlas(GLOW_ATLAS)
            glow:SetVertexColor(GLOW_COLOR.r, GLOW_COLOR.g, GLOW_COLOR.b, GLOW_COLOR.a)
            glow:SetBlendMode(GLOW_BLEND_MODE)
            iconFrame.Glow = glow
        end
        iconFrame.Glow:SetSize(finalIconSize * GLOW_SCALE, finalIconSize * GLOW_SCALE)
        iconFrame.Glow:SetPoint("CENTER", iconFrame.texture, "CENTER")
        iconFrame.Glow:Show()
    elseif iconFrame.Glow then
        iconFrame.Glow:Hide()
    end
    if iconFrame.fontString then iconFrame.fontString:Hide() end

    local posX = x * mapWidth
    local posY = -y * mapHeight
    local offsetX = (marker.offsetX or 0) * reverseScale
    local offsetY = (marker.offsetY or 0) * reverseScale

    iconFrame:ClearAllPoints()
    iconFrame:SetPoint("CENTER", parent, "TOPLEFT", posX + offsetX, posY + offsetY)

    self:AddMarkerTooltip(iconFrame, marker)
    self:AddMarkerClickHandler(iconFrame, marker)
    iconFrame:EnableMouse(true)

    if not isReused then iconFrame.markerData = {} end
    iconFrame.markerData.coord = marker.coord
    iconFrame.markerData.offsetX = marker.offsetX
    iconFrame.markerData.offsetY = marker.offsetY
    iconFrame.markerData.cityScale = cityScale
    iconFrame.markerData.icon = marker.icon
    iconFrame.markerData.isIcon = true
    return iconFrame
end

function MapMarkers:CreateMarker(parent, marker, mapWidth, mapHeight, cityScale)
    cityScale = cityScale or 1.0
    local c = cfg()
    local markerType = c and c.mapMarkerType or "TEXT"
    if self.markerPool.currentMarkerType and self.markerPool.currentMarkerType ~= markerType then
        self.markerPool.frames = {}
    end
    self.markerPool.currentMarkerType = markerType
    if markerType == "ICON" then
        if marker.icon then
            return self:CreateIconMarker(parent, marker, mapWidth, mapHeight, cityScale)
        end
        return nil
    end
    return self:CreateTextMarker(parent, marker, mapWidth, mapHeight, cityScale)
end

--------------------------------------------------------------------------------
-- 标记管理
--------------------------------------------------------------------------------
function MapMarkers:ClearAllMarkers()
    for _, mf in ipairs(self.activeMarkers) do
        if mf then self:ReturnMarkerToPool(mf) end
    end
    self.activeMarkers = {}
end

function MapMarkers:UpdateMarkerPositions()
    if #self.activeMarkers == 0 then return end
    local canvas = WorldMapFrame:GetCanvas()
    if not canvas then return end
    local mapWidth = canvas:GetWidth()
    local mapHeight = canvas:GetHeight()
    local reverseScale = self:GetMapScaleFactor()
    local c = cfg()

    for _, mf in ipairs(self.activeMarkers) do
        if mf and mf.markerData then
            local data = mf.markerData
            local x, y = self:GetXY(data.coord)
            local posX = x * mapWidth
            local posY = -y * mapHeight
            local offsetX = (data.offsetX or 0) * reverseScale
            local offsetY = (data.offsetY or 0) * reverseScale
            mf:ClearAllPoints()

            if data.isIcon then
                local finalIconSize = self:GetGlobalSize() * (data.cityScale or 1.0) * 1.4 * reverseScale
                mf:SetSize(finalIconSize, finalIconSize)
                mf:SetPoint("CENTER", canvas, "TOPLEFT", posX + offsetX, posY + offsetY)
                if mf.Glow and mf.Glow:IsShown() then
                    mf.Glow:SetSize(finalIconSize * GLOW_SCALE, finalIconSize * GLOW_SCALE)
                end
            else
                local finalTextSize = self:GetGlobalSize() * (data.cityScale or 1.0) * reverseScale
                local fontPath = GameFontNormal:GetFont()
                local outlineStyle = c and c.mapMarkerTextOutline or ""
                mf.fontString:SetFont(fontPath, finalTextSize, outlineStyle)
                mf.fontString:SetShadowOffset(0, 0)
                local textWidth = mf.fontString:GetStringWidth()
                local textHeight = mf.fontString:GetStringHeight()
                mf:SetSize(textWidth, textHeight)
                local textAnchor = data.textA or "CENTER"
                if textAnchor == "CENTER" then
                    mf:SetPoint("CENTER", canvas, "TOPLEFT", posX + offsetX, posY + offsetY)
                elseif textAnchor == "RIGHT" then
                    mf:SetPoint("LEFT", canvas, "TOPLEFT", posX - textWidth * COMPENSATION_FACTOR + offsetX,
                        posY + offsetY)
                elseif textAnchor == "LEFT" then
                    mf:SetPoint("RIGHT", canvas, "TOPLEFT", posX + textWidth * COMPENSATION_FACTOR + offsetX,
                        posY + offsetY)
                end
            end
        end
    end
end

function MapMarkers:UpdateMapMarkers(forceRecreate)
    local c = cfg()
    if not c then
        self:ClearAllMarkers(); return
    end
    if not WorldMapFrame or not WorldMapFrame:IsVisible() then
        self:ClearAllMarkers(); return
    end
    if not c.enableMapMarkers then
        self:ClearAllMarkers(); return
    end

    if not forceRecreate and #self.activeMarkers > 0 then
        local mapID = WorldMapFrame:GetMapID()
        local mapData = MARKER_DATABASE[mapID]
        local g = globalDB()
        local hasCustom = g and g.customMarkers and g.customMarkers[mapID] and #g.customMarkers[mapID] > 0
        if (mapData and self:ShouldShowByCity(mapData)) or hasCustom then
            self:UpdateMarkerPositions()
            return
        end
    end

    self:ClearAllMarkers()
    if not WorldMapFrame or not WorldMapFrame:IsShown() then return end

    local mapID = WorldMapFrame:GetMapID()
    if not mapID then return end

    local mapData = MARKER_DATABASE[mapID]
    local g = globalDB()
    local customList = g and g.customMarkers and g.customMarkers[mapID]
    local hasCustom = type(customList) == "table" and #customList > 0
    if not mapData and not hasCustom then return end

    if mapData and not self:ShouldShowByCity(mapData) then return end

    local cityScale = mapData and self:GetCityScale(mapData) or 1.0
    local markers = self:GetMarkers(mapData, mapID)
    local canvas = WorldMapFrame:GetCanvas()
    if not canvas then return end
    local mapWidth = canvas:GetWidth()
    local mapHeight = canvas:GetHeight()

    for _, marker in ipairs(markers) do
        if self:ShouldShowByProfession(marker) and self:ShouldShowByType(marker) then
            local mf = self:CreateMarker(canvas, marker, mapWidth, mapHeight, cityScale)
            if mf then table.insert(self.activeMarkers, mf) end
        end
    end
end

-- ========================================================================================================================
-- 快速添加弹窗
-- ========================================================================================================================
local quickAddFrame
local refreshCustomMarkerPanel

local function AddCustomMarkerAtPlayerPos(markerTitle, markerNote, markerColor)
    ensureCustomMarkerDB()
    local g = globalDB()
    local title = strtrim(markerTitle or "")
    if title == "" then
        return false, "请输入标题"
    end

    local mapID, x, y = GetCurrentPlayerMapCoord()
    if not mapID or not x or not y then
        return false, "无法获取当前坐标"
    end

    local note = strtrim(markerNote or "")
    addCustomMarker(mapID, encodeCoord(x, y), title, markerColor or g.customMarkerLastColor or DEFAULT_CUSTOM_COLOR, note)
    g.customMarkerLastColor = cloneColor(markerColor or g.customMarkerLastColor or DEFAULT_CUSTOM_COLOR)
    refreshMapMarkers()
    print(string.format("|cFF33FF99雨轩工具箱|r丨自定义\"%s\"添加成功", title))
    return true
end

local function ShowQuickAddPopup()
    ensureCustomMarkerDB()
    local g = globalDB()

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
        if quickAddFrame.TitleText then quickAddFrame.TitleText:SetText("快速添加坐标") end
        if quickAddFrame.Bg then quickAddFrame.Bg:SetVertexColor(0.08, 0.08, 0.10, 0.95) end
        if quickAddFrame.TitleBg then quickAddFrame.TitleBg:SetVertexColor(0.14, 0.22, 0.18, 0.95) end
        if quickAddFrame.NineSlice then
            quickAddFrame.NineSlice:SetBorderColor(0.20, 0.85, 0.62, 0.95)
        end
        if quickAddFrame.TitleText then
            quickAddFrame.TitleText:SetTextColor(0.20, 0.95, 0.70)
        end

        -- 创建一个覆盖整个标题栏的可拖动区域
        local dragRegion = CreateFrame("Frame", nil, quickAddFrame)
        dragRegion:SetPoint("TOPLEFT", quickAddFrame, "TOPLEFT", 0, 0)
        dragRegion:SetPoint("TOPRIGHT", quickAddFrame, "TOPRIGHT", -26, 0) -- 避开关闭按钮
        dragRegion:SetHeight(26)
        dragRegion:EnableMouse(true)
        dragRegion:RegisterForDrag("LeftButton")
        dragRegion:SetScript("OnDragStart", function() quickAddFrame:StartMoving() end)
        dragRegion:SetScript("OnDragStop", function() quickAddFrame:StopMovingOrSizing() end)

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

        quickAddFrame.color = cloneColor(g.customMarkerLastColor or DEFAULT_CUSTOM_COLOR)
        quickAddFrame.swatch = CreateFrame("Button", nil, quickAddFrame, "BackdropTemplate")
        quickAddFrame.swatch:SetSize(30, 18)
        quickAddFrame.swatch:SetPoint("LEFT", colorLabel, "RIGHT", 8, 0)
        quickAddFrame.swatch:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8X8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 12,
            insets = { left = 2, right = 2, top = 2, bottom = 2 },
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
        quickAddFrame.status:SetTextColor(0.55, 0.90, 1.00)

        local saveBtn = CreateFrame("Button", nil, quickAddFrame, "UIPanelButtonTemplate")
        saveBtn:SetSize(120, 24)
        saveBtn:SetPoint("BOTTOM", quickAddFrame, "BOTTOM", -64, 12)
        saveBtn:SetText("保存")

        local closeBtn = CreateFrame("Button", nil, quickAddFrame, "UIPanelButtonTemplate")
        closeBtn:SetSize(120, 24)
        closeBtn:SetPoint("LEFT", saveBtn, "RIGHT", 8, 0)
        closeBtn:SetText("关闭")
        closeBtn:SetScript("OnClick", function() quickAddFrame:Hide() end)

        saveBtn:SetScript("OnClick", function()
            local markerTitle = quickAddFrame.titleEdit:GetText() or ""
            local markerNote = quickAddFrame.noteEdit:GetText() or ""
            local ok, msg = AddCustomMarkerAtPlayerPos(markerTitle, markerNote, quickAddFrame.color)
            if ok then
                quickAddFrame.status:SetText("已保存")
                quickAddFrame:Hide()
            else
                quickAddFrame.status:SetText(msg or "保存失败")
            end
        end)
        refreshPopupColor()
    end

    quickAddFrame.titleEdit:SetText("")
    quickAddFrame.noteEdit:SetText("")
    quickAddFrame.status:SetText("")
    quickAddFrame:Show()
end

-- ========================================================================================================================
-- 快速坐标导航输入
-- ========================================================================================================================
local function ParseQuickCoordInput(text)
    local xStr, yStr = tostring(text or ""):match("^%s*([%d%.]+)[,%s]+([%d%.]+)%s*$")
    if not xStr or not yStr then return nil, nil end
    local x, y = tonumber(xStr), tonumber(yStr)
    if not x or not y then return nil, nil end
    if x > 1 or y > 1 then x, y = x / 100, y / 100 end
    if x < 0 or x > 1 or y < 0 or y > 1 then return nil, nil end
    return x, y
end

local function ApplyQuickWaypointFromInput(text)
    local mapID = WorldMapFrame and WorldMapFrame:GetMapID()
    if not mapID then
        return false, "当前地图不可用"
    end

    local x, y = ParseQuickCoordInput(text)
    if not x or not y then
        return false, "坐标格式错误，示例：12.34 56.78"
    end

    local waypoint = UiMapPoint.CreateFromCoordinates(mapID, x, y)
    if not waypoint then
        return false, "当前地图无法创建导航点"
    end

    C_Map.SetUserWaypoint(waypoint)
    if C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then
        C_SuperTrack.SetSuperTrackedUserWaypoint(true)
    end

    print(string.format("|cFF33FF99雨轩工具箱|r丨已设置导航点：%.2f %.2f", x * 100, y * 100))
    return true
end

local function InitializeQuickWaypointInput()
    if quickWaypointInput or not WorldMapFrame then return end

    quickWaypointHolder = CreateFrame("Frame", nil, WorldMapFrame, "BackdropTemplate")
    quickWaypointHolder:SetHeight(30)
    quickWaypointHolder:SetPoint("TOPLEFT", WorldMapFrame, "BOTTOMLEFT", 0, -2)
    quickWaypointHolder:SetPoint("TOPRIGHT", WorldMapFrame, "BOTTOMRIGHT", 0, -2)
    quickWaypointHolder:SetFrameStrata("HIGH")
    quickWaypointHolder:SetFrameLevel(3600)
    quickWaypointHolder:Hide()

    quickWaypointHolder:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    quickWaypointHolder:SetBackdropColor(0.08, 0.08, 0.09, 0.98)
    quickWaypointHolder:SetBackdropBorderColor(0.32, 0.32, 0.36, 1)

    quickWaypointHolder.playerText = quickWaypointHolder:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    quickWaypointHolder.playerText:SetPoint("LEFT", quickWaypointHolder, "LEFT", 12, 0)
    quickWaypointHolder.playerText:SetJustifyH("LEFT")
    quickWaypointHolder.playerText:SetTextColor(0.95, 0.82, 0.18)
    quickWaypointHolder.playerText:SetText("玩家: --")

    quickWaypointHolder.cursorText = quickWaypointHolder:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    quickWaypointHolder.cursorText:SetPoint("LEFT", quickWaypointHolder.playerText, "RIGHT", 18, 0)
    quickWaypointHolder.cursorText:SetJustifyH("LEFT")
    quickWaypointHolder.cursorText:SetTextColor(0.82, 0.88, 0.95)
    quickWaypointHolder.cursorText:SetText("鼠标: --")

    quickWaypointInput = CreateFrame("EditBox", nil, quickWaypointHolder, "InputBoxTemplate")
    quickWaypointInput:SetSize(150, 20)
    quickWaypointInput:SetPoint("RIGHT", quickWaypointHolder, "RIGHT", -72, 0)
    quickWaypointInput:SetAutoFocus(false)
    quickWaypointInput:SetMaxLetters(32)
    quickWaypointInput:SetTextInsets(6, 6, 0, 0)
    quickWaypointInput:SetFontObject(GameFontHighlightSmall)
    quickWaypointInput.cursorOffset = 0

    quickWaypointInput.hint = quickWaypointInput:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
    quickWaypointInput.hint:SetPoint("LEFT", quickWaypointInput, "LEFT", 8, 0)
    quickWaypointInput.hint:SetText("坐标: 12.34 56.78")

    quickWaypointButton = CreateFrame("Button", nil, quickWaypointHolder, "UIPanelButtonTemplate")
    quickWaypointButton:SetSize(56, 20)
    quickWaypointButton:SetPoint("LEFT", quickWaypointInput, "RIGHT", 8, 0)
    quickWaypointButton:SetText("导航")
    quickWaypointButton:SetScript("OnClick", function()
        local ok, err = ApplyQuickWaypointFromInput(quickWaypointInput:GetText())
        if ok then
            quickWaypointInput:ClearFocus()
        elseif err then
            print("|cFF33FF99雨轩工具箱|r丨" .. err)
        end
    end)

    quickWaypointExtraArea = CreateFrame("Frame", nil, quickWaypointHolder)
    quickWaypointExtraArea:SetPoint("LEFT", quickWaypointHolder.cursorText, "RIGHT", 18, 0)
    quickWaypointExtraArea:SetPoint("RIGHT", quickWaypointInput, "LEFT", -10, 0)
    quickWaypointExtraArea:SetHeight(20)

    quickWaypointInput:SetScript("OnTextChanged", function(self)
        self.hint:SetShown(not self:GetText() or self:GetText() == "")
    end)
    quickWaypointInput:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    quickWaypointInput:SetScript("OnEditFocusGained", function(self)
        if self.cursorOffset == nil then self.cursorOffset = 0 end
    end)
    quickWaypointInput:SetScript("OnEnterPressed", function(self)
        local ok, err = ApplyQuickWaypointFromInput(self:GetText())
        if not ok and err then
            print("|cFF33FF99雨轩工具箱|r丨" .. err)
            return
        end
        self:ClearFocus()
    end)

    local elapsed = 0
    quickWaypointHolder:SetScript("OnUpdate", function(self, dt)
        elapsed = elapsed + dt
        if elapsed < 0.05 then return end
        elapsed = 0

        if not WorldMapFrame or not WorldMapFrame:IsShown() then
            return
        end

        local mapID = WorldMapFrame:GetMapID()
        if mapID then
            local pos = C_Map.GetPlayerMapPosition(mapID, "player")
            if pos then
                self.playerText:SetText(string.format("玩家: %.2f, %.2f", pos.x * 100, pos.y * 100))
            else
                self.playerText:SetText("玩家: --")
            end
        else
            self.playerText:SetText("玩家: --")
        end

        if WorldMapFrame.ScrollContainer and WorldMapFrame.ScrollContainer:IsMouseOver() then
            local cursorX, cursorY = WorldMapFrame.ScrollContainer:GetNormalizedCursorPosition()
            if cursorX and cursorY and cursorX >= 0 and cursorX <= 1 and cursorY >= 0 and cursorY <= 1 then
                self.cursorText:SetText(string.format("鼠标: %.2f, %.2f", cursorX * 100, cursorY * 100))
            else
                self.cursorText:SetText("鼠标: --")
            end
        else
            self.cursorText:SetText("鼠标: --")
        end
    end)
end

-- ========================================================================================================================
-- 坐标显示
-- ========================================================================================================================
local coordFrame

local function CreateCoordDisplay()
    InitializeQuickWaypointInput()
    coordFrame = quickWaypointHolder
end

local function ToggleCoordDisplay()
    local c = cfg()
    if not c then return end
    if c.enableCoordDisplay then
        CreateCoordDisplay()
        if coordFrame and WorldMapFrame and WorldMapFrame:IsVisible() then
            coordFrame:Show()
        end
    else
        if coordFrame then
            coordFrame:Hide()
        end
    end
end

-- ========================================================================================================================
-- 初始化和事件
-- ========================================================================================================================
local mapMarkerHooked = false

local function InitializeMapMarkers()
    if mapMarkerHooked then return end
    if not WorldMapFrame then return false end
    mapMarkerHooked = true

    WorldMapFrame:HookScript("OnShow", function()
        MapMarkers:UpdateMapMarkers(true)
        ToggleCoordDisplay()
    end)
    WorldMapFrame:HookScript("OnHide", function()
        MapMarkers:ClearAllMarkers()
        if MapMarkers.poolConfig.cleanupOnHide then MapMarkers:CleanupObjectPool() end
    end)
    hooksecurefunc(WorldMapFrame, "OnMapChanged", function()
        MapMarkers:UpdateMapMarkers(true)
    end)
    if WorldMapFrame.ScrollContainer then
        hooksecurefunc(WorldMapFrame.ScrollContainer, "ZoomIn", function()
            MapMarkers:UpdateMapMarkers(false)
        end)
        hooksecurefunc(WorldMapFrame.ScrollContainer, "ZoomOut", function()
            MapMarkers:UpdateMapMarkers(false)
        end)
    end

    MapMarkers:InitializeProfessions()
    InitializeQuickWaypointInput()
    return true
end

local mapGuideInitWaiter
local function EnsureMapGuideInitializedWhenWorldMapReady()
    if mapMarkerHooked then return end
    if InitializeMapMarkers() then
        if mapGuideInitWaiter then
            mapGuideInitWaiter:UnregisterAllEvents()
            mapGuideInitWaiter:SetScript("OnEvent", nil)
            mapGuideInitWaiter = nil
        end
        return
    end

    if mapGuideInitWaiter then return end
    mapGuideInitWaiter = CreateFrame("Frame")
    mapGuideInitWaiter:RegisterEvent("ADDON_LOADED")
    mapGuideInitWaiter:RegisterEvent("PLAYER_ENTERING_WORLD")
    mapGuideInitWaiter:SetScript("OnEvent", function(_, event, arg1)
        if event == "ADDON_LOADED" and arg1 ~= "Blizzard_WorldMap" then
            return
        end
        if InitializeMapMarkers() then
            mapGuideInitWaiter:UnregisterAllEvents()
            mapGuideInitWaiter:SetScript("OnEvent", nil)
            mapGuideInitWaiter = nil
        end
    end)
end

-- ========================================================================================================================
-- 旧数据迁移
-- ========================================================================================================================
local function MigrateOldRoyMapGuideDB()
    local old = _G["RoyMapGuideDB"]
    if not old or type(old) ~= "table" then return end
    if Core.db.global._mapGuideMigrated then return end

    -- 迁移自定义标记到 global
    if old.customMarkers and type(old.customMarkers) == "table" then
        ensureCustomMarkerDB()
        local g = globalDB()
        for mapID, list in pairs(old.customMarkers) do
            if type(list) == "table" then
                g.customMarkers[mapID] = g.customMarkers[mapID] or {}
                for _, marker in ipairs(list) do
                    table.insert(g.customMarkers[mapID], marker)
                end
            end
        end
    end
    if old.customMarkerLastColor then
        Core.db.global.customMarkerLastColor = cloneColor(old.customMarkerLastColor)
    end

    -- 迁移设置到 profile.mapGuide
    local settingKeys = {
        "enableMapMarkers", "globalMarkerSize", "mapMarkerType", "mapMarkerTextOutline",
        "mapMarkerIconGlow", "mapMarkerTooltips", "mapMarkerProfessionFilter",
        "mapMarkersPortal", "mapMarkersInn", "mapMarkersOfficial", "mapMarkersProfession",
        "mapMarkersService", "mapMarkersStable", "mapMarkersCollection", "mapMarkersVendor",
        "mapMarkersUnique", "mapMarkersSpecial", "mapMarkersQuartermaster", "mapMarkersPvp",
        "mapMarkersInstance", "mapMarkersDelve",
    }
    local c = cfg()
    for _, key in ipairs(settingKeys) do
        if old[key] ~= nil then c[key] = old[key] end
    end

    -- 迁移城市show/scale
    local groups = {
        "Stormwind", "Ironforge", "Darnassus", "Exodar", "Gilneas", "Stormshield",
        "Boralus", "Belamath", "Orgrimmar", "ThunderBluff", "Undercity", "Warspear",
        "Dazaralor", "Shattrath", "DalaranNorthrend", "DalaranLegion", "Oribos",
        "SanctumofDomination", "Sinfall", "HeartoftheForest", "ElysianHold", "Valdrakken",
        "Dornogal", "CityofThreads", "Undermine", "Tazavesh", "SilvermoonCityMidnight",
        "Darkmoonfaire", "IsleofDorn", "TheRingingDeeps", "Hallowfall", "AzjKahet",
        "KAresh", "EversongWoods", "Voidstorm", "IsleofQuelDanas", "ZulAman", "Harandar",
    }
    for _, grp in ipairs(groups) do
        local showKey = "show" .. grp
        local scaleKey = "scale" .. grp
        if old[showKey] ~= nil then c[showKey] = old[showKey] end
        if old[scaleKey] ~= nil then c[scaleKey] = old[scaleKey] end
    end

    Core.db.global._mapGuideMigrated = true
    print("|cFF33FF99雨轩工具箱|r丨已从 RoyMapGuideEx 迁移地图标记数据")
end

-- ========================================================================================================================
-- Core 方法注入
-- ========================================================================================================================
function Core:ToggleMapMarkers()
    local c = cfg()
    if c and c.enableMapMarkers then
        MapMarkers:UpdateMapMarkers(true)
    else
        MapMarkers:ClearAllMarkers()
    end
end

function Core:ToggleCoordDisplay()
    ToggleCoordDisplay()
    if self.UpdateEventTrackers then
        self:UpdateEventTrackers()
    end
end

function Core:GetCoordDisplayFrame()
    return coordFrame
end

function Core:ShowQuickAddPopup()
    ShowQuickAddPopup()
end

function Core:AddMapGuideCustomMarkerAtPlayerPos(title, note, color)
    return AddCustomMarkerAtPlayerPos(title, note, color)
end

function Core:GetMapGuideCustomMarkerList()
    ensureCustomMarkerDB()
    local g = globalDB()
    local rows, ids = {}, {}

    for mapID in pairs(g.customMarkers or {}) do
        if tonumber(mapID) then
            table.insert(ids, tonumber(mapID))
        end
    end
    table.sort(ids)

    for _, mapID in ipairs(ids) do
        local list = g.customMarkers[mapID]
        if type(list) == "table" then
            for idx, marker in ipairs(list) do
                if marker and marker.coord and marker.title then
                    local x, y = decodeCoord(marker.coord)
                    local color = getMarkerCustomColor(marker)
                    table.insert(rows, {
                        mapID = mapID,
                        index = idx,
                        title = marker.title or "",
                        note = marker.note or "",
                        x = x,
                        y = y,
                        mapName = getMapNameByID(mapID),
                        colorHex = toHexColorString(color),
                    })
                end
            end
        end
    end

    return rows
end

function Core:RemoveMapGuideCustomMarker(mapID, index)
    local ok = removeCustomMarker(mapID, index)
    if ok then
        refreshMapMarkers()
    end
    return ok
end

function Core:ExportMapGuideCustomMarkers()
    return exportCustomMarkers()
end

function Core:ImportMapGuideCustomMarkers(text)
    local count = importCustomMarkers(text)
    if count > 0 then
        refreshMapMarkers()
    end
    return count
end

function Core:InitializeMapGuide()
    MigrateOldRoyMapGuideDB()
    EnsureMapGuideInitializedWhenWorldMapReady()
end

function Core:GetMapGuideTopBarExtraArea()
    return quickWaypointExtraArea
end

-- 注册 /yxpin 斜杠命令
SLASH_YuXuanPin1 = "/yxpin"
SlashCmdList["YuXuanPin"] = function()
    ShowQuickAddPopup()
end

-- 暴露给 Options.lua
ns.ShowQuickAddPopup = ShowQuickAddPopup
