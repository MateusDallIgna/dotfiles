#!/bin/bash

case "$1" in
    -)
        brightnessctl s 10%-
        ;;
    +)
        brightnessctl s +10%
        ;;
    *)
        echo "Use + ou -"
        ;;
esac
