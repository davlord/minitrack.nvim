local M = {}

function M.create_dir_if_missing(dir)
    if vim.fn.isdirectory(dir) == 0 then
	vim.fn.mkdir(dir)
    end
end

return M
