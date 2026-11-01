#!/bin/bash
# ========================================================
# Workspace switcher helper for Labwc & Eww
# ========================================================

export PATH="${HOME}/.local/bin:${PATH}"

if [ -z "$WAYLAND_DISPLAY" ]; then
    export WAYLAND_DISPLAY="wayland-0"
fi

target="$1"

case "$target" in
    1|2|3|4)
        # Update Eww state immediately
        eww update active_workspace="$target" 2>/dev/null || true
        # Send keypress via wtype
        wtype -M logo -k "$target" -m logo 2>/dev/null || true
        ;;
    *)
        echo "Usage: workspace.sh [1-4]"
        ;;
esac
