local _, ns = ...
local Core = ns.Core

ns.OptionsShared = ns.OptionsShared or {}
local S = ns.OptionsShared

function S.QC() return Core.db.profile.quickChat end

function S.AT() return Core.db.profile.attribute end

function S.CUcfg() return Core.db.profile.currency end

function S.DMcfg() return Core.db.profile.distanceMonitor end

function S.PMcfg() return Core.db.profile.performanceMonitor end

function S.MIcfg() return Core.db.profile.misc end

function S.SAcfg() return Core.db.profile.systemAdjust end

function S.IDcfg() return Core.db.profile.instanceDifficulty end

function S.CBcfg() return Core.db.profile.castBar end

function S.MGcfg() return Core.db.profile.mapGuide end
