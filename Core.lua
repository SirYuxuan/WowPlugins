local addonName, ns = ...

local VERSION = "1.3.1"

local AceDB = LibStub("AceDB-3.0")
local LibDataBroker = LibStub("LibDataBroker-1.1")
local LibDBIcon = LibStub("LibDBIcon-1.0")
local LibSharedMedia = LibStub("LibSharedMedia-3.0")

local SHARED_PROFILE_NAME = "Default"

ns.addonName = addonName
ns.VERSION = VERSION

pcall(function()
    LibSharedMedia:Register("statusbar", "Yuxuan", "Interface\\AddOns\\" .. addonName .. "\\Resource\\Texture\\Yuxuan")
    LibSharedMedia:Register("statusbar", "Gradient-Circle",
        "Interface\\AddOns\\" .. addonName .. "\\Resource\\Texture\\Gradient-Circle")
    LibSharedMedia:Register("statusbar", "Gradient-Line",
        "Interface\\AddOns\\" .. addonName .. "\\Resource\\Texture\\Gradient-Line")
end)

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

    -- Currency display state
    currencyFrame = nil,
    currencyItems = {},

    -- CastBar state
    castBars = {},
    castBarEventFrame = nil,

    -- Misc state
    miscFrame = nil,
    miscDropdown = nil,
    miscEventFrame = nil,
    raidMarkersFrame = nil,
    distanceMonitorFrame = nil,
    timerFrame = nil,
    timerSession = nil,
    levelingTipFrame = nil,
    levelingTipState = nil,
    instanceDifficultyFrame = nil,
    instanceDifficultyEventFrame = nil,
    instanceDifficultyToast = nil,
    instanceDifficultyTicker = nil,
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
            colorIlvl          = { r = 0.996, g = 0.349, b = 0.827 },
            colorPrimary       = { r = 1, g = 0.498, b = 0.259 },
            colorCrit          = { r = 1, g = 0, b = 0.071 },
            colorHaste         = { r = 0.043, g = 1, b = 0 },
            colorMastery       = { r = 1, g = 1, b = 1 },
            colorVersa         = { r = 0, g = 0.902, b = 1 },
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
            progressBarTexture = "Yuxuan",
            progressBarColor   = { r = 1, g = 1, b = 1 },
            maxIlvl            = 289,
        },
        currency = {
            enabled = false,
            locked = false,
            orientation = "HORIZONTAL",
            spacing = 8,
            iconSize = 16,
            fontSize = 14,
            fontOutline = false,
            font = "Friz Quadrata TT",
            displayMode = "ICON_TEXT", -- ICON / TEXT / ICON_TEXT
            showMoney = true,
            selected = {},
            order = {},
            pos = { point = "CENTER", relativeTo = "UIParent", relativePoint = "CENTER", x = 0, y = -220 },
        },
        distanceMonitor = {
            enabled = false,
            locked = true,
            font = "Friz Quadrata TT",
            fontSize = 14,
            updateInterval = 0.2,
            rangeSeparator = " - ",
            showBackground = true,
            showBorder = true,
            backgroundColor = {
                r = 0,
                g = 0,
                b = 0,
                a = 0.32,
            },
            borderColor = {
                r = 0,
                g = 0.6,
                b = 1,
                a = 0.45,
            },
            point = {
                point = "CENTER",
                relativePoint = "CENTER",
                x = -220,
                y = -20,
            },
        },
        gameBar = {
            enabled           = false,
            locked            = true,
            buttonSize        = 28,
            spacing           = 4,
            middleWidth       = 80,
            timeFontSize      = 20,
            animationDuration = 0.2,
            showBackground    = true,
            backgroundColor   = { r = 0, g = 0, b = 0, a = 0.45 },
            mouseOver         = false,
            point             = "TOP",
            relativePoint     = "TOP",
            x                 = 0,
            y                 = -20,
            leftButtons       = { "CHARACTER", "TALENTS", "SPELLBOOK", "QUESTLOG" },
            rightButtons      = { "BAGS", "FRIENDS", "GUILD", "SETTINGS" },
            hearthstone       = {
                showBindLocation = true,
                left = "AUTO",
                middle = "RANDOM",
                right = "AUTO",
            },
        },
        performanceMonitor = {
            enabled = true,
            locked = true,
            font = "Friz Quadrata TT",
            fontSize = 14,
            updateInterval = 1,
            showBackground = true,
            backgroundColor = { r = 0, g = 0, b = 0, a = 0.32 },
            point = {
                point = "CENTER",
                relativePoint = "CENTER",
                x = 220,
                y = -20,
            },
        },
        misc = {
            questToolsEnabled = false,
            questToolsLocked = true,
            questToolsOrientation = "HORIZONTAL",
            raidMarkersEnabled = false,
            raidMarkersLocked = true,
            raidMarkersShowWhenSolo = false,
            raidMarkersOrientation = "HORIZONTAL",
            raidMarkersSpacing = 6,
            raidMarkersIconSize = 28,
            raidMarkersCountdown = 6,
            raidMarkersShowBackground = true,
            raidMarkersShowBorder = true,
            raidMarkersBackgroundColor = {
                r = 0,
                g = 0,
                b = 0,
                a = 0.35,
            },
            raidMarkersBorderColor = {
                r = 0,
                g = 0.6,
                b = 1,
                a = 0.45,
            },
            levelingTipEnabled = false,
            levelingTipLocked = true,
            levelingTipFont = "Friz Quadrata TT",
            levelingTipFontSize = 13,
            levelingTipShowXPPerMinute = true,
            levelingTipShowRemainingXP = true,
            levelingTipShowLevelETA = true,
            levelingTipShowMaxETA = true,
            levelingTipHideAtMaxLevel = true,
            autoAnnounceQuest = false,
            autoQuestTurnIn = false,
            announceTemplate = "|cFF33FF99【雨轩工具箱】|r |cFFFFFF00{action}|r：{quest}",
            tooltipFollowCursor = false,
            disableAllTooltips = false,
            infoBarEnabled = true,
            infoBarLocked = true,
            infoBarOrientation = "HORIZONTAL",
            delveQuickLeaveEnabled = false,
            delveQuickLeaveLocked = true,
            delveQuickLeaveIconSize = 40,
            delveQuickLeaveIconPreset = "Interface\\Icons\\spell_arcane_teleportdalaran",
            delveQuickLeaveCustomIcon = "",
            font = "Friz Quadrata TT",
            fontSize = 13,
            barSpacing = 18,
            textColor = {
                r = 1,
                g = 1,
                b = 1,
            },
            questToolsFont = "Friz Quadrata TT",
            questToolsFontSize = 13,
            questToolsSpacing = 18,
            questToolsTextColor = {
                r = 1,
                g = 1,
                b = 1,
            },
            barPoint = {
                point = "CENTER",
                relativePoint = "CENTER",
                x = 0,
                y = -150,
            },
            questToolsPoint = {
                point = "CENTER",
                relativePoint = "CENTER",
                x = 0,
                y = -110,
            },
            raidMarkersPoint = {
                point = "CENTER",
                relativePoint = "CENTER",
                x = 0,
                y = -30,
            },
            levelingTipPoint = {
                point = "CENTER",
                relativePoint = "CENTER",
                x = 0,
                y = -70,
            },
            delveQuickLeavePoint = {
                point = "CENTER",
                relativePoint = "CENTER",
                x = 180,
                y = -20,
            },
        },
        systemAdjust = {
            combatDamageTextScale = 3,
            opaqueTooltipBackground = false,
            showTooltipHealthBar = false,
            targetArrowEnabled = false,
            targetArrowSize = 28,
            targetArrowColor = { r = 1, g = 0.12, b = 0.12, a = 0.95 },
            showNPCAliveTime = false,
            npcTimeShowCurrentTime = false,
            npcTimeShowLayer = false,
            npcTimeShowNPCID = false,
            npcTimeUseModifier = false,
            npcTimeShowPhaseAlert = false,
        },
        chatBeautify = {
            enabled = false,
            font = "Friz Quadrata TT",
            fontSize = 13,
            backgroundAlpha = 0.12,
            editBoxAlpha = 0.18,
            hideMenuButton = true,
            hideChannelButtons = true,
            hideQuickJoinButton = true,
            tabAlpha = 0.75,
            abbreviateChannels = true,
        },
        instanceDifficulty = {
            enabled = true,
            visible = true,
            locked = false,
            showOnLogin = true,
            autoCollapseInInstance = true,
            showCenterToast = true,
            centerToastDuration = 3,
            ttsEnabled = true,
            ttsVolume = 100,
            announceToChat = true,
            showResetButton = true,
            showTeleportButton = true,
            showLeaveButton = true,
            frameScale = 1,
            fontSize = 13,
            fontOutline = true,
            orientation = "VERTICAL",
            backgroundTexture = "Yuxuan",
            backgroundAlpha = 0.18,
            point = {
                point = "CENTER",
                relativePoint = "CENTER",
                x = 280,
                y = 0,
            },
        },
        -- 图标收纳模块已移除，不再保留 iconCollector 配置
        eventTracker = {
            enabled = true,
            fontSize = 12,
            fontOutline = true,
            trackerWidth = 220,
            trackerHeight = 28,
            backdropAlpha = 0.6,
            alertEnabled = true,
            alertSecond = 60,
            -- 各事件默认启用
            weeklyMN = true,
            professionsWeeklyMN = true,
            stormarionAssault = true,
            weeklyTWW = true,
            nightfall = true,
            theaterTroupe = true,
            ecologicalSuccession = true,
            ringingDeeps = true,
            spreadingTheLight = true,
            underworldOperative = true,
        },
        mapGuide = {
            enableMapMarkers = false,
            enableCoordDisplay = false,
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
            texture = "Yuxuan",
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
            profiles = { [SHARED_PROFILE_NAME] = oldData },
        }
    end
end

local function DeepCopyTable(source)
    if type(source) ~= "table" then
        return source
    end

    local copy = {}
    for key, value in pairs(source) do
        copy[key] = DeepCopyTable(value)
    end
    return copy
end

local function GetCurrentCharacterProfileKey()
    if type(UnitFullName) ~= "function" then
        return nil
    end

    local name, realm = UnitFullName("player")
    if not name or name == "" then
        return nil
    end

    realm = realm or (type(GetRealmName) == "function" and GetRealmName()) or ""
    if realm ~= "" then
        return string.format("%s - %s", name, realm)
    end

    return name
end

local function IsAutoGeneratedProfileName(profileName)
    return type(profileName) == "string" and profileName:match(".+ %- .+") ~= nil
end

local function GetPreferredSharedProfileName(saved)
    if type(saved) ~= "table" then
        return SHARED_PROFILE_NAME
    end

    saved.profiles = saved.profiles or {}
    saved.profileKeys = saved.profileKeys or {}

    local sharedProfileName = saved._sharedSelectedProfileName
    if type(sharedProfileName) == "string" and sharedProfileName ~= ""
        and type(saved.profiles[sharedProfileName]) == "table" then
        return sharedProfileName
    end

    for _, profileName in pairs(saved.profileKeys) do
        if type(profileName) == "string" and profileName ~= SHARED_PROFILE_NAME
            and not IsAutoGeneratedProfileName(profileName)
            and type(saved.profiles[profileName]) == "table" then
            return profileName
        end
    end

    local currentKey = GetCurrentCharacterProfileKey()
    local currentProfileName = currentKey and saved.profileKeys[currentKey] or nil
    if type(currentProfileName) == "string" and currentProfileName ~= ""
        and type(saved.profiles[currentProfileName]) == "table" then
        return currentProfileName
    end

    if type(saved.profiles[SHARED_PROFILE_NAME]) == "table" then
        return SHARED_PROFILE_NAME
    end

    for profileName, profileData in pairs(saved.profiles) do
        if type(profileName) == "string" and not IsAutoGeneratedProfileName(profileName)
            and type(profileData) == "table" then
            return profileName
        end
    end

    return SHARED_PROFILE_NAME
end

local function ApplySharedProfileSelection(profileName)
    local saved = _G["YuXuanToolboxDB"]
    if type(saved) ~= "table" then
        return SHARED_PROFILE_NAME
    end

    saved.profiles = saved.profiles or {}
    saved.profileKeys = saved.profileKeys or {}

    local sharedProfileName = profileName
    if type(sharedProfileName) ~= "string" or sharedProfileName == "" then
        sharedProfileName = GetPreferredSharedProfileName(saved)
    end

    if type(saved.profiles[sharedProfileName]) ~= "table" then
        local sourceProfileData = nil

        if type(saved.profiles[SHARED_PROFILE_NAME]) == "table" then
            sourceProfileData = saved.profiles[SHARED_PROFILE_NAME]
        else
            for _, profileData in pairs(saved.profiles) do
                if type(profileData) == "table" then
                    sourceProfileData = profileData
                    break
                end
            end
        end

        saved.profiles[sharedProfileName] = sourceProfileData and DeepCopyTable(sourceProfileData) or {}
    end

    local currentKey = GetCurrentCharacterProfileKey()
    if currentKey and (saved.profileKeys[currentKey] == nil or saved.profileKeys[currentKey] == "") then
        saved.profileKeys[currentKey] = sharedProfileName
    end

    for characterKey in pairs(saved.profileKeys) do
        saved.profileKeys[characterKey] = sharedProfileName
    end

    saved._sharedSelectedProfileName = sharedProfileName
    return sharedProfileName
end

local function MigrateToSharedDefaultProfile()
    local saved = _G["YuXuanToolboxDB"]
    if type(saved) ~= "table" then
        return
    end

    saved.profiles = saved.profiles or {}
    saved.profileKeys = saved.profileKeys or {}

    if saved._sharedDefaultProfileMigrated then
        return
    end

    local currentKey = GetCurrentCharacterProfileKey()
    local sourceProfileName = nil
    local sourceProfileData = nil

    if type(saved.profiles[SHARED_PROFILE_NAME]) == "table" then
        sourceProfileName = SHARED_PROFILE_NAME
        sourceProfileData = saved.profiles[SHARED_PROFILE_NAME]
    else
        local currentProfileName = currentKey and saved.profileKeys[currentKey] or nil
        if currentProfileName and IsAutoGeneratedProfileName(currentProfileName)
            and type(saved.profiles[currentProfileName]) == "table" then
            sourceProfileName = currentProfileName
            sourceProfileData = saved.profiles[currentProfileName]
        end

        if not sourceProfileData then
            for _, profileName in pairs(saved.profileKeys) do
                if IsAutoGeneratedProfileName(profileName) and type(saved.profiles[profileName]) == "table" then
                    sourceProfileName = profileName
                    sourceProfileData = saved.profiles[profileName]
                    break
                end
            end
        end

        if not sourceProfileData then
            for profileName, profileData in pairs(saved.profiles) do
                if type(profileData) == "table" then
                    sourceProfileName = profileName
                    sourceProfileData = profileData
                    break
                end
            end
        end
    end

    if type(saved.profiles[SHARED_PROFILE_NAME]) ~= "table" then
        saved.profiles[SHARED_PROFILE_NAME] = sourceProfileData and DeepCopyTable(sourceProfileData) or {}
    end

    for characterKey, profileName in pairs(saved.profileKeys) do
        if IsAutoGeneratedProfileName(profileName) then
            saved.profileKeys[characterKey] = SHARED_PROFILE_NAME
        end
    end

    for profileName in pairs(saved.profiles) do
        if profileName ~= SHARED_PROFILE_NAME and IsAutoGeneratedProfileName(profileName) then
            saved.profiles[profileName] = nil
        end
    end

    saved._sharedDefaultProfileMigrated = true
end

-- ─── Minimap button ────────────────────────────────
function Core:SetupMinimapButton()
    local dataobj = LibDataBroker:NewDataObject(addonName, {
        type = "launcher",
        icon = "Interface\\Icons\\INV_Misc_Gear_01",
        OnClick = function(_, button)
            if button == "LeftButton" then
                if ns.EnsureOptionsRegistered then
                    ns.EnsureOptionsRegistered(Core.db)
                end
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

function Core:HandleProfileChanged()
    local currentProfileName = self.db and self.db.GetCurrentProfile and self.db:GetCurrentProfile() or
        SHARED_PROFILE_NAME
    ApplySharedProfileSelection(currentProfileName)
    self:ApplyAllSettings()
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
    if self.ApplyMiscSettings then
        self:ApplyMiscSettings()
    end
    if self.ApplySystemAdjustSettings then
        self:ApplySystemAdjustSettings()
    end
    if self.ApplyGameBarSettings then
        self:ApplyGameBarSettings()
    end
    if self.ApplyInstanceDifficultySettings then
        self:ApplyInstanceDifficultySettings()
    end
    if self.ApplyEventTrackerSettings then
        self:ApplyEventTrackerSettings()
    end
    if self.ApplyDistanceMonitorSettings then
        self:ApplyDistanceMonitorSettings()
    end
    if self.ApplyPerformanceMonitorSettings then
        self:ApplyPerformanceMonitorSettings()
    end
    if self.ApplyChatBeautifySettings then
        self:ApplyChatBeautifySettings()
    end
    if self.ApplyAttributeSettings then
        self:ApplyAttributeSettings()
    end
    if self.ApplyCurrencySettings then
        self:ApplyCurrencySettings()
    end
    if self.ApplyCastBarSettings then
        self:ApplyCastBarSettings()
    end
    if self.ToggleMapMarkers then
        self:ToggleMapMarkers()
    end
    if self.ToggleCoordDisplay then
        self:ToggleCoordDisplay()
    end
    -- 图标收纳模块已移除，这里不再调用相关设置应用逻辑
    self:UpdateMinimapIcon()
end

-- ─── Slash commands ────────────────────────────────
function Core:RegisterSlashCommands()
    SLASH_YuXuanToolbox1 = "/yx"
    SlashCmdList["YuXuanToolbox"] = function(msg)
        msg = strtrim(strlower(msg or ""))
        local command, rest = msg:match("^(%S+)%s*(.-)$")
        if msg == "lock" then
            self.db.profile.castBar.locked = true
            if self.ApplyCastBarSettings then self:ApplyCastBarSettings() end
            print("|cFF33FF99雨轩工具箱|r丨施法条已锁定")
        elseif msg == "unlock" then
            self.db.profile.castBar.locked = false
            if self.ApplyCastBarSettings then self:ApplyCastBarSettings() end
            print("|cFF33FF99雨轩工具箱|r丨施法条已解锁，拖动以移动位置")
        elseif command == "diff" then
            local sub = strtrim(rest or "")
            if sub == "lock" then
                self.db.profile.instanceDifficulty.locked = true
                if self.ApplyInstanceDifficultySettings then self:ApplyInstanceDifficultySettings() end
                print("|cFF33FF99雨轩工具箱|r丨副本难度助手已锁定")
            elseif sub == "unlock" then
                self.db.profile.instanceDifficulty.locked = false
                if self.ApplyInstanceDifficultySettings then self:ApplyInstanceDifficultySettings() end
                print("|cFF33FF99雨轩工具箱|r丨副本难度助手已解锁")
            elseif sub == "reset" then
                if self.ResetCurrentInstances then self:ResetCurrentInstances() end
            elseif sub == "leave" then
                if self.QuickLeaveInstance then self:QuickLeaveInstance() end
            else
                if self.ToggleInstanceDifficultyFrame then self:ToggleInstanceDifficultyFrame() end
            end
        else
            if ns.EnsureOptionsRegistered then
                ns.EnsureOptionsRegistered(self.db)
            end
            local AceConfigDialog = LibStub("AceConfigDialog-3.0")
            AceConfigDialog:Open(addonName)
        end
    end

    SLASH_YuXuanToolboxDifficulty1 = "/c"
    SlashCmdList["YuXuanToolboxDifficulty"] = function()
        if self.ToggleInstanceDifficultyFrame then
            self:ToggleInstanceDifficultyFrame()
        end
    end

    SLASH_YuXuanToolboxTimer1 = "/timer"
    SlashCmdList["YuXuanToolboxTimer"] = function()
        if self.ToggleTimerWindow then
            self:ToggleTimerWindow()
        end
    end
end

function Core:PrintWelcome()
    print("|cFF33FF99雨轩工具箱|r：|cFFFFD700欢迎使用|r |cFF00FFFFv" ..
        self.VERSION .. "|r |cFFAAAAAA输入|r |cFFFFFF00/yx|r |cFFAAAAAA打开设置窗口  问题反馈QQ群：|r |cFF00FFFF1087904677|r")
end

-- ─── Initialization ────────────────────────────────
function Core:Initialize()
    MigrateOldDB()
    MigrateToSharedDefaultProfile()
    local sharedProfileName = ApplySharedProfileSelection()
    self.db = AceDB:New("YuXuanToolboxDB", self.DEFAULTS, sharedProfileName)
    if self.db.GetCurrentProfile and self.db:GetCurrentProfile() ~= sharedProfileName then
        self.db:SetProfile(sharedProfileName)
    end
    ApplySharedProfileSelection(self.db.GetCurrentProfile and self.db:GetCurrentProfile() or sharedProfileName)
    if self.db.profile.attribute and self.db.profile.attribute.progressBarTexture == "Blizzard" then
        self.db.profile.attribute.progressBarTexture = "Yuxuan"
    end
    if self.db.profile.castBar and self.db.profile.castBar.texture == "Blizzard" then
        self.db.profile.castBar.texture = "Yuxuan"
    end
    self.db.RegisterCallback(self, "OnProfileChanged", "HandleProfileChanged")
    self.db.RegisterCallback(self, "OnProfileCopied", "HandleProfileChanged")
    self.db.RegisterCallback(self, "OnProfileReset", "HandleProfileChanged")

    self:EnsureQuickChatData()
    self:CreateQuickChatBar()
    self:CreateMiscBar()
    self:CreateDistanceMonitorFrame()
    if self.CreatePerformanceMonitorFrame then
        self:CreatePerformanceMonitorFrame()
    end
    self:CreateAttributeFrame()
    self:CreateCurrencyFrame()
    self:CreateCastBars()
    if self.CreateInstanceDifficultyFrame then
        self:CreateInstanceDifficultyFrame()
    end
    if self.CreateEventTrackerFrame then
        self:CreateEventTrackerFrame()
    end
    self:InitializeMapGuide()
    -- 图标收纳模块已移除，这里不再执行其初始化
    self:SetupMinimapButton()
    self:RegisterSlashCommands()
    if ns.EnsureOptionsRegistered then
        ns.EnsureOptionsRegistered(self.db)
    else
        ns.RegisterOptions(self.db)
    end
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
