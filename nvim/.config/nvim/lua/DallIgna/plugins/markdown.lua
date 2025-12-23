return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "Avante" },
		opts = {
			file_types = { "markdown", "Avante" },
			code = {
				sign = false,
				width = "block",
				right_pad = 1,
			},
			heading = {
				sign = false,
				icons = { "", "", "", "", "", "" },
			},
			config = function(_, opts)
				require("render-markdown").setup(opts)
				--Automatically enable render-markdown when opening a markdown file
				require("render-markdown").enable()
			end,
		},
	},
}
