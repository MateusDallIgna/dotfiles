#!/bin/bash

MODE=$1

case $MODE in

    region)
        hyprshot -m region --raw | satty -f - --copy-command wl-copy
        ;;
    window)
        hyprshot -m window --raw | satty -f - --copy-command wl-copy
        ;;
esac
