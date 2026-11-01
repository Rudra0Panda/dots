#!/bin/bash
# GPU monitoring script for Intel Arc / UHD

CARD_ARC="/sys/class/drm/card0"
CARD_IGPU="/sys/class/drm/card1"
HWMON_ARC="/sys/class/drm/card0/device/hwmon/hwmon5"

get_util() {
    local card=$1
    local r1=$(cat "$card/gt/gt0/rc6_residency_ms" 2>/dev/null || echo 0)
    local t1=$(date +%s%3N)
    sleep 0.1
    local r2=$(cat "$card/gt/gt0/rc6_residency_ms" 2>/dev/null || echo 0)
    local t2=$(date +%s%3N)
    local dt=$((t2 - t1))
    local dr=$((r2 - r1))
    if [ "$dt" -le 0 ]; then dt=100; fi
    local busy=$(( 100 - (dr * 100 / dt) ))
    if [ "$busy" -lt 0 ]; then busy=0; fi
    if [ "$busy" -gt 100 ]; then busy=100; fi
    echo "$busy"
}

get_temp() {
    if [ -f "$HWMON_ARC/temp1_input" ]; then
        local raw=$(cat "$HWMON_ARC/temp1_input" 2>/dev/null || echo 0)
        echo "$(( raw / 1000 ))°C"
    else
        echo ""
    fi
}

case "$1" in
    "temp")
        get_temp
        ;;
    "icon")
        echo "󰢮"
        ;;
    *)
        # Check Arc discrete GPU first, fallback to iGPU if Arc is sleeping (0%)
        ARC_BUSY=$(get_util "$CARD_ARC")
        if [ "$ARC_BUSY" -gt 0 ]; then
            echo "${ARC_BUSY}%"
        else
            IGPU_BUSY=$(get_util "$CARD_IGPU")
            echo "${IGPU_BUSY}%"
        fi
        ;;
esac
