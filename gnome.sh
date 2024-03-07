
dotfiledir="${HOME}/dotfiles"
cachedir="${HOME}/dotfiles/.cache"

cd "${cachedir}" || exit

echo "Installing Colloid Icon Theme"
git clone https://github.com/vinceliuice/Colloid-icon-theme.git

cd Colloid-icon-theme || exit

./install.sh -n Colloid -s default -t teal

gsettings set org.gnome.desktop.interface font-name 'Roboto Light 15'
gsettings set org.gnome.desktop.interface document-font-name 'Roboto 15'
gsettings set org.gnome.desktop.interface monospace-font-name 'SauceCodePro Nerd Font 15'
gsettings set org.gnome.desktop.vm.preferences titlebar-font 'SauceCodePro Nerd Font 14'

gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'
gsettings set org.gnome.desktop.interface icon-theme 'Colloid-teal'
gsettings set org.gnome.shell.extensions.user-theme name 'Marble-red-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Colloid-Red'


