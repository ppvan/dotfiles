#!/usr/bin/env bash

# Install native packages

# Flatpak

apps=(com.discordapp.Discord com.github.neithern.g4music com.github.unrud.VideoDownloader com.mattjakeman.ExtensionManager com.raggesilver.BlackBox de.haeckerfelix.Fragments io.github.celluloid_player.Celluloid me.ppvan.psequel org.gimp.GIMP org.gnome.meld)

for app in "${apps[@]}"; do
    echo "$app"
    flatpak install -y flathub $app
done
