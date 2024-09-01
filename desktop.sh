#!/usr/bin/env bash

# Config gnome desktop env
# Install theme and extensions...

# Fonts
for font in "${dotfiledir}"/.local/share/fonts/*; do
    echo "Installing $(basename ${font}) font"
    sleep 0.1
    cp -r "${file}" "${HOME}/.local/share/fonts/"
done


# Firefox config
echo "Install Firefox Config"
cp -R "${dotfiledir}"/.config/firefox/* "${HOME}"/.config/firefox/

dotfiledir="${HOME}/dotfiles"
cachedir="${HOME}/dotfiles/.cache"
extensions=(3740 19 779 2890 3210 3193 3843 307)

mkdir -p "${cachedir}"

cd "${cachedir}" || exit

echo "Installing Colloid Icon Theme"
git clone --depth 1 https://github.com/vinceliuice/Colloid-icon-theme.git
cd Colloid-icon-theme || exit
./install.sh -s catppuccin

echo "Installing Colloid GTK Theme"
cd "${cachedir}" || exit
git clone --depth 1 https://github.com/vinceliuice/Colloid-gtk-theme.git
cd Colloid-gtk-theme || exit
./install.sh -n Colloid -s standard --tweaks normal -l

echo "Installing Marble Shell Theme"
cd "${cachedir}" || exit
git clone --depth 1 https://github.com/imarkoff/Marble-shell-theme.git
cd Marble-shell-theme || exit
python install.py -a

# install extensions
cd "${cachedir}" || exit
rm -f ./install-gnome-extensions.sh; wget -N -q "https://raw.githubusercontent.com/ToasterUwU/install-gnome-extensions/master/install-gnome-extensions.sh" -O ./install-gnome-extensions.sh && chmod +x install-gnome-extensions.sh

./install-gnome-extensions.sh "${extensions[@]}"

# Load extensions settings
cd "${dotfiledir}" || exit

# dump command
# dconf dump /org/gnome/shell/extensions/ > extension-settings.conf
dconf load /org/gnome/shell/extensions/ < extension-settings.conf

rm -rf "${cachedir}"
