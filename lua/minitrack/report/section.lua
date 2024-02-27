local util = require("minitrack.util")
local M = {}

local logo = {
    "           _       _ _                  _    ",
    " _ __ ___ (_)_ __ (_) |_ _ __ __ _  ___| | __",
    "| '_ ` _ \\| | '_ \\| | __| '__/ _` |/ __| |/ /",
    "| | | | | | | | | | | |_| | | (_| | (__|   < ",
    "|_| |_| |_|_|_| |_|_|\\__|_|  \\____|\\___|_|\\_\\"
}
local logo_max_length = util.text.max_length(logo)
local separator = "- - - - - - - - - - - -"

function M.details(_, map)
    local max_topic_len = 0
    for _, report_line in ipairs(map) do
	max_topic_len = math.max(max_topic_len, string.len(report_line.topic))
    end

    local r = {}
    for _, report_line in ipairs(map) do
	table.insert(r, util.text.padding(report_line.topic, -max_topic_len)  .. "  " .. util.duration.format(report_line.duration))
    end

    return r
end

function M.summary(day, map)
    local total_duration = 0
    for _, report_line in ipairs(map) do
	total_duration = total_duration + report_line.duration
    end

    local r = {
	separator,
	"tracked:   \t" .. util.duration.format(total_duration),
    }

    return r
end

function M.title(_, _)
    local title = util.table.copy(logo)
    title[#title] = title[#title] .. " v" .. MinitrackConfig.version
    table.insert(title, util.text.padding(MinitrackConfig.catchphrase, logo_max_length))
    return title
end

function M.day(day, _)
    local day_string = day:to_string("%A %d %B %Y")
    if day:is_today() then
    	day_string = day_string .. " (today)"
    end
    return {
	day_string,
	separator,
    }
end

function M.section_separator(_, _)
    return {""}
end

return M
