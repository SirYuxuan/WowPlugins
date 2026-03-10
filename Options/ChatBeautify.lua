local _, ns = ...
local Core = ns.Core
local LibSharedMedia = LibStub("LibSharedMedia-3.0")

local S = ns.OptionsShared
local CB = S.CHBcfg

function ns.BuildChatBeautifyOptions()
    return {
        type = "group",
        name = "聊天美化",
        order = 27,
        args = {
            enabled = {
                type = "toggle",
                name = "启用聊天美化",
                order = 1,
                get = function() return CB().enabled end,
                set = function(_, val)
                    CB().enabled = val
                    Core:ApplyChatBeautifySettings()
                end,
            },
            font = {
                type = "select",
                name = "聊天字体",
                order = 2,
                disabled = function() return not CB().enabled end,
                dialogControl = "LSM30_Font",
                values = LibSharedMedia:HashTable("font"),
                get = function() return CB().font end,
                set = function(_, val)
                    CB().font = val
                    Core:ApplyChatBeautifySettings()
                end,
            },
            fontSize = {
                type = "range",
                name = "字体大小",
                order = 3,
                disabled = function() return not CB().enabled end,
                min = 10,
                max = 20,
                step = 1,
                get = function() return CB().fontSize or 13 end,
                set = function(_, val)
                    CB().fontSize = val
                    Core:ApplyChatBeautifySettings()
                end,
            },
            backgroundAlpha = {
                type = "range",
                name = "聊天背景透明度",
                order = 4,
                disabled = function() return not CB().enabled end,
                min = 0,
                max = 0.5,
                step = 0.01,
                isPercent = true,
                get = function() return CB().backgroundAlpha or 0.12 end,
                set = function(_, val)
                    CB().backgroundAlpha = val
                    Core:ApplyChatBeautifySettings()
                end,
            },
            editBoxAlpha = {
                type = "range",
                name = "输入框背景透明度",
                order = 5,
                disabled = function() return not CB().enabled end,
                min = 0,
                max = 0.6,
                step = 0.01,
                isPercent = true,
                get = function() return CB().editBoxAlpha or 0.18 end,
                set = function(_, val)
                    CB().editBoxAlpha = val
                    Core:ApplyChatBeautifySettings()
                end,
            },
            tabAlpha = {
                type = "range",
                name = "标签透明度",
                order = 6,
                disabled = function() return not CB().enabled end,
                min = 0,
                max = 1,
                step = 0.01,
                isPercent = true,
                get = function() return CB().tabAlpha or 0.75 end,
                set = function(_, val)
                    CB().tabAlpha = val
                    Core:ApplyChatBeautifySettings()
                end,
            },
            hideMenuButton = {
                type = "toggle",
                name = "隐藏聊天菜单按钮",
                order = 7,
                disabled = function() return not CB().enabled end,
                get = function() return CB().hideMenuButton end,
                set = function(_, val)
                    CB().hideMenuButton = val
                    Core:ApplyChatBeautifySettings()
                end,
            },
            hideChannelButtons = {
                type = "toggle",
                name = "隐藏聊天侧边按钮",
                order = 8,
                disabled = function() return not CB().enabled end,
                get = function() return CB().hideChannelButtons end,
                set = function(_, val)
                    CB().hideChannelButtons = val
                    Core:ApplyChatBeautifySettings()
                end,
            },
            hideQuickJoinButton = {
                type = "toggle",
                name = "隐藏社交快速加入按钮",
                order = 9,
                disabled = function() return not CB().enabled end,
                get = function() return CB().hideQuickJoinButton end,
                set = function(_, val)
                    CB().hideQuickJoinButton = val
                    Core:ApplyChatBeautifySettings()
                end,
            },
            tips = {
                type = "description",
                name = "为聊天窗口添加简洁暗色背景、简化标签样式，并可隐藏菜单按钮、侧边按钮和快速加入按钮。",
                order = 20,
                width = "full",
            },
        },
    }
end
