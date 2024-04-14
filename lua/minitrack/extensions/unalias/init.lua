local util = require("minitrack.util")
local report = require("minitrack.report")

local original_renderer = nil

local M = {}

local function sort_by_text_length_desc(a, b)
    return string.len(b) - string.len(a)
end

local function unalias_topic(topic)
    local sorted_aliases = util.table.keys_sort_by(MinitrackConfig.aliases, sort_by_text_length_desc)
    for _, from in ipairs(sorted_aliases) do
	if string.find(topic, from, 1, true) then
	    local to = MinitrackConfig.aliases[from]
	    return string.gsub(topic, from, to)
	end
    end
    return topic
end

local function unalias(map)
    local unaliased_map = {}
    for _, report_line in pairs(map) do
	table.insert(unaliased_map, {
	    topic = unalias_topic(report_line.topic),
	    duration = util.duration.round(report_line.duration, 5)
	})
    end
    return unaliased_map
end

local function details_unaliased(day, map)
    local unaliased_map = unalias(map)
    return original_renderer(day, unaliased_map)
end

function M.get_config()
    original_renderer = report.get_renderer("details")
    report.set_renderer("details_unaliased", details_unaliased)
    return {
	aliases = {},
	report_modes = {
	    ["unalias"] = {
		"title",
		"separator",
		"day",
		"separator",
		"details_unaliased",
		"separator",
		"summary",
	    }
	},
    }
end

return M
