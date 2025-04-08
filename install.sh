#!/usr/bin/env bash
############################
# This script creates symlinks from the home directory to any desired dotfiles in $HOME/dotfiles
############################

# dotfiles directory

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "ERROR: git is not installed"
fi

# Check if curl is installed
if ! command -v curl &> /dev/null; then
    echo "ERROR: curl is not installed"
fi

dotfiledir="${HOME}/dotfiles"

# list of files/folders to symlink in ${homedir}
files=(bashrc gitconfig)

# change to the dotfiles directory
echo "Changing to the ${dotfiledir} directory"
cd "${dotfiledir}" || exit

# create symlinks (will overwrite old dotfiles)
for file in "${files[@]}"; do
    echo "Creating symlink to $file in home directory."
    ln -sf "${dotfiledir}/.${file}" "${HOME}/.${file}"
done

# Link fish config
echo "~/.config/fish -> ~/dotfiles/fish"
rm -rf ~/.config/fish && ln -sf ~/dotfiles/fish ~/.config/fish

# Install homebrew
./brew.sh

echo "Installation Complete!"
