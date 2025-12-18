return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	lazy = true,
	cmd = "Neotree",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("neo-tree").setup({
			filesystem = {
				follow_current_file = { enabled = true },
				hijack_netrw = true,
				use_libuv_file_watcher = true,
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_by_name = { "node_modules", ".git", "build" },
					never_show = { ".DS_Store", "thumbs.db" },
				},
			},
			buffers = {
				follow_current_file = { enabled = true },
			},
			git_status = {
				enabled = false,
			},
			window = {
				mappings = {
					["a"] = "add",
					["d"] = "delete",
					["r"] = "rename",
					["y"] = "copy_to_clipboard",
					["x"] = "cut_to_clipboard",
					["p"] = "paste_from_clipboard",
					["q"] = "close_window",
					["R"] = "refresh",
					["<BS>"] = "navigate_up",
					["h"] = "navigate_up",
					["l"] = "open",
				},
			},
		})
	end,
}
