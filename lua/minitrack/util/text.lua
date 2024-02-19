local M = {}
-- size: positive aligns right, negative aligns left
function M.padding(text, size)
    return string.format('%'..size..'s', text)
end

function M.max_length(texts)
    local max_length = 0
    for _, text in ipairs(texts) do
	max_length = math.max(max_length, string.len(text))
    end
    return max_length
end

return M
