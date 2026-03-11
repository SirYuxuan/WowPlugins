local _, ns = ...
local Core = ns.Core
local LibSharedMedia = LibStub("LibSharedMedia-3.0")

local S = ns.OptionsShared
local ID = S.IDcfg

function ns.BuildInstanceDifficultyOptions()
    return {
        type = "group",
        name = "副本难度助手",
        order = 10,
        args = {
            enabled = {
                type = "toggle",
                name = "启用副本难度助手",
                order = 1,
                get = function() return ID().enabled end,
                set = function(_, val)
                    ID().enabled = val
                    if val and ID().visible == nil then
                        ID().visible = ID().showOnLogin ~= false
                    end
                    Core:ApplyInstanceDifficultySettings()
                end,
            },
            visible = {
                type = "toggle",
                name = "显示窗口",
                order = 2,
                disabled = function() return not ID().enabled end,
                get = function() return ID().visible end,
                set = function(_, val)
                    ID().visible = val
                    Core:ApplyInstanceDifficultySettings()
                end,
            },
            locked = {
                type = "toggle",
                name = function() return ID().locked and "解锁拖动" or "锁定框体" end,
                order = 3,
                disabled = function() return not ID().enabled end,
                get = function() return ID().locked end,
                set = function(_, val)
                    ID().locked = val
                    Core:ApplyInstanceDifficultySettings()
                end,
            },
            frameScale = {
                type = "range",
                name = "窗口缩放",
                order = 4,
                min = 0.7,
                max = 1.5,
                step = 0.05,
                disabled = function() return not ID().enabled end,
                get = function() return ID().frameScale or 1 end,
                set = function(_, val)
                    ID().frameScale = val
                    Core:ApplyInstanceDifficultySettings()
                end,
            },
            fontSize = {
                type = "range",
                name = "字体大小",
                order = 5,
                min = 10,
                max = 24,
                step = 1,
                disabled = function() return not ID().enabled end,
                get = function() return ID().fontSize or 13 end,
                set = function(_, val)
                    ID().fontSize = val
                    Core:ApplyInstanceDifficultySettings()
                end,
            },
            fontOutline = {
                type = "toggle",
                name = "字体描边",
                order = 6,
                disabled = function() return not ID().enabled end,
                get = function() return ID().fontOutline ~= false end,
                set = function(_, val)
                    ID().fontOutline = val
                    Core:ApplyInstanceDifficultySettings()
                end,
            },
            orientation = {
                type = "select",
                name = "布局方向",
                order = 7,
                disabled = function() return not ID().enabled end,
                values = {
                    VERTICAL = "竖排",
                    HORIZONTAL = "横排",
                },
                get = function() return ID().orientation or "VERTICAL" end,
                set = function(_, val)
                    ID().orientation = val
                    Core:ApplyInstanceDifficultySettings()
                end,
            },
            backgroundTexture = {
                type = "select",
                dialogControl = "LSM30_Statusbar",
                name = "背景纹理",
                order = 8,
                disabled = function() return not ID().enabled end,
                values = LibSharedMedia:HashTable("statusbar"),
                get = function() return ID().backgroundTexture or "Yuxuan" end,
                set = function(_, val)
                    ID().backgroundTexture = val
                    Core:ApplyInstanceDifficultySettings()
                end,
            },
            backgroundAlpha = {
                type = "range",
                name = "背景透明度",
                order = 9,
                min = 0,
                max = 1,
                step = 0.01,
                isPercent = true,
                disabled = function() return not ID().enabled end,
                get = function() return ID().backgroundAlpha or 0.18 end,
                set = function(_, val)
                    ID().backgroundAlpha = val
                    Core:ApplyInstanceDifficultySettings()
                end,
            },
            autoCollapseInInstance = {
                type = "toggle",
                name = "进入副本自动收缩",
                order = 10,
                disabled = function() return not ID().enabled end,
                get = function() return ID().autoCollapseInInstance end,
                set = function(_, val)
                    ID().autoCollapseInInstance = val
                    Core:ApplyInstanceDifficultySettings()
                end,
            },
            showCenterToast = {
                type = "toggle",
                name = "进入副本中央提示",
                order = 11,
                disabled = function() return not ID().enabled end,
                get = function() return ID().showCenterToast end,
                set = function(_, val)
                    ID().showCenterToast = val
                    Core:ApplyInstanceDifficultySettings()
                end,
            },
            centerToastDuration = {
                type = "range",
                name = "中央提示时长",
                order = 12,
                min = 1,
                max = 8,
                step = 1,
                disabled = function() return not ID().enabled or not ID().showCenterToast end,
                get = function() return ID().centerToastDuration or 3 end,
                set = function(_, val)
                    ID().centerToastDuration = val
                end,
            },
            ttsEnabled = {
                type = "toggle",
                name = "启用难度播报",
                order = 13,
                disabled = function() return not ID().enabled end,
                get = function() return ID().ttsEnabled end,
                set = function(_, val)
                    ID().ttsEnabled = val
                end,
            },
            ttsVolume = {
                type = "range",
                name = "播报音量",
                order = 14,
                min = 0,
                max = 100,
                step = 5,
                disabled = function() return not ID().enabled or not ID().ttsEnabled end,
                get = function() return ID().ttsVolume or 100 end,
                set = function(_, val)
                    ID().ttsVolume = val
                end,
            },
            announceToChat = {
                type = "toggle",
                name = "动作同步到队伍/团队",
                order = 15,
                disabled = function() return not ID().enabled end,
                get = function() return ID().announceToChat end,
                set = function(_, val)
                    ID().announceToChat = val
                end,
            },
            showResetButton = {
                type = "toggle",
                name = "显示重置副本",
                order = 20,
                disabled = function() return not ID().enabled end,
                get = function() return ID().showResetButton end,
                set = function(_, val)
                    ID().showResetButton = val
                    Core:ApplyInstanceDifficultySettings()
                end,
            },
            showTeleportButton = {
                type = "toggle",
                name = "显示传进/出副本",
                order = 21,
                disabled = function() return not ID().enabled end,
                get = function() return ID().showTeleportButton end,
                set = function(_, val)
                    ID().showTeleportButton = val
                    Core:ApplyInstanceDifficultySettings()
                end,
            },
            showLeaveButton = {
                type = "toggle",
                name = "显示一键退出",
                order = 22,
                disabled = function() return not ID().enabled end,
                get = function() return ID().showLeaveButton end,
                set = function(_, val)
                    ID().showLeaveButton = val
                    Core:ApplyInstanceDifficultySettings()
                end,
            },
            quickActions = {
                type = "group",
                name = "快捷操作",
                order = 30,
                inline = true,
                args = {
                    toggleFrame = {
                        type = "execute",
                        name = "显示/隐藏窗口",
                        order = 1,
                        func = function()
                            Core:ToggleInstanceDifficultyFrame()
                        end,
                    },
                    resetInstance = {
                        type = "execute",
                        name = "立即重置副本",
                        order = 2,
                        func = function()
                            Core:ResetCurrentInstances()
                        end,
                    },
                    quickLeave = {
                        type = "execute",
                        name = "立即一键退出",
                        order = 3,
                        func = function()
                            Core:QuickLeaveInstance()
                        end,
                    },
                },
            },
        },
    }
end
