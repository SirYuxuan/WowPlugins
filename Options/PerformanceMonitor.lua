local _, ns = ...
local Core = ns.Core
local LibSharedMedia = LibStub("LibSharedMedia-3.0")

local S = ns.OptionsShared
local PM = S.PMcfg

function ns.BuildPerformanceMonitorOptions()
    return {
        type = "group",
        name = "性能监控",
        order = 26,
        args = {
            enabled = {
                type = "toggle",
                name = "启用性能监控",
                order = 1,
                get = function() return PM().enabled end,
                set = function(_, val)
                    PM().enabled = val
                    Core:ApplyPerformanceMonitorSettings()
                end,
            },
            locked = {
                type = "toggle",
                name = function() return PM().locked and "解锁拖动" or "锁定框体" end,
                order = 2,
                disabled = function() return not PM().enabled end,
                get = function() return PM().locked end,
                set = function(_, val)
                    PM().locked = val
                    Core:ApplyPerformanceMonitorSettings()
                end,
            },
            font = {
                type = "select",
                name = "字体",
                order = 3,
                disabled = function() return not PM().enabled end,
                dialogControl = "LSM30_Font",
                values = LibSharedMedia:HashTable("font"),
                get = function() return PM().font end,
                set = function(_, val)
                    PM().font = val
                    Core:ApplyPerformanceMonitorSettings()
                end,
            },
            fontSize = {
                type = "range",
                name = "字体大小",
                order = 4,
                disabled = function() return not PM().enabled end,
                min = 10,
                max = 28,
                step = 1,
                get = function() return PM().fontSize or 14 end,
                set = function(_, val)
                    PM().fontSize = val
                    Core:ApplyPerformanceMonitorSettings()
                end,
            },
            updateInterval = {
                type = "range",
                name = "刷新间隔",
                order = 5,
                disabled = function() return not PM().enabled end,
                min = 0.2,
                max = 5,
                step = 0.1,
                get = function() return PM().updateInterval or 1 end,
                set = function(_, val)
                    PM().updateInterval = val
                    Core:ApplyPerformanceMonitorSettings()
                end,
            },
            showBackground = {
                type = "toggle",
                name = "显示背景",
                order = 10,
                disabled = function() return not PM().enabled end,
                get = function() return PM().showBackground end,
                set = function(_, val)
                    PM().showBackground = val
                    Core:ApplyPerformanceMonitorSettings()
                end,
            },
            backgroundColor = {
                type = "color",
                name = "背景颜色",
                order = 11,
                hasAlpha = true,
                disabled = function() return not PM().enabled or not PM().showBackground end,
                get = function()
                    local c = PM().backgroundColor or { r = 0, g = 0, b = 0, a = 0.32 }
                    return c.r, c.g, c.b, c.a
                end,
                set = function(_, r, g, b, a)
                    PM().backgroundColor = { r = r, g = g, b = b, a = a }
                    Core:ApplyPerformanceMonitorSettings()
                end,
            },
            tips = {
                type = "description",
                name = "显示独立 FPS / MS 文本；已移除边框，仅保留紧凑背景。鼠标移入后会实时刷新插件内存列表。",
                order = 20,
                width = "full",
            },
        },
    }
end
