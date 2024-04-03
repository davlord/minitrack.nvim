local parser = require("minitrack.tracking.parser")
local util = require("minitrack.util")

local M = {}

local function reallocate_details(map)
    local new_map = {}
    local total_duration = 0;
    local duration_to_reallocate = 0;
    for _, report_line in ipairs(map) do
	if report_line.topic == MinitrackConfig.topic_to_reallocate then
	    duration_to_reallocate = duration_to_reallocate + report_line.duration
	else
	    table.insert(new_map, util.table.copy(report_line))
	end
	total_duration = total_duration + report_line.duration
    end

    local remaining_duration_to_reallocate = duration_to_reallocate
    for i, report_line in ipairs(new_map) do
	if i == #new_map then
	    report_line.duration = report_line.duration + remaining_duration_to_reallocate
	    remaining_duration_to_reallocate = 0
	else
	    local duration_to_add = math.ceil(duration_to_reallocate * report_line.duration / total_duration + 0.5)
	    report_line.duration = report_line.duration + duration_to_add
	    remaining_duration_to_reallocate = remaining_duration_to_reallocate - duration_to_add
	end
    end

    return new_map
end

function M.get_config()
    parser.register_parsed_tracking_converter(reallocate_details)
    return {
	topic_to_reallocate = "_",
    }
end

return M
