local M = {}

function M.between(start_time, end_time)
    local duration = end_time - start_time
    if duration < 0 then
    	duration = (24 * 60 - start_time) + end_time
    end
    return duration
end

function M.format(duration)
    local h = math.floor(duration / 60)
    local m = duration % 60
    return string.format('%2d', h) .. ":" .. string.format("%02d", m)
end

function M.round(duration, step)
    return math.floor((duration / step) + 0.5) * step
end

return M
