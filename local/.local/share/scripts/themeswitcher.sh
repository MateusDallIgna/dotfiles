#!/bin/bash

THEMES=$($HOME/.local/share/scripts/listthemes.sh)

SELECTED_THEME=$(echo "$THEMES" | rofi -dmenu -p "Select Theme:" -theme ~/.config/rofi/styles/themeluncher.rasi)

if [ -n "$SELECTED_THEME" ]; then
    $HOME/.local/share/scripts/applytheme.sh "$SELECTED_THEME"
fi
