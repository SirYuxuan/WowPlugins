local addonName, ns = ...
local Core = ns.Core
local LibSharedMedia = LibStub("LibSharedMedia-3.0")

local S = ns.OptionsShared
local MI = S.MIcfg

function ns.BuildMiscOptions()
    return {
        type = "group",
        name = "杂项",
        order = 85,
        args = {
            quest = {
                type = "group",
                name = "任务交接",
                order = 10,
                inline = true,
                args = {
                    autoAnnounceQuest = {
                        type = "toggle",
                        name = "通报",
                        desc = "接取和完成任务时发送统一通报",
                        order = 1,
                        get = function() return MI().autoAnnounceQuest end,
                        set = function(_, val)
                            MI().autoAnnounceQuest = val
                            Core:ApplyMiscSettings()
                        end,
                    },
                    autoQuestTurnIn = {
                        type = "toggle",
                        name = "自动交接",
                        desc = "自动接取任务、完成进度、领取奖励",
                        order = 2,
                        get = function() return MI().autoQuestTurnIn end,
                        set = function(_, val)
                            MI().autoQuestTurnIn = val
                            Core:ApplyMiscSettings()
                        end,
                    },
                    announceTemplate = {
                        type = "input",
                        name = "通报模板",
                        order = 3,
                        width = 1.6,
                        desc = "支持占位符：{action}=任务已接取/任务已完成、{quest}=任务名、{newline}=换行",
                        get = function() return MI().announceTemplate end,
                        set = function(_, val)
                            MI().announceTemplate = val ~= "" and val or
                                "|cFF33FF99【雨轩工具箱】|r |cFFFFFF00{action}|r：{quest}"
                        end,
                    },
                    tips = {
                        type = "description",
                        name =
                        "|cFFFFCC00占位符说明：|r {action}=任务已接取或任务已完成  {quest}=任务名称  {newline}=换行\n默认文案会区分接任务和完成任务，通报优先发送到副本频道，其次团队/小队频道。",
                        order = 4,
                        width = "full",
                    },
                },
            },
            infoBar = {
                type = "group",
                name = "展示条",
                order = 20,
                inline = true,
                args = {
                    infoBarEnabled = {
                        type = "toggle",
                        name = "启用展示条",
                        order = 1,
                        get = function() return MI().infoBarEnabled end,
                        set = function(_, val)
                            MI().infoBarEnabled = val
                            Core:ApplyMiscSettings()
                        end,
                    },
                    infoBarLocked = {
                        type = "toggle",
                        name = function() return MI().infoBarLocked and "解锁拖动" or "锁定展示条" end,
                        order = 2,
                        get = function() return MI().infoBarLocked end,
                        set = function(_, val)
                            MI().infoBarLocked = val
                            Core:ApplyMiscSettings()
                        end,
                    },
                    fontSize = {
                        type = "range",
                        name = "字体大小",
                        order = 3,
                        min = 10,
                        max = 24,
                        step = 1,
                        get = function() return MI().fontSize end,
                        set = function(_, val)
                            MI().fontSize = val
                            Core:UpdateMiscBarLayout()
                        end,
                    },
                    font = {
                        type = "select",
                        name = "字体",
                        order = 4,
                        dialogControl = "LSM30_Font",
                        values = LibSharedMedia:HashTable("font"),
                        get = function() return MI().font end,
                        set = function(_, val)
                            MI().font = val
                            Core:UpdateMiscBarLayout()
                        end,
                    },
                    barSpacing = {
                        type = "range",
                        name = "专精/耐久间隔",
                        order = 5,
                        min = 1,
                        max = 300,
                        step = 1,
                        get = function()
                            local value = MI().barSpacing or 18
                            return math.max(1, math.min(300, value))
                        end,
                        set = function(_, val)
                            MI().barSpacing = math.max(1, math.min(300, val))
                            Core:UpdateMiscBarLayout()
                        end,
                    },
                    barTips = {
                        type = "description",
                        name =
                        "左键切专精，右键切天赋；右侧显示耐久度百分比（60%以上绿色、30~60%黄色、30%以下红色），低于60%闪烁提示，悬停列出所有装备耐久（含图标）。",
                        order = 6,
                        width = "full",
                    },
                },
            },
            delveQuickLeave = {
                type = "group",
                name = "地下堡快速离开",
                order = 25,
                inline = true,
                args = {
                    delveQuickLeaveEnabled = {
                        type = "toggle",
                        name = "开启快速离开",
                        desc = "进入地下堡后显示快速离开图标，点击图标即可离开当前地下堡。",
                        order = 1,
                        get = function() return MI().delveQuickLeaveEnabled end,
                        set = function(_, val)
                            MI().delveQuickLeaveEnabled = val
                            Core:ApplyMiscSettings()
                        end,
                    },
                    delveQuickLeaveLocked = {
                        type = "toggle",
                        name = function() return MI().delveQuickLeaveLocked and "解锁框架" or "锁定框架" end,
                        order = 2,
                        disabled = function() return not MI().delveQuickLeaveEnabled end,
                        get = function() return MI().delveQuickLeaveLocked end,
                        set = function(_, val)
                            MI().delveQuickLeaveLocked = val
                            Core:ApplyMiscSettings()
                        end,
                    },
                    delveQuickLeaveIconSize = {
                        type = "range",
                        name = "图标大小",
                        order = 3,
                        min = 24,
                        max = 72,
                        step = 1,
                        disabled = function() return not MI().delveQuickLeaveEnabled end,
                        get = function() return MI().delveQuickLeaveIconSize or 40 end,
                        set = function(_, val)
                            MI().delveQuickLeaveIconSize = val
                            Core:ApplyMiscSettings()
                        end,
                    },
                    delveQuickLeaveTips = {
                        type = "description",
                        name = "使用传送图标作为地下堡快速离开按钮，仅在地下堡内显示；解锁后可拖动调整位置。",
                        order = 4,
                        width = "full",
                    },
                },
            },
            tooltip = {
                type = "group",
                name = "鼠标提示",
                order = 30,
                inline = true,
                args = {
                    tooltipFollowCursor = {
                        type = "toggle",
                        name = "鼠标提示跟随鼠标",
                        order = 1,
                        get = function() return MI().tooltipFollowCursor end,
                        set = function(_, val)
                            MI().tooltipFollowCursor = val
                            Core:ApplyGlobalTooltipHook()
                        end,
                    },
                    tooltipDesc = {
                        type = "description",
                        name = "启用后，游戏中所有提示框（含系统默认提示）都会跟随鼠标显示，而非固定在屏幕角落。",
                        order = 2,
                        width = "full",
                    },
                },
            },
        },
    }
end
