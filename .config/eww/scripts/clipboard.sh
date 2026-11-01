#!/bin/bash
# ========================================================
# Eww Clipboard Helper (cliphist)
# ========================================================

case "$1" in
    open)
        ~/.config/labwc/scripts/clipboard.sh &
        ;;
    clear)
        if command -v cliphist >/dev/null 2>&1; then
            cliphist wipe
            notify-send "Clipboard" "Clipboard history cleared."
        fi
        ;;
    count|*)
        if command -v cliphist >/dev/null 2>&1; then
            cliphist list 2>/dev/null | wc -l | tr -d ' '
        else
            echo "0"
        fi
        ;;
esac
