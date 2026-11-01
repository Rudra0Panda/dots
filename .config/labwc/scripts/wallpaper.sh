#!/bin/bash
# ========================================================
# Labwc Monochrome Wallpaper Setter
# Usage: wallpaper.sh [path/to/custom/image]
# ========================================================

WALLPAPER="/home/rudra/.config/labwc/wallpaper.jpg"

if [ -n "$1" ] && [ -f "$1" ]; then
    WALLPAPER="$1"
fi

# Kill previous instances of swaybg
pkill -x swaybg 2>/dev/null
sleep 0.1

if [ -f "$WALLPAPER" ]; then
    swaybg -i "$WALLPAPER" -m fill >/dev/null 2>&1 &
else
    swaybg -c "#121212" >/dev/null 2>&1 &
fi
