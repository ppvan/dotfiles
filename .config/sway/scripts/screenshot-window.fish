#!/usr/bin/fish

set -l region "$(swaymsg -t get_tree | jq -j '.. | select(.type?) | select(.focused).rect | "\(.x),\(.y) \(.width)x\(.height)"')"

set -l location "$(xdg-user-dir PICTURES)/Screenshots/$(date +%Y%m%d_%H%M%S).png"

grim -g $region $location

notify-send "Window screenshot saved" "Screenshots/$(date +%Y%m%d_%H%M%S).png"
