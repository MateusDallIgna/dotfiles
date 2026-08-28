hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})

hl.window_rule({
    name = "move-hyprland-run",
    match = { class = "hyprland-run" },
    float = true,
    move = { "20", "monitor_h - 120" },
})

hl.window_rule({
    match = { class = "kitty" },
    opacity = "0.98 0.98",
})

hl.window_rule({
    match = { title = "overskride" },
    float = true,
})

hl.window_rule({
    match = { class = "org.pulseaudio.pavucontrol" },
    float = true,
    size = { 923, 644 },
})

hl.window_rule({
    match = { class = "com.gabm.satty" },
    float = true,
})

hl.layer_rule({
    match = { namespace = "waybar" },
    blur = true,
    ignore_alpha = 0.5,
})

hl.layer_rule({
    match = { namespace = "swaync-control-center" },
    blur = true,
    ignore_alpha = 0.5,
})

hl.layer_rule({
    match = { namespace = "swaync-notification-window" },
    blur = true,
    ignore_alpha = 0.5,
})

hl.layer_rule({
    match = { namespace = "logout_dialog" },
    blur = true,
    animation = "fade",
})

hl.layer_rule({
    match = { namespace = "rofi" },
    blur = true,
    ignore_alpha = 0.1,
})
