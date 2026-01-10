#!/bin/bash

hyprctl switchxkblayout all next

LAYOUT=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap')

notify-send -u low -r 99 \
    "Keyboard" \
    "Layout Set: <b>$LAYOUT</b>" \
    -i input-keyboard
