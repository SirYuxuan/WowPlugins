local _, ns = ...
local Core = ns.Core
local LibSharedMedia = LibStub("LibSharedMedia-3.0")

local S = ns.OptionsShared
local CBcfg = S.CBcfg

local function BuildCastBarUnitArgs(key, label, order)
    return {
        type = "group",
        name = label,
        order = order,
        args = {
            enabled = {
                type = "toggle",
                name = "启用",
                order = 1,
                get = function() return CBcfg().bars[key].enabled end,
                set = function(_, v)
                    CBcfg().bars[key].enabled = v; Core:ApplyCastBarSettings()
                end,
            },
            width = {
                type = "range",
                name = "宽度",
                order = 2,
                min = 60,
                max = 600,
                step = 1,
                get = function() return CBcfg().bars[key].width end,
                set = function(_, v)
                    CBcfg().bars[key].width = v; Core:ApplyCastBarSettings()
                end,
            },
            height = {
                type = "range",
                name = "高度",
                order = 3,
                min = 4,
                max = 40,
                step = 1,
                get = function() return CBcfg().bars[key].height end,
                set = function(_, v)
                    CBcfg().bars[key].height = v; Core:ApplyCastBarSettings()
                end,
            },
            alpha = {
                type = "range",
                name = "不透明度",
                order = 4,
                min = 0,
                max = 1,
                step = 0.05,
                get = function() return CBcfg().bars[key].alpha end,
                set = function(_, v)
                    CBcfg().bars[key].alpha = v; Core:ApplyCastBarSettings()
                end,
            },
            scale = {
                type = "range",
                name = "缩放",
                order = 5,
                min = 0.5,
                max = 3,
                step = 0.05,
                get = function() return CBcfg().bars[key].scale end,
                set = function(_, v)
                    CBcfg().bars[key].scale = v; Core:ApplyCastBarSettings()
                end,
            },
            showIcon = {
                type = "toggle",
                name = "显示图标",
                order = 6,
                hidden = function() return key == "gcd" end,
                get = function() return CBcfg().bars[key].showIcon ~= false end,
                set = function(_, v)
                    CBcfg().bars[key].showIcon = v; Core:ApplyCastBarSettings()
                end,
            },
            showSpark = {
                type = "toggle",
                name = "显示闪光",
                order = 7,
                get = function() return CBcfg().bars[key].showSpark ~= false end,
                set = function(_, v)
                    CBcfg().bars[key].showSpark = v; Core:ApplyCastBarSettings()
                end,
            },
            showTime = {
                type = "toggle",
                name = "显示时间",
                order = 8,
                get = function() return CBcfg().bars[key].showTime == true end,
                set = function(_, v)
                    CBcfg().bars[key].showTime = v; Core:ApplyCastBarSettings()
                end,
            },
            showSpellName = {
                type = "toggle",
                name = "显示法术名称",
                order = 9,
                hidden = function() return key == "gcd" end,
                get = function() return CBcfg().bars[key].showSpellName ~= false end,
                set = function(_, v)
                    CBcfg().bars[key].showSpellName = v; Core:ApplyCastBarSettings()
                end,
            },
            showLatency = {
                type = "toggle",
                name = "显示延迟指示",
                order = 10,
                hidden = function() return key ~= "player" end,
                get = function() return CBcfg().bars[key].showLatency ~= false end,
                set = function(_, v)
                    CBcfg().bars[key].showLatency = v; Core:ApplyCastBarSettings()
                end,
            },
        },
    }
end

function ns.BuildCastBarOptions()
    return {
        type = "group",
        name = "施法条",
        order = 30,
        args = {
            global = {
                type = "group",
                name = "全局设置",
                order = 1,
                inline = true,
                args = {
                    locked = {
                        type = "toggle",
                        name = "锁定位置",
                        order = 1,
                        desc = "解锁后可拖动施法条（/yx lock 或 /yx unlock）",
                        get = function() return CBcfg().locked end,
                        set = function(_, v)
                            CBcfg().locked = v; Core:ApplyCastBarSettings()
                        end,
                    },
                    hideBlizzardPlayer = {
                        type = "toggle",
                        name = "隐藏暴雪玩家施法条",
                        order = 2,
                        get = function() return CBcfg().hideBlizzardPlayer end,
                        set = function(_, v)
                            CBcfg().hideBlizzardPlayer = v; Core:ApplyCastBarSettings()
                        end,
                    },
                    hideBlizzardTarget = {
                        type = "toggle",
                        name = "隐藏暴雪目标/焦点施法条",
                        order = 3,
                        get = function() return CBcfg().hideBlizzardTarget end,
                        set = function(_, v)
                            CBcfg().hideBlizzardTarget = v; Core:ApplyCastBarSettings()
                        end,
                    },
                },
            },
            appearance = {
                type = "group",
                name = "外观",
                order = 2,
                inline = true,
                args = {
                    texture = {
                        type = "select",
                        name = "材质",
                        order = 1,
                        dialogControl = "LSM30_Statusbar",
                        values = LibSharedMedia:HashTable("statusbar"),
                        get = function() return CBcfg().texture end,
                        set = function(_, v)
                            CBcfg().texture = v; Core:ApplyCastBarSettings()
                        end,
                    },
                    font = {
                        type = "select",
                        name = "字体",
                        order = 2,
                        dialogControl = "LSM30_Font",
                        values = LibSharedMedia:HashTable("font"),
                        get = function() return CBcfg().font end,
                        set = function(_, v)
                            CBcfg().font = v; Core:ApplyCastBarSettings()
                        end,
                    },
                    fontSize = {
                        type = "range",
                        name = "字体大小",
                        order = 3,
                        min = 6,
                        max = 24,
                        step = 1,
                        get = function() return CBcfg().fontSize end,
                        set = function(_, v)
                            CBcfg().fontSize = v; Core:ApplyCastBarSettings()
                        end,
                    },
                    outline = {
                        type = "select",
                        name = "字体描边",
                        order = 4,
                        values = { OUTLINE = "描边", THICKOUTLINE = "粗描边", NONE = "无" },
                        get = function() return CBcfg().outline end,
                        set = function(_, v)
                            CBcfg().outline = v; Core:ApplyCastBarSettings()
                        end,
                    },
                },
            },
            colors = {
                type = "group",
                name = "颜色",
                order = 3,
                inline = true,
                args = {
                    colorCast = {
                        type = "color",
                        name = "施法颜色",
                        order = 1,
                        hasAlpha = true,
                        get = function()
                            local c = CBcfg().colorCast
                            return c.r, c.g, c.b, c.a
                        end,
                        set = function(_, r, g, b, a)
                            CBcfg().colorCast = { r = r, g = g, b = b, a = a }
                            Core:ApplyCastBarSettings()
                        end,
                    },
                    colorChannel = {
                        type = "color",
                        name = "引导颜色",
                        order = 2,
                        hasAlpha = true,
                        get = function()
                            local c = CBcfg().colorChannel
                            return c.r, c.g, c.b, c.a
                        end,
                        set = function(_, r, g, b, a)
                            CBcfg().colorChannel = { r = r, g = g, b = b, a = a }
                            Core:ApplyCastBarSettings()
                        end,
                    },
                },
            },
            playerBar = BuildCastBarUnitArgs("player", "玩家施法条", 10),
            targetBar = BuildCastBarUnitArgs("target", "目标施法条", 20),
            focusBar = BuildCastBarUnitArgs("focus", "焦点施法条", 30),
            gcdBar = BuildCastBarUnitArgs("gcd", "GCD 条", 40),
        },
    }
end
