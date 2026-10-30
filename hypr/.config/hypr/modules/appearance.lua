hl.config({
	general = {
		border_size = 1,
		gaps_in = 3,
		gaps_out = 8,

		col = {
			active_border = {
				colors = { "rgba(33ccffee)", "rgba(00ff99ee)" },
				angle = 45,
			},
			inactive_border = "rgba(595959aa)",
		},

		layout = "scrolling",

		resize_on_border = false,
		hover_icon_on_border = true,

		allow_tearing = false,
	},

	decoration = {
		rounding = 15,
		rounding_power = 4,

		active_opacity = 1.0,
		inactive_opacity = 1.0,

		blur = {
			brightness = 0.5,
			enabled = true,
			size = 10,
			passes = 4,

			new_optimizations = true,

			contrast = 2,
			vibrancy = 1,
			noise = 0.0,

			-- variant = 8,
			-- acrylic = {
			-- 	refraction = 24,
			-- 	bulb = 5,
			-- 	clarity = 0.40,
			-- 	aberration = 0.25,
			-- },
		},

		shadow = {
			enabled = true,
			range = 5,
			render_power = 4,
			color = 0xff1a1a1a,
		},
	},
})
