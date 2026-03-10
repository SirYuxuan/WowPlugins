local _, ns = ...
local Core = ns.Core

local S = ns.OptionsShared
local SA = S.SAcfg
local MI = S.MIcfg

function ns.BuildSystemAdjustOptions()
    return {
        type = "group",
        name = "系统调节",
        order = 10,
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
                order = 20,
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
            targetMarkerGroup = {
                type = "group",
                name = "目标标记",
                order = 30,
                inline = true,
                args = {
                    targetArrowEnabled = {
                        type = "toggle",
                        name = "启用目标箭头",
                        desc = "在当前选中目标头顶显示一个红色上下浮动箭头。",
                        order = 1,
                        get = function()
                            return SA().targetArrowEnabled
                        end,
                        set = function(_, val)
                            SA().targetArrowEnabled = val
                            Core:ApplySystemAdjustSettings()
                        end,
                    },
                    targetArrowSize = {
                        type = "range",
                        name = "箭头大小",
                        order = 2,
                        min = 12,
                        max = 64,
                        step = 1,
                        disabled = function() return not SA().targetArrowEnabled end,
                        get = function()
                            return tonumber(SA().targetArrowSize) or 28
                        end,
                        set = function(_, val)
                            SA().targetArrowSize = math.max(12, math.min(64, val or 28))
                            Core:ApplySystemAdjustSettings()
                        end,
                    },
                    targetArrowFilterHeader = {
                        type = "description",
                        name = "显示箭头的目标类型：",
                        order = 3,
                        width = "full",
                    },
                    targetArrowShowEnemy = {
                        type = "toggle",
                        name = "敌方",
                        order = 4,
                        width = 0.6,
                        disabled = function() return not SA().targetArrowEnabled end,
                        get = function() return SA().targetArrowShowEnemy end,
                        set = function(_, val)
                            SA().targetArrowShowEnemy = val
                            Core:ApplySystemAdjustSettings()
                        end,
                    },
                    targetArrowShowFriendly = {
                        type = "toggle",
                        name = "友方",
                        order = 5,
                        width = 0.6,
                        disabled = function() return not SA().targetArrowEnabled end,
                        get = function() return SA().targetArrowShowFriendly end,
                        set = function(_, val)
                            SA().targetArrowShowFriendly = val
                            Core:ApplySystemAdjustSettings()
                        end,
                    },
                    targetArrowShowNeutral = {
                        type = "toggle",
                        name = "中立",
                        order = 6,
                        width = 0.6,
                        disabled = function() return not SA().targetArrowEnabled end,
                        get = function() return SA().targetArrowShowNeutral end,
                        set = function(_, val)
                            SA().targetArrowShowNeutral = val
                            Core:ApplySystemAdjustSettings()
                        end,
                    },
                    targetArrowShowPet = {
                        type = "toggle",
                        name = "宠物",
                        order = 7,
                        width = 0.6,
                        disabled = function() return not SA().targetArrowEnabled end,
                        get = function() return SA().targetArrowShowPet end,
                        set = function(_, val)
                            SA().targetArrowShowPet = val
                            Core:ApplySystemAdjustSettings()
                        end,
                    },
                    targetArrowShowCritter = {
                        type = "toggle",
                        name = "小动物",
                        order = 8,
                        width = 0.7,
                        disabled = function() return not SA().targetArrowEnabled end,
                        get = function() return SA().targetArrowShowCritter end,
                        set = function(_, val)
                            SA().targetArrowShowCritter = val
                            Core:ApplySystemAdjustSettings()
                        end,
                    },
                    targetArrowColor = {
                        type = "color",
                        name = "箭头颜色",
                        order = 8,
                        hasAlpha = true,
                        disabled = function() return not SA().targetArrowEnabled end,
                        get = function()
                            local c = SA().targetArrowColor or { r = 1, g = 0.12, b = 0.12, a = 0.95 }
                            return c.r, c.g, c.b, c.a
                        end,
                        set = function(_, r, g, b, a)
                            SA().targetArrowColor = { r = r, g = g, b = b, a = a }
                            Core:ApplySystemAdjustSettings()
                        end,
                    },
                    targetArrowDesc = {
                        type = "description",
                        name = "箭头会尽量锚定在当前目标姓名板上方，并持续上下浮动。不勾选任何类型时对所有目标显示。",
                        order = 9,
                        width = "full",
                    },
                },
            },
        },
    }
end
