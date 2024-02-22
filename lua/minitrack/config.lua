local util = require("minitrack.util")
local section = require("minitrack.report.section")

local fixed_config = {
    dir = vim.fn.stdpath("data") .. '/minitrack',
    tracking_file_extension = '.minitrack',
    version = "0.1",
    report_buffer_name = 'MINITRACK_REPORT',
}
local default_user_config = {
    catchphrase = "make time tracking great again",
    keybinds = {
	insert_current_time = "<C-i>",
	navigate_day_previous = "<C-Left>",
	navigate_day_next = "<C-Right>",
	navigate_day_today = "<C-Down>",
	change_report_mode = "m",
	change_report_sort = "s",
	copy_report_details = "y",
    },
    report_modes = {
	["standard"] = {
	    { renderer=section.title },
	    { renderer=section.day },
	    { renderer=section.section_separator },
	    { renderer=section.details, line_range="details" },
	    { renderer=section.section_separator },
	    { renderer=section.summary },
	}
    },
}

MinitrackConfig = MinitrackConfig or {}
local M = {}

function M.apply(user_config)
    MinitrackConfig = util.table.merge(
	default_user_config,
	user_config or {},
	fixed_config
    )
end

M.apply() -- default config in case apply is never called

return M


