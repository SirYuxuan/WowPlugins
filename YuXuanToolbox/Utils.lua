local _, ns = ...

-- ═══════════════════════════════════════════════════
--  Shared Utilities
-- ═══════════════════════════════════════════════════
local util = {}

function util.trim(str)
    return (tostring(str or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

function util.clampColor(v)
    v = tonumber(v) or 0
    if v < 0 then return 0 end
    if v > 1 then return 1 end
    return v
end

function util.cloneColor(c)
    return {
        r = util.clampColor(c and c.r or 1),
        g = util.clampColor(c and c.g or 1),
        b = util.clampColor(c and c.b or 1),
    }
end

function util.tableContains(t, value)
    for _, v in ipairs(t) do
        if v == value then return true end
    end
    return false
end

function util.tableIndexOf(t, value)
    for i, v in ipairs(t) do
        if v == value then return i end
    end
    return nil
end

function util.tableRemoveValue(t, value)
    for i = #t, 1, -1 do
        if t[i] == value then
            table.remove(t, i)
            return true
        end
    end
    return false
end

function util.deepcopy(src)
    if type(src) ~= "table" then return src end
    local out = {}
    for k, v in pairs(src) do out[k] = util.deepcopy(v) end
    return out
end

function util.mergeDefaults(dst, src)
    for k, v in pairs(src) do
        if type(v) == "table" then
            if type(dst[k]) ~= "table" then dst[k] = {} end
            util.mergeDefaults(dst[k], v)
        elseif dst[k] == nil then
            dst[k] = v
        end
    end
end

ns.util = util
