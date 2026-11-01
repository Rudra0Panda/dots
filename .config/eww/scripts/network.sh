#!/bin/bash

TYPE=$(nmcli -t -f TYPE connection show --active 2>/dev/null | head -n 1)
NAME=$(nmcli -t -f NAME connection show --active 2>/dev/null | head -n 1)

case "$1" in
    "icon")
        if [ -z "$NAME" ]; then
            echo "󰤭"
        elif echo "$TYPE" | grep -q "wireless"; then
            echo "󰤨"
        elif echo "$TYPE" | grep -q "ethernet"; then
            echo "󰈀"
        else
            echo "󰤨"
        fi
        ;;
    *)
        if [ -z "$NAME" ]; then
            echo "Disconnected"
        else
            echo "$NAME"
        fi
        ;;
esac
