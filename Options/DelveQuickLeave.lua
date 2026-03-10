local _, ns = ...
local Core = ns.Core

local S = ns.OptionsShared
local MI = S.MIcfg

local DELVE_QUICK_LEAVE_ICON_OPTIONS = {
    ["Interface\\Icons\\spell_arcane_teleportdalaran"] =
    "|TInterface\\Icons\\spell_arcane_teleportdalaran:16:16:0:0|t 达拉然传送",
    ["Interface\\Icons\\inv_misc_rune_01"] = "|TInterface\\Icons\\inv_misc_rune_01:16:16:0:0|t 符文石",
    ["Interface\\Icons\\ability_mage_massinvisibility"] =
    "|TInterface\\Icons\\ability_mage_massinvisibility:16:16:0:0|t 奥术漩涡",
    ["Interface\\Icons\\achievement_dungeon_ulduar80_raid_normal"] =
    "|TInterface\\Icons\\achievement_dungeon_ulduar80_raid_normal:16:16:0:0|t 地城徽记",
    ["Interface\\Icons\\inv_111_achievement_delves_season1"] =
    "|TInterface\\Icons\\inv_111_achievement_delves_season1:16:16:0:0|t 地下堡徽记",
    ["Interface\\Icons\\spell_shadow_teleport"] = "|TInterface\\Icons\\spell_shadow_teleport:16:16:0:0|t 暗影传送",
}

function ns.BuildDelveQuickLeaveOptions()
    return {
        type = "group",
        name = "地下堡快速离开",
        order = 82,
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
            delveQuickLeaveIconPreset = {
                type = "select",
                name = "预设图标",
                order = 4,
                disabled = function() return not MI().delveQuickLeaveEnabled end,
                values = DELVE_QUICK_LEAVE_ICON_OPTIONS,
                get = function()
                    return MI().delveQuickLeaveIconPreset or "Interface\\Icons\\spell_arcane_teleportdalaran"
                end,
                set = function(_, val)
                    MI().delveQuickLeaveIconPreset = val
                    Core:ApplyMiscSettings()
                end,
            },
            delveQuickLeaveCustomIcon = {
                type = "input",
                name = "自定义图标",
                order = 5,
                width = 1.6,
                disabled = function() return not MI().delveQuickLeaveEnabled end,
                desc = "可填写图标路径或文件ID；留空时使用上方预设图标。",
                get = function() return MI().delveQuickLeaveCustomIcon or "" end,
                set = function(_, val)
                    MI().delveQuickLeaveCustomIcon = val or ""
                    Core:ApplyMiscSettings()
                end,
            },
            delveQuickLeaveTips = {
                type = "description",
                name = "按钮仅在地下堡内显示；可从预设里选图标，也可输入自定义图标路径/文件ID；解锁后可拖动调整位置。",
                order = 6,
                width = "full",
            },
        },
    }
end
