#!/usr/bin/env bash
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

# Link fish config
ln -s ~/dotfiles/.config/fish/ ~/.config/fish

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


# Install packages and flatpak apps

./apps.sh

# Gnome desktop config
./desktop.sh

echo "Installation Complete!"
