local _, ns = ...
local Core = ns.Core
local LibSharedMedia = LibStub("LibSharedMedia-3.0")

local S = ns.OptionsShared
local DM = S.DMcfg

function ns.BuildDistanceMonitorOptions()
    return {
        type = "group",
        name = "距离监控",
        order = 18,
        args = {
            enabled = {
                type = "toggle",
                name = "启用距离监控",
                order = 1,
                get = function() return DM().enabled end,
                set = function(_, val)
                    DM().enabled = val
                    Core:ApplyDistanceMonitorSettings()
                end,
            },
            locked = {
                type = "toggle",
                name = function() return DM().locked and "解锁拖动" or "锁定框体" end,
                order = 2,
                disabled = function() return not DM().enabled end,
                get = function() return DM().locked end,
                set = function(_, val)
                    DM().locked = val
                    Core:ApplyDistanceMonitorSettings()
                end,
            },
            font = {
                type = "select",
                name = "字体",
                order = 3,
                disabled = function() return not DM().enabled end,
                dialogControl = "LSM30_Font",
                values = LibSharedMedia:HashTable("font"),
                get = function() return DM().font end,
                set = function(_, val)
                    DM().font = val
                    Core:ApplyDistanceMonitorSettings()
                end,
            },
            fontSize = {
                type = "range",
                name = "字体大小",
                order = 4,
                disabled = function() return not DM().enabled end,
                min = 10,
                max = 28,
                step = 1,
                get = function() return DM().fontSize or 14 end,
                set = function(_, val)
                    DM().fontSize = val
                    Core:ApplyDistanceMonitorSettings()
                end,
            },
            updateInterval = {
                type = "range",
                name = "刷新间隔",
                order = 5,
                disabled = function() return not DM().enabled end,
                min = 0.05,
                max = 1,
                step = 0.05,
                isPercent = false,
                get = function() return DM().updateInterval or 0.2 end,
                set = function(_, val)
                    DM().updateInterval = val
                    Core:ApplyDistanceMonitorSettings()
                end,
            },
            rangeSeparator = {
                type = "input",
                name = "区间分隔符",
                order = 6,
                width = 1.3,
                disabled = function() return not DM().enabled end,
                desc = "仅在范围回退文本中生效，例如填写 - 显示为 5-6，填写  -  显示为 5 - 6。",
                get = function() return DM().rangeSeparator or " - " end,
                set = function(_, val)
                    DM().rangeSeparator = (val ~= nil and val ~= "") and val or " - "
                    Core:ApplyDistanceMonitorSettings()
                end,
            },
            showBackground = {
                type = "toggle",
                name = "显示背景",
                order = 10,
                disabled = function() return not DM().enabled end,
                get = function() return DM().showBackground end,
                set = function(_, val)
                    DM().showBackground = val
                    Core:ApplyDistanceMonitorSettings()
                end,
            },
            backgroundColor = {
                type = "color",
                name = "背景颜色",
                order = 11,
                hasAlpha = true,
                disabled = function() return not DM().enabled or not DM().showBackground end,
                get = function()
                    local c = DM().backgroundColor or { r = 0, g = 0, b = 0, a = 0.32 }
                    return c.r, c.g, c.b, c.a
                end,
                set = function(_, r, g, b, a)
                    DM().backgroundColor = { r = r, g = g, b = b, a = a }
                    Core:ApplyDistanceMonitorSettings()
                end,
            },
            showBorder = {
                type = "toggle",
                name = "显示边框",
                order = 12,
                disabled = function() return not DM().enabled end,
                get = function() return DM().showBorder end,
                set = function(_, val)
                    DM().showBorder = val
                    Core:ApplyDistanceMonitorSettings()
                end,
            },
            borderColor = {
                type = "color",
                name = "边框颜色",
                order = 13,
                hasAlpha = true,
                disabled = function() return not DM().enabled or not DM().showBorder end,
                get = function()
                    local c = DM().borderColor or { r = 0, g = 0.6, b = 1, a = 0.45 }
                    return c.r, c.g, c.b, c.a
                end,
                set = function(_, r, g, b, a)
                    DM().borderColor = { r = r, g = g, b = b, a = a }
                    Core:ApplyDistanceMonitorSettings()
                end,
            },
            tips = {
                type = "description",
                name = "仅在有目标时显示；优先使用精确坐标，无法获取时回退 LibRangeCheck 范围，并按距离自动变色。",
                order = 20,
                width = "full",
            },
        },
    }
end
