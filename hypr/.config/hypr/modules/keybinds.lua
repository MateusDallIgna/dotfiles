local mainMod = "SUPER"
local scrPath = os.getenv("HOME") .. "/.local/share/scripts"
local terminal = "kitty"
local fileManager = os.getenv("HOME") .. "/.local/share/scripts/filemanager.sh"
local browser = "zen-browser"
local home = os.getenv("HOME")

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"))
hl.bind(mainMod .. " + W", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t"))
hl.bind(mainMod .. " + G", hl.dsp.group.toggle())
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd("hyprctl dispatch togglefloating active && hyprctl dispatch pin active"))
hl.bind("ALT + Return", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind("ALT + SHIFT + Return", hl.dsp.window.fullscreen_state({ internal = 0, client = 2 }))
hl.bind(mainMod .. " + Backspace", hl.dsp.exec_cmd("wlogout -b 5"))

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))

hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(scrPath .. "/wallpaperswitcher.sh"))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd(scrPath .. "/themeswitcher.sh"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(scrPath .. "/rofi_launcher.sh || pkill -x rofi"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(scrPath .. "/screenshot.sh region"))
hl.bind("Print", hl.dsp.exec_cmd(scrPath .. "/screenshot.sh window"))
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd(scrPath .. "/keyboardswitch.sh"))
hl.bind(mainMod .. " + ALT + W", hl.dsp.exec_cmd(scrPath .. "/waybarswitcher.sh"))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu -theme .config/rofi/styles/minimal.rasi | cliphist decode | wl-copy"))
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd(home .. "/.config/hyprlock/scripts/hyprlock.sh"))

-- Scrolling layout: focus rolls the tape horizontally, plain focus within column
hl.bind(mainMod .. " + H", hl.dsp.layout("focus l"))
hl.bind(mainMod .. " + L", hl.dsp.layout("focus r"))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))

hl.bind(mainMod .. " + ALT + H", hl.dsp.layout("swapcol l"))
hl.bind(mainMod .. " + ALT + L", hl.dsp.layout("swapcol r"))
hl.bind(mainMod .. " + ALT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + ALT + J", hl.dsp.window.move({ direction = "d" }))

hl.bind(mainMod .. " + CTRL + H", hl.dsp.group.prev())
hl.bind(mainMod .. " + CTRL + L", hl.dsp.group.next())

hl.bind(mainMod .. " + SHIFT + H", hl.dsp.layout("move -col"))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.layout("move +col"))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.layout("consume_or_expel next"))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.layout("consume_or_expel prev"))

hl.bind(mainMod .. " + I", hl.dsp.layout("colresize +conf"))
local uWide = false
hl.bind(mainMod .. " + U", function()
  uWide = not uWide
  hl.dispatch(hl.dsp.layout("colresize " .. (uWide and "1.0" or "0.5")))
end)

for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
    hl.bind(mainMod .. " + ALT + " .. i, hl.dsp.window.move({ workspace = i, follow = false }))
end
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))
hl.bind(mainMod .. " + ALT + 0", hl.dsp.window.move({ workspace = 10, follow = false }))

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special())
hl.bind(mainMod .. " + ALT + S", hl.dsp.window.move({ workspace = "special" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))

hl.define_submap("resize", function()
    -- h/l resize the column width (tiling); j/k fall back to window resize (floats)
    hl.bind("l", hl.dsp.layout("colresize +0.05"), { repeating = true })
    hl.bind("h", hl.dsp.layout("colresize -0.05"), { repeating = true })
    hl.bind("j", hl.dsp.window.resize({ x = 0, y = 30, relative = true }), { repeating = true })
    hl.bind("k", hl.dsp.window.resize({ x = 0, y = -30, relative = true }), { repeating = true })

    hl.bind("escape", hl.dsp.submap("reset"))
    hl.bind("return", hl.dsp.submap("reset"))
end)

hl.bind("F12", hl.dsp.exec_cmd(scrPath .. "/volume.sh --increase"), { locked = true, repeating = true })
hl.bind("F11", hl.dsp.exec_cmd(scrPath .. "/volume.sh --decrease"), { locked = true, repeating = true })
hl.bind("F10", hl.dsp.exec_cmd(scrPath .. "/volume.sh --toggle-mute"), { locked = true })
hl.bind("F9", hl.dsp.exec_cmd(scrPath .. "/volume.sh --toggle-mute-source"), { locked = true })
hl.bind("F8", hl.dsp.exec_cmd(scrPath .. "/brightnesscontrol.sh --increase"), { locked = true, repeating = true })
hl.bind("F7", hl.dsp.exec_cmd(scrPath .. "/brightnesscontrol.sh --decrease"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
