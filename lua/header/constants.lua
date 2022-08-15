local values = {}

values.header = [[%2s %74s %2s
%2s                                                                            %2s
%2s   File: %s/%s%s               %2s
%2s                                                                            %2s
%2s   Author: %s <%s>%s                      %2s
%2s   Git: %s %s                %2s
%2s                                                                            %2s
%2s   Created: %19s by %s%s                  %2s
%2s   Updated: %19s by %s%s                   %2s
%2s                                                                            %2s
%2s %74s %2s
]]

values.length = 80
values.margin = 5

--- Makes constants read-only by using lua `setmetatable`
-- @param tbl Table with all contants values
local set_constants = function(tbl)
	return setmetatable({}, {
		__index = tbl,
		__newindex = function(_, _, _)
			error("[header] Attempting to change constant value.")
		end,
	})
end

local constants = set_constants(values)

return constants