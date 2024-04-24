#!/bin/sh
killall -SIGUSR2 waybar && rm /home/rudra/.config/spicetify/Themes/Blossom/color.ini &&  cp /home/rudra/.cache/wal/color.ini /home/rudra/.config/spicetify/Themes/Blossom/color.ini & rm /home/rudra/Documents/start-page/colors.css &&  cp /home/rudra/.cache/wal/colors.css /home/rudra/Documents/start-page & spicetify apply & dunstify changed
