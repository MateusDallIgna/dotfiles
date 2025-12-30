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
