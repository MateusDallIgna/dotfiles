#!/bin/bash

THEMES=$($HOME/.local/share/scripts/listthemes.sh)

SELECTED_THEME=$(echo "$THEMES" | rofi -dmenu -p "Select Theme:")

if [ -n "$SELECTED_THEME" ]; then
    $HOME/.local/share/scripts/applytheme.sh "$SELECTED_THEME"
fi
