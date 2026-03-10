local _, ns = ...
local Core = ns.Core
local LibSharedMedia = LibStub("LibSharedMedia-3.0")

local S = ns.OptionsShared
local MI = S.MIcfg

function ns.BuildLevelingTipOptions()
    return {
        type = "group",
        name = "升级提示",
        order = 27,
        args = {
            enabled = {
                type = "toggle",
                name = "启用升级提示",
                order = 1,
                get = function() return MI().levelingTipEnabled end,
                set = function(_, val)
                    MI().levelingTipEnabled = val
                    if val and Core.ResetLevelingTipTracking then
                        Core:ResetLevelingTipTracking()
                    end
                    Core:ApplyMiscSettings()
                end,
            },
            locked = {
                type = "toggle",
                name = function() return MI().levelingTipLocked and "解锁拖动" or "锁定框体" end,
                order = 2,
                disabled = function() return not MI().levelingTipEnabled end,
                get = function() return MI().levelingTipLocked end,
                set = function(_, val)
                    MI().levelingTipLocked = val
                    Core:ApplyMiscSettings()
                end,
            },
            font = {
                type = "select",
                name = "字体",
                order = 3,
                disabled = function() return not MI().levelingTipEnabled end,
                dialogControl = "LSM30_Font",
                values = LibSharedMedia:HashTable("font"),
                get = function() return MI().levelingTipFont end,
                set = function(_, val)
                    MI().levelingTipFont = val
                    Core:ApplyMiscSettings()
                end,
            },
            fontSize = {
                type = "range",
                name = "字体大小",
                order = 4,
                disabled = function() return not MI().levelingTipEnabled end,
                min = 10,
                max = 24,
                step = 1,
                get = function() return MI().levelingTipFontSize or 13 end,
                set = function(_, val)
                    MI().levelingTipFontSize = val
                    Core:ApplyMiscSettings()
                end,
            },
            showXPPerMinute = {
                type = "toggle",
                name = "显示每分钟经验",
                order = 10,
                disabled = function() return not MI().levelingTipEnabled end,
                get = function() return MI().levelingTipShowXPPerMinute end,
                set = function(_, val)
                    MI().levelingTipShowXPPerMinute = val
                    Core:ApplyMiscSettings()
                end,
            },
            showRemainingXP = {
                type = "toggle",
                name = "显示距离升级",
                order = 11,
                disabled = function() return not MI().levelingTipEnabled end,
                get = function() return MI().levelingTipShowRemainingXP end,
                set = function(_, val)
                    MI().levelingTipShowRemainingXP = val
                    Core:ApplyMiscSettings()
                end,
            },
            showLevelETA = {
                type = "toggle",
                name = "显示预计升级",
                order = 12,
                disabled = function() return not MI().levelingTipEnabled end,
                get = function() return MI().levelingTipShowLevelETA end,
                set = function(_, val)
                    MI().levelingTipShowLevelETA = val
                    Core:ApplyMiscSettings()
                end,
            },
            showMaxETA = {
                type = "toggle",
                name = "显示预计满级",
                order = 13,
                disabled = function() return not MI().levelingTipEnabled end,
                get = function() return MI().levelingTipShowMaxETA end,
                set = function(_, val)
                    MI().levelingTipShowMaxETA = val
                    Core:ApplyMiscSettings()
                end,
            },
            hideAtMaxLevel = {
                type = "toggle",
                name = "满级自动隐藏",
                order = 14,
                disabled = function() return not MI().levelingTipEnabled end,
                get = function()
                    if MI().levelingTipHideAtMaxLevel == nil then
                        return true
                    end
                    return MI().levelingTipHideAtMaxLevel
                end,
                set = function(_, val)
                    MI().levelingTipHideAtMaxLevel = val
                    Core:ApplyMiscSettings()
                end,
            },
            tips = {
                type = "description",
                name = "升级提示会根据当前经验获取速度，动态显示升级效率、距离下一级以及预计升级时间。",
                order = 20,
                width = "full",
            },
        },
    }
end
