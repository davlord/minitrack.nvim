local report = require("minitrack.report")
local util = require("minitrack.util")

local M = {}
local original_renderer = nil

local function reallocate_details(day, map)
    local new_map = {}
    local duration_to_reallocate = 0;
    for _, report_line in ipairs(map) do
	if report_line.topic == MinitrackConfig.topic_to_reallocate then
	    duration_to_reallocate = duration_to_reallocate + report_line.duration
	else
	    table.insert(new_map, util.table.copy(report_line))
	end
    end

    local duration_per_report = 0
    local duration_per_report_excess = 0

    if #new_map > 0 then
	duration_per_report = duration_to_reallocate / #new_map
	duration_per_report_excess = duration_to_reallocate % #new_map
    end
    for i, report_line in ipairs(new_map) do
	report_line.duration = report_line.duration + duration_per_report
	if i == 1 then
	    report_line.duration = report_line.duration + duration_per_report_excess
	end
    end

    return original_renderer(day, new_map);
end

function M.get_config()
    original_renderer = report.get_renderer("details")
    report.set_renderer("details", reallocate_details)
    return {
	topic_to_reallocate = "_",
    }
end

return M
