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
        order = 100,
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
                name = "|cFF33FF99●|r |cFFFFFFFF属性面板|r - 显示角色关键属性的浮动面板",
                order = 12,
                fontSize = "medium",
            },
            feature3 = {
                type = "description",
                name = "|cFF33FF99●|r |cFFFFFFFF施法条|r - 可自定义样式的玩家和目标施法条",
                order = 13,
                fontSize = "medium",
            },
            feature4 = {
                type = "description",
                name = "|cFF33FF99●|r |cFFFFFFFF地图标记|r - 在地图上显示NPC和功能点位置，支持自定义坐标",
                order = 14,
                fontSize = "medium",
            },
            spacer3 = { type = "description", name = " ", order = 20, width = "full" },
            headerCommands = {
                type = "header",
                name = "常用命令",
                order = 30,
            },
            cmd1 = {
                type = "description",
                name = "|cFFFFFF00/yx|r - 打开设置窗口",
                order = 31,
                fontSize = "medium",
            },
            cmd2 = {
                type = "description",
                name = "|cFFFFFF00/yx lock|r - 锁定施法条",
                order = 32,
                fontSize = "medium",
            },
            cmd3 = {
                type = "description",
                name = "|cFFFFFF00/yx unlock|r - 解锁施法条（可拖动）",
                order = 33,
                fontSize = "medium",
            },
            cmd4 = {
                type = "description",
                name = "|cFFFFFF00/yxpin|r - 快速添加当前位置到地图标记",
                order = 34,
                fontSize = "medium",
            },
            spacer4 = { type = "description", name = " ", order = 40, width = "full" },
            headerTips = {
                type = "header",
                name = "使用提示",
                order = 50,
            },
            tip1 = {
                type = "description",
                name = "|cFFCCCCCC• 拖动窗口：按住标题栏任意位置拖动|r",
                order = 51,
                fontSize = "medium",
            },
            tip2 = {
                type = "description",
                name = "|cFFCCCCCC• 配置档：可以创建多个配置档，在不同角色间切换|r",
                order = 52,
                fontSize = "medium",
            },
            tip3 = {
                type = "description",
                name = "|cFFCCCCCC• 地图标记：左键点击地图上的标记可设置导航点|r",
                order = 53,
                fontSize = "medium",
            },
        },
    }
end

--------------------------------------------------------------------------------
-- 主选项构建
--------------------------------------------------------------------------------
local function GetOptions()
    return {
        name = "|cFF33FF99雨轩工具箱|r  v" .. Core.VERSION,
        type = "group",
        childGroups = "tab",
        args = {
            quickChat = ns.BuildQuickChatOptions(),
            attribute = ns.BuildAttributeOptions(),
            castBar = ns.BuildCastBarOptions(),
            mapGuide = ns.BuildMapGuideOptions(),
            profiles = {
                type = "group",
                name = "配置档",
                order = 90,
                args = {},
            },
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

    -- 获取标题栏区域
    local titlebar = aceFrame.titlebar or aceFrame.titlebg
    if not titlebar then
        -- 尝试查找标题栏背景
        for _, region in pairs({ aceFrame:GetRegions() }) do
            if region:GetObjectType() == "Texture" and region:GetDrawLayer() == "ARTWORK" then
                local _, _, _, _, y1 = region:GetPoint()
                if y1 and y1 > -30 then
                    titlebar = region
                    break
                end
            end
        end
    end

    -- 创建覆盖整个标题栏的拖动区域
    local dragRegion = CreateFrame("Frame", nil, aceFrame)
    dragRegion:SetPoint("TOPLEFT", aceFrame, "TOPLEFT", 0, 0)
    dragRegion:SetPoint("TOPRIGHT", aceFrame, "TOPRIGHT", -26, 0) -- 避开关闭按钮
    dragRegion:SetHeight(28)
    dragRegion:EnableMouse(true)
    dragRegion:RegisterForDrag("LeftButton")
    dragRegion:SetScript("OnDragStart", function()
        aceFrame:StartMoving()
    end)
    dragRegion:SetScript("OnDragStop", function()
        aceFrame:StopMovingOrSizing()
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

    -- Hook Open函数以增强拖动区域
    if not AceConfigDialog._openHooked then
        hooksecurefunc(AceConfigDialog, "Open", function(_, name)
            if name == addonName then
                C_Timer.After(0.05, EnhanceDialogDrag)
            end
        end)
        AceConfigDialog._openHooked = true
    end
end
