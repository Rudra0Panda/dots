#!/bin/bash
# ========================================================
# Labwc Automated Startup Script
# Automatically launches:
# - Monochrome Wallpaper (swaybg)
# - OpenTabletDriver Daemon (otd-daemon)
# - Bluetooth Tray Applet (blueman-applet)
# - NetworkManager Applet (nm-applet)
# - KDE Connect (kdeconnect-indicator / daemon)
# ========================================================

# Setup PATH and log directory
export PATH="${HOME}/.local/bin:${PATH}"
LOG_DIR="${HOME}/.local/state/labwc"
mkdir -p "$LOG_DIR"
exec >> "$LOG_DIR/autostart.log" 2>&1

echo "=========================================="
echo "Labwc autostart initiated: $(date)"
echo "WAYLAND_DISPLAY: ${WAYLAND_DISPLAY:-not set}"
echo "=========================================="

# Helper: run command safely with nohup in background if installed & not running
run_once() {
    local binary="$1"
    shift
    if command -v "$binary" >/dev/null 2>&1; then
        if ! pgrep -x "$binary" >/dev/null 2>&1; then
            echo "[$(date +%T)] Starting $binary $@"
            nohup "$binary" "$@" >/dev/null 2>&1 &
        else
            echo "[$(date +%T)] $binary is already running"
        fi
    else
        echo "[$(date +%T)] Warning: $binary is not installed"
    fi
}

# 1. Set Wallpaper (Monochrome)
echo "[$(date +%T)] Initializing wallpaper..."
"${HOME}/.config/labwc/scripts/wallpaper.sh" &

# 2. OpenTabletDriver Daemon (otd-daemon)
echo "[$(date +%T)] Initializing OpenTabletDriver daemon..."
if command -v otd-daemon >/dev/null 2>&1; then
    if ! pgrep -x "otd-daemon" >/dev/null 2>&1; then
        if systemctl --user list-unit-files opentabletdriver.service 2>/dev/null | grep -q opentabletdriver.service; then
            systemctl --user start opentabletdriver.service
            echo "[$(date +%T)] Started OpenTabletDriver via user systemd service"
        else
            nohup otd-daemon >/dev/null 2>&1 &
            echo "[$(date +%T)] Started otd-daemon in background"
        fi
    else
        echo "[$(date +%T)] otd-daemon is already active"
    fi
else
    echo "[$(date +%T)] otd-daemon not found"
fi

# 3. Bluetooth (rfkill + blueman-applet)
echo "[$(date +%T)] Configuring Bluetooth..."
if command -v rfkill >/dev/null 2>&1; then
    rfkill unblock bluetooth 2>/dev/null || true
fi
(sleep 1 && run_once blueman-applet) &

# 4. NetworkManager Applet (nm-applet)
echo "[$(date +%T)] Starting NetworkManager Applet..."
(sleep 1 && run_once nm-applet --indicator) &

# 5. KDE Connect
echo "[$(date +%T)] Initializing KDE Connect..."
if systemctl --user list-unit-files kdeconnect.service 2>/dev/null | grep -q kdeconnect.service; then
    systemctl --user start kdeconnect.service 2>/dev/null || true
fi
if command -v kdeconnect-indicator >/dev/null 2>&1; then
    (sleep 1 && run_once kdeconnect-indicator) &
elif command -v kdeconnectd >/dev/null 2>&1; then
    (sleep 1 && run_once kdeconnectd) &
fi

# 6. Notification Daemon (SwayNC)
if command -v swaync >/dev/null 2>&1; then
    run_once swaync
elif command -v mako >/dev/null 2>&1; then
    run_once mako
elif command -v dunst >/dev/null 2>&1; then
    run_once dunst
fi

# 7. Clipboard History Daemon (cliphist + wl-paste)
if command -v cliphist >/dev/null 2>&1 && command -v wl-paste >/dev/null 2>&1; then
    if ! pgrep -f "wl-paste --type text --watch cliphist" >/dev/null 2>&1; then
        wl-paste --type text --watch cliphist store >/dev/null 2>&1 &
        wl-paste --type image --watch cliphist store >/dev/null 2>&1 &
        echo "[$(date +%T)] Started cliphist clipboard daemon"
    fi
fi

# 8. Eww Monochrome Status Bar
echo "[$(date +%T)] Initializing Eww monochrome bar..."
if command -v eww >/dev/null 2>&1; then
    if ! eww ping >/dev/null 2>&1; then
        nohup eww daemon >/dev/null 2>&1 &
        sleep 0.5
    fi
    eww open bar >/dev/null 2>&1 &
fi

# 8. Optional: Fallback waybar (if eww not present and waybar installed)
if ! command -v eww >/dev/null 2>&1 && command -v waybar >/dev/null 2>&1; then
    run_once waybar
fi

echo "[$(date +%T)] Autostart sequence successfully triggered."
