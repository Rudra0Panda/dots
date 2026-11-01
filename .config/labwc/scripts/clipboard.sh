#!/bin/bash
# ========================================================
# Clipboard Manager Picker (cliphist + wofi)
# ========================================================

if ! command -v cliphist >/dev/null 2>&1; then
    notify-send "Clipboard" "cliphist is not installed"
    exit 1
fi

selection=$(cliphist list | wofi --dmenu --prompt "Clipboard History" --width 600 --height 400)
if [ -n "$selection" ]; then
    echo "$selection" | cliphist decode | wl-copy
fi
