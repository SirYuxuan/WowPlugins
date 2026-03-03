local addonName, ns = ...

local VERSION = "1.3.0"

local AceDB = LibStub("AceDB-3.0")
local LibDataBroker = LibStub("LibDataBroker-1.1")
local LibDBIcon = LibStub("LibDBIcon-1.0")

ns.addonName = addonName
ns.VERSION = VERSION

-- ─── Dragon Riding Spell IDs (for speed detection) ─
ns.dragonRidingSpellIDs = {
    32235, 32239, 32240, 32242, 32289, 32290, 32292, 336036, 340068, 341776,
    342666, 342667, 344574, 346554, 349943, 353263, 353265, 353856, 353875,
    353883, 358319, 359317, 359367, 359380, 359407, 360954, 366790, 366962,
    367, 368896, 368899, 368901, 369536, 397406, 400976, 413827, 41514, 41515,
    41516, 417888, 418286, 420097, 424082, 425338, 427777, 431357, 431359,
    431360, 431992, 432558, 432562, 43927, 44153, 443660, 446017, 446022,
    446052, 447057, 447176, 447185, 447195, 447413, 448188, 448851, 448939,
    451487, 454682, 458335, 463133, 466012, 466013, 466016, 466133, 468205,
    471538, 472253, 472487, 48025, 54729, 59568, 59569, 59570, 59571, 59650,
    60025, 61229, 61996, 62048, 63796, 63956, 63963, 71342, 72286, 72807,
    74856, 75614, 75973, 88741, 88744, 88990, 97493, 97501, 97359, 113199,
    123992, 123993, 124408, 1245358, 1245359, 1245517, 1246781, 1241429,
    1250482, 1251255, 1251279, 1251281, 1251283, 1251284, 1251295, 1251297,
    1251298, 1251300, 1253130, 1255264, 129918, 130092, 130985, 132036,
    133023, 134359, 136163, 139442, 139448, 142478, 148476, 163024, 171847,
    196681, 215159, 233364, 235764, 239013, 242875, 242882, 243651, 253088,
    253106, 253107, 253108, 253109, 253639, 272770, 278966, 280729, 289083,
    289555, 290328, 290718, 299158, 299159, 302143, 308078, 312776, 317177,
    332252, 332256, 334352, 334482, 335150,
}

-- ═══════════════════════════════════════════════════
--  Core object
-- ═══════════════════════════════════════════════════
local Core = {
    NAME = addonName,
    VERSION = VERSION,
    db = nil, -- AceDB object

    -- QuickChat state
    barFrame = nil,
    quickChatButtons = {},
    quickChatDefs = {},

    -- Attribute display state
    attributeFrame = nil,
    attributeLines = {},
    attributeProgressBars = {},

    -- CastBar state
    castBars = {},
    castBarEventFrame = nil,
}

-- Backward compat: Core.util points to ns.util (populated by Utils.lua)
Core.util = ns.util

-- ─── AceDB Defaults ────────────────────────────────
Core.DEFAULTS = {
    profile = {
        minimap = { hide = false },
        quickChat = {
            enabled = true,
            unlocked = false,
            spacing = 10,
            fontSize = 14,
            font = "Friz Quadrata TT",
            worldChannelName = "大脚世界频道",
            barPoint = {
                point = "CENTER",
                relativePoint = "CENTER",
                x = 0,
                y = -180,
            },
            buttonColors = {},
            customButtons = {},
            nextCustomId = 1,
            buttonOrder = {},
            selectedButtonKey = "SAY",
        },
        attribute = {
            enabled            = true,
            locked             = false,
            fontOutline        = false,
            -- Stats visibility
            showIlvl           = true,
            showPrimary        = true,
            showCrit           = true,
            showHaste          = true,
            showMastery        = true,
            showVersa          = true,
            showLeech          = false,
            showDodge          = false,
            showParry          = false,
            showBlock          = false,
            showSpeed          = true,
            -- Colors
            colorIlvl          = { r = 1, g = 1, b = 1 },
            colorPrimary       = { r = 1, g = 1, b = 1 },
            colorCrit          = { r = 1, g = 1, b = 1 },
            colorHaste         = { r = 1, g = 1, b = 1 },
            colorMastery       = { r = 1, g = 1, b = 1 },
            colorVersa         = { r = 1, g = 1, b = 1 },
            colorLeech         = { r = 0.81, g = 0.39, b = 0.99 },
            colorDodge         = { r = 0.85, g = 0.85, b = 0.65 },
            colorParry         = { r = 0.65, g = 0.85, b = 0.85 },
            colorBlock         = { r = 0.75, g = 0.75, b = 0.75 },
            colorSpeed         = { r = 1, g = 1, b = 0.4 },
            -- Display
            fontSize           = 14,
            lineSpacing        = 2,
            decimalPlaces      = 1,
            bgAlpha            = 0.5,
            bgStyle            = "semi",
            font               = "Friz Quadrata TT",
            align              = "LEFT",
            visibility         = "always",
            ilvlFormat         = "real",
            secondaryFormat    = "percent",
            speedFormat        = "current",
            -- Position
            pos                = { point = "CENTER", relativeTo = "UIParent", relativePoint = "CENTER", x = 0, y = 0 },
            -- Progress bars
            progressBarEnable  = false,
            progressBarHeight  = 6,
            progressBarWidth   = 180,
            progressBarTexture = "Blizzard",
            progressBarColor   = { r = 1, g = 1, b = 1 },
            maxIlvl            = 289,
        },
        mapGuide = {
            enableMapMarkers = false,
            globalMarkerSize = 14,
            mapMarkerType = "TEXT",
            mapMarkerTextOutline = "OUTLINE",
            mapMarkerIconGlow = "",
            mapMarkerTooltips = false,
            mapMarkerProfessionFilter = false,
            -- 标记类型
            mapMarkersPortal = true,
            mapMarkersInn = true,
            mapMarkersOfficial = true,
            mapMarkersProfession = true,
            mapMarkersService = true,
            mapMarkersStable = true,
            mapMarkersCollection = true,
            mapMarkersVendor = true,
            mapMarkersUnique = true,
            mapMarkersSpecial = true,
            mapMarkersQuartermaster = true,
            mapMarkersPvp = true,
            mapMarkersInstance = true,
            mapMarkersDelve = true,
            -- 联盟
            showStormwind = true,
            scaleStormwind = 0.8,
            showIronforge = true,
            scaleIronforge = 0.8,
            showDarnassus = true,
            scaleDarnassus = 0.8,
            showExodar = true,
            scaleExodar = 0.8,
            showGilneas = true,
            scaleGilneas = 0.8,
            showStormshield = true,
            scaleStormshield = 0.8,
            showBoralus = true,
            scaleBoralus = 1.0,
            showBelamath = true,
            scaleBelamath = 1.0,
            -- 部落
            showOrgrimmar = true,
            scaleOrgrimmar = 0.7,
            showThunderBluff = true,
            scaleThunderBluff = 0.8,
            showUndercity = true,
            scaleUndercity = 0.8,
            showWarspear = true,
            scaleWarspear = 0.8,
            showDazaralor = true,
            scaleDazaralor = 1.0,
            -- 中立
            showShattrath = true,
            scaleShattrath = 0.8,
            showDalaranNorthrend = true,
            scaleDalaranNorthrend = 0.8,
            showDalaranLegion = true,
            scaleDalaranLegion = 0.8,
            showOribos = true,
            scaleOribos = 0.8,
            showSanctumofDomination = true,
            scaleSanctumofDomination = 0.8,
            showSinfall = true,
            scaleSinfall = 0.8,
            showHeartoftheForest = true,
            scaleHeartoftheForest = 0.8,
            showElysianHold = true,
            scaleElysianHold = 0.8,
            showValdrakken = true,
            scaleValdrakken = 1.2,
            showDornogal = true,
            scaleDornogal = 1.2,
            showCityofThreads = true,
            scaleCityofThreads = 1.2,
            showUndermine = true,
            scaleUndermine = 1.2,
            showTazavesh = true,
            scaleTazavesh = 0.8,
            showSilvermoonCityMidnight = true,
            scaleSilvermoonCityMidnight = 1.1,
            -- 区域
            showDarkmoonfaire = true,
            scaleDarkmoonfaire = 0.7,
            showIsleofDorn = true,
            scaleIsleofDorn = 1.2,
            showTheRingingDeeps = true,
            scaleTheRingingDeeps = 1.2,
            showHallowfall = true,
            scaleHallowfall = 1.2,
            showAzjKahet = true,
            scaleAzjKahet = 1.2,
            showKAresh = true,
            scaleKAresh = 1.2,
            showEversongWoods = true,
            scaleEversongWoods = 1.2,
            showVoidstorm = true,
            scaleVoidstorm = 1.2,
            showIsleofQuelDanas = true,
            scaleIsleofQuelDanas = 1.2,
            showZulAman = true,
            scaleZulAman = 1.2,
            showHarandar = true,
            scaleHarandar = 1.2,
        },
        castBar = {
            locked = true,
            hideBlizzardPlayer = true,
            hideBlizzardTarget = true,
            texture = "Blizzard",
            font = "Friz Quadrata TT",
            fontSize = 12,
            outline = "OUTLINE",
            colorCast = { r = 0.24, g = 0.56, b = 0.95, a = 1.0 },
            colorChannel = { r = 0.35, g = 0.90, b = 0.55, a = 1.0 },
            colorFailed = { r = 0.85, g = 0.25, b = 0.25, a = 1.0 },
            colorSuccess = { r = 0.25, g = 0.90, b = 0.35, a = 1.0 },
            safeZoneColor = { r = 1.0, g = 0.2, b = 0.2, a = 0.35 },
            bars = {
                player = {
                    enabled = true,
                    width = 260,
                    height = 18,
                    point = "CENTER",
                    relPoint = "CENTER",
                    x = 0,
                    y = -180,
                    alpha = 1.0,
                    scale = 1.0,
                    showIcon = true,
                    showSpark = true,
                    showTime = true,
                    showSpellName = true,
                    showLatency = true,
                },
                target = {
                    enabled = true,
                    width = 240,
                    height = 16,
                    point = "CENTER",
                    relPoint = "CENTER",
                    x = 0,
                    y = -140,
                    alpha = 1.0,
                    scale = 1.0,
                    showIcon = true,
                    showSpark = true,
                    showTime = true,
                    showSpellName = true,
                },
                focus = {
                    enabled = false,
                    width = 240,
                    height = 16,
                    point = "CENTER",
                    relPoint = "CENTER",
                    x = 0,
                    y = -110,
                    alpha = 1.0,
                    scale = 1.0,
                    showIcon = true,
                    showSpark = true,
                    showTime = true,
                    showSpellName = true,
                },
                gcd = {
                    enabled = false,
                    width = 200,
                    height = 8,
                    point = "CENTER",
                    relPoint = "CENTER",
                    x = 0,
                    y = -210,
                    alpha = 1.0,
                    scale = 1.0,
                    showSpark = true,
                    showTime = false,
                },
            },
        },
    },
}

-- ─── Old DB migration ──────────────────────────────
local function MigrateOldDB()
    local old = _G["YuXuanToolboxDB"]
    if old and old.quickChat and not old.profiles then
        local oldData = {}
        for k, v in pairs(old) do
            if type(v) == "table" then
                oldData[k] = v
            end
        end
        _G["YuXuanToolboxDB"] = {
            profiles = { ["Default"] = oldData },
        }
    end
end

-- ─── Minimap button ────────────────────────────────
function Core:SetupMinimapButton()
    local dataobj = LibDataBroker:NewDataObject(addonName, {
        type = "launcher",
        icon = "Interface\\Icons\\INV_Misc_Gear_01",
        OnClick = function(_, button)
            if button == "LeftButton" then
                local AceConfigDialog = LibStub("AceConfigDialog-3.0")
                AceConfigDialog:Open(addonName)
            end
        end,
        OnTooltipShow = function(tooltip)
            tooltip:AddLine("|cFF33FF99雨轩工具箱|r")
            tooltip:AddLine("左键打开设置", 0.8, 0.8, 0.8)
        end,
    })
    LibDBIcon:Register(addonName, dataobj, self.db.profile.minimap)
end

function Core:UpdateMinimapIcon()
    if not self.db then return end
    if self.db.profile.minimap.hide then
        LibDBIcon:Hide(addonName)
    else
        LibDBIcon:Show(addonName)
    end
end

-- ─── Apply all settings (called on profile change) ─
function Core:ApplyAllSettings()
    self:EnsureQuickChatData()
    self:UpdateQuickChatBar()
    if self.ApplyAttributeSettings then
        self:ApplyAttributeSettings()
    end
    if self.ApplyCastBarSettings then
        self:ApplyCastBarSettings()
    end
    if self.ToggleMapMarkers then
        self:ToggleMapMarkers()
    end
    self:UpdateMinimapIcon()
end

-- ─── Slash commands ────────────────────────────────
function Core:RegisterSlashCommands()
    SLASH_YuXuanToolbox1 = "/yx"
    SlashCmdList["YuXuanToolbox"] = function(msg)
        msg = strtrim(strlower(msg or ""))
        if msg == "lock" then
            self.db.profile.castBar.locked = true
            if self.ApplyCastBarSettings then self:ApplyCastBarSettings() end
            print("|cFF33FF99雨轩工具箱|r丨施法条已锁定")
        elseif msg == "unlock" then
            self.db.profile.castBar.locked = false
            if self.ApplyCastBarSettings then self:ApplyCastBarSettings() end
            print("|cFF33FF99雨轩工具箱|r丨施法条已解锁，拖动以移动位置")
        else
            local AceConfigDialog = LibStub("AceConfigDialog-3.0")
            AceConfigDialog:Open(addonName)
        end
    end
end

function Core:PrintWelcome()
    print("|cFF33FF99雨轩工具箱|r：|cFFFFD700欢迎使用|r |cFF00FFFFv" ..
        self.VERSION .. "|r |cFFAAAAAA输入|r |cFFFFFF00/yx|r |cFFAAAAAA打开设置窗口|r")
end

-- ─── Initialization ────────────────────────────────
function Core:Initialize()
    MigrateOldDB()
    self.db = AceDB:New("YuXuanToolboxDB", self.DEFAULTS)
    self.db.RegisterCallback(self, "OnProfileChanged", "ApplyAllSettings")
    self.db.RegisterCallback(self, "OnProfileCopied", "ApplyAllSettings")
    self.db.RegisterCallback(self, "OnProfileReset", "ApplyAllSettings")

    self:EnsureQuickChatData()
    self:CreateQuickChatBar()
    self:CreateAttributeFrame()
    self:CreateCastBars()
    self:InitializeMapGuide()
    self:SetupMinimapButton()
    self:RegisterSlashCommands()
    ns.RegisterOptions(self.db)
    self:ApplyAllSettings()
end

ns.Core = Core

-- ─── Events ────────────────────────────────────────
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:SetScript("OnEvent", function(_, event, arg1, arg2)
    if event == "ADDON_LOADED" and arg1 == addonName then
        Core:Initialize()
        eventFrame:UnregisterEvent("ADDON_LOADED")
    elseif event == "PLAYER_ENTERING_WORLD" then
        local isInitialLogin = arg1
        local isReloadingUi = arg2
        if isInitialLogin or isReloadingUi then
            Core:PrintWelcome()
        end
    end
end)
