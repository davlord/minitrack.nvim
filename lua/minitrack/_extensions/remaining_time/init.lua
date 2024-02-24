local section = require("minitrack.report.section")
local util = require("minitrack.util")

local M = {}

local function expected_duration_summary(day, map)
    local total_duration = 0
    for _, report_line in ipairs(map) do
	total_duration = total_duration + report_line.duration
    end

    local remaining_duration = MinitrackConfig.expected_duration - total_duration
    local overtime_duration = 0

    if remaining_duration < 0 then 
	overtime_duration = -remaining_duration
	remaining_duration = 0
    end

    local estimated_end = ''
    if day:is_today() and remaining_duration > 0 then
	estimated_end = ' (until ' .. os.date('%H:%M', os.time() + remaining_duration * 60) .. ')'
    end

    local r = section.summary(day, map)

    table.insert(r, "remaining: \t" .. util.duration.format(remaining_duration) .. estimated_end)

    if overtime_duration > 0 then 
	table.insert(r, "overtime:  \t" .. util.duration.format(overtime_duration))
    end

    return r
end

function M.get_config()
    return {
	expected_duration = 3*60,
	report_modes = {
	    ["standard"] = {
		{ id="title", renderer=section.title },
		{ id="day", renderer=section.day },
		{ renderer=section.section_separator },
		{ id="details", renderer=section.details },
		{ renderer=section.section_separator },
		{ id="summary", renderer=expected_duration_summary },
	    },
	} 
    }
end

return M
