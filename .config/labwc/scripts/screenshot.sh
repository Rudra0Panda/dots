#!/bin/bash
# ========================================================
# Screenshot Utility for Labwc
# Supports Fullscreen and Area/Region Selection
# Copies to clipboard & saves to ~/Pictures/Screenshots/
# ========================================================

SCREENSHOTS_DIR="${HOME}/Pictures/Screenshots"
mkdir -p "$SCREENSHOTS_DIR"

TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
FILE="${SCREENSHOTS_DIR}/Screenshot_${TIMESTAMP}.png"

MODE="${1:-full}"

case "$MODE" in
    area|select|region)
        # Select region with slurp
        GEOM=$(slurp -d -b "#12121288" -c "#ffffff" -s "#ffffff22" -w 1 2>/dev/null)
        if [ -z "$GEOM" ]; then
            # User canceled selection (e.g. Esc)
            exit 0
        fi
        grim -g "$GEOM" "$FILE"
        ;;
    full|*)
        grim "$FILE"
        ;;
esac

if [ -f "$FILE" ]; then
    # Copy to clipboard if wl-copy is installed
    if command -v wl-copy >/dev/null 2>&1; then
        wl-copy --type image/png < "$FILE"
    fi

    # Send desktop notification
    notify-send -i "$FILE" "Screenshot Saved" "Saved to $(basename "$FILE") and copied to clipboard."
fi
