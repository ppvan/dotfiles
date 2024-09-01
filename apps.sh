#!/usr/bin/env bash

# Install native packages

if ! command -v yay &> /dev/null
then
    echo "Installing yay"
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin || exit
    makepkg -si

    cd "${dotfiledir}" || exit
fi

yay install --needed - < packages.txt

# Flatpak

apps=(com.discordapp.Discord com.github.neithern.g4music com.github.unrud.VideoDownloader com.mattjakeman.ExtensionManager com.raggesilver.BlackBox de.haeckerfelix.Fragments io.github.celluloid_player.Celluloid me.ppvan.psequel org.gimp.GIMP org.gnome.meld)

for app in "${apps[@]}"; do
    echo "$app"
    flatpak install -y flathub $app
done
