local _, ns = ...
local Core = ns.Core
local LibSharedMedia = LibStub("LibSharedMedia-3.0")

local S = ns.OptionsShared
local MI = S.MIcfg

function ns.BuildQuestToolsOptions()
    return {
        type = "group",
        name = "任务助手",
        order = 50,
        args = {
            questToolsEnabled = {
                type = "toggle",
                name = "启用任务助手",
                desc = "开启后显示独立的任务助手框体，包含“任务通报”和“自动交接”两个切换按钮。",
                order = 1,
                get = function() return MI().questToolsEnabled end,
                set = function(_, val)
                    MI().questToolsEnabled = val
                    Core:ApplyMiscSettings()
                end,
            },
            questToolsLocked = {
                type = "toggle",
                name = function() return MI().questToolsLocked and "解锁拖动" or "锁定框体" end,
                order = 2,
                disabled = function() return not MI().questToolsEnabled end,
                get = function() return MI().questToolsLocked end,
                set = function(_, val)
                    MI().questToolsLocked = val
                    Core:ApplyMiscSettings()
                end,
            },
            questToolsOrientation = {
                type = "select",
                name = "排列方向",
                order = 3,
                disabled = function() return not MI().questToolsEnabled end,
                values = {
                    HORIZONTAL = "横排",
                    VERTICAL = "竖排",
                },
                get = function() return MI().questToolsOrientation or "HORIZONTAL" end,
                set = function(_, val)
                    MI().questToolsOrientation = val
                    Core:ApplyMiscSettings()
                end,
            },
            questToolsFont = {
                type = "select",
                name = "字体",
                order = 4,
                disabled = function() return not MI().questToolsEnabled end,
                dialogControl = "LSM30_Font",
                values = LibSharedMedia:HashTable("font"),
                get = function() return MI().questToolsFont or MI().font end,
                set = function(_, val)
                    MI().questToolsFont = val
                    Core:ApplyMiscSettings()
                end,
            },
            questToolsFontSize = {
                type = "range",
                name = "字体大小",
                order = 5,
                disabled = function() return not MI().questToolsEnabled end,
                min = 10,
                max = 24,
                step = 1,
                get = function() return MI().questToolsFontSize or 13 end,
                set = function(_, val)
                    MI().questToolsFontSize = val
                    Core:ApplyMiscSettings()
                end,
            },
            questToolsTextColor = {
                type = "color",
                name = "文字颜色",
                order = 6,
                disabled = function() return not MI().questToolsEnabled end,
                hasAlpha = false,
                get = function()
                    local c = MI().questToolsTextColor or { r = 1, g = 1, b = 1 }
                    return c.r, c.g, c.b
                end,
                set = function(_, r, g, b)
                    MI().questToolsTextColor = { r = r, g = g, b = b }
                    Core:ApplyMiscSettings()
                end,
            },
            questToolsSpacing = {
                type = "range",
                name = "项目间隔",
                order = 7,
                disabled = function() return not MI().questToolsEnabled end,
                min = 0,
                max = 300,
                step = 1,
                get = function() return MI().questToolsSpacing or 18 end,
                set = function(_, val)
                    MI().questToolsSpacing = math.max(0, math.min(300, val))
                    Core:ApplyMiscSettings()
                end,
            },
            announceTemplate = {
                type = "input",
                name = "通报模板",
                order = 8,
                width = 1.6,
                disabled = function() return not MI().questToolsEnabled end,
                desc = "支持占位符：{action}=任务已接取/任务已完成、{quest}=任务名、{newline}=换行",
                get = function() return MI().announceTemplate end,
                set = function(_, val)
                    MI().announceTemplate = val ~= "" and val or
                        "|cFF33FF99【雨轩工具箱】|r |cFFFFFF00{action}|r：{quest}"
                end,
            },
            tips = {
                type = "description",
                name = "任务助手会显示独立框体；“任务通报”和“自动交接”开关请直接点击框体上的按钮切换。",
                order = 9,
                width = "full",
            },
        },
    }
end
