#!/usr/bin/fish

cat /sys/class/leds/input3::capslock/brightness | sed s/1/󰪛/| sed s/0//
