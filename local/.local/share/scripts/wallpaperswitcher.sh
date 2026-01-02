#!/bin/bash

CWD=$(pwd)

CURRENT_THEME="$(head -n 1 ~/.cache/current_theme.txt)"

WALLPAPER_PATH=$HOME/.local/share/themes/$CURRENT_THEME/wallpapers

cd $WALLPAPER_PATH || exit

SELECTED_WALLPAPER=$(for theme in *.jpg *.png *.gif; do echo -en "$theme\0icon\x1f$theme\n" ; done | rofi -dmenu -p "" -theme ~/.config/rofi/styles/wallpaperluncher.rasi)
    
if [ -n "$SELECTED_WALLPAPER" ]; then
    swww img -t center --transition-duration 3 --transition-fps 60 "$WALLPAPER_PATH/$SELECTED_WALLPAPER"
    echo "$SELECTED_WALLPAPER" > $HOME/.local/share/themes/$CURRENT_THEME/wall.set
    ## set rofi background image
    cp "$WALLPAPER_PATH/$SELECTED_WALLPAPER" $HOME/.config/rofi/backgrounds/current_wallpaper.png

fi

cd $CWD || exit
