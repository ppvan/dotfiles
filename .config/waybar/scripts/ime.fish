#!/usr/bin/fish

function current
    # get current ime from dbus and trim result
    set -l local_ime (dbus-send --session --print-reply=literal --dest=org.fcitx.Fcitx5 /controller org.fcitx.Fcitx.Controller1.CurrentInputMethod | sed 's/^ *//;s/ *$//')

    if test $local_ime = "bamboo"
        echo "vi"
    else
        echo "en"
    end
end

# first time
current

dbus-monitor destination='org.fcitx.Fcitx5',interface='org.fcitx.Fcitx.Controller1' | stdbuf -oL grep "member=Toggle" | while read line
    current
end
