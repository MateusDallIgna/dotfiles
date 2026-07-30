#!/bin/bash

THEME_NAME=$1
THEME_DIR=$HOME/.local/share/themes/"$THEME_NAME"

for app in kitty rofi waybar; do
    THEME_FILE="$THEME_DIR/${app}.theme"

    FIRST_LINE=$(head -n1 "$THEME_FILE")

    DESTINATION=$(echo "$FIRST_LINE" | cut -d '|' -f1)
    DESTINATION=$(eval echo "$DESTINATION")

    CMD=$(echo "$FIRST_LINE" | cut -d '|' -f2-)

    tail -n+2  "$THEME_FILE" > "$DESTINATION"

    if [ -n "$CMD" ]; then
        eval "$CMD"
    fi
done

HYPR_THEME="$THEME_DIR/hypr.theme"

if [ -f "$HYPR_THEME" ]; then

    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"

    GTK_THEME=$(grep '$GTK_THEME=' "$HYPR_THEME" | head -1 | sed 's/.*=//' | tr -d ' ')

    ICON_THEME=$(grep '$ICON_THEME' "$HYPR_THEME" | head -1 | sed 's/.*=//' | tr -d ' ')

    COLOR_SCHEME=$(grep '$COLOR_SCHEME' "$HYPR_THEME" | head -1 | sed 's/.*=//' | tr -d ' ')

    if [ -n "$GTK_THEME" ]; then
        gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"
        echo "✓ GTK theme: $GTK_THEME"
    fi

    if [ -n "$ICON_THEME" ]; then
        gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME"
        echo "✓ Icon theme: $ICON_THEME"
    fi

    if [ -n "$COLOR_SCHEME" ]; then
        gsettings set org.gnome.desktop.interface color-scheme "$COLOR_SCHEME"
        echo "✓ Color scheme: $COLOR_SCHEME"
    fi

    echo "✓ GTK atualizado"
fi

## Set the last wallpaper used in the theme
if [ -f $THEME_DIR/wall.set ]; then
    WALLPAPER_NAME=$(head -n1 $THEME_DIR/wall.set) 
    awww img -t center --transition-duration 3 --transition-fps 60 "$THEME_DIR/wallpapers/$WALLPAPER_NAME"
    ## Set rofi background
    cp "$THEME_DIR/wallpapers/$WALLPAPER_NAME" $HOME/.config/rofi/backgrounds/current_wallpaper.png
    
fi

## Set the GTK theme

cp -r "$THEME_DIR/gtk-3.0" $HOME/.config/
cp -r "$THEME_DIR/gtk-4.0" $HOME/.config/

echo "$THEME_NAME" > $HOME/.cache/current_theme.txt

# Pre-load the wallpapers for the theme switcher

WALLPAPER_PATH=$HOME/.local/share/themes/$1/wallpapers

cd "$WALLPAPER_PATH" || exit

CACHE_DIR="/tmp/rofi-wp-cache/$1"
mkdir -p "$CACHE_DIR"

SELECTED_WALLPAPER=$(for theme in *.jpg *.png *.gif; do
    thumb="$CACHE_DIR/${theme%.*}.png"
    if [ "$theme" -nt "$thumb" ]; then
        convert "$theme" -resize x500 -gravity center -crop 340x500+0+0 +repage "$thumb"
    fi
    echo -en "$theme\0icon\x1f$thumb\n"
done | echo "bla" )
