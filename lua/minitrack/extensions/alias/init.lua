local util = require("minitrack.util")
local section = require("minitrack.report.section")

local M = {}

local function unalias_topic(topic)
    local sorted_aliases = util.table.keys_sorted_reverse(MinitrackConfig.aliases)
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
    return section.details(day, unaliased_map)
end

function M.get_config()
    return {
	aliases = {},
	report_modes = {
	    ["unalias"] = {
		{ id="title", renderer=section.title },
		{ id="day", renderer=section.day },
		{ renderer=section.section_separator },
		{ id="details", renderer=details_unaliased },
		{ renderer=section.section_separator },
		{ id="summary", renderer=section.summary },
	    }
	},
    }
end

return M
