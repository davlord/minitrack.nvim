require("minitrack.util")
local config = require("minitrack.config")
local Day = require("minitrack.util.day")
local report = require("minitrack.report")
local tracking = require("minitrack.tracking")
local actions = require("minitrack.util.actions")
local fs = require("minitrack.util.fs")

local M = {}
local day = nil

local function refresh_report()
     report.refresh(day, tracking.get_parsed_tracking_lines(day:is_today()))
end

local function refresh()
	tracking.open(day)
	refresh_report()
end

local function on_realtime_events()
	if day:is_today() then
		refresh_report()
	end
end

local function init_autocommands()
	local minitrack_group = vim.api.nvim_create_augroup(
		"MINITRACK",
		{ clear = true }
	)
	vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			group = minitrack_group,
			pattern = "*" .. MinitrackConfig.tracking_file_extension,
			callback = refresh_report
	})
	vim.api.nvim_create_autocmd({ "CursorHold", "FocusGained", "FocusLost" }, {
			group = minitrack_group,
			pattern = {
				"*" .. MinitrackConfig.tracking_file_extension,
				MinitrackConfig.report_buffer_name
			},
			callback = on_realtime_events
	})
end

local function on_action(action)
    if action.type == "NAVIGATE_DAY" then
	if action.args == "next" then
		day = day:from_me(1)
	elseif action.args == "previous" then
		day = day:from_me(-1)
	elseif action.args == "today" then
		day = Day:new()
	end
	refresh()
    end
end

local function startup()
	fs.create_dir_if_missing(MinitrackConfig.dir)
	actions.subscribe(on_action)
	day = Day:new()
	tracking.set_window(vim.api.nvim_get_current_win())
	init_autocommands()
	tracking.open(day)
	report.open(day, tracking.get_parsed_tracking_lines(day:is_today()))
end

vim.api.nvim_create_user_command('Minitrack', startup, {})

function M.setup(options)
    config.apply(options)
end

return M
