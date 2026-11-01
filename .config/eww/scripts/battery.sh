#!/bin/bash
CAP_FILE="/sys/class/power_supply/BAT1/capacity"
STATUS_FILE="/sys/class/power_supply/BAT1/status"

if [ ! -f "$CAP_FILE" ]; then
    echo "N/A"
    exit 0
fi

CAP=$(cat "$CAP_FILE" 2>/dev/null || echo 0)
STATUS=$(cat "$STATUS_FILE" 2>/dev/null || echo "Unknown")

case "$1" in
    "icon")
        if [ "$STATUS" = "Charging" ]; then
            echo "󰂄"
        elif [ "$CAP" -ge 90 ]; then
            echo "󰁹"
        elif [ "$CAP" -ge 70 ]; then
            echo "󰂁"
        elif [ "$CAP" -ge 50 ]; then
            echo "󰁾"
        elif [ "$CAP" -ge 30 ]; then
            echo "󰁼"
        elif [ "$CAP" -ge 15 ]; then
            echo "󰁺"
        else
            echo "󰂃"
        fi
        ;;
    *)
        echo "${CAP}%"
        ;;
esac
