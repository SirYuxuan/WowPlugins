local _, ns = ...
local Core = ns.Core

local S = ns.OptionsShared
local MI = S.MIcfg

function ns.BuildRaidMarkersOptions()
    return {
        type = "group",
        name = "团队标记",
        order = 40,
        args = {
            raidMarkersEnabled = {
                type = "toggle",
                name = "启用团队标记",
                order = 1,
                get = function() return MI().raidMarkersEnabled end,
                set = function(_, val)
                    MI().raidMarkersEnabled = val
                    Core:ApplyMiscSettings()
                end,
            },
            raidMarkersLocked = {
                type = "toggle",
                name = function() return S.GetLockLayoutToggleName(MI().raidMarkersLocked) end,
                order = 2,
                disabled = function() return not MI().raidMarkersEnabled end,
                get = function() return MI().raidMarkersLocked end,
                set = function(_, val)
                    MI().raidMarkersLocked = val
                    Core:ApplyMiscSettings()
                end,
            },
            raidMarkersShowWhenSolo = {
                type = "toggle",
                name = "非团队时显示",
                order = 2.5,
                disabled = function() return not MI().raidMarkersEnabled end,
                get = function() return MI().raidMarkersShowWhenSolo end,
                set = function(_, val)
                    MI().raidMarkersShowWhenSolo = val
                    Core:ApplyMiscSettings()
                end,
            },
            raidMarkersOrientation = {
                type = "select",
                name = "排列方向",
                order = 3,
                disabled = function() return not MI().raidMarkersEnabled end,
                values = {
                    HORIZONTAL = "横排",
                    VERTICAL = "竖排",
                },
                get = function() return MI().raidMarkersOrientation or "HORIZONTAL" end,
                set = function(_, val)
                    MI().raidMarkersOrientation = val
                    Core:ApplyMiscSettings()
                end,
            },
            raidMarkersSpacing = {
                type = "range",
                name = "按钮间隔",
                order = 4,
                min = 0,
                max = 40,
                step = 1,
                disabled = function() return not MI().raidMarkersEnabled end,
                get = function() return MI().raidMarkersSpacing or 6 end,
                set = function(_, val)
                    MI().raidMarkersSpacing = math.max(0, math.min(40, val))
                    Core:ApplyMiscSettings()
                end,
            },
            raidMarkersIconSize = {
                type = "range",
                name = "图标大小",
                order = 5,
                min = 20,
                max = 48,
                step = 1,
                disabled = function() return not MI().raidMarkersEnabled end,
                get = function() return MI().raidMarkersIconSize or 28 end,
                set = function(_, val)
                    MI().raidMarkersIconSize = val
                    Core:ApplyMiscSettings()
                end,
            },
            raidMarkersCountdown = {
                type = "range",
                name = "倒计时秒数",
                order = 6,
                min = 3,
                max = 15,
                step = 1,
                disabled = function() return not MI().raidMarkersEnabled end,
                get = function() return MI().raidMarkersCountdown or 6 end,
                set = function(_, val)
                    MI().raidMarkersCountdown = math.max(3, math.min(15, val))
                    Core:ApplyMiscSettings()
                end,
            },
            raidMarkersShowBackground = {
                type = "toggle",
                name = "显示背景",
                order = 7,
                disabled = function() return not MI().raidMarkersEnabled end,
                get = function() return MI().raidMarkersShowBackground end,
                set = function(_, val)
                    MI().raidMarkersShowBackground = val
                    Core:ApplyMiscSettings()
                end,
            },
            raidMarkersBackgroundColor = {
                type = "color",
                name = "背景颜色",
                order = 8,
                hasAlpha = true,
                disabled = function() return not MI().raidMarkersEnabled or not MI().raidMarkersShowBackground end,
                get = function()
                    local c = MI().raidMarkersBackgroundColor or { r = 0, g = 0, b = 0, a = 0.35 }
                    return c.r, c.g, c.b, c.a
                end,
                set = function(_, r, g, b, a)
                    MI().raidMarkersBackgroundColor = { r = r, g = g, b = b, a = a }
                    Core:ApplyMiscSettings()
                end,
            },
            raidMarkersShowBorder = {
                type = "toggle",
                name = "显示边框",
                order = 9,
                disabled = function() return not MI().raidMarkersEnabled end,
                get = function() return MI().raidMarkersShowBorder end,
                set = function(_, val)
                    MI().raidMarkersShowBorder = val
                    Core:ApplyMiscSettings()
                end,
            },
            raidMarkersBorderColor = {
                type = "color",
                name = "边框颜色",
                order = 10,
                hasAlpha = true,
                disabled = function() return not MI().raidMarkersEnabled or not MI().raidMarkersShowBorder end,
                get = function()
                    local c = MI().raidMarkersBorderColor or { r = 0, g = 0.6, b = 1, a = 0.45 }
                    return c.r, c.g, c.b, c.a
                end,
                set = function(_, r, g, b, a)
                    MI().raidMarkersBorderColor = { r = r, g = g, b = b, a = a }
                    Core:ApplyMiscSettings()
                end,
            },
        },
    }
end
