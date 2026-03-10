local addonName, ns = ...
local Core = ns.Core

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")

--------------------------------------------------------------------------------
-- 关于页面
--------------------------------------------------------------------------------
local function BuildAboutOptions()
    return {
        type = "group",
        name = "关于",
        order = 999,
        args = {
            header = {
                type = "header",
                name = "雨轩工具箱",
                order = 1,
            },
            version = {
                type = "description",
                name = function()
                    return "|cFFFFCC00版本：|r |cFF00FFFF" .. Core.VERSION .. "|r"
                end,
                order = 2,
                fontSize = "large",
            },
            spacer1 = { type = "description", name = " ", order = 3, width = "full" },
            desc = {
                type = "description",
                name = "|cFFCCCCCC雨轩工具箱是一个多功能魔兽世界插件合集，整合了多个实用功能模块。|r",
                order = 4,
                fontSize = "medium",
            },
            spacer2 = { type = "description", name = " ", order = 5, width = "full" },
            headerFeatures = {
                type = "header",
                name = "功能模块",
                order = 10,
            },
            feature1 = {
                type = "description",
                name = "|cFF33FF99●|r |cFFFFFFFF快捷频道|r - 快速切换聊天频道的浮动按钮条",
                order = 11,
                fontSize = "medium",
            },
            feature2 = {
                type = "description",
                name = "|cFF33FF99●|r |cFFFFFFFF任务助手|r - 任务通报与自动交接浮动按钮",
                order = 12,
                fontSize = "medium",
            },
            feature3 = {
                type = "description",
                name = "|cFF33FF99●|r |cFFFFFFFF团队标记|r - 快捷团队标记条、就位与倒计时",
                order = 13,
                fontSize = "medium",
            },
            feature4 = {
                type = "description",
                name = "|cFF33FF99●|r |cFFFFFFFF施法条|r - 可自定义样式的玩家和目标施法条",
                order = 14,
                fontSize = "medium",
            },
            feature5 = {
                type = "description",
                name = "|cFF33FF99●|r |cFFFFFFFF距离监控|r - 实时显示与目标的距离",
                order = 15,
                fontSize = "medium",
            },
            feature6 = {
                type = "description",
                name = "|cFF33FF99●|r |cFFFFFFFF属性面板|r - 显示角色关键属性的浮动面板",
                order = 16,
                fontSize = "medium",
            },
            feature7 = {
                type = "description",
                name = "|cFF33FF99●|r |cFFFFFFFF货币展示|r - 按游戏分组选择货币、自定义排列方向与展示样式",
                order = 17,
                fontSize = "medium",
            },
            feature8 = {
                type = "description",
                name = "|cFF33FF99●|r |cFFFFFFFF专精/天赋信息条|r - 显示当前专精、天赋方案与耐久度",
                order = 18,
                fontSize = "medium",
            },
            feature9 = {
                type = "description",
                name = "|cFF33FF99●|r |cFFFFFFFF升级提示|r - 动态显示升级效率与预计升级时间",
                order = 19,
                fontSize = "medium",
            },
            feature10 = {
                type = "description",
                name = "|cFF33FF99●|r |cFFFFFFFF副本难度助手|r - 快速切换难度、重置副本、传进/出与一键退出",
                order = 20,
                fontSize = "medium",
            },
            feature11 = {
                type = "description",
                name = "|cFF33FF99●|r |cFFFFFFFF地下堡快速离开|r - 地下堡内一键离开的浮动图标",
                order = 21,
                fontSize = "medium",
            },
            feature12 = {
                type = "description",
                name = "|cFF33FF99●|r |cFFFFFFFF收益计时器|r - 统计一段时间内的金币和经验变化",
                order = 22,
                fontSize = "medium",
            },
            feature13 = {
                type = "description",
                name = "|cFF33FF99●|r |cFFFFFFFF地图标记|r - 在地图上显示NPC和功能点位置，支持自定义坐标",
                order = 23,
                fontSize = "medium",
            },
            spacer3 = { type = "description", name = " ", order = 30, width = "full" },
            headerCommands = {
                type = "header",
                name = "常用命令",
                order = 40,
            },
            cmd1 = {
                type = "description",
                name = "|cFFFFFF00/yx|r - 打开设置窗口",
                order = 41,
                fontSize = "medium",
            },
            cmd2 = {
                type = "description",
                name = "|cFFFFFF00/yx lock|r - 锁定施法条",
                order = 42,
                fontSize = "medium",
            },
            cmd3 = {
                type = "description",
                name = "|cFFFFFF00/yx unlock|r - 解锁施法条（可拖动）",
                order = 43,
                fontSize = "medium",
            },
            cmd4 = {
                type = "description",
                name = "|cFFFFFF00/yxpin|r - 快速添加当前位置到地图标记",
                order = 44,
                fontSize = "medium",
            },
            cmd5 = {
                type = "description",
                name = "|cFFFFFF00/timer|r - 打开收益计时器窗口",
                order = 45,
                fontSize = "medium",
            },
            cmd6 = {
                type = "description",
                name = "|cFFFFFF00/c|r 或 |cFFFFFF00/yx diff|r - 显示/隐藏副本难度助手",
                order = 46,
                fontSize = "medium",
            },
            spacer4 = { type = "description", name = " ", order = 50, width = "full" },
            headerTips = {
                type = "header",
                name = "使用提示",
                order = 60,
            },
            tip1 = {
                type = "description",
                name = "|cFFCCCCCC• 拖动窗口：按住标题栏任意位置拖动|r",
                order = 61,
                fontSize = "medium",
            },
            tip2 = {
                type = "description",
                name = "|cFFCCCCCC• 配置档：可以创建多个配置档，在不同角色间切换|r",
                order = 62,
                fontSize = "medium",
            },
            tip3 = {
                type = "description",
                name = "|cFFCCCCCC• 地图标记：左键点击地图上的标记可设置导航点|r",
                order = 63,
                fontSize = "medium",
            },
        },
    }
end

--------------------------------------------------------------------------------
-- 主选项构建
-- 分组结构：
--   战斗辅助  (order=10)：快捷频道、施法条、距离监控、团队标记、任务助手
--   界面显示  (order=20)：专精信息条、属性面板、货币展示、升级提示、地下堡离开
--   副本工具  (order=30)：副本难度助手
--   地图探索  (order=40)：地图标记
--   系统调节  (order=50)：系统调节
--   配置档    (order=90)
--   关于      (order=999)
--------------------------------------------------------------------------------
local function GetOptions()
    return {
        name = "|cFF33FF99雨轩工具箱|r  v" .. Core.VERSION .. "  |cFFAAAAAA问题反馈QQ群：|r |cFF00FFFF1087904677|r",
        type = "group",
        childGroups = "tree",
        args = {
            -- ── 战斗辅助 ──────────────────────────────
            combat = {
                type = "group",
                name = "战斗辅助",
                order = 10,
                args = {
                    quickChat       = ns.BuildQuickChatOptions(),
                    castBar         = ns.BuildCastBarOptions(),
                    distanceMonitor = ns.BuildDistanceMonitorOptions(),
                    raidMarkers     = ns.BuildRaidMarkersOptions(),
                    questTools      = ns.BuildQuestToolsOptions(),
                },
            },
            -- ── 界面显示 ──────────────────────────────
            interface = {
                type = "group",
                name = "界面显示",
                order = 20,
                args = {
                    infoBar            = ns.BuildInfoBarOptions(),
                    attribute          = ns.BuildAttributeOptions(),
                    currency           = ns.BuildCurrencyOptions(),
                    levelingTip        = ns.BuildLevelingTipOptions(),
                    delveQuickLeave    = ns.BuildDelveQuickLeaveOptions(),
                    gameBar            = ns.BuildGameBarOptions(),
                    performanceMonitor = ns.BuildPerformanceMonitorOptions(),
                    chatBeautify       = ns.BuildChatBeautifyOptions(),
                },
            },
            -- ── 副本工具 ──────────────────────────────
            instance = {
                type = "group",
                name = "副本工具",
                order = 30,
                args = {
                    instanceDifficulty = ns.BuildInstanceDifficultyOptions(),
                },
            },
            -- ── 地图探索 ──────────────────────────────
            exploration = {
                type = "group",
                name = "地图探索",
                order = 40,
                args = {
                    mapGuide = ns.BuildMapGuideOptions(),
                },
            },
            -- ── 系统调节 ──────────────────────────────
            system = {
                type = "group",
                name = "系统调节",
                order = 50,
                args = {
                    systemAdjust = ns.BuildSystemAdjustOptions(),
                },
            },
            -- ── 配置档 ────────────────────────────────
            profiles = {
                type = "group",
                name = "配置档",
                order = 90,
                args = {},
            },
            -- ── 关于 ──────────────────────────────────
            about = BuildAboutOptions(),
        },
    }
end

--------------------------------------------------------------------------------
-- 优化AceConfigDialog窗口的拖动区域
--------------------------------------------------------------------------------
local function EnhanceDialogDrag()
    local frame = AceConfigDialog.OpenFrames[addonName]
    if not frame then return end

    local aceFrame = frame.frame
    if not aceFrame or aceFrame._dragEnhanced then return end
    aceFrame:SetUserPlaced(true)

    local function SaveDialogStatus()
        local obj = aceFrame.obj
        if not obj then return end
        local status = obj.status or obj.localstatus
        if not status then return end
        status.width = aceFrame:GetWidth()
        status.height = aceFrame:GetHeight()
        status.top = aceFrame:GetTop()
        status.left = aceFrame:GetLeft()
    end

    local dragRegion = CreateFrame("Frame", nil, aceFrame)
    dragRegion:SetPoint("TOPLEFT", aceFrame, "TOPLEFT", 0, 0)
    dragRegion:SetPoint("TOPRIGHT", aceFrame, "TOPRIGHT", -26, 0)
    dragRegion:SetHeight(28)
    dragRegion:EnableMouse(true)
    dragRegion:RegisterForDrag("LeftButton")
    dragRegion:SetScript("OnDragStart", function()
        aceFrame:StartMoving()
    end)
    dragRegion:SetScript("OnDragStop", function()
        aceFrame:StopMovingOrSizing()
        SaveDialogStatus()
    end)
    dragRegion:SetFrameLevel(aceFrame:GetFrameLevel() + 10)

    aceFrame._dragEnhanced = true
end

function ns.RegisterOptions(db)
    local options = GetOptions()
    local profiles = AceDBOptions:GetOptionsTable(db)
    profiles.order = 90
    options.args.profiles = profiles

    AceConfig:RegisterOptionsTable(addonName, options)
    AceConfigDialog:SetDefaultSize(addonName, 820, 620)

    if not AceConfigDialog._openHooked then
        hooksecurefunc(AceConfigDialog, "Open", function(_, name)
            if name == addonName then
                C_Timer.After(0.05, EnhanceDialogDrag)
            end
        end)
        AceConfigDialog._openHooked = true
    end
end
