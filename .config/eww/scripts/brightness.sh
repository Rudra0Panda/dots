#!/bin/bash
BRIGHT_DIR="/sys/class/backlight/intel_backlight"

if [ ! -d "$BRIGHT_DIR" ]; then
    echo "N/A"
    exit 0
fi

CURRENT=$(cat "$BRIGHT_DIR/brightness" 2>/dev/null || echo 0)
MAX=$(cat "$BRIGHT_DIR/max_brightness" 2>/dev/null || echo 1)
STEP=$(( MAX / 20 )) # 5%

set_brightness() {
    local val=$1
    if [ "$val" -gt "$MAX" ]; then val="$MAX"; fi
    if [ "$val" -lt "$STEP" ]; then val="$STEP"; fi # min 5%
    busctl call org.freedesktop.login1 /org/freedesktop/login1/session/auto org.freedesktop.login1.Session SetBrightness ssu "backlight" "intel_backlight" "$val" >/dev/null 2>&1
}

case "$1" in
    "up")
        NEW=$(( CURRENT + STEP ))
        set_brightness "$NEW"
        ;;
    "down")
        NEW=$(( CURRENT - STEP ))
        set_brightness "$NEW"
        ;;
    "icon")
        PCT=$(( CURRENT * 100 / MAX ))
        if [ "$PCT" -ge 70 ]; then
            echo "󰃠"
        elif [ "$PCT" -ge 30 ]; then
            echo "󰃟"
        else
            echo "󰃞"
        fi
        ;;
    *)
        PCT=$(( CURRENT * 100 / MAX ))
        echo "${PCT}%"
        ;;
esac
