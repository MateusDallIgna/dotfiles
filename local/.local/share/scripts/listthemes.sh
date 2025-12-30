#!/bin/bash

THEMES_DIR=$HOME/.local/share/themes

cd $THEMES_DIR ||  exit >&2

for theme in */; do 
    for app in kitty rofi waybar; do
        if [ ! -f "$theme/${app}.theme" ]; then
            echo "$theme is missing $app style file"
            exit 1
        fi
    
    done
    echo "${theme%/}"
done | sort
