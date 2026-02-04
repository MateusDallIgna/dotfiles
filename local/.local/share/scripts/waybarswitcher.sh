#!/bin/bash

THEMES=$($HOME/.local/share/scripts/listwaybars.sh)

SELECTED_THEME=$(echo "$THEMES" | rofi -dmenu -p "Select Waybar:" -theme ~/.config/rofi/styles/themeluncher.rasi)

if [ -n "$SELECTED_THEME" ]; then
    cp ~/.local/share/waybars/"$SELECTED_THEME"/config.jsonc ~/.config/waybar/config.jsonc
    cp ~/.local/share/waybars/"$SELECTED_THEME"/style.css ~/.config/waybar/style.css
    $($HOME/.local/share/scripts/startwaybar.sh)
fi
