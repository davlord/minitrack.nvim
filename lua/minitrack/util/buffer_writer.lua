local M = {
    buffer = nil,
    last_written_line = 0
}

function M:new(buffer)
    local mt  = {
	buffer = buffer,
        last_written_line = 0
    }
    setmetatable(mt, self)
    self.__index = self
    return mt
end

function M:set_lines_at(start, lines)
    vim.api.nvim_buf_set_lines(self.buffer, start, -1, true, lines)
    local from = self.last_written_line + 1
    local to = self.last_written_line + #lines
    self.last_written_line = to
    return {
	from = from,
	to = to
    }
end

function M:clear()
    self.last_written_line = 0
    return self:set_lines_at(0, {})
end

function M:append_lines(lines)
    return self:set_lines_at(-1, lines)
end

return M
