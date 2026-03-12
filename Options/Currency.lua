---@diagnostic disable: undefined-global, undefined-field, inject-field
local addonName, ns = ...
local Core = ns.Core
local LibSharedMedia = LibStub("LibSharedMedia-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

local S = ns.OptionsShared
local CU = S.CUcfg

local function EnsureSelected()
    local cfg = CU()
    cfg.selected = cfg.selected or {}
    return cfg.selected
end

local function NotifyChanged()
    AceConfigRegistry:NotifyChange(addonName or "YuXuanToolbox")
end

local function SafeGetCurrencyInfo(cid)
    if C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo then
        return C_CurrencyInfo.GetCurrencyInfo(cid)
    end
    return nil
end

local function BuildHeaderMultiselect(headerName, sortOrder, refreshOrder)
    return {
        type = "multiselect",
        name = headerName,
        width = "full",
        order = sortOrder,
        values = function()
            return Core:GetAvailableCurrencyValuesByHeader(headerName)
        end,
        get = function(_, key)
            local id = tonumber(key)
            if not id then
                return false
            end
            return EnsureSelected()[id] == true
        end,
        set = function(_, key, val)
            local id = tonumber(key)
            if not id then
                return
            end
            EnsureSelected()[id] = val and true or nil
            Core:UpdateCurrencyDisplay()
            if refreshOrder then
                refreshOrder()
            end
        end,
    }
end
local function BuildOrderArgs(refreshOrder)
    local args = {}
    local order = Core:GetOrderedSelectedCurrencyIDs()

    if #order == 0 then
        args.empty = {
            type = "description",
            name = "|cFF888888" .. "当前未勾选任何货币，请先在货币类型中勾选。" .. "|r",
            order = 1,
            width = "full",
            fontSize = "medium",
        }
        return args
    end

    args.tip = {
        type = "description",
        name = "|cFFFFCC00" .. "已选货币列表" .. "|r",
        order = 1,
        width = "full",
        fontSize = "medium",
    }
    args.sep = {
        type = "header",
        name = "",
        order = 2,
    }

    for idx, currencyID in ipairs(order) do
        local info = SafeGetCurrencyInfo(currencyID)
        local cname = "ID " .. tostring(currencyID)
        if info and info.name then
            cname = info.name
        end
        local header = Core:GetCurrencyHeaderForID(currencyID)
        local rowOrder = 10 + idx

        local capturedIdx = idx
        local totalCount = #order
        local rowKey = "ord_" .. tostring(currencyID)
        local rowLabel = "|cFF88BBEE" .. tostring(idx) .. ".|r " .. cname .. "  |cFF666666(" .. header .. ")|r"

        args[rowKey] = {
            type = "group",
            name = rowLabel,
            order = rowOrder,
            args = {
                up = {
                    type = "execute",
                    name = "▲ 上移",
                    order = 1,
                    width = 0.55,
                    disabled = function() return capturedIdx == 1 end,
                    func = function()
                        if Core:MoveCurrencyOrder(currencyID, -1) then
                            Core:UpdateCurrencyDisplay()
                            if refreshOrder then
                                refreshOrder()
                            end
                        end
                    end,
                },
                down = {
                    type = "execute",
                    name = "▼ 下移",
                    order = 2,
                    width = 0.55,
                    disabled = function() return capturedIdx == totalCount end,
                    func = function()
                        if Core:MoveCurrencyOrder(currencyID, 1) then
                            Core:UpdateCurrencyDisplay()
                            if refreshOrder then
                                refreshOrder()
                            end
                        end
                    end,
                },
                remove = {
                    type = "execute",
                    name = "移除",
                    order = 3,
                    width = 0.55,
                    func = function()
                        EnsureSelected()[currencyID] = nil
                        Core:UpdateCurrencyDisplay()
                        if refreshOrder then
                            refreshOrder()
                        end
                    end,
                },
            },
        }
    end

    return args
end
function ns.BuildCurrencyOptions()
    local group

    local function RefreshOrderGroup()
        if not group then return end
        if not group.args then return end
        if not group.args.ordering then return end
        group.args.ordering.args = BuildOrderArgs(RefreshOrderGroup)
        NotifyChanged()
    end

    local function RefreshCurrencyTabs()
        if not group then return end
        if not group.args then return end
        if not group.args.currencyList then return end

        Core:RefreshCurrencyCatalog()
        local headers = Core:GetCurrencyHeaderList()

        local listArgs = {
            tips = {
                type = "description",
                name = "|cFFFFCC00" .. "勾选要展示的货币" .. "|r",
                order = 1,
                width = "full",
                fontSize = "medium",
            },
        }

        for tabIdx, headerName in ipairs(headers) do
            local ids = Core:GetCurrenciesByHeader(headerName)
            if #ids > 0 then
                local tabKey = "header_" .. tostring(tabIdx)
                listArgs[tabKey] = {
                    type = "group",
                    name = headerName .. " (" .. tostring(#ids) .. ")",
                    order = tabIdx + 1,
                    args = {
                        desc = {
                            type = "description",
                            name = "|cFFCCCCCC" .. headerName .. " - " .. tostring(#ids) .. " items|r",
                            order = 1,
                            width = "full",
                        },
                        currencies = BuildHeaderMultiselect(headerName, 2, RefreshOrderGroup),
                    },
                }
            end
        end

        listArgs["header_all"] = {
            type = "group",
            name = "全部",
            order = 0,
            args = {
                desc = {
                    type = "description",
                    name = "|cFFCCCCCC" .. "全部货币一览" .. "|r",
                    order = 1,
                    width = "full",
                },
                currencies = {
                    type = "multiselect",
                    name = "所有货币",
                    width = "full",
                    order = 2,
                    values = function()
                        return Core:GetAvailableCurrencyValues()
                    end,
                    get = function(_, key)
                        local id = tonumber(key)
                        if not id then
                            return false
                        end
                        return EnsureSelected()[id] == true
                    end,
                    set = function(_, key, val)
                        local id = tonumber(key)
                        if not id then
                            return
                        end
                        EnsureSelected()[id] = val and true or nil
                        Core:UpdateCurrencyDisplay()
                        RefreshOrderGroup()
                    end,
                },
            },
        }

        group.args.currencyList.args = listArgs
        NotifyChanged()
    end

    group = {
        type = "group",
        name = "货币展示",
        order = 25,
        childGroups = "tab",
        args = {
            settings = {
                type = "group",
                name = "基本设置",
                order = 1,
                args = {
                    basic = {
                        type = "group",
                        name = "启用",
                        order = 10,
                        args = {
                            enabled = {
                                type = "toggle",
                                name = "启用货币展示",
                                order = 1,
                                get = function() return CU().enabled end,
                                set = function(_, val)
                                    CU().enabled = val
                                    Core:ApplyCurrencySettings()
                                end,
                            },
                            locked = {
                                type = "toggle",
                                name = function() return S.GetLockLayoutToggleName(CU().locked) end,
                                order = 2,
                                get = function() return CU().locked end,
                                set = function(_, val)
                                    CU().locked = val
                                    Core:ApplyCurrencySettings()
                                end,
                            },
                            showMoney = {
                                type = "toggle",
                                name = "显示金币",
                                order = 3,
                                get = function() return CU().showMoney end,
                                set = function(_, val)
                                    CU().showMoney = val
                                    Core:UpdateCurrencyDisplay()
                                end,
                            },
                        },
                    },
                    layout = {
                        type = "group",
                        name = "布局",
                        order = 20,
                        args = {
                            orientation = {
                                type = "select",
                                name = "排列方向",
                                order = 1,
                                values = {
                                    HORIZONTAL = "横向",
                                    VERTICAL = "纵向",
                                },
                                get = function() return CU().orientation end,
                                set = function(_, val)
                                    CU().orientation = val
                                    Core:UpdateCurrencyDisplay()
                                end,
                            },
                            spacing = {
                                type = "range",
                                name = "项目间隔",
                                order = 2,
                                min = 0,
                                max = 40,
                                step = 1,
                                get = function() return CU().spacing end,
                                set = function(_, val)
                                    CU().spacing = val
                                    Core:UpdateCurrencyDisplay()
                                end,
                            },
                            displayMode = {
                                type = "select",
                                name = "展示模式",
                                order = 3,
                                values = {
                                    ICON = "图标+数量",
                                    TEXT = "仅文字",
                                    ICON_TEXT = "图标+文字",
                                },
                                get = function() return CU().displayMode end,
                                set = function(_, val)
                                    CU().displayMode = val
                                    Core:UpdateCurrencyDisplay()
                                end,
                            },
                        },
                    },
                    style = {
                        type = "group",
                        name = "样式",
                        order = 30,
                        args = {
                            iconSize = {
                                type = "range",
                                name = "图标大小",
                                order = 1,
                                min = 10,
                                max = 40,
                                step = 1,
                                get = function() return CU().iconSize end,
                                set = function(_, val)
                                    CU().iconSize = val
                                    Core:UpdateCurrencyDisplay()
                                end,
                            },
                            fontSize = {
                                type = "range",
                                name = "文字大小",
                                order = 2,
                                min = 8,
                                max = 30,
                                step = 1,
                                get = function() return CU().fontSize end,
                                set = function(_, val)
                                    CU().fontSize = val
                                    Core:UpdateCurrencyDisplay()
                                end,
                            },
                            font = {
                                type = "select",
                                name = "字体",
                                order = 3,
                                dialogControl = "LSM30_Font",
                                values = LibSharedMedia:HashTable("font"),
                                get = function() return CU().font end,
                                set = function(_, val)
                                    CU().font = val
                                    Core:UpdateCurrencyDisplay()
                                end,
                            },
                            fontOutline = {
                                type = "toggle",
                                name = "字体轮廓",
                                order = 4,
                                get = function() return CU().fontOutline end,
                                set = function(_, val)
                                    CU().fontOutline = val
                                    Core:UpdateCurrencyDisplay()
                                end,
                            },
                        },
                    },
                },
            },
            currencyList = {
                type = "group",
                name = "货币类型",
                order = 2,
                childGroups = "tab",
                args = {},
            },
            ordering = {
                type = "group",
                name = "顺序排序",
                order = 3,
                childGroups = "tree",
                args = {},
            },
        },
    }

    RefreshCurrencyTabs()
    RefreshOrderGroup()
    return group
end
