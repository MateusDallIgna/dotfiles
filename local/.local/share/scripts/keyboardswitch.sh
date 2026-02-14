#!/bin/bash

hyprctl switchxkblayout all next

LAYOUT=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap')

notify-send -e -h string:x-canonical-private-synchronous:osd -r 99 \
    "Keyboard" \
    "Layout Set: <b>$LAYOUT</b>" \
    -i input-keyboard
