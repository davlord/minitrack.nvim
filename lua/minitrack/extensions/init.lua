local M = {}

local extensions_configs = {}

function M.setup(extension_name)
	local ok, extension = pcall(require, "minitrack.extensions." .. extension_name)
	if not ok then
	   error("unable to load extension ".. extension_name)
	end
	table.insert(extensions_configs, extension.get_config())
end

function M.get_configs()
    return extensions_configs
end

return M
