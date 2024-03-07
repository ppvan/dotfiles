
# Install Yay if it isn't already installed
if ! command -v yay &>/dev/null; then
    echo "yay not installed. Installing yay."
    pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd -
else
    echo "yay is already installed."
fi


yay install --needed - < packageslist