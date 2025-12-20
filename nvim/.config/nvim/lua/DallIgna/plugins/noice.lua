return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	opts = {
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
		},
		-- Presets
		presets = {
			bottom_search = true, -- Search  '/' bottom (classic), command line ':' flowt
			command_palette = true, -- Command palette for ':' and '/'
			long_message_to_split = true, -- Long messages go to a split
			inc_rename = false, -- Inline rename
		},
	},
}
