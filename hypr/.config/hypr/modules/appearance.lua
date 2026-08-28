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
            enabled = true,
            size = 8,
            passes = 4,

            new_optimizations = true,

            contrast = 2,
            vibrancy = 1,
            noise = 0.0,
        },

        shadow = {
            enabled = true,
            range = 5,
            render_power = 6,
            color = 0xff1a1a1a,
        },
    },
})
