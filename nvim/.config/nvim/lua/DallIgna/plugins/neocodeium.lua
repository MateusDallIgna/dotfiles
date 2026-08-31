return {
	"monkoose/neocodeium",
	cmd = "NeoCodeium",
	event = "InsertEnter",
	config = function()
		local neocodeium = require("neocodeium")
		neocodeium.setup({
			enabled = false,
			debounce = false,
			filetypes = {
				help = false,
				gitcommit = false,
				gitrebase = false,
				["."] = false,
			},
		})
		vim.keymap.set("i", "<C-y>", neocodeium.accept)
	end,
}
