#!/bin/bash

get_raw() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null
}

case "$1" in
    "up")
        wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+
        ;;
    "down")
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        ;;
    "mute")
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        ;;
    "icon")
        RAW=$(get_raw)
        if echo "$RAW" | grep -q "\[MUTED\]"; then
            echo "󰝟"
        else
            VOL=$(echo "$RAW" | awk '{print $2}')
            PCT=$(awk -v v="$VOL" 'BEGIN {p=int(v*100+0.5); if (p>100) p=100; print p}')
            if [ "$PCT" -ge 60 ]; then
                echo "󰕾"
            elif [ "$PCT" -ge 25 ]; then
                echo "󰖀"
            elif [ "$PCT" -gt 0 ]; then
                echo "󰕿"
            else
                echo "󰝟"
            fi
        fi
        ;;
    *)
        RAW=$(get_raw)
        if echo "$RAW" | grep -q "\[MUTED\]"; then
            echo "MUTED"
        else
            VOL=$(echo "$RAW" | awk '{print $2}')
            PCT=$(awk -v v="$VOL" 'BEGIN {p=int(v*100+0.5); if (p>100) p=100; print p}')
            echo "${PCT}%"
        fi
        ;;
esac
