hl.config({
    input = {
        kb_layout = "us,br",
        kb_variant = ",abnt2",

        numlock_by_default = false,

        sensitivity = 0.2,
        accel_profile = "adaptive",

        follow_mouse = 1,

        touchpad = {
            tap_to_click = true,
            natural_scroll = false,
        },

        tablet = {
            left_handed = true,
            transform = 2,
        },
    },

    binds = {
        workspace_center_on = 1,
        movefocus_cycles_fullscreen = true,
    },

    cursor = {
        sync_gsettings_theme = true,
        inactive_timeout = 3,
        hide_on_key_press = true,
        warp_on_change_workspace = true,
        persistent_warps = true,
        no_hardware_cursors = true,
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})

hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})
