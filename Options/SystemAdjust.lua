local _, ns = ...
local Core = ns.Core

local S = ns.OptionsShared
local SA = S.SAcfg
local MI = S.MIcfg

function ns.BuildSystemAdjustOptions()
    return {
        type = "group",
        name = "系统调节",
        order = 85,
        args = {
            overview = {
                type = "description",
                name = "用于统一调整系统显示效果与鼠标提示行为。",
                order = 1,
                width = "full",
            },
            combatTextGroup = {
                type = "group",
                name = "战斗文字",
                order = 10,
                inline = true,
                args = {
                    combatDamageTextScale = {
                        type = "range",
                        name = "伤害字体大小",
                        desc = "对应系统变量 floatingCombatTextCombatDamageDirectionalScale_V2。",
                        order = 1,
                        min = 1,
                        max = 20,
                        step = 1,
                        get = function()
                            return tonumber(SA().combatDamageTextScale) or 3
                        end,
                        set = function(_, val)
                            SA().combatDamageTextScale = math.max(1, math.min(20, val or 3))
                            Core:ApplySystemAdjustSettings()
                        end,
                    },
                    combatTextDesc = {
                        type = "description",
                        name = "调整后会立即同步到游戏系统变量。",
                        order = 2,
                        width = "full",
                    },
                },
            },
            tooltipGroup = {
                type = "group",
                name = "鼠标提示",
                order = 2,
                inline = true,
                args = {
                    disableAllTooltips = {
                        type = "toggle",
                        name = "禁止鼠标提示",
                        desc = "勾选后尽量隐藏所有常见提示框。",
                        order = 1,
                        width = 1.2,
                        get = function() return MI().disableAllTooltips end,
                        set = function(_, val)
                            MI().disableAllTooltips = val
                            Core:ApplyMiscSettings()
                        end,
                    },
                    tooltipFollowCursor = {
                        type = "toggle",
                        name = "提示跟随鼠标",
                        order = 2,
                        width = 1.2,
                        disabled = function() return MI().disableAllTooltips end,
                        get = function() return MI().tooltipFollowCursor end,
                        set = function(_, val)
                            MI().tooltipFollowCursor = val
                            Core:ApplyMiscSettings()
                        end,
                    },
                    opaqueTooltipBackground = {
                        type = "toggle",
                        name = "取消背景透明",
                        desc = "让常见鼠标提示框背景改为不透明显示。",
                        order = 3,
                        width = 1.2,
                        disabled = function() return MI().disableAllTooltips end,
                        get = function()
                            return SA().opaqueTooltipBackground
                        end,
                        set = function(_, val)
                            SA().opaqueTooltipBackground = val
                            Core:ApplySystemAdjustSettings()
                        end,
                    },
                    showTooltipHealthBar = {
                        type = "toggle",
                        name = "显示提示框血条",
                        desc = "控制鼠标提示框底部单位血条是否显示。",
                        order = 4,
                        width = 1.2,
                        disabled = function() return MI().disableAllTooltips end,
                        get = function()
                            return SA().showTooltipHealthBar
                        end,
                        set = function(_, val)
                            SA().showTooltipHealthBar = val
                            Core:ApplySystemAdjustSettings()
                        end,
                    },
                    showNPCAliveTime = {
                        type = "toggle",
                        name = "显示NPC存活时间",
                        desc = "在鼠标提示框中追加 NPC 存活时间。",
                        order = 5,
                        width = 1.2,
                        disabled = function() return MI().disableAllTooltips end,
                        get = function()
                            return SA().showNPCAliveTime
                        end,
                        set = function(_, val)
                            SA().showNPCAliveTime = val
                            Core:ApplySystemAdjustSettings()
                        end,
                    },
                    npcTimeShowCurrentTime = {
                        type = "toggle",
                        name = "显示当前时间",
                        order = 6,
                        width = 1.2,
                        disabled = function() return MI().disableAllTooltips or not SA().showNPCAliveTime end,
                        get = function() return SA().npcTimeShowCurrentTime end,
                        set = function(_, val)
                            SA().npcTimeShowCurrentTime = val
                            Core:ApplySystemAdjustSettings()
                        end,
                    },
                    npcTimeShowLayer = {
                        type = "toggle",
                        name = "显示位面层",
                        order = 7,
                        width = 1.2,
                        disabled = function() return MI().disableAllTooltips or not SA().showNPCAliveTime end,
                        get = function() return SA().npcTimeShowLayer end,
                        set = function(_, val)
                            SA().npcTimeShowLayer = val
                            Core:ApplySystemAdjustSettings()
                        end,
                    },
                    npcTimeShowNPCID = {
                        type = "toggle",
                        name = "显示NPC ID",
                        order = 8,
                        width = 1.2,
                        disabled = function() return MI().disableAllTooltips or not SA().showNPCAliveTime end,
                        get = function() return SA().npcTimeShowNPCID end,
                        set = function(_, val)
                            SA().npcTimeShowNPCID = val
                            Core:ApplySystemAdjustSettings()
                        end,
                    },
                    npcTimeUseModifier = {
                        type = "toggle",
                        name = "按住修饰键时显示",
                        order = 9,
                        width = 1.2,
                        disabled = function() return MI().disableAllTooltips or not SA().showNPCAliveTime end,
                        get = function() return SA().npcTimeUseModifier end,
                        set = function(_, val)
                            SA().npcTimeUseModifier = val
                            Core:ApplySystemAdjustSettings()
                        end,
                    },
                    npcTimeShowPhaseAlert = {
                        type = "toggle",
                        name = "显示位面切换提示",
                        order = 10,
                        width = 1.2,
                        get = function() return SA().npcTimeShowPhaseAlert end,
                        set = function(_, val)
                            SA().npcTimeShowPhaseAlert = val
                            Core:ApplySystemAdjustSettings()
                        end,
                    },
                    tooltipDesc = {
                        type = "description",
                        name = "NPC 存活时间参考 GUID 生成时间计算，可额外显示当前时间、位面层、NPC ID，也可改为仅按住 Ctrl/Alt/Shift 时显示。",
                        order = 11,
                        width = "full",
                    },
                },
            },
        },
    }
end
