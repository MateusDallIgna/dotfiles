return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" }, -- Loads only when opening a file
	config = function()
		require("gitsigns").setup({
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			-- Highlights the line number instead of the sign column (optional)
			numhl = false,
			-- Toggles word diff in the buffer (optional)
			word_diff = false,
			current_line_blame = true, -- Shows who edited the line (like VS Code GitLens)
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 500,
				ignore_whitespace = false,
			},
		})
	end,
}
