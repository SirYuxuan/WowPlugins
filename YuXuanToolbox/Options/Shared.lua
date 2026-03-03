local _, ns = ...
local Core = ns.Core

ns.OptionsShared = ns.OptionsShared or {}
local S = ns.OptionsShared

function S.QC() return Core.db.profile.quickChat end

function S.AT() return Core.db.profile.attribute end

function S.CBcfg() return Core.db.profile.castBar end

function S.MGcfg() return Core.db.profile.mapGuide end
