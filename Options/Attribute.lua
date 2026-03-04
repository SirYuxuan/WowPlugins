local _, ns = ...
local Core = ns.Core
local LibSharedMedia = LibStub("LibSharedMedia-3.0")

local S = ns.OptionsShared
local AT = S.AT

function ns.BuildAttributeOptions()
    return {
        type = "group",
        name = "属性显示",
        order = 20,
        args = {
            basic = {
                type = "group",
                name = "基本",
                order = 10,
                inline = true,
                args = {
                    enabled = {
                        type = "toggle",
                        name = "启用属性显示",
                        order = 1,
                        get = function() return AT().enabled end,
                        set = function(_, val)
                            AT().enabled = val; Core:ApplyAttributeSettings()
                        end,
                    },
                    locked = {
                        type = "toggle",
                        order = 2,
                        name = function() return AT().locked and "解除锁定" or "锁定框架" end,
                        desc = "锁定后无法拖动",
                        get = function() return AT().locked end,
                        set = function(_, val)
                            AT().locked = val; Core:ApplyAttributeSettings()
                        end,
                    },
                    fontOutline = {
                        type = "toggle",
                        name = "字体轮廓",
                        order = 3,
                        get = function() return AT().fontOutline end,
                        set = function(_, val)
                            AT().fontOutline = val; Core:UpdateAttributeDisplay()
                        end,
                    },
                    showMinimapButton = {
                        type = "toggle",
                        name = "显示小地图按钮",
                        order = 4,
                        get = function() return not Core.db.profile.minimap.hide end,
                        set = function(_, val)
                            Core.db.profile.minimap.hide = not val; Core:UpdateMinimapIcon()
                        end,
                    },
                },
            },
            display = {
                type = "group",
                name = "属性开关与颜色",
                order = 20,
                args = {
                    ilvl_header = { type = "header", name = "装等", order = 1 },
                    showIlvl = {
                        type = "toggle",
                        name = "显示装等",
                        order = 2,
                        get = function() return AT().showIlvl end,
                        set = function(_, val)
                            AT().showIlvl = val; Core:UpdateAttributeDisplay()
                        end,
                    },
                    colorIlvl = {
                        type = "color",
                        name = "装等颜色",
                        order = 3,
                        hasAlpha = false,
                        get = function() return AT().colorIlvl.r, AT().colorIlvl.g, AT().colorIlvl.b end,
                        set = function(_, r, g, b)
                            AT().colorIlvl = { r = r, g = g, b = b }; Core:UpdateAttributeDisplay()
                        end,
                    },
                    primary_header = { type = "header", name = "主属性", order = 4 },
                    showPrimary = {
                        type = "toggle",
                        name = "显示主属性",
                        order = 5,
                        get = function() return AT().showPrimary end,
                        set = function(_, val)
                            AT().showPrimary = val; Core:UpdateAttributeDisplay()
                        end,
                    },
                    colorPrimary = {
                        type = "color",
                        name = "主属性颜色",
                        order = 6,
                        hasAlpha = false,
                        get = function() return AT().colorPrimary.r, AT().colorPrimary.g, AT().colorPrimary.b end,
                        set = function(_, r, g, b)
                            AT().colorPrimary = { r = r, g = g, b = b }; Core:UpdateAttributeDisplay()
                        end,
                    },
                    crit_header = { type = "header", name = "暴击", order = 7 },
                    showCrit = {
                        type = "toggle",
                        name = "显示暴击",
                        order = 8,
                        get = function() return AT().showCrit end,
                        set = function(_, val)
                            AT().showCrit = val; Core:UpdateAttributeDisplay()
                        end,
                    },
                    colorCrit = {
                        type = "color",
                        name = "暴击颜色",
                        order = 9,
                        hasAlpha = false,
                        get = function() return AT().colorCrit.r, AT().colorCrit.g, AT().colorCrit.b end,
                        set = function(_, r, g, b)
                            AT().colorCrit = { r = r, g = g, b = b }; Core:UpdateAttributeDisplay()
                        end,
                    },
                    haste_header = { type = "header", name = "急速", order = 10 },
                    showHaste = {
                        type = "toggle",
                        name = "显示急速",
                        order = 11,
                        get = function() return AT().showHaste end,
                        set = function(_, val)
                            AT().showHaste = val; Core:UpdateAttributeDisplay()
                        end,
                    },
                    colorHaste = {
                        type = "color",
                        name = "急速颜色",
                        order = 12,
                        hasAlpha = false,
                        get = function() return AT().colorHaste.r, AT().colorHaste.g, AT().colorHaste.b end,
                        set = function(_, r, g, b)
                            AT().colorHaste = { r = r, g = g, b = b }; Core:UpdateAttributeDisplay()
                        end,
                    },
                    mastery_header = { type = "header", name = "精通", order = 13 },
                    showMastery = {
                        type = "toggle",
                        name = "显示精通",
                        order = 14,
                        get = function() return AT().showMastery end,
                        set = function(_, val)
                            AT().showMastery = val; Core:UpdateAttributeDisplay()
                        end,
                    },
                    colorMastery = {
                        type = "color",
                        name = "精通颜色",
                        order = 15,
                        hasAlpha = false,
                        get = function() return AT().colorMastery.r, AT().colorMastery.g, AT().colorMastery.b end,
                        set = function(_, r, g, b)
                            AT().colorMastery = { r = r, g = g, b = b }; Core:UpdateAttributeDisplay()
                        end,
                    },
                    versa_header = { type = "header", name = "全能", order = 16 },
                    showVersa = {
                        type = "toggle",
                        name = "显示全能",
                        order = 17,
                        get = function() return AT().showVersa end,
                        set = function(_, val)
                            AT().showVersa = val; Core:UpdateAttributeDisplay()
                        end,
                    },
                    colorVersa = {
                        type = "color",
                        name = "全能颜色",
                        order = 18,
                        hasAlpha = false,
                        get = function() return AT().colorVersa.r, AT().colorVersa.g, AT().colorVersa.b end,
                        set = function(_, r, g, b)
                            AT().colorVersa = { r = r, g = g, b = b }; Core:UpdateAttributeDisplay()
                        end,
                    },
                    leech_header = { type = "header", name = "吸血", order = 19 },
                    showLeech = {
                        type = "toggle",
                        name = "显示吸血",
                        order = 20,
                        get = function() return AT().showLeech end,
                        set = function(_, val)
                            AT().showLeech = val; Core:UpdateAttributeDisplay()
                        end,
                    },
                    colorLeech = {
                        type = "color",
                        name = "吸血颜色",
                        order = 21,
                        hasAlpha = false,
                        get = function() return AT().colorLeech.r, AT().colorLeech.g, AT().colorLeech.b end,
                        set = function(_, r, g, b)
                            AT().colorLeech = { r = r, g = g, b = b }; Core:UpdateAttributeDisplay()
                        end,
                    },
                    dodge_header = { type = "header", name = "躲闪", order = 22 },
                    showDodge = {
                        type = "toggle",
                        name = "显示躲闪",
                        order = 23,
                        get = function() return AT().showDodge end,
                        set = function(_, val)
                            AT().showDodge = val; Core:UpdateAttributeDisplay()
                        end,
                    },
                    colorDodge = {
                        type = "color",
                        name = "躲闪颜色",
                        order = 24,
                        hasAlpha = false,
                        get = function() return AT().colorDodge.r, AT().colorDodge.g, AT().colorDodge.b end,
                        set = function(_, r, g, b)
                            AT().colorDodge = { r = r, g = g, b = b }; Core:UpdateAttributeDisplay()
                        end,
                    },
                    parry_header = { type = "header", name = "招架", order = 25 },
                    showParry = {
                        type = "toggle",
                        name = "显示招架",
                        order = 26,
                        get = function() return AT().showParry end,
                        set = function(_, val)
                            AT().showParry = val; Core:UpdateAttributeDisplay()
                        end,
                    },
                    colorParry = {
                        type = "color",
                        name = "招架颜色",
                        order = 27,
                        hasAlpha = false,
                        get = function() return AT().colorParry.r, AT().colorParry.g, AT().colorParry.b end,
                        set = function(_, r, g, b)
                            AT().colorParry = { r = r, g = g, b = b }; Core:UpdateAttributeDisplay()
                        end,
                    },
                    block_header = { type = "header", name = "格挡", order = 28 },
                    showBlock = {
                        type = "toggle",
                        name = "显示格挡",
                        order = 29,
                        get = function() return AT().showBlock end,
                        set = function(_, val)
                            AT().showBlock = val; Core:UpdateAttributeDisplay()
                        end,
                    },
                    colorBlock = {
                        type = "color",
                        name = "格挡颜色",
                        order = 30,
                        hasAlpha = false,
                        get = function() return AT().colorBlock.r, AT().colorBlock.g, AT().colorBlock.b end,
                        set = function(_, r, g, b)
                            AT().colorBlock = { r = r, g = g, b = b }; Core:UpdateAttributeDisplay()
                        end,
                    },
                    speed_header = { type = "header", name = "移动速度", order = 31 },
                    showSpeed = {
                        type = "toggle",
                        name = "显示移动速度",
                        order = 32,
                        get = function() return AT().showSpeed end,
                        set = function(_, val)
                            AT().showSpeed = val; Core:UpdateAttributeDisplay()
                        end,
                    },
                    colorSpeed = {
                        type = "color",
                        name = "移速颜色",
                        order = 33,
                        hasAlpha = false,
                        get = function() return AT().colorSpeed.r, AT().colorSpeed.g, AT().colorSpeed.b end,
                        set = function(_, r, g, b)
                            AT().colorSpeed = { r = r, g = g, b = b }; Core:UpdateAttributeDisplay()
                        end,
                    },
                },
            },
            size = {
                type = "group",
                name = "尺寸与背景",
                order = 30,
                args = {
                    fontSize = {
                        type = "range",
                        name = "字体尺寸",
                        order = 1,
                        min = 6,
                        max = 30,
                        step = 1,
                        get = function() return AT().fontSize end,
                        set = function(_, val)
                            AT().fontSize = val; Core:UpdateAttributeDisplay()
                        end,
                    },
                    lineSpacing = {
                        type = "range",
                        name = "行距",
                        order = 2,
                        min = 0,
                        max = 20,
                        step = 1,
                        get = function() return AT().lineSpacing end,
                        set = function(_, val)
                            AT().lineSpacing = val; Core:UpdateAttributeDisplay()
                        end,
                    },
                    decimalPlaces = {
                        type = "range",
                        name = "小数位数",
                        order = 3,
                        min = 0,
                        max = 2,
                        step = 1,
                        get = function() return AT().decimalPlaces end,
                        set = function(_, val)
                            AT().decimalPlaces = val; Core:UpdateAttributeDisplay()
                        end,
                    },
                    bgStyle = {
                        type = "select",
                        name = "背景样式",
                        order = 4,
                        values = { none = "无背景", semi = "半透明背景" },
                        get = function() return AT().bgStyle end,
                        set = function(_, val)
                            AT().bgStyle = val; Core:UpdateAttributeDisplay()
                        end,
                    },
                    bgAlpha = {
                        type = "range",
                        name = "背景不透明度",
                        order = 5,
                        desc = "仅当背景样式为\"半透明背景\"时有效",
                        min = 0,
                        max = 1,
                        step = 0.05,
                        get = function() return AT().bgAlpha end,
                        set = function(_, val)
                            AT().bgAlpha = val; Core:UpdateAttributeDisplay()
                        end,
                        disabled = function() return AT().bgStyle == "none" end,
                    },
                    progressBarHeader = { type = "header", name = "进度条", order = 6 },
                    progressBarEnable = {
                        type = "toggle",
                        name = "启用进度条",
                        order = 7,
                        get = function() return AT().progressBarEnable end,
                        set = function(_, val)
                            AT().progressBarEnable = val; Core:UpdateAttributeDisplay()
                        end,
                    },
                    progressBarTexture = {
                        type = "select",
                        name = "进度条材质",
                        order = 8,
                        dialogControl = "LSM30_Statusbar",
                        values = LibSharedMedia:HashTable("statusbar"),
                        get = function() return AT().progressBarTexture end,
                        set = function(_, val)
                            AT().progressBarTexture = val; Core:UpdateAttributeDisplay()
                        end,
                    },
                    progressBarColor = {
                        type = "color",
                        name = "进度条颜色",
                        order = 9,
                        hasAlpha = false,
                        get = function() return AT().progressBarColor.r, AT().progressBarColor.g, AT().progressBarColor
                            .b end,
                        set = function(_, r, g, b)
                            AT().progressBarColor = { r = r, g = g, b = b }; Core:UpdateAttributeDisplay()
                        end,
                    },
                    progressBarWidth = {
                        type = "range",
                        name = "进度条宽度",
                        order = 10,
                        min = 50,
                        max = 300,
                        step = 1,
                        get = function() return AT().progressBarWidth end,
                        set = function(_, val)
                            AT().progressBarWidth = val; Core:UpdateAttributeDisplay()
                        end,
                    },
                    progressBarHeight = {
                        type = "range",
                        name = "进度条高度",
                        order = 11,
                        min = 2,
                        max = 20,
                        step = 1,
                        get = function() return AT().progressBarHeight end,
                        set = function(_, val)
                            AT().progressBarHeight = val; Core:UpdateAttributeDisplay()
                        end,
                    },
                },
            },
            format = {
                type = "group",
                name = "格式选项",
                order = 40,
                args = {
                    font = {
                        type = "select",
                        name = "字体",
                        order = 1,
                        dialogControl = "LSM30_Font",
                        values = LibSharedMedia:HashTable("font"),
                        get = function() return AT().font end,
                        set = function(_, val)
                            AT().font = val; Core:UpdateAttributeDisplay()
                        end,
                    },
                    align = {
                        type = "select",
                        name = "文本对齐",
                        order = 2,
                        values = { LEFT = "左对齐", CENTER = "居中", RIGHT = "右对齐" },
                        get = function() return AT().align end,
                        set = function(_, val)
                            AT().align = val; Core:UpdateAttributeDisplay()
                        end,
                    },
                    visibility = {
                        type = "select",
                        name = "可见性",
                        order = 3,
                        values = { always = "始终", combat = "战斗中", noncombat = "非战斗中" },
                        get = function() return AT().visibility end,
                        set = function(_, val)
                            AT().visibility = val; Core:UpdateAttributeVisibility()
                        end,
                    },
                    ilvlFormat = {
                        type = "select",
                        name = "装等格式",
                        order = 4,
                        values = { real = "仅实装", both = "实装+虚装" },
                        get = function() return AT().ilvlFormat end,
                        set = function(_, val)
                            AT().ilvlFormat = val; Core:UpdateAttributeDisplay()
                        end,
                    },
                    secondaryFormat = {
                        type = "select",
                        name = "副属性格式",
                        order = 5,
                        values = { percent = "仅百分比", ["number+percent"] = "数字+百分比" },
                        get = function() return AT().secondaryFormat end,
                        set = function(_, val)
                            AT().secondaryFormat = val; Core:UpdateAttributeDisplay()
                        end,
                    },
                    speedFormat = {
                        type = "select",
                        name = "移动速度格式",
                        order = 6,
                        values = { current = "当前速度", static = "静态速度" },
                        get = function() return AT().speedFormat end,
                        set = function(_, val)
                            AT().speedFormat = val; Core:UpdateAttributeDisplay()
                        end,
                    },
                    maxIlvl = {
                        type = "input",
                        name = "当前赛季最大装等",
                        order = 7,
                        desc = "用于装等进度条的最大参考值",
                        get = function() return tostring(AT().maxIlvl) end,
                        set = function(_, val)
                            local num = tonumber(val)
                            if num and num > 0 then
                                AT().maxIlvl = num
                                Core:UpdateAttributeDisplay()
                            else
                                print("请输入有效的数字")
                            end
                        end,
                    },
                },
            },
        },
    }
end
