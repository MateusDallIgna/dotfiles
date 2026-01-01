local M = {}

function M:setup()
	ya.dbg("Yazi init.lua loaded successfully")

	if os.getenv("KITTY_PID") then
		ya.dbg("Running in Kitty terminal - graphics protocol should be available")
	end
end

return M