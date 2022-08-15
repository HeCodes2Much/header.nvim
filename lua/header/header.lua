local header = {}

local config = require("header.config")
local constants = require("header.constants")

local fn = vim.fn
local bo = vim.bo

--- Formats the header for insertion
local function format_header(ft_config)
	local filename = fn.expand("%:t")
  local dir = os.getenv("PWD") or io.popen("cd"):read()
	local username = ft_config.username or config.username
	local email = ft_config.email or config.email
  local git = ft_config.git or config.git
	-- Calculate spaces to keep the header tidy
	local SPACES_AFTER_FILENAME = constants.length - (2 * constants.margin) - string.len(filename) - string.len(dir) - 19
  local SPACES_AFTER_GIT = constants.length - (2 * constants.margin) - string.len(git) - 19
	local SPACES_AFTER_EMAIL = constants.length - (2 * constants.margin) - string.len(email) - string.len(username) - 30
	local SPACES_AFTER_CREATED = constants.length - (2 * constants.margin) - string.len(username) - 52
	local SPACES_AFTER_UPDATED = SPACES_AFTER_CREATED - 1
	-- stylua: ignore
	return string.format(constants.header,
		ft_config.start_comment, string.rep(ft_config.fill_comment, 74), ft_config.end_comment,
		ft_config.start_comment, ft_config.end_comment,
		ft_config.start_comment, dir, filename, string.rep(' ', SPACES_AFTER_FILENAME), ft_config.end_comment,
		ft_config.start_comment, ft_config.end_comment,
		ft_config.start_comment, username, email, string.rep(' ', SPACES_AFTER_EMAIL), ft_config.end_comment,
    ft_config.start_comment, git, string.rep(' ', SPACES_AFTER_GIT), ft_config.end_comment,
		ft_config.start_comment, ft_config.end_comment,
		ft_config.start_comment, fn.strftime("%d %b %Y, %I:%M:%S %P"), username, string.rep(' ', SPACES_AFTER_CREATED), ft_config.end_comment,
		ft_config.start_comment, fn.strftime("%d %b %Y, %I:%M:%S %P"), username, string.rep(' ', SPACES_AFTER_UPDATED), ft_config.end_comment,
		ft_config.start_comment, ft_config.end_comment,
		ft_config.start_comment, string.rep(ft_config.fill_comment, 74), ft_config.end_comment
	)
end

--- Adds header to current buffer
header.insert = function(ft_config)
	-- Adds each line of the header on the current file
	local lineno = 0
	local formated_header = format_header(ft_config)
	for line in formated_header:gmatch("(.-)\n") do
		fn.append(lineno, line)
		lineno = lineno + 1
	end
end

-- Updates if header is already present on the file
header.update = function(ft_config)
	-- Check if filetype is supported
	if config.ft[bo.filetype] == nil then
		return false
	end
	local username = ft_config.username or config.username
	-- Searches for the "Updated by" line of the header
	local found = fn.getline(9):find(
		ft_config.start_comment .. string.rep(" ", constants.margin - #ft_config.start_comment) .. "Updated: "
	)
	if found then
		local filename = fn.expand("%:t")
    local dir = os.getenv("PWD") or io.popen("cd"):read()
		local SPACES_AFTER_FILENAME = constants.length - (2 * constants.margin) - string.len(filename) - string.len(dir) - 19
		local SPACES_AFTER_UPDATED = constants.length - (2 * constants.margin) - string.len(username) - 53
		-- Sets the filename line(useful for when renaming files)
		fn.setline(
			3,
			string.format(
				"%2s   File: %s/%s%s               %2s",
				ft_config.start_comment,
				dir,
        filename,
				string.rep(" ", SPACES_AFTER_FILENAME),
				ft_config.end_comment
			)
		)
		-- Sets the "Updated by" line of the header
		fn.setline(
			9,
			string.format(
				"%2s   Updated: %19s by %s%s                   %2s",
				ft_config.start_comment,
				fn.strftime("%d %b %Y, %I:%M:%S %P"),
				username,
				string.rep(" ", SPACES_AFTER_UPDATED),
				ft_config.end_comment
			)
		)
		return true
	end
	return false
end

return header