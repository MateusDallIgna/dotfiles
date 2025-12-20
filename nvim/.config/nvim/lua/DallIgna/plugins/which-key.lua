return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 10
	end,
	config = function()
		require("which-key").setup({})
	end,
}
