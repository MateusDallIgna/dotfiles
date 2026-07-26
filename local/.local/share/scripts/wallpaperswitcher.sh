#!/bin/bash

CWD=$(pwd)

CURRENT_THEME="$(head -n 1 ~/.cache/current_theme.txt)"
WALLPAPER_PATH=$HOME/.local/share/themes/$CURRENT_THEME/wallpapers

cd "$WALLPAPER_PATH" || exit

CACHE_DIR="/tmp/rofi-wp-cache/$CURRENT_THEME"
mkdir -p "$CACHE_DIR"

SELECTED_WALLPAPER=$(for theme in *.jpg *.png *.gif; do
    thumb="$CACHE_DIR/${theme%.*}.png"
    if [ "$theme" -nt "$thumb" ]; then
        convert "$theme" -resize x500 -gravity center -crop 340x500+0+0 +repage "$thumb"
    fi
    echo -en "$theme\0icon\x1f$thumb\n"
done | rofi -i -dmenu -p "" -theme ~/.config/rofi/styles/wallpaperluncher.rasi)

if [ -n "$SELECTED_WALLPAPER" ]; then
    awww img -t center --transition-duration 3 --transition-fps 60 "$WALLPAPER_PATH/$SELECTED_WALLPAPER"
    echo "$SELECTED_WALLPAPER" > "$HOME/.local/share/themes/$CURRENT_THEME/wall.set"
    cp "$WALLPAPER_PATH/$SELECTED_WALLPAPER" "$HOME/.config/rofi/backgrounds/current_wallpaper.png"
fi

cd "$CWD" || exit
