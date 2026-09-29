local bookmarks = {
	{ tag = "Home",         path = "~",                          key = "h" },
	{ tag = "Config",       path = "~/.config",                  key = "c" },
	{ tag = "Documentos",   path = "~/Documentos",               key = "d" },
	{ tag = "Big_Projects", path = "~/Documentos/Big_Projects",  key = "p" },
	{ tag = "Workspace",    path = "~/Documentos/Workspace",     key = "w" },
	{ tag = ".local",       path = "~/.local",                   key = "l" },
	{ tag = "Yazi",         path = "~/.config/yazi",             key = "y" },
	{ tag = "Nvim",         path = "~/.config/nvim",             key = "n" },
}

require("whoosh"):setup {
	bookmarks = bookmarks,
	jump_notify = false,
}

require("git"):setup {
	order = 1500,
}

require("full-border"):setup {
	type = ui.Border.ROUNDED,
}

require("glyphmark"):setup()

require("sduf"):setup()

require("linemode-plus"):setup {
	date_mode = "custom",
	custom = {
		order = { "year", "month", "day" },
		separator = "-",
		year_digits = 4,
	},
}
