local addonName, ns = ...
local Core = ns.Core
local util = ns.util
local LibSharedMedia = LibStub("LibSharedMedia-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

local S = ns.OptionsShared
local QC = S.QC

local function BuildButtonListArgs(refreshButtonManagement)
    local args = {}
    local cfg = QC()
    local defs = Core:GetAllButtonDefs()

    for idx, def in ipairs(defs) do
        local key = def.key
        local isCustom = (def.action == "custom")
        local prefix = isCustom and "|cFFFF9900[自定义]|r " or "|cFF88BBEE[内置]|r "

        args["btn_" .. key] = {
            type = "group",
            name = prefix .. def.label,
            order = idx,
            args = {
                color = {
                    type = "color",
                    name = "颜色",
                    order = 1,
                    hasAlpha = false,
                    width = 0.5,
                    get = function()
                        local c = Core:GetColorForKey(key)
                        return c.r, c.g, c.b
                    end,
                    set = function(_, r, g, b)
                        local c = Core:GetColorForKey(key)
                        c.r, c.g, c.b = r, g, b
                        Core:LayoutQuickChatButtons()
                    end,
                },
                moveUp = {
                    type = "execute",
                    name = "▲上移",
                    order = 2,
                    width = 0.5,
                    disabled = function()
                        return util.tableIndexOf(cfg.buttonOrder, key) == 1
                    end,
                    func = function()
                        local order = cfg.buttonOrder
                        local i = util.tableIndexOf(order, key)
                        if i and i > 1 then
                            order[i], order[i - 1] = order[i - 1], order[i]
                            Core:UpdateQuickChatBar()
                            if refreshButtonManagement then refreshButtonManagement() end
                        end
                    end,
                },
                moveDown = {
                    type = "execute",
                    name = "▼下移",
                    order = 3,
                    width = 0.5,
                    disabled = function()
                        return util.tableIndexOf(cfg.buttonOrder, key) == #cfg.buttonOrder
                    end,
                    func = function()
                        local order = cfg.buttonOrder
                        local i = util.tableIndexOf(order, key)
                        if i and i < #order then
                            order[i], order[i + 1] = order[i + 1], order[i]
                            Core:UpdateQuickChatBar()
                            if refreshButtonManagement then refreshButtonManagement() end
                        end
                    end,
                },
                delete = {
                    type = "execute",
                    name = "删除",
                    order = 4,
                    width = 0.5,
                    confirm = true,
                    confirmText = "确定要删除按钮 [" .. def.label .. "] 吗？",
                    func = function()
                        util.tableRemoveValue(cfg.buttonOrder, key)
                        if isCustom then
                            local _, cIdx = Core:GetCustomByKey(key)
                            if cIdx then table.remove(cfg.customButtons, cIdx) end
                            cfg.buttonColors[key] = nil
                        end
                        Core:UpdateQuickChatBar()
                        if refreshButtonManagement then refreshButtonManagement() end
                    end,
                },
            },
        }

        if isCustom then
            args["btn_" .. key].args.editLabel = {
                type = "input",
                name = "按钮文字",
                order = 10,
                width = 0.8,
                get = function()
                    local c = Core:GetCustomByKey(key)
                    return c and c.label or ""
                end,
                set = function(_, val)
                    local c = Core:GetCustomByKey(key)
                    if c then
                        c.label = util.trim(val)
                        Core:UpdateQuickChatBar()
                        if refreshButtonManagement then refreshButtonManagement() end
                    end
                end,
            }
            args["btn_" .. key].args.editCmd = {
                type = "input",
                name = "指令",
                order = 11,
                width = 1.0,
                get = function()
                    local c = Core:GetCustomByKey(key)
                    return c and c.command or ""
                end,
                set = function(_, val)
                    local c = Core:GetCustomByKey(key)
                    if c then
                        c.command = util.trim(val)
                        Core:UpdateQuickChatBar()
                        if refreshButtonManagement then refreshButtonManagement() end
                    end
                end,
            }
        end
    end

    return args
end

function ns.BuildQuickChatOptions()
    local newBtnLabel = ""
    local newBtnCmd = ""
    local group

    local function RefreshButtonManagement()
        if not group or not group.args or not group.args.buttonManagement then return end
        group.args.buttonManagement.args = BuildButtonListArgs(RefreshButtonManagement)
        AceConfigRegistry:NotifyChange(addonName or "YuXuanToolbox")
    end

    group = {
        type = "group",
        name = "快捷频道",
        order = 10,
        childGroups = "tab",
        args = {
            basic = {
                type = "group",
                name = "基础设置",
                order = 1,
                args = {
                    enabled = {
                        type = "toggle",
                        name = "启用快捷条",
                        order = 1,
                        get = function() return QC().enabled end,
                        set = function(_, val)
                            QC().enabled = val; Core:UpdateQuickChatBar()
                        end,
                    },
                    unlocked = {
                        type = "toggle",
                        name = function() return S.GetUnlockLayoutToggleName(QC().unlocked) end,
                        order = 2,
                        get = function() return QC().unlocked end,
                        set = function(_, val)
                            QC().unlocked = val; Core:UpdateQuickChatBarDraggable()
                        end,
                    },
                    worldChannelName = {
                        type = "input",
                        name = "世界频道名称",
                        order = 3,
                        width = 1.2,
                        get = function() return QC().worldChannelName end,
                        set = function(_, val)
                            local name = util.trim(val)
                            if name == "" then name = "大脚世界频道" end
                            QC().worldChannelName = name
                        end,
                    },
                    spacing = {
                        type = "range",
                        name = "按钮间隔",
                        order = 10,
                        min = 0,
                        max = 30,
                        step = 1,
                        get = function() return QC().spacing end,
                        set = function(_, val)
                            QC().spacing = val; Core:LayoutQuickChatButtons()
                        end,
                    },
                    fontSize = {
                        type = "range",
                        name = "文字大小",
                        order = 11,
                        min = 10,
                        max = 32,
                        step = 1,
                        get = function() return QC().fontSize end,
                        set = function(_, val)
                            QC().fontSize = val; Core:LayoutQuickChatButtons()
                        end,
                    },
                    font = {
                        type = "select",
                        name = "字体",
                        order = 12,
                        dialogControl = "LSM30_Font",
                        values = LibSharedMedia:HashTable("font"),
                        get = function() return QC().font end,
                        set = function(_, val)
                            QC().font = val; Core:LayoutQuickChatButtons()
                        end,
                    },
                },
            },
            buttonManagement = {
                type = "group",
                name = "按钮管理",
                order = 2,
                childGroups = "tree",
                args = {},
            },
            addCustom = {
                type = "group",
                name = "添加自定义按钮",
                order = 3,
                args = {
                    newLabel = {
                        type = "input",
                        name = "按钮文字",
                        order = 1,
                        width = 0.8,
                        get = function() return newBtnLabel end,
                        set = function(_, val) newBtnLabel = val end,
                    },
                    newCmd = {
                        type = "input",
                        name = "指令",
                        order = 2,
                        width = 1.0,
                        get = function() return newBtnCmd end,
                        set = function(_, val) newBtnCmd = val end,
                    },
                    addBtn = {
                        type = "execute",
                        name = "添加",
                        order = 3,
                        func = function()
                            local label = util.trim(newBtnLabel)
                            local cmd = util.trim(newBtnCmd)
                            if label == "" then
                                print("|cFF33FF99雨轩工具箱|r丨请填写按钮文字"); return
                            end
                            if cmd == "" then
                                print("|cFF33FF99雨轩工具箱|r丨请填写指令"); return
                            end
                            local cfg = QC()
                            local id = cfg.nextCustomId
                            cfg.nextCustomId = id + 1
                            table.insert(cfg.customButtons, { id = id, label = label, command = cmd })
                            local key = "CUSTOM_" .. tostring(id)
                            cfg.buttonColors[key] = util.cloneColor({ r = 1, g = 0.82, b = 0 })
                            table.insert(cfg.buttonOrder, key)
                            newBtnLabel = ""
                            newBtnCmd = ""
                            Core:UpdateQuickChatBar()
                            RefreshButtonManagement()
                        end,
                    },
                    restoreBuiltin = {
                        type = "execute",
                        name = "恢复内置按钮",
                        order = 4,
                        func = function()
                            local cfg = QC()
                            local order = cfg.buttonOrder
                            local insertPos, restored = 0, 0
                            for i, key in ipairs(order) do
                                if Core.CONSTANTS.BUILTIN_LOOKUP[key] then insertPos = i end
                            end
                            for _, def in ipairs(Core.CONSTANTS.BUILTIN_BUTTONS) do
                                if not util.tableContains(order, def.key) then
                                    insertPos = insertPos + 1
                                    table.insert(order, insertPos, def.key)
                                    if not cfg.buttonColors[def.key] then
                                        cfg.buttonColors[def.key] = util.cloneColor(
                                            Core.CONSTANTS.DEFAULT_BUTTON_COLORS[def.key] or { r = 1, g = 1, b = 1 }
                                        )
                                    end
                                    restored = restored + 1
                                end
                            end
                            if restored > 0 then
                                print("|cFF33FF99雨轩工具箱|r丨已恢复 " .. restored .. " 个内置按钮")
                            else
                                print("|cFF33FF99雨轩工具箱|r丨所有内置按钮已存在")
                            end
                            Core:UpdateQuickChatBar()
                            RefreshButtonManagement()
                        end,
                    },
                },
            },
        },
    }

    RefreshButtonManagement()

    return group
end
