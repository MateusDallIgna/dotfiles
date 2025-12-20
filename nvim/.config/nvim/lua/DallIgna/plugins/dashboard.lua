return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("dashboard").setup({
			theme = "doom",
			config = {
				header = {
					[[-._    _.--'"`'--._    _.--'"`'--._    _.--'"`'--._    _   ]],
					[[  '-:`.'|`|"':-.  '-:`.'|`|"':-.  '-:`.'|`|"':-.  '.` : '.   ]],
					[['.  '.  | |  | |'.  '.  | |  | |'.  '.  | |  | |'.  '.:   '.]],
					[[: '.  '.| |  | |  '.  '.| |  | |  '.  '.| |  | |  '.  '.  : ]],
					[['   '.  `.:_ | :_.' '.  `.:_ | :_.' '.  `.:_ | :_.' '.  `.' ]],
					[[     `-..,..-'       `-..,..-'       `-..,..-'       `     ]],
					[[                                     ]],
					[[ █▀▀▄  ▄▀▄  █    █    █   █  █  █▀▄▀█ ]],
					[[ █  █  █▀█  █    █    █   █  █  █ █ █ ]],
					[[ █▄▄▀  █ █  █▄▄  █▄▄   ▀▄▀   █  █   █ ]],
					[[                                     ]],
					[[           ]],
					[[  Evolving Code  ]],
					[[           ]],
					[[           ]],
				},
				center = {
					{
						action = "Telescope find_files",
						desc = " Find File",
						icon = " ",
						key = "f",
					},
					{
						action = "ene | startinsert",
						desc = " New File",
						icon = " ",
						key = "n",
					},
					{
						action = "Telescope oldfiles",
						desc = " Recent Files",
						icon = " ",
						key = "r",
					},
					{
						action = "Telescope live_grep",
						desc = " Find Text",
						icon = " ",
						key = "g",
					},
					{
						action = "qa",
						desc = " Quit",
						icon = " ",
						key = "q",
					},
				},
				footer = function()
					local stats = require("lazy").stats()
					local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
					return {
						"⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms",
						"",
						"",
						"It is not the strongest of the species that survives,",
						"nor the most intelligent...",
						"It is the one that is most adaptable to change.",
						"-- Charles Darwin",
					}
				end,
			},
		})
	end,
}
