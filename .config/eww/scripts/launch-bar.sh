#!/bin/bash
# ========================================================
# Launch Eww Monochrome Panel
# Robust startup script with daemon readiness verification
# ========================================================

export PATH="${HOME}/.local/bin:${PATH}"

# Ensure WAYLAND_DISPLAY is available
if [ -z "$WAYLAND_DISPLAY" ]; then
    export WAYLAND_DISPLAY="wayland-0"
fi

# Close any existing eww instances cleanly
eww kill >/dev/null 2>&1 || true
sleep 0.4

# Start eww daemon in background
nohup eww daemon >/dev/null 2>&1 &

# Poll for daemon socket readiness (up to 3 seconds)
READY=0
for i in {1..15}; do
    if eww ping >/dev/null 2>&1; then
        READY=1
        break
    fi
    sleep 0.2
done

if [ "$READY" -eq 1 ]; then
    eww open bar >/dev/null 2>&1 &
    echo "Eww bar successfully launched."
else
    echo "Error: Eww daemon did not respond to ping in time."
fi
