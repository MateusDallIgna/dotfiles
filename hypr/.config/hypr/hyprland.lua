package.path = package.path .. ";" .. os.getenv("HOME") .. "/.config/hypr/?.lua"

require("modules.monitors")
require("modules.variables")
require("modules.animation")
require("modules.appearance")
require("modules.input")
require("modules.layouts")
require("modules.autostart")
require("modules.windowrules")
require("modules.keybinds")
