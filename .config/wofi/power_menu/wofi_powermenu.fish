#!/usr/bin/env fish

set entries "  Logout\n󰤄  Suspend\n  Reboot\n  Shutdown"

set selected (echo -e $entries | wofi --width 250 -c ~/.config/wofi/power_menu/config -s ~/.config/wofi/power_menu/style.css --cache-file /dev/null | awk '{print tolower($2)}')

switch $selected
    case logout
        swaymsg exit
    case suspend
        exec systemctl suspend
    case reboot
        exec systemctl reboot
    case shutdown
        exec systemctl poweroff -i
end
