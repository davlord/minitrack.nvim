local BufferWriter = require("minitrack.util.buffer_writer")
local actions = require("minitrack.util.actions")

local M = {}

local report_buffer = nil
local sort_duration = true
local memo = {
    day = nil,
    map = {},
}
local line_ranges = {}
local current_mode = "standard"

local function refresh_same()
    M.refresh(memo.day, memo.map)
end

local function toggle_sort()
	sort_duration = not sort_duration
	refresh_same()
end

local function yank_details()
    local range = line_ranges["details"]
    vim.cmd( range.from .. ',' .. range.to .. 'y')
end

local function sort_by_topic(a, b)
    return a.topic < b.topic
end

local function sort_by_duration_desc(a, b)
    return a.duration > b.duration
end

local function cycle_modes()
    -- TODO crappy impl, improve
    local pick_next = false
    for mode, _ in pairs(MinitrackConfig.report_modes) do
	if pick_next then
	    current_mode = mode
            refresh_same()
	    return
	end
	if not pick_next and mode == current_mode then
		pick_next = true
	end
    end
    -- if not found pick first
    for mode, _ in pairs(MinitrackConfig.report_modes) do
	    current_mode = mode
            refresh_same()
	    return
    end
end

function M.get_mode()
    return current_mode
end

function M.open(day, map)
	vim.api.nvim_command("botright vsplit " .. MinitrackConfig.report_buffer_name)
	report_buffer = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_set_keymap(
		report_buffer,
		"n",
		MinitrackConfig.keybinds.navigate_day_previous,
		"",
		{ callback = function() actions.send{ type = "NAVIGATE_DAY", args = "previous" } end }
	)
	vim.api.nvim_buf_set_keymap(
		report_buffer,
		"n",
		MinitrackConfig.keybinds.navigate_day_next,
		"",
		{ callback = function() actions.send{ type = "NAVIGATE_DAY", args = "next" } end }
	)
	vim.api.nvim_buf_set_keymap(
		report_buffer,
		"n",
		MinitrackConfig.keybinds.navigate_day_today,
		"",
		{ callback = function() actions.send{ type = "NAVIGATE_DAY", args = "today" } end }
	)
	vim.api.nvim_buf_set_keymap(
		report_buffer,
		"n",
		MinitrackConfig.keybinds.change_report_mode,
		"",
		{ callback = cycle_modes }
	)
	vim.api.nvim_buf_set_keymap(
		report_buffer,
		"n",
		MinitrackConfig.keybinds.change_report_sort,
		"",
		{ callback = toggle_sort }
	)
	vim.api.nvim_buf_set_keymap(
		report_buffer,
		"n",
		MinitrackConfig.keybinds.copy_report_details,
		"",
		{ callback = yank_details }
	)
	vim.api.nvim_buf_set_keymap(
		report_buffer,
		"n",
		MinitrackConfig.keybinds.insert_current_time,
		"",
		{ callback = function()  actions.send{ type = "APPEND_NEW_TRACKING_LINE" } end }
	)
	vim.api.nvim_buf_set_option(report_buffer, 'buftype', 'nofile')
	M.refresh(day, map)
end

function M.refresh(day, map)
    local sort_fn = sort_by_duration_desc
    if not sort_duration then
    	sort_fn = sort_by_topic
    end
    table.sort(map, sort_fn)

    vim.api.nvim_buf_set_option(report_buffer, 'modifiable', true)
    local bw = BufferWriter:new(report_buffer)
    bw:clear()

    for _,section in ipairs(MinitrackConfig.report_modes[current_mode]) do
	local line_range = bw:append_lines(section.renderer(day, map))
	if section.line_range then
	   line_ranges[section.line_range] = line_range
	end
    end
    vim.api.nvim_buf_set_option(report_buffer, 'modifiable', false)

    memo.day = day
    memo.map = map
end


return M
