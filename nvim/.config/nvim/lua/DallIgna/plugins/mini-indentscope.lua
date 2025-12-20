return {
	"echasnovski/mini.indentscope",
	version = "*", -- Use the latest stable version
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("mini.indentscope").setup({
			-- symbol = "│",
			symbol = "│",
			options = {
				-- Type of animation: 'none', 'linear', 'inout', 'elastic'
				animation = function(s, n)
					return s / n * 20
				end,
			},
			-- Disable on specific file types to keep it clean
			mappings = {
				-- Mapping to toggle the plugin manually if needed
				toggle = "<leader>ti",
			},
		})

		-- Disable for certain filetypes (like Dashboard or Lazy)
		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"help",
				"alpha",
				"dashboard",
				"neo-tree",
				"Trouble",
				"lazy",
				"mason",
				"notify",
				"toggleterm",
				"lazyterm",
			},
			callback = function()
				vim.b.miniindentscope_disable = true
			end,
		})
	end,
}
