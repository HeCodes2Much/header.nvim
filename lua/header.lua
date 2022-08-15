local M = {}

local config
local utils = require("header.utils")
local bo = vim.bo
local api = vim.api

M.setup = function(opts)
	config = require("header.config"):set(opts)
end

--- Global function for command!
_G.StrHeader = function()
	local filetype = bo.filetype
	-- Error handling
	if config.ft[filetype] == nil then
		utils.error(string.format("Filetype '%s' is not registered", filetype))
		return
	else
		local fields = { "start_comment", "end_comment", "fill_comment" }
		for _, field in ipairs(fields) do
			if config.ft[filetype][field] == nil then
				utils.error(string.format("Missing required field for filetype '%s': %s", filetype, field))
				return
			end
		end
	end
	local header = require("header.header")
	local ft_config = config.ft[filetype]
	-- If header was not updated, insert it
	if not header.update(ft_config) then
		header.insert(ft_config)
	end
end

_G.StrHeader_update = function()
	local filetype = bo.filetype
	-- Error handling
	if config.ft[filetype] == nil then
		return
	else
		local fields = { "start_comment", "end_comment", "fill_comment" }
		for _, field in ipairs(fields) do
			if config.ft[filetype][field] == nil then
				utils.warn(
					string.format(
						"Could not update. Reason: Missing required field for filetype '%s': %s",
						filetype,
						field
					)
				)
				return
			end
		end
	end
	local ft_config = config.ft[filetype]
	require("header.header").update(ft_config)
end
api.nvim_command([[command! StrHeader lua StrHeader()]])
api.nvim_command([[autocmd BufWritePre * lua StrHeader_update()]])
return M