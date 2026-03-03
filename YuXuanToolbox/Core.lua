local addonName, ns = ...

local DB_NAME = "YuXuanToolboxDB"

---@class QuickChatColor
---@field r number
---@field g number
---@field b number

---@class QuickChatBarPoint
---@field point string
---@field relativePoint string
---@field x number
---@field y number

---@class QuickChatCustomButton
---@field id number
---@field label string
---@field command string

---@class QuickChatConfig
---@field enabled boolean
---@field unlocked boolean
---@field spacing number
---@field fontSize number
---@field font string
---@field worldChannelName string
---@field barPoint QuickChatBarPoint
---@field buttonColors table<string, QuickChatColor>
---@field customButtons QuickChatCustomButton[]
---@field nextCustomId number
---@field buttonOrder string[]
---@field selectedButtonKey string

---@class YuXuanToolboxDB
---@field quickChat QuickChatConfig

ns = ns or {}

local Core = {
    NAME = addonName,
    DB_NAME = DB_NAME,
    VERSION = "0.0.1",

    ---@type YuXuanToolboxDB
    db = nil,

    eventFrame = CreateFrame("Frame"),
    barFrame = nil,
    settingsFrame = nil,
    quickChatButtons = {},
    tabButtons = {},
    contentPanels = {},
    quickChatDefs = {},
    ui = {},
}

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
        SAY = { r = 1.00, g = 1.00, b = 1.00 },
        YELL = { r = 1.00, g = 0.25, b = 0.25 },
        PARTY = { r = 0.66, g = 0.66, b = 1.00 },
        INSTANCE_CHAT = { r = 1.00, g = 0.50, b = 0.20 },
        RAID = { r = 1.00, g = 0.50, b = 0.00 },
        GUILD = { r = 0.25, g = 1.00, b = 0.25 },
        WORLD = { r = 0.30, g = 0.95, b = 1.00 },
        DICE = { r = 1.00, g = 0.82, b = 0.00 },
    },
}

Core.CONSTANTS.BUILTIN_LOOKUP = {}
Core.CONSTANTS.DEFAULT_ORDER = {}
for _, def in ipairs(Core.CONSTANTS.BUILTIN_BUTTONS) do
    Core.CONSTANTS.BUILTIN_LOOKUP[def.key] = def
    table.insert(Core.CONSTANTS.DEFAULT_ORDER, def.key)
end

Core.DEFAULTS = {
    quickChat = {
        enabled = true,
        unlocked = false,
        spacing = 10,
        fontSize = 14,
        font = "Fonts\\FRIZQT__.TTF",
        worldChannelName = "大脚世界频道",
        barPoint = {
            point = "CENTER",
            relativePoint = "CENTER",
            x = 0,
            y = -180,
        },
        buttonColors = {},
        customButtons = {},
        nextCustomId = 1,
        buttonOrder = {},
        selectedButtonKey = "SAY",
    },
}

Core.util = {}

function Core.util.deepCopy(dst, src)
    for k, v in pairs(src) do
        if type(v) == "table" then
            dst[k] = dst[k] or {}
            Core.util.deepCopy(dst[k], v)
        elseif dst[k] == nil then
            dst[k] = v
        end
    end
end

function Core.util.trim(str)
    return (tostring(str or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

function Core.util.clampColor(v)
    v = tonumber(v) or 0
    if v < 0 then return 0 end
    if v > 1 then return 1 end
    return v
end

function Core.util.cloneColor(c)
    return {
        r = Core.util.clampColor(c and c.r or 1),
        g = Core.util.clampColor(c and c.g or 1),
        b = Core.util.clampColor(c and c.b or 1),
    }
end

function Core.util.tableContains(t, value)
    for _, v in ipairs(t) do
        if v == value then return true end
    end
    return false
end

function Core.util.tableIndexOf(t, value)
    for i, v in ipairs(t) do
        if v == value then return i end
    end
    return nil
end

function Core.util.tableRemoveValue(t, value)
    for i = #t, 1, -1 do
        if t[i] == value then
            table.remove(t, i)
            return true
        end
    end
    return false
end

function Core:OpenChatWithSlash(slashText)
    if not ChatFrame_OpenChat then return end
    ChatFrame_OpenChat(slashText or "", DEFAULT_CHAT_FRAME)
end

function Core:EnsureDB()
    if type(_G[self.DB_NAME]) ~= "table" then
        _G[self.DB_NAME] = {}
    end

    Core.util.deepCopy(_G[self.DB_NAME], self.DEFAULTS)
    self.db = _G[self.DB_NAME]

    local cfg = self.db.quickChat
    cfg.buttonColors = cfg.buttonColors or {}
    cfg.customButtons = cfg.customButtons or {}
    cfg.buttonOrder = cfg.buttonOrder or {}
    cfg.worldChannelName = cfg.worldChannelName or "大脚世界频道"

    if #cfg.buttonOrder == 0 then
        for _, key in ipairs(self.CONSTANTS.DEFAULT_ORDER) do
            table.insert(cfg.buttonOrder, key)
        end
        for _, custom in ipairs(cfg.customButtons) do
            local key = "CUSTOM_" .. tostring(custom.id)
            if not Core.util.tableContains(cfg.buttonOrder, key) then
                table.insert(cfg.buttonOrder, key)
            end
        end
    end

    for _, def in ipairs(self.CONSTANTS.BUILTIN_BUTTONS) do
        if not cfg.buttonColors[def.key] then
            cfg.buttonColors[def.key] = Core.util.cloneColor(self.CONSTANTS.DEFAULT_BUTTON_COLORS[def.key] or
                { r = 1, g = 1, b = 1 })
        end
    end

    for _, custom in ipairs(cfg.customButtons) do
        custom.id = tonumber(custom.id) or 0
        custom.label = Core.util.trim(custom.label)
        custom.command = Core.util.trim(custom.command)
        local key = "CUSTOM_" .. tostring(custom.id)
        cfg.buttonColors[key] = cfg.buttonColors[key] or Core.util.cloneColor({ r = 1, g = 0.82, b = 0 })
    end

    cfg.nextCustomId = tonumber(cfg.nextCustomId) or 1
    cfg.selectedButtonKey = tostring(cfg.selectedButtonKey or "SAY")
end

function Core:GetAllButtonDefs()
    local defs = {}
    local cfg = self.db.quickChat

    for _, key in ipairs(cfg.buttonOrder) do
        if self.CONSTANTS.BUILTIN_LOOKUP[key] then
            table.insert(defs, self.CONSTANTS.BUILTIN_LOOKUP[key])
        else
            for _, custom in ipairs(cfg.customButtons) do
                local ckey = "CUSTOM_" .. tostring(custom.id)
                if ckey == key then
                    local label = Core.util.trim(custom.label)
                    if label ~= "" then
                        table.insert(defs, {
                            key = ckey,
                            label = label,
                            action = "custom",
                            command = Core.util.trim(custom.command),
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
    local colors = self.db.quickChat.buttonColors
    if not colors[key] then
        colors[key] = Core.util.cloneColor({ r = 1, g = 1, b = 1 })
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
    for i, custom in ipairs(self.db.quickChat.customButtons) do
        if tonumber(custom.id) == id then
            return custom, i
        end
    end
    return nil, nil
end

function Core:RegisterSlashCommands()
    SLASH_YuXuanToolbox1 = "/yx"
    SlashCmdList["YuXuanToolbox"] = function()
        self:ToggleSettingsWindow()
    end
end

function Core:PrintWelcome()
    print("|cFF33FF99雨轩工具箱|r：|cFFFFD700欢迎使用|r |cFF00FFFFv" ..
        self.VERSION .. "|r |cFFAAAAAA输入|r |cFFFFFF00/yx|r |cFFAAAAAA打开设置窗口|r")
end

function Core:Initialize()
    self:EnsureDB()
    self:CreateQuickChatBar()
    self:RegisterSlashCommands()
end

ns.Core = Core

Core.eventFrame:RegisterEvent("ADDON_LOADED")
Core.eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
Core.eventFrame:SetScript("OnEvent", function(_, event, arg1, arg2)
    if event == "ADDON_LOADED" and arg1 == addonName then
        Core:Initialize()
    elseif event == "PLAYER_ENTERING_WORLD" then
        local isInitialLogin = arg1
        local isReloadingUi = arg2
        if isInitialLogin or isReloadingUi then
            Core:PrintWelcome()
        end
    end
end)
