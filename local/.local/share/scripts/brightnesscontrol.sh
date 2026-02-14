#!/bin/bash
iDIR="$HOME/.config/swaync/icons"
notification_timeout=1000
step=5 #INCREASE AND DECREASE FOR THIS VALUE

get_backlight(){
    brightnessctl -m | cut -d, -f4 | sed 's/%//'
}

get_icons(){
    current=$(get_backlight)
    if [ "$current" -le "20" ]; then
        icon="$iDIR/brightness-20.png"
    elif [ "$current" -le "40" ]; then
        icon="$iDIR/brightness-40.png"
    elif [ "$current" -le "60" ]; then
        icon="$iDIR/brightness-60.png"
    elif [ "$current" -le "80" ]; then
        icon="$iDIR/brightness-80.png"
    else 
        icon="$iDIR/brightness-100.png"
    fi
}

#Notify
notify_user() {
    notify-send -e -h string:x-canonical-private-synchronous:osd -h int:value:$current -u low -i $icon "Brightness" "$current%" 
}

change_backlight(){
    local current_brightness
    current_brightness=$(get_backlight)

    if [[ "$1" == "increase" ]]; then
        new_brightness=$((current_brightness + step))
    elif [[ "$1" == "decrease" ]]; then
        new_brightness=$((current_brightness - step))
    fi

    if (( new_brightness < 5 )); then
        new_brightness=5
    elif (( new_brightness > 100 )); then
        new_brightness=100
    fi

    brightnessctl set "${new_brightness}%"
    get_icons
    current=$new_brightness
    notify_user
}

case "$1" in
    "--increase")
        change_backlight "increase"
        ;;
    "--decrease")
        change_backlight "decrease"
        ;;
esac
