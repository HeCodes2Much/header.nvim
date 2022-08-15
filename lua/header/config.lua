---@class Config User config defaults
---@field username string: default username
---@field email string: default email
---@field git string: default git_url
---@field ft table: filetype configuration
local Config = {
	username = "username",
	email = "email@gmail.com",
  git = "git_url",
	ft = {
		c = {
			start_comment = "/*",
			end_comment = "*/",
			fill_comment = "*",
		},
		cpp = {
			start_comment = "/*",
			end_comment = "*/",
			fill_comment = "*",
		},
		make = {
			start_comment = "##",
			end_comment = "##",
			fill_comment = "#",
		},
		python = {
			start_comment = "##",
			end_comment = "##",
			fill_comment = "#",
		},
		lua = {
			start_comment = "--",
			end_comment = "--",
			fill_comment = "-",
		},
		vim = {
			start_comment = '""',
			end_comment = '""',
			fill_comment = "*",
		},
	},
}

setmetatable(Config, {
	__call = function(cls, ...)
		return cls:new(...)
	end,
})

---@param opts table
function Config:set(opts)
	self.__index = self
	self.username = opts.username or "username"
	self.email = opts.email or "email@gmail.com"
  self.git = opts.git or "git_url"
	if opts.ft ~= nil then
		self.ft = vim.tbl_deep_extend("force", self.ft, opts.ft)
	end
	return self
end

return Config