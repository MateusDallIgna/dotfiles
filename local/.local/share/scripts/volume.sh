#!/bin/bash
iDIR="$HOME/.config/swaync/icons"
notification_timeout=1000
step=5

get_volume(){
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}'
}

get_mute(){
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED" && echo "yes" || echo "no"
}

get_icons(){
    mute=$(get_mute)
    if [[ "$mute" == "yes" ]]; then
        icon="$iDIR/volume-mute.png"
    elif [[  "$current" == "0"  ]]; then
        icon="$iDIR/volume-mute.png"
    elif [ "$current" -le "20" ]; then
        icon="$iDIR/volume-low.png"
    elif [ "$current" -le "40" ]; then
        icon="$iDIR/volume-low.png"
    elif [ "$current" -le "60" ]; then
        icon="$iDIR/volume-mid.png"
    else 
        icon="$iDIR/volume-high.png"
    fi
}

notify_user(){
    mute=$(get_mute)
    if [[ "$mute" == "yes" ]]; then
        notify-send -e -h string:x-canonical-private-synchronous:osd -h int:value:0 -u low -i "$icon" "Volume" "Muted"
    else
        notify-send -e -h string:x-canonical-private-synchronous:osd -h int:value:$current -u low -i "$icon" "Volume" "$current%"
    fi
}

change_volume(){
    local current_volume
    current_volume=$(get_volume)

    if [[ "$1" == "increase" ]]; then
        new_volume=$((current_volume + step))
    elif [[ "$1" == "decrease" ]]; then
        new_volume=$((current_volume - step))
    fi

    if (( new_volume < 0 )); then
        new_volume=0
    elif (( new_volume > 100 )); then
        new_volume=100
    fi

    wpctl set-volume @DEFAULT_AUDIO_SINK@ "${new_volume}%"
    current=$new_volume
    get_icons
    notify_user
}

toggle_mute(){
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    mute=$(get_mute)
    current=$(get_volume)
    get_icons
    notify_user
}

toggle_mute_source(){
    wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
    source_mute=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q "MUTED" && echo "yes" || echo "no")
    if [[ "$source_mute" == "yes" ]]; then
        icon="$iDIR/microphone-mute.png"
        notify-send -e -h string:x-canonical-private-synchronous:osd -u low -i "$icon" "Microphone" "Muted"
    else
        icon="$iDIR/microphone.png"
        notify-send -e -h string:x-canonical-private-synchronous:osd -u low -i "$icon" "Microphone" "Unmuted"
    fi
}

case "$1" in
    "--increase")
        change_volume "increase"
        ;;
    "--decrease")
        change_volume "decrease"
        ;;
    "--toggle-mute")
        toggle_mute
        ;;
    "--toggle-mute-source")
        toggle_mute_source
        ;;
esac
