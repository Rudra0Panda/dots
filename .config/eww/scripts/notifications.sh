#!/bin/bash
# ========================================================
# Eww Notification Helper for SwayNC
# ========================================================

count=$(swaync-client -c 2>/dev/null || echo 0)
dnd=$(swaync-client -D 2>/dev/null || echo false)

case "$1" in
    icon)
        if [ "$dnd" = "true" ]; then
            printf "󰂛"
        elif [ "$count" -gt 0 ] 2>/dev/null; then
            printf "󱅫"
        else
            printf "󰂚"
        fi
        ;;
    count)
        echo "$count"
        ;;
    dnd)
        echo "$dnd"
        ;;
    *)
        if [ "$dnd" = "true" ]; then
            printf "DND"
        elif [ "$count" -gt 0 ] 2>/dev/null; then
            printf "%s" "$count"
        else
            printf "0"
        fi
        ;;
esac
