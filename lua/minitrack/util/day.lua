local day_in_seconds = 24*60*60
local day_format = '%Y%m%d'
local day_pattern = '(%d%d%d%d)(%d%d)(%d%d)'

local M = {
    time = nil
}

function M:new(time)
    local mt  = {
	time = time or os.time()
    }
    setmetatable(mt, self)
    self.__index = self
    return mt
end

function M:to_string(format)
    return os.date(format or day_format, self.time)
end

function M:from_string(day_string)
    local year, month, day = day_string:match(day_pattern)
    local date_table = {year = year, month = month, day = day}
    local time = os.time(date_table)
    return M:new(time)
end

function M:from_me(days_count)
    return M:new(self.time + (days_count * day_in_seconds))
end

function M:is_today()
    return self:to_string() == M:new():to_string()
end

return M
