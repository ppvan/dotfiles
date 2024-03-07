#!/usr/bin/env zsh
############################
# This script creates symlinks from the home directory to any desired dotfiles in $HOME/dotfiles
############################

# dotfiles directory
dotfiledir="${HOME}/dotfiles"

# list of files/folders to symlink in ${homedir}
files=(bashrc bash_profile bash_prompt bash_alias gitconfig)

# change to the dotfiles directory
echo "Changing to the ${dotfiledir} directory"
cd "${dotfiledir}" || exit

# create symlinks (will overwrite old dotfiles)
for file in "${files[@]}"; do
    echo "Creating symlink to $file in home directory."
    ln -sf "${dotfiledir}/.${file}" "${HOME}/.${file}"
done

# Copy some custom desktop files
echo "Install Custom Desktop Files"
for file in "${dotfiledir}"/.local/share/applications/*; do
    echo "$(basename ${file}) -> ${HOME}/.local/share/applications/$(basename ${file})"
    sleep 0.1
    ln -sf "${file}" "${HOME}/.local/share/applications/$(basename ${file})"
done


echo "Install Custom Bash Completions"
for file in "${dotfiledir}"/.local/share/bash-completion/completions/*; do
    
    echo "$(basename ${file}) -> ${HOME}/.local/share/bash-completion/completions/$(basename ${file})"
    sleep 0.1
    ln -sf "${file}" "${HOME}/.local/share/bash-completion/completions/$(basename ${file})"
    sleep 0.1
done

# Fonts
for font in "${dotfiledir}"/.local/share/fonts/*; do
    echo "Installing $(basename ${font}) font"
    sleep 0.1
    cp -r "${file}" "${HOME}/.local/share/fonts/"
done


# Firefox config
echo "Install Firefox Config"
cp -R "${dotfiledir}"/.config/firefox/* "${HOME}"/.config/firefox/

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

apps=(com.discordapp.Discord com.discordapp.Discord com.github.IsmaelMartinez.teams_for_linux com.github.neithern.g4music com.github.unrud.VideoDownloader com.mattjakeman.ExtensionManager com.raggesilver.BlackBox com.skype.Client de.haeckerfelix.Fragments io.dbeaver.DBeaverCommunity io.github.alainm23.planify io.github.celluloid_player.Celluloid me.ppvan.psequel org.freedesktop.appstream-glib org.gimp.GIMP org.gnome.Builder org.gnome.design.AppIconPreview org.gnome.design.IconLibrary org.gnome.meld org.inkscape.Inkscape re.sonny.Workbench)

for app in "${apps[@]}"; do
    flatpak install -y flathub $app
done

# Gnome desktop config
./desktop.sh

echo "Installation Complete!"