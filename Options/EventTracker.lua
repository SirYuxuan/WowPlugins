local addonName, ns = ...
local Core = ns.Core
local ETD = ns.EventTrackerData

--------------------------------------------------------------------------------
-- 事件追踪器 - 选项面板
--------------------------------------------------------------------------------

function ns.BuildEventTrackerOptions()
    return {
        type = "group",
        name = "事件追踪器",
        order = 10,
        args = {
            header = {
                type = "header",
                name = "事件追踪器",
                order = 1,
            },
            desc = {
                type = "description",
                name = "|cFFCCCCCC在世界地图下方显示循环事件计时与周常任务完成状态。\n支持至暗之夜、剧团演出、暴行突袭等事件追踪。|r",
                order = 2,
                fontSize = "medium",
            },
            spacer1 = { type = "description", name = " ", order = 3, width = "full" },

            -- ── 基本设置 ──
            enabled = {
                type = "toggle",
                name = "启用事件追踪器",
                desc = "在世界地图下方显示事件追踪面板",
                order = 10,
                width = "full",
                get = function() return Core.db.profile.eventTracker.enabled end,
                set = function(_, val)
                    Core.db.profile.eventTracker.enabled = val
                    if Core.ApplyEventTrackerSettings then Core:ApplyEventTrackerSettings() end
                end,
            },

            headerStyle = {
                type = "header",
                name = "样式设置",
                order = 20,
            },

            fontSize = {
                type = "range",
                name = "字体大小",
                order = 21,
                min = 9,
                max = 18,
                step = 1,
                get = function() return Core.db.profile.eventTracker.fontSize or 12 end,
                set = function(_, val)
                    Core.db.profile.eventTracker.fontSize = val
                    if Core.ApplyEventTrackerFonts then Core:ApplyEventTrackerFonts() end
                    if Core.UpdateEventTrackers then Core:UpdateEventTrackers() end
                end,
            },

            fontOutline = {
                type = "toggle",
                name = "字体描边",
                desc = "为字体添加描边效果，增强可读性",
                order = 22,
                get = function() return Core.db.profile.eventTracker.fontOutline end,
                set = function(_, val)
                    Core.db.profile.eventTracker.fontOutline = val
                    if Core.ApplyEventTrackerFonts then Core:ApplyEventTrackerFonts() end
                end,
            },

            trackerWidth = {
                type = "range",
                name = "追踪器宽度",
                order = 23,
                min = 160,
                max = 320,
                step = 5,
                get = function() return Core.db.profile.eventTracker.trackerWidth or 220 end,
                set = function(_, val)
                    Core.db.profile.eventTracker.trackerWidth = val
                    if Core.UpdateEventTrackers then Core:UpdateEventTrackers() end
                end,
            },

            trackerHeight = {
                type = "range",
                name = "追踪器高度",
                order = 24,
                min = 22,
                max = 40,
                step = 1,
                get = function() return Core.db.profile.eventTracker.trackerHeight or 28 end,
                set = function(_, val)
                    Core.db.profile.eventTracker.trackerHeight = val
                    if Core.UpdateEventTrackers then Core:UpdateEventTrackers() end
                end,
            },

            backdropAlpha = {
                type = "range",
                name = "背景透明度",
                order = 25,
                min = 0,
                max = 1,
                step = 0.05,
                isPercent = true,
                get = function() return Core.db.profile.eventTracker.backdropAlpha or 0.6 end,
                set = function(_, val)
                    Core.db.profile.eventTracker.backdropAlpha = val
                    if Core.UpdateEventTrackers then Core:UpdateEventTrackers() end
                end,
            },

            -- ── 通知设置 ──
            headerAlert = {
                type = "header",
                name = "通知设置",
                order = 30,
            },

            alertEnabled = {
                type = "toggle",
                name = "事件提前通知",
                desc = "循环事件即将开始时在聊天框提示",
                order = 31,
                get = function() return Core.db.profile.eventTracker.alertEnabled end,
                set = function(_, val)
                    Core.db.profile.eventTracker.alertEnabled = val
                end,
            },

            alertSecond = {
                type = "range",
                name = "提前通知时间(秒)",
                desc = "事件开始前多少秒发送通知",
                order = 32,
                min = 15,
                max = 300,
                step = 5,
                get = function() return Core.db.profile.eventTracker.alertSecond or 60 end,
                set = function(_, val)
                    Core.db.profile.eventTracker.alertSecond = val
                end,
            },

            -- ── 事件开关 ──
            headerEvents = {
                type = "header",
                name = "事件开关",
                order = 40,
            },

            eventsDesc = {
                type = "description",
                name = "|cFFCCCCCC勾选要追踪的事件，取消勾选则隐藏对应追踪器。|r",
                order = 41,
                fontSize = "medium",
            },

            -- 午夜事件分组标题
            headerMN = {
                type = "description",
                name = "\n|cFFFF8800── 午夜 (Midnight) ──|r",
                order = 50,
                fontSize = "medium",
                width = "full",
            },

            weeklyMN = {
                type = "toggle",
                name = "周常任务 (午夜)",
                order = 51,
                get = function() return Core.db.profile.eventTracker.weeklyMN end,
                set = function(_, val)
                    Core.db.profile.eventTracker.weeklyMN = val
                    if Core.UpdateEventTrackers then Core:UpdateEventTrackers() end
                end,
            },

            professionsWeeklyMN = {
                type = "toggle",
                name = "专业周常 (午夜)",
                order = 52,
                get = function() return Core.db.profile.eventTracker.professionsWeeklyMN end,
                set = function(_, val)
                    Core.db.profile.eventTracker.professionsWeeklyMN = val
                    if Core.UpdateEventTrackers then Core:UpdateEventTrackers() end
                end,
            },

            stormarionAssault = {
                type = "toggle",
                name = "暴行突袭",
                order = 53,
                get = function() return Core.db.profile.eventTracker.stormarionAssault end,
                set = function(_, val)
                    Core.db.profile.eventTracker.stormarionAssault = val
                    if Core.UpdateEventTrackers then Core:UpdateEventTrackers() end
                end,
            },

            -- TWW事件分组标题
            headerTWW = {
                type = "description",
                name = "\n|cFF00CCFF── 地心之战 (The War Within) ──|r",
                order = 60,
                fontSize = "medium",
                width = "full",
            },

            weeklyTWW = {
                type = "toggle",
                name = "周常任务 (地心之战)",
                order = 61,
                get = function() return Core.db.profile.eventTracker.weeklyTWW end,
                set = function(_, val)
                    Core.db.profile.eventTracker.weeklyTWW = val
                    if Core.UpdateEventTrackers then Core:UpdateEventTrackers() end
                end,
            },

            nightfall = {
                type = "toggle",
                name = "至暗之夜",
                order = 62,
                get = function() return Core.db.profile.eventTracker.nightfall end,
                set = function(_, val)
                    Core.db.profile.eventTracker.nightfall = val
                    if Core.UpdateEventTrackers then Core:UpdateEventTrackers() end
                end,
            },

            theaterTroupe = {
                type = "toggle",
                name = "剧团演出",
                order = 63,
                get = function() return Core.db.profile.eventTracker.theaterTroupe end,
                set = function(_, val)
                    Core.db.profile.eventTracker.theaterTroupe = val
                    if Core.UpdateEventTrackers then Core:UpdateEventTrackers() end
                end,
            },

            ecologicalSuccession = {
                type = "toggle",
                name = "生态重构",
                order = 64,
                get = function() return Core.db.profile.eventTracker.ecologicalSuccession end,
                set = function(_, val)
                    Core.db.profile.eventTracker.ecologicalSuccession = val
                    if Core.UpdateEventTrackers then Core:UpdateEventTrackers() end
                end,
            },

            ringingDeeps = {
                type = "toggle",
                name = "回响深渊",
                order = 65,
                get = function() return Core.db.profile.eventTracker.ringingDeeps end,
                set = function(_, val)
                    Core.db.profile.eventTracker.ringingDeeps = val
                    if Core.UpdateEventTrackers then Core:UpdateEventTrackers() end
                end,
            },

            spreadingTheLight = {
                type = "toggle",
                name = "散布光芒",
                order = 66,
                get = function() return Core.db.profile.eventTracker.spreadingTheLight end,
                set = function(_, val)
                    Core.db.profile.eventTracker.spreadingTheLight = val
                    if Core.UpdateEventTrackers then Core:UpdateEventTrackers() end
                end,
            },

            underworldOperative = {
                type = "toggle",
                name = "暗影行动",
                order = 67,
                get = function() return Core.db.profile.eventTracker.underworldOperative end,
                set = function(_, val)
                    Core.db.profile.eventTracker.underworldOperative = val
                    if Core.UpdateEventTrackers then Core:UpdateEventTrackers() end
                end,
            },
        },
    }
end
