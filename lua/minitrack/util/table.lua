local M ={}

local function revert_sort(a, b)
    return a > b
end

function M.keys(t)
    local keys = {}
    for k,_ in pairs(t) do
	table.insert(keys, k)
    end
    return keys
end

function M.keys_sort_by(t, sort_fn)
    local keys = M.keys(t)
    table.sort(keys, sort_fn)
    return keys
end

function M.keys_sorted_reverse(t)
    return M.keys_sort_by(t, revert_sort)
end

function M.map(t, map_fn)
    local m = {}
    for i,v in ipairs(t) do
        m[i] = map_fn(v, i)
    end
    return m
end

function M.copy(t)
    local c = {}
    for k,v in pairs(t) do
        c[k] = v
    end
    return c
end

local function table_merge(target, source)
	for k,v in pairs(source) do
	    if type(target[k]) == "table" and type(v) == "table" then
		table_merge(target[k], v)
	    else
		target[k] = v
	    end
	end
end

function M.merge(target, ...)
    local sources = {...}
    local result = M.copy(target)
    for _,source in ipairs(sources) do
	table_merge(result, source)
    end

    return result
end

return M
