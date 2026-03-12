-- ============================================================
-- Options/GameBar.lua
-- 雨轩工具箱 · 游戏条选项面板
-- ============================================================
local addonName, ns = ...
local Core = ns.Core

local function GB() return Core.db.profile.gameBar end
local function GetHearthstoneChoices() return ns.GetGameBarHearthstoneChoices and ns.GetGameBarHearthstoneChoices() or {} end

local function GetButtonChoices()
    local choices = {}
    local defs    = ns.GameBarButtonDefs or {}
    local ids     = ns.GameBarButtonIDs or {}
    for _, id in ipairs(ids) do
        local def = defs[id]
        if def then choices[id] = def.label or id end
    end
    return choices
end

local function MakeSlotOption(side, i)
    local key = side .. "Buttons"
    return {
        type     = "select",
        name     = "按钮 " .. i,
        order    = 10 + i,
        width    = 1.1,
        values   = GetButtonChoices,
        get      = function()
            local slot = GB()[key]
            return (slot and slot[i]) or "NONE"
        end,
        set      = function(_, val)
            local slot = GB()[key]
            slot[i] = val
            Core:ApplyGameBarSettings()
        end,
        disabled = function() return not GB().enabled end,
    }
end

local function BuildSideSlots(side)
    local key = side .. "Buttons"
    local opts = {}
    local function numSlots()
        local s = GB()[key]; return s and math.max(1, math.min(7, #s)) or 4
    end
    for i = 1, 7 do
        opts["slot" .. i] = MakeSlotOption(side, i)
    end
    opts.addSlot = {
        type = "execute",
        name = "+ 添加",
        order = 100,
        width = 0.6,
        func = function()
            local s = GB()[key]; if #s < 7 then
                table.insert(s, "NONE"); Core:ApplyGameBarSettings()
            end
        end,
        disabled = function() return not GB().enabled or #GB()[key] >= 7 end,
    }
    opts.removeSlot = {
        type = "execute",
        name = "- 移除",
        order = 101,
        width = 0.6,
        func = function()
            local s = GB()[key]; if #s > 1 then
                table.remove(s); Core:ApplyGameBarSettings()
            end
        end,
        disabled = function() return not GB().enabled or #GB()[key] <= 1 end,
    }
    return opts
end

function ns.BuildGameBarOptions()
    return {
        type  = "group",
        name  = "游戏条",
        order = 25,
        args  = {
            enabled = {
                type = "toggle",
                name = "启用游戏条",
                order = 1,
                width = "full",
                get = function() return GB().enabled end,
                set = function(_, v)
                    GB().enabled = v; Core:ApplyGameBarSettings()
                end,
            },
            sp0 = { type = "description", name = " ", order = 2, width = "full" },

            -- ── 外观 ──
            appearHeader = { type = "header", name = "外观", order = 10 },
            buttonSize = {
                type = "range",
                name = "图标大小",
                order = 11,
                min = 16,
                max = 64,
                step = 2,
                get = function() return GB().buttonSize or 28 end,
                set = function(_, v)
                    GB().buttonSize = v; Core:ApplyGameBarSettings()
                end,
                disabled = function() return not GB().enabled end,
            },
            spacing = {
                type = "range",
                name = "按钮间距",
                order = 12,
                min = 0,
                max = 20,
                step = 1,
                get = function() return GB().spacing or 4 end,
                set = function(_, v)
                    GB().spacing = v; Core:ApplyGameBarSettings()
                end,
                disabled = function() return not GB().enabled end,
            },
            middleWidth = {
                type = "range",
                name = "时间区域宽",
                order = 13,
                min = 50,
                max = 160,
                step = 2,
                get = function() return GB().middleWidth or 80 end,
                set = function(_, v)
                    GB().middleWidth = v; Core:ApplyGameBarSettings()
                end,
                disabled = function() return not GB().enabled end,
            },
            timeFontSize = {
                type = "range",
                name = "时间字体大小",
                order = 14,
                min = 10,
                max = 36,
                step = 1,
                get = function() return GB().timeFontSize or 20 end,
                set = function(_, v)
                    GB().timeFontSize = v; Core:ApplyGameBarSettings()
                end,
                disabled = function() return not GB().enabled end,
            },
            animationDuration = {
                type = "range",
                name = "悬停动画时长",
                order = 15,
                min = 0,
                max = 1,
                step = 0.01,
                get = function() return GB().animationDuration or 0.2 end,
                set = function(_, v)
                    GB().animationDuration = v; Core:ApplyGameBarSettings()
                end,
                disabled = function() return not GB().enabled end,
            },
            showBackground = {
                type = "toggle",
                name = "显示背景",
                order = 16,
                get = function() return GB().showBackground end,
                set = function(_, v)
                    GB().showBackground = v; Core:ApplyGameBarSettings()
                end,
                disabled = function() return not GB().enabled end,
            },
            backgroundColor = {
                type = "color",
                name = "背景颜色",
                order = 17,
                hasAlpha = true,
                get = function()
                    local c = GB().backgroundColor or { r = 0, g = 0, b = 0, a = 0.45 }
                    return c.r, c.g, c.b, c.a
                end,
                set = function(_, r, g, b, a)
                    GB().backgroundColor = { r = r, g = g, b = b, a = a }; Core:ApplyGameBarSettings()
                end,
                disabled = function() return not GB().enabled or not GB().showBackground end,
            },
            mouseOver = {
                type = "toggle",
                name = "仅悬停显示",
                order = 18,
                get = function() return GB().mouseOver end,
                set = function(_, v)
                    GB().mouseOver = v; Core:ApplyGameBarSettings()
                end,
                disabled = function() return not GB().enabled end,
            },
            locked = {
                type = "toggle",
                name = function() return ns.OptionsShared.GetLockLayoutToggleName(GB().locked) end,
                order = 19,
                get = function() return GB().locked end,
                set = function(_, v)
                    GB().locked = v
                    Core:ApplyGameBarSettings()
                end,
                disabled = function() return not GB().enabled end,
            },

            buttonConfig = {
                type = "group",
                name = "按钮配置",
                order = 40,
                childGroups = "tab",
                disabled = function() return not GB().enabled end,
                args = {
                    leftSlots = {
                        type = "group",
                        name = "左侧按钮",
                        order = 1,
                        args = BuildSideSlots("left"),
                    },
                    rightSlots = {
                        type = "group",
                        name = "右侧按钮",
                        order = 2,
                        args = BuildSideSlots("right"),
                    },
                    hearthstone = {
                        type = "group",
                        name = "炉石",
                        order = 3,
                        args = {
                            showBindLocation = {
                                type = "toggle",
                                name = "提示中显示绑定地点",
                                order = 1,
                                get = function() return GB().hearthstone and GB().hearthstone.showBindLocation ~= false end,
                                set = function(_, v)
                                    GB().hearthstone = GB().hearthstone or {}
                                    GB().hearthstone.showBindLocation = v
                                    Core:ApplyGameBarSettings()
                                end,
                            },
                            left = {
                                type = "select",
                                name = "左键",
                                order = 2,
                                width = "full",
                                values = GetHearthstoneChoices,
                                get = function() return (GB().hearthstone and GB().hearthstone.left) or "AUTO" end,
                                set = function(_, v)
                                    GB().hearthstone = GB().hearthstone or {}
                                    GB().hearthstone.left = v
                                    Core:ApplyGameBarSettings()
                                end,
                            },
                            middle = {
                                type = "select",
                                name = "中键",
                                order = 3,
                                width = "full",
                                values = GetHearthstoneChoices,
                                get = function() return (GB().hearthstone and GB().hearthstone.middle) or "RANDOM" end,
                                set = function(_, v)
                                    GB().hearthstone = GB().hearthstone or {}
                                    GB().hearthstone.middle = v
                                    Core:ApplyGameBarSettings()
                                end,
                            },
                            right = {
                                type = "select",
                                name = "右键",
                                order = 4,
                                width = "full",
                                values = GetHearthstoneChoices,
                                get = function() return (GB().hearthstone and GB().hearthstone.right) or "AUTO" end,
                                set = function(_, v)
                                    GB().hearthstone = GB().hearthstone or {}
                                    GB().hearthstone.right = v
                                    Core:ApplyGameBarSettings()
                                end,
                            },
                        },
                    },
                },
            },
        },
    }
end
