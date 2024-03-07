
dotfiledir="${HOME}/dotfiles"
cachedir="${HOME}/dotfiles/.cache"
extensions=(3740 19 779 2890 3210 97 3193 3843 307 517)


mkdir -p "${cachedir}"

cd "${cachedir}" || exit

echo "Installing Colloid Icon Theme"
git clone --depth 1 https://github.com/vinceliuice/Colloid-icon-theme.git
cd Colloid-icon-theme || exit
./install.sh -n Colloid -s default -t teal


echo "Installing Colloid GTK Theme"
cd "${cachedir}" || exit
git clone --depth 1 https://github.com/vinceliuice/Colloid-gtk-theme.git
cd Colloid-gtk-theme || exit
./install.sh -n Colloid -s standard -t teal --tweaks normal

echo "Installing Marble Shell Theme"
cd "${cachedir}" || exit
git clone --depth 1 https://github.com/imarkoff/Marble-shell-theme.git
cd Marble-shell-theme || exit
python install.py --red


cd "${cachedir}" || exit
rm -f ./install-gnome-extensions.sh; wget -N -q "https://raw.githubusercontent.com/ToasterUwU/install-gnome-extensions/master/install-gnome-extensions.sh" -O ./install-gnome-extensions.sh && chmod +x install-gnome-extensions.sh

./install-gnome-extensions.sh "${extensions[@]}"

# Load settings
cd "${dotfiledir}" || exit
dconf load /org/gnome/ < gnome-settings.txt

rm -rf "${cachedir}"