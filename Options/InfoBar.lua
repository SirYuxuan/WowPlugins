local _, ns = ...
local Core = ns.Core
local LibSharedMedia = LibStub("LibSharedMedia-3.0")

local S = ns.OptionsShared
local MI = S.MIcfg

function ns.BuildInfoBarOptions()
    return {
        type = "group",
        name = "专精/天赋信息条",
        order = 10,
        args = {
            infoBarEnabled = {
                type = "toggle",
                name = "启用信息条",
                order = 1,
                get = function() return MI().infoBarEnabled end,
                set = function(_, val)
                    MI().infoBarEnabled = val
                    Core:ApplyMiscSettings()
                end,
            },
            infoBarLocked = {
                type = "toggle",
                name = function() return S.GetLockLayoutToggleName(MI().infoBarLocked) end,
                order = 2,
                get = function() return MI().infoBarLocked end,
                set = function(_, val)
                    MI().infoBarLocked = val
                    Core:ApplyMiscSettings()
                end,
            },
            orientation = {
                type = "select",
                name = "排列方向",
                order = 3,
                values = {
                    HORIZONTAL = "横排",
                    VERTICAL = "竖排",
                },
                get = function() return MI().infoBarOrientation or "HORIZONTAL" end,
                set = function(_, val)
                    MI().infoBarOrientation = val
                    Core:UpdateMiscBarLayout()
                end,
            },
            fontSize = {
                type = "range",
                name = "字体大小",
                order = 4,
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
                order = 5,
                dialogControl = "LSM30_Font",
                values = LibSharedMedia:HashTable("font"),
                get = function() return MI().font end,
                set = function(_, val)
                    MI().font = val
                    Core:UpdateMiscBarLayout()
                end,
            },
            textColor = {
                type = "color",
                name = "文字颜色",
                order = 6,
                hasAlpha = false,
                get = function()
                    local c = MI().textColor or { r = 1, g = 1, b = 1 }
                    return c.r, c.g, c.b
                end,
                set = function(_, r, g, b)
                    MI().textColor = { r = r, g = g, b = b }
                    Core:UpdateMiscBarLayout()
                end,
            },
            barSpacing = {
                type = "range",
                name = "项目间隔",
                order = 7,
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
        },
    }
end
