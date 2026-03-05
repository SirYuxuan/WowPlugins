local addonName, ns = ...
local Core = ns.Core
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

local S = ns.OptionsShared
local MGcfg = S.MGcfg

--------------------------------------------------------------------------------
-- 本地状态变量
--------------------------------------------------------------------------------
local quickAddTitle = ""
local quickAddNote = ""
local quickAddColor = { r = 0.2, g = 1, b = 0.73 }
local quickAddStatus = ""

local importExportText = ""
local importExportStatus = ""

-- 自定义坐标列表分页状态
local customListPage = 1
local customListPerPage = 10

--------------------------------------------------------------------------------
-- 工具函数
--------------------------------------------------------------------------------
local function ResolveDefaultQuickColor()
    local c = Core.db and Core.db.global and Core.db.global.customMarkerLastColor
    if type(c) == "table" then
        quickAddColor = {
            r = tonumber(c.r) or 0.2,
            g = tonumber(c.g) or 1,
            b = tonumber(c.b) or 0.73,
        }
    end
end

local function NotifyOptionsChanged()
    AceConfigRegistry:NotifyChange(addonName)
end

--------------------------------------------------------------------------------
-- 城市配置构建器（简洁模式：只有开关，无缩放）
--------------------------------------------------------------------------------
local function BuildCityArgs(cities, columns)
    columns = columns or 4
    local a = {}
    local colWidth = 3.0 / columns
    for i, c in ipairs(cities) do
        local key, label = c[1], c[2]
        a["show" .. key] = {
            type = "toggle",
            name = label,
            order = i,
            width = colWidth,
            get = function() return MGcfg()["show" .. key] end,
            set = function(_, v)
                MGcfg()["show" .. key] = v
                Core:ToggleMapMarkers()
            end,
        }
    end
    return a
end

--------------------------------------------------------------------------------
-- 自定义坐标列表构建器（带分页）
--------------------------------------------------------------------------------
local function BuildCustomMarkerListArgs(onChanged)
    local args = {}
    local allRows = Core:GetMapGuideCustomMarkerList() or {}
    local totalCount = #allRows
    local totalPages = math.max(1, math.ceil(totalCount / customListPerPage))

    -- 修正当前页码
    if customListPage > totalPages then customListPage = totalPages end
    if customListPage < 1 then customListPage = 1 end

    -- 空列表提示
    if totalCount == 0 then
        args.empty = {
            type = "description",
            name = "|cFF888888暂无自定义坐标。|r\n可在上方[坐标扩展]中添加，或在[坐标导入导出]中导入。",
            order = 1,
            fontSize = "medium",
        }
        return args
    end

    -- 分页信息
    args.pageInfo = {
        type = "description",
        name = function()
            return string.format("|cFFFFCC00第 %d/%d 页|r  （共 %d 条坐标）", customListPage, totalPages, totalCount)
        end,
        order = 1,
        fontSize = "medium",
        width = 1.2,
    }

    -- 上一页按钮
    args.prevPage = {
        type = "execute",
        name = "上一页",
        order = 2,
        width = 0.6,
        disabled = function() return customListPage <= 1 end,
        func = function()
            customListPage = math.max(1, customListPage - 1)
            if onChanged then onChanged() end
        end,
    }

    -- 下一页按钮
    args.nextPage = {
        type = "execute",
        name = "下一页",
        order = 3,
        width = 0.6,
        disabled = function() return customListPage >= totalPages end,
        func = function()
            customListPage = math.min(totalPages, customListPage + 1)
            if onChanged then onChanged() end
        end,
    }

    -- 分隔线
    args.sep1 = {
        type = "description",
        name = " ",
        order = 4,
        width = "full",
    }

    -- 计算当前页显示的条目
    local startIdx = (customListPage - 1) * customListPerPage + 1
    local endIdx = math.min(startIdx + customListPerPage - 1, totalCount)

    local displayOrder = 10
    for i = startIdx, endIdx do
        local row = allRows[i]
        if row then
            local displayTitle = (row.title and row.title ~= "") and row.title or ("未命名坐标")
            local mapName = row.mapName or ("MapID " .. tostring(row.mapID or "?"))
            local x = tonumber(row.x) or 0
            local y = tonumber(row.y) or 0
            local noteText = row.note or ""
            local colorHex = row.colorHex or "33FF99"

            -- 标记序号（全局序号）
            local rowKey = "row_" .. i

            args[rowKey] = {
                type = "group",
                name = string.format("|cFF%s●|r %s", colorHex, displayTitle),
                order = displayOrder,
                inline = true,
                args = {
                    info = {
                        type = "description",
                        name = string.format(
                            "|cFFCCCCCC地图:|r %s    |cFFCCCCCC坐标:|r %.2f, %.2f    |cFFCCCCCC颜色:|r #%s%s",
                            mapName, x, y, colorHex,
                            (noteText ~= "" and ("    |cFFCCCCCC备注:|r " .. noteText) or "")
                        ),
                        order = 1,
                        width = 2.6,
                        fontSize = "medium",
                    },
                    remove = {
                        type = "execute",
                        name = "删除",
                        order = 2,
                        width = 0.5,
                        confirm = true,
                        confirmText = "确定删除坐标「" .. displayTitle .. "」吗？",
                        func = function()
                            if Core:RemoveMapGuideCustomMarker(row.mapID, row.index) then
                                quickAddStatus = "已删除：" .. displayTitle
                                if onChanged then onChanged() end
                            end
                        end,
                    },
                },
            }
            displayOrder = displayOrder + 1
        end
    end

    return args
end

--------------------------------------------------------------------------------
-- 主函数：构建地图标记选项
--------------------------------------------------------------------------------
function ns.BuildMapGuideOptions()
    local group
    local function RefreshCustomMarkerList()
        if not group or not group.args or not group.args.coordExtend then return end
        local listGroup = group.args.coordExtend.args.customMarkerList
        if not listGroup then return end
        listGroup.args = BuildCustomMarkerListArgs(function()
            RefreshCustomMarkerList()
            NotifyOptionsChanged()
        end)
    end

    group = {
        type = "group",
        name = "地图标记",
        order = 40,
        childGroups = "tab",
        args = {
            -- ====================================================================================
            -- Tab 1: 地图增强
            -- ====================================================================================
            mapEnhance = {
                type = "group",
                name = "地图增强",
                order = 1,
                args = {
                    -- 总开关和全局设置
                    headerMain = {
                        type = "header",
                        name = "全地图NPC标记",
                        order = 1,
                    },
                    enableMapMarkers = {
                        type = "toggle",
                        name = "启用全地图NPC标记",
                        desc = "在地图上显示NPC和功能点位置",
                        order = 2,
                        width = 1.2,
                        get = function() return MGcfg().enableMapMarkers end,
                        set = function(_, v)
                            MGcfg().enableMapMarkers = v
                            Core:ToggleMapMarkers()
                        end,
                    },
                    globalMarkerSize = {
                        type = "range",
                        name = "标记大小",
                        order = 3,
                        width = 1.0,
                        min = 8,
                        max = 20,
                        step = 1,
                        get = function() return MGcfg().globalMarkerSize end,
                        set = function(_, v)
                            MGcfg().globalMarkerSize = v
                            Core:ToggleMapMarkers()
                        end,
                    },
                    mapMarkerType = {
                        type = "select",
                        name = "显示类型",
                        order = 4,
                        width = 0.8,
                        values = { TEXT = "文本", ICON = "图标" },
                        get = function() return MGcfg().mapMarkerType end,
                        set = function(_, v)
                            MGcfg().mapMarkerType = v
                            Core:ToggleMapMarkers()
                        end,
                    },
                    mapMarkerTextOutline = {
                        type = "select",
                        name = "文本样式",
                        order = 5,
                        width = 0.8,
                        values = { [""] = "普通", OUTLINE = "描边", THICKOUTLINE = "粗描边" },
                        get = function() return MGcfg().mapMarkerTextOutline end,
                        set = function(_, v)
                            MGcfg().mapMarkerTextOutline = v
                            Core:ToggleMapMarkers()
                        end,
                    },
                    mapMarkerIconGlow = {
                        type = "select",
                        name = "图标样式",
                        order = 6,
                        width = 0.8,
                        values = { [""] = "普通", GLOW = "发光" },
                        get = function() return MGcfg().mapMarkerIconGlow end,
                        set = function(_, v)
                            MGcfg().mapMarkerIconGlow = v
                            Core:ToggleMapMarkers()
                        end,
                    },
                    spacer1 = { type = "description", name = "", order = 7, width = "full" },
                    mapMarkerTooltips = {
                        type = "toggle",
                        name = "鼠标提示",
                        desc = "鼠标悬停时显示标记的额外提示信息",
                        order = 8,
                        width = 0.7,
                        get = function() return MGcfg().mapMarkerTooltips end,
                        set = function(_, v)
                            MGcfg().mapMarkerTooltips = v
                            Core:ToggleMapMarkers()
                        end,
                    },
                    mapMarkerProfessionFilter = {
                        type = "toggle",
                        name = "专业过滤",
                        desc = "只显示你学习的专业（钓鱼、烹饪、考古除外）",
                        order = 9,
                        width = 0.7,
                        get = function() return MGcfg().mapMarkerProfessionFilter end,
                        set = function(_, v)
                            MGcfg().mapMarkerProfessionFilter = v
                            Core:ToggleMapMarkers()
                        end,
                    },

                    -- 坐标显示
                    headerCoordDisplay = {
                        type = "header",
                        name = "坐标显示",
                        order = 15,
                    },
                    enableCoordDisplay = {
                        type = "toggle",
                        name = "启用坐标显示",
                        desc = "在地图左下角显示当前玩家坐标和鼠标所在坐标",
                        order = 16,
                        width = 1.2,
                        get = function() return MGcfg().enableCoordDisplay end,
                        set = function(_, v)
                            MGcfg().enableCoordDisplay = v
                            Core:ToggleCoordDisplay()
                        end,
                    },

                    -- 标记类型开关
                    headerTypes = {
                        type = "header",
                        name = "标记类型开关",
                        order = 20,
                    },
                    mapMarkersPortal = {
                        type = "toggle",
                        name = "传送",
                        desc = "传送门/通道",
                        order = 21,
                        width = 0.5,
                        get = function() return MGcfg().mapMarkersPortal end,
                        set = function(_, v)
                            MGcfg().mapMarkersPortal = v; Core:ToggleMapMarkers()
                        end,
                    },
                    mapMarkersInn = {
                        type = "toggle",
                        name = "旅店",
                        order = 22,
                        width = 0.5,
                        get = function() return MGcfg().mapMarkersInn end,
                        set = function(_, v)
                            MGcfg().mapMarkersInn = v; Core:ToggleMapMarkers()
                        end,
                    },
                    mapMarkersOfficial = {
                        type = "toggle",
                        name = "商业",
                        desc = "拍卖/银行/黑市",
                        order = 23,
                        width = 0.5,
                        get = function() return MGcfg().mapMarkersOfficial end,
                        set = function(_, v)
                            MGcfg().mapMarkersOfficial = v; Core:ToggleMapMarkers()
                        end,
                    },
                    mapMarkersProfession = {
                        type = "toggle",
                        name = "专业",
                        order = 24,
                        width = 0.5,
                        get = function() return MGcfg().mapMarkersProfession end,
                        set = function(_, v)
                            MGcfg().mapMarkersProfession = v; Core:ToggleMapMarkers()
                        end,
                    },
                    mapMarkersService = {
                        type = "toggle",
                        name = "服务",
                        desc = "理发/幻化/商栈/物品升级/订单/地下堡总部",
                        order = 25,
                        width = 0.5,
                        get = function() return MGcfg().mapMarkersService end,
                        set = function(_, v)
                            MGcfg().mapMarkersService = v; Core:ToggleMapMarkers()
                        end,
                    },
                    mapMarkersStable = {
                        type = "toggle",
                        name = "兽栏",
                        order = 26,
                        width = 0.5,
                        get = function() return MGcfg().mapMarkersStable end,
                        set = function(_, v)
                            MGcfg().mapMarkersStable = v; Core:ToggleMapMarkers()
                        end,
                    },
                    mapMarkersCollection = {
                        type = "toggle",
                        name = "藏品",
                        desc = "坐骑/玩具/宠物/家宅装饰",
                        order = 27,
                        width = 0.5,
                        get = function() return MGcfg().mapMarkersCollection end,
                        set = function(_, v)
                            MGcfg().mapMarkersCollection = v; Core:ToggleMapMarkers()
                        end,
                    },
                    mapMarkersVendor = {
                        type = "toggle",
                        name = "通用商人",
                        desc = "普通商人/公会商人/外观商人/传家宝商人",
                        order = 28,
                        width = 0.6,
                        get = function() return MGcfg().mapMarkersVendor end,
                        set = function(_, v)
                            MGcfg().mapMarkersVendor = v; Core:ToggleMapMarkers()
                        end,
                    },
                    mapMarkersUnique = {
                        type = "toggle",
                        name = "特殊商人",
                        desc = "墨黑药水/焰火/礼服/要塞图纸等",
                        order = 29,
                        width = 0.6,
                        get = function() return MGcfg().mapMarkersUnique end,
                        set = function(_, v)
                            MGcfg().mapMarkersUnique = v; Core:ToggleMapMarkers()
                        end,
                    },
                    mapMarkersSpecial = {
                        type = "toggle",
                        name = "特殊功能",
                        desc = "马戏团专业任务/传送门训练师/克罗米等",
                        order = 30,
                        width = 0.6,
                        get = function() return MGcfg().mapMarkersSpecial end,
                        set = function(_, v)
                            MGcfg().mapMarkersSpecial = v; Core:ToggleMapMarkers()
                        end,
                    },
                    mapMarkersQuartermaster = {
                        type = "toggle",
                        name = "军需官",
                        desc = "声望军需官/盟约军需官",
                        order = 31,
                        width = 0.5,
                        get = function() return MGcfg().mapMarkersQuartermaster end,
                        set = function(_, v)
                            MGcfg().mapMarkersQuartermaster = v; Core:ToggleMapMarkers()
                        end,
                    },
                    mapMarkersPvp = {
                        type = "toggle",
                        name = "PVP",
                        desc = "PVP商人/PVP坐骑/木桩",
                        order = 32,
                        width = 0.5,
                        get = function() return MGcfg().mapMarkersPvp end,
                        set = function(_, v)
                            MGcfg().mapMarkersPvp = v; Core:ToggleMapMarkers()
                        end,
                    },
                    mapMarkersInstance = {
                        type = "toggle",
                        name = "副本",
                        order = 33,
                        width = 0.5,
                        get = function() return MGcfg().mapMarkersInstance end,
                        set = function(_, v)
                            MGcfg().mapMarkersInstance = v; Core:ToggleMapMarkers()
                        end,
                    },
                    mapMarkersDelve = {
                        type = "toggle",
                        name = "地下堡",
                        order = 34,
                        width = 0.5,
                        get = function() return MGcfg().mapMarkersDelve end,
                        set = function(_, v)
                            MGcfg().mapMarkersDelve = v; Core:ToggleMapMarkers()
                        end,
                    },

                    -- 联盟城市
                    headerAlliance = {
                        type = "header",
                        name = "联盟城市",
                        order = 40,
                    },
                    alliance = {
                        type = "group",
                        name = "",
                        order = 41,
                        inline = true,
                        args = BuildCityArgs({
                            { "Stormwind", "暴风城" },
                            { "Ironforge", "铁炉堡" },
                            { "Darnassus", "达纳苏斯" },
                            { "Exodar", "埃索达" },
                            { "Gilneas", "吉尔尼斯" },
                            { "Stormshield", "暴风之盾" },
                            { "Boralus", "伯拉勒斯" },
                            { "Belamath", "贝拉梅斯" },
                        }),
                    },

                    -- 部落城市
                    headerHorde = {
                        type = "header",
                        name = "部落城市",
                        order = 50,
                    },
                    horde = {
                        type = "group",
                        name = "",
                        order = 51,
                        inline = true,
                        args = BuildCityArgs({
                            { "Orgrimmar", "奥格瑞玛" },
                            { "ThunderBluff", "雷霆崖" },
                            { "Undercity", "幽暗城" },
                            { "Warspear", "战争之矛" },
                            { "Dazaralor", "达萨罗" },
                        }),
                    },

                    -- 中立城市
                    headerNeutral = {
                        type = "header",
                        name = "中立城市",
                        order = 60,
                    },
                    neutral = {
                        type = "group",
                        name = "",
                        order = 61,
                        inline = true,
                        args = BuildCityArgs({
                            { "Shattrath", "沙塔斯" },
                            { "DalaranNorthrend", "达拉然（诺森德）" },
                            { "DalaranLegion", "达拉然（破碎群岛）" },
                            { "Oribos", "奥利波斯" },
                            { "SanctumofDomination", "兵主之座" },
                            { "Sinfall", "堕罪堡" },
                            { "HeartoftheForest", "森林之心" },
                            { "ElysianHold", "极乐堡" },
                            { "Valdrakken", "瓦德拉肯" },
                            { "Dornogal", "多恩诺嘉尔" },
                            { "CityofThreads", "千丝之城" },
                            { "Undermine", "安德麦" },
                            { "Tazavesh", "塔扎维什" },
                            { "SilvermoonCityMidnight", "银月城（至暗之夜）" },
                        }),
                    },

                    -- 区域
                    headerRegions = {
                        type = "header",
                        name = "地图区域",
                        order = 70,
                    },
                    regions = {
                        type = "group",
                        name = "",
                        order = 71,
                        inline = true,
                        args = BuildCityArgs({
                            { "Darkmoonfaire", "暗月马戏团" },
                            { "IsleofDorn", "多恩岛" },
                            { "TheRingingDeeps", "喧鸣深窟" },
                            { "Hallowfall", "陨圣峪" },
                            { "AzjKahet", "艾基-卡赫特" },
                            { "KAresh", "卡雷什" },
                            { "EversongWoods", "永歌森林" },
                            { "Voidstorm", "虚影风暴" },
                            { "IsleofQuelDanas", "奎尔丹纳斯岛" },
                            { "ZulAman", "祖阿曼" },
                            { "Harandar", "哈籁恩达尔" },
                        }),
                    },
                },
            },

            -- ====================================================================================
            -- Tab 2: 坐标扩展
            -- ====================================================================================
            coordExtend = {
                type = "group",
                name = "坐标扩展",
                order = 2,
                args = {
                    headerQuickAdd = {
                        type = "header",
                        name = "快速添加坐标",
                        order = 1,
                    },
                    quickAddDesc = {
                        type = "description",
                        name =
                        "|cFFCCCCCC在下方填写标题和备注，点击[添加当前位置]即可保存当前坐标。|r\n|cFFCCCCCC也可以使用 |cFF33FF99/yxpin|r 命令打开弹窗添加。|r",
                        order = 2,
                        fontSize = "medium",
                    },
                    spacer1 = { type = "description", name = "", order = 3, width = "full" },
                    quickAddTitle = {
                        type = "input",
                        name = "标题",
                        order = 4,
                        width = 1.0,
                        get = function() return quickAddTitle end,
                        set = function(_, v) quickAddTitle = tostring(v or "") end,
                    },
                    quickAddNote = {
                        type = "input",
                        name = "备注",
                        order = 5,
                        width = 1.4,
                        get = function() return quickAddNote end,
                        set = function(_, v) quickAddNote = tostring(v or "") end,
                    },
                    quickAddColor = {
                        type = "color",
                        name = "颜色",
                        order = 6,
                        hasAlpha = false,
                        width = 0.6,
                        get = function()
                            ResolveDefaultQuickColor()
                            return quickAddColor.r, quickAddColor.g, quickAddColor.b
                        end,
                        set = function(_, r, g, b)
                            quickAddColor = { r = r, g = g, b = b }
                        end,
                    },
                    spacer2 = { type = "description", name = "", order = 7, width = "full" },
                    quickAddHere = {
                        type = "execute",
                        name = "添加当前位置",
                        order = 8,
                        width = 1.0,
                        func = function()
                            ResolveDefaultQuickColor()
                            local ok, msg = Core:AddMapGuideCustomMarkerAtPlayerPos(quickAddTitle, quickAddNote,
                                quickAddColor)
                            if ok then
                                quickAddStatus = "|cFF33FF99添加成功!|r"
                                quickAddTitle = ""
                                quickAddNote = ""
                                RefreshCustomMarkerList()
                            else
                                quickAddStatus = "|cFFFF3333" .. (msg or "添加失败") .. "|r"
                            end
                            NotifyOptionsChanged()
                        end,
                    },
                    quickAddPopup = {
                        type = "execute",
                        name = "打开弹窗",
                        desc = "打开独立的快速添加坐标弹窗",
                        order = 9,
                        width = 0.7,
                        func = function()
                            Core:ShowQuickAddPopup()
                        end,
                    },
                    quickAddStatus = {
                        type = "description",
                        name = function()
                            return quickAddStatus ~= "" and quickAddStatus or "|cFF888888等待操作...|r"
                        end,
                        order = 10,
                        fontSize = "medium",
                    },

                    -- 自定义坐标历史列表
                    headerHistory = {
                        type = "header",
                        name = "自定义坐标列表",
                        order = 20,
                    },
                    customMarkerList = {
                        type = "group",
                        name = "",
                        order = 21,
                        inline = true,
                        args = {},
                    },
                },
            },

            -- ====================================================================================
            -- Tab 3: 坐标导入导出
            -- ====================================================================================
            coordImportExport = {
                type = "group",
                name = "导入导出",
                order = 3,
                args = {
                    headerIO = {
                        type = "header",
                        name = "坐标导入导出",
                        order = 1,
                    },
                    ioDesc = {
                        type = "description",
                        name =
                        "|cFFCCCCCC支持与 RoyMapGuideEx 格式兼容的导入导出。|r\n|cFFCCCCCC点击[导出全部]将所有自定义坐标导出到文本框，复制后可分享给他人。|r\n|cFFCCCCCC将他人分享的文本粘贴到文本框，点击[导入]即可添加。|r",
                        order = 2,
                        fontSize = "medium",
                    },
                    spacer1 = { type = "description", name = "", order = 3, width = "full" },
                    exportNow = {
                        type = "execute",
                        name = "导出全部",
                        order = 4,
                        width = 0.8,
                        func = function()
                            importExportText = Core:ExportMapGuideCustomMarkers() or ""
                            if importExportText ~= "" then
                                importExportStatus = "|cFF33FF99导出完成，请复制下方文本|r"
                            else
                                importExportStatus = "|cFFFFCC00没有可导出的坐标|r"
                            end
                            NotifyOptionsChanged()
                        end,
                    },
                    importNow = {
                        type = "execute",
                        name = "导入",
                        order = 5,
                        width = 0.6,
                        func = function()
                            local count = Core:ImportMapGuideCustomMarkers(importExportText)
                            if count and count > 0 then
                                importExportStatus = string.format("|cFF33FF99导入成功：%d 条坐标|r", count)
                                RefreshCustomMarkerList()
                            else
                                importExportStatus = "|cFFFF3333未导入任何条目，请检查格式|r"
                            end
                            NotifyOptionsChanged()
                        end,
                    },
                    clearText = {
                        type = "execute",
                        name = "清空",
                        order = 6,
                        width = 0.5,
                        func = function()
                            importExportText = ""
                            importExportStatus = "|cFF888888已清空文本框|r"
                            NotifyOptionsChanged()
                        end,
                    },
                    importExportStatus = {
                        type = "description",
                        name = function()
                            return importExportStatus ~= "" and importExportStatus or "|cFF888888等待操作...|r"
                        end,
                        order = 7,
                        fontSize = "medium",
                    },
                    spacer2 = { type = "description", name = "", order = 8, width = "full" },
                    importExportText = {
                        type = "input",
                        name = "坐标数据",
                        desc = "粘贴导入数据或复制导出数据",
                        order = 9,
                        width = "full",
                        multiline = 20,
                        get = function() return importExportText end,
                        set = function(_, v) importExportText = tostring(v or "") end,
                    },
                },
            },
        },
    }

    -- 初始化自定义坐标列表
    RefreshCustomMarkerList()

    return group
end
