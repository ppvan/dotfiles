#!/usr/bin/env zsh
############################
# This script creates symlinks from the home directory to any desired dotfiles in $HOME/dotfiles
# And also installs MacOS Software
# And also installs Homebrew Packages and Casks (Apps)
# And also sets up VS Code
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




echo "Installation Complete!"