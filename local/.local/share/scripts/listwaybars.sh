#!/bin/bash

WAYBAR_DIR=$HOME/.local/share/waybars

cd $WAYBAR_DIR ||  exit >&2

for theme in */; do 
    echo "${theme%/}"
done | sort
