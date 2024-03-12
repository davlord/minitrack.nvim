local util = require("minitrack.util")
local tracking_line_pattern = "([012]?%d):(%d%d)%s?(.*)"

local M = {}

local function to_time(h, m)
    return h * 60 + m
end

function M.parse_tracking_line(line)
    if line == nil then return nil end
    local i, _, h, m, topic = line:find(tracking_line_pattern)
    if i == nil then return nil end
    topic = topic:match'^%s*(.*)%s*$' -- trim spaces
    return {
	time = to_time(h, m),
	topic = topic,
	is_stop = topic == nil or topic == ''
    }
end

local function tracking_parse_lines(lines)
    if lines == nil then
	return {}
    end

    local parsed_lines = {}
    for i, line in ipairs(lines) do
	local parsed_line = M.parse_tracking_line(line)
	if parsed_line ~= nil then
		table.insert(parsed_lines, parsed_line)
	end
    end
    return parsed_lines
end


function M.parse_tracking_lines(raw_lines, stop_at_current_time)
    local lines = tracking_parse_lines(raw_lines)

    if not next(lines) then
    	return {}
    end

    if stop_at_current_time then
    	local last_line = lines[#lines]
	if not last_line.is_stop then
	        local now = os.date("*t")
		table.insert(lines, {
		    time = to_time(now.hour, now.min),
		    topic = nil,
		    is_stop = true
		})
	end
    end

    local map = {}
    for i, v in ipairs(lines) do
	if i == 1 then
	    goto continue
	end

	local previous = lines[i-1]
	if previous.is_stop then
	    goto continue
	end

	local current = v
	local duration = util.duration.between(previous.time, current.time)
	local topic = previous.topic
	if map[topic] == nil then
	    map[topic] = duration
	else
	    map[topic] = map[topic] + duration
	end

	::continue::
    end

    local tracking_parsed = {}

    for topic, duration in pairs(map) do
    	table.insert(tracking_parsed, {
	    topic = topic,
	    duration = duration
	})
    end

    return tracking_parsed
end

return M
