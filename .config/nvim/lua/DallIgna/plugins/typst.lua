return {
	{
		"chomosuke/typst-preview.nvim",
		ft = "typst",
		version = "1.*",
		build = function()
			require("typst-preview").update()
		end,
		opts = {
			open_automatically = false,
			invert_colors = "never",
		},
	},
	{
		"kaarmu/typst.vim",
		ft = "typst",
	},
}
