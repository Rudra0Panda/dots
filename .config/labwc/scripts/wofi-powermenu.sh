#!/bin/bash
# ========================================================
# Monochrome Wofi Power / Session Menu
# ========================================================

options="Lock\nSuspend\nReboot\nPower Off\nExit Labwc"

choice=$(echo -e "$options" | wofi --dmenu --prompt "Session" --width 260 --height 240 --location center)

case "$choice" in
    "Lock")
        if command -v swaylock >/dev/null 2>&1; then
            swaylock -f -c 000000
        fi
        ;;
    "Suspend")
        systemctl suspend
        ;;
    "Reboot")
        systemctl reboot
        ;;
    "Power Off")
        systemctl poweroff
        ;;
    "Exit Labwc")
        labwc --exit 2>/dev/null || pkill -x labwc
        ;;
esac
