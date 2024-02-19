local actions = require("minitrack.util.actions")
local parser = require("minitrack.tracking.parser")

local M = {}

local tracking_buffer = nil
local tracking_window = nil
local termcodes = {
    space = vim.api.nvim_replace_termcodes("<space>", true, true, true),
    escape = vim.api.nvim_replace_termcodes("<esc>", true, true, true)
}

local function insert_current_time_normal_mode()
	local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1]
	local current_time = os.date('%H:%M')
	if current_time:sub(1,1) == "0" then
		current_time = current_time:sub(2)
	end
	if parser.parse_tracking_line(line) then
		vim.fn.feedkeys("o")
	else
		vim.fn.feedkeys("I")
	end
	vim.fn.feedkeys(current_time)
	vim.fn.feedkeys(termcodes.space)
end

local function insert_current_time_insert_mode()
	vim.fn.feedkeys(termcodes.escape)
        insert_current_time_normal_mode()
end

local function update_state_tracking_buf(buffer)
	tracking_buffer = buffer
	vim.api.nvim_buf_set_keymap(
		tracking_buffer,
		"n",
		MinitrackConfig.keybinds.insert_current_time,
		"",
		{ callback = insert_current_time_normal_mode }
	)

	vim.api.nvim_buf_set_keymap(
		tracking_buffer,
		"i",
		MinitrackConfig.keybinds.insert_current_time,
		"",
		{ callback = insert_current_time_insert_mode }
	)
end

function M.open(day)
	local previous_win = vim.api.nvim_get_current_win()
	vim.api.nvim_set_current_win(tracking_window)
	local tracking_file = MinitrackConfig.dir .. '/' .. day:to_string() .. MinitrackConfig.tracking_file_extension
	vim.cmd('e ' .. tracking_file)
	update_state_tracking_buf(vim.api.nvim_get_current_buf())
	vim.api.nvim_set_current_win(previous_win)
end

function M.set_window(window)
    tracking_window = window
end

function M.get_parsed_tracking_lines(stop_at_current_time)
     local tracking_lines = vim.api.nvim_buf_get_lines(tracking_buffer, 0, -1, false)
     return parser.parse_tracking_lines(tracking_lines, stop_at_current_time)
end

local function on_action(action)
    if action.type == "APPEND_NEW_TRACKING_LINE" then
	vim.api.nvim_set_current_win(tracking_window)
	vim.fn.feedkeys("G")
	insert_current_time_normal_mode()
    end
end
actions.subscribe(on_action)

return M
