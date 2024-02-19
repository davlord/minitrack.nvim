local M = {}

local subscribers = {}

function M.subscribe(on_action)
    table.insert(subscribers, on_action)
end

function M.send(action)
    for _, on_action in ipairs(subscribers) do
	on_action(action)
    end
end

return M
