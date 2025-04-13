#!/usr/bin/env bash

# Install Homebrew if it isn't already installed
if ! command -v brew &>/dev/null; then
    echo "Homebrew not installed. Installing Homebrew."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Attempt to set up Homebrew PATH automatically for this session
    if [ -x "/opt/homebrew/bin/brew" ]; then
        # For Apple Silicon Macs
        echo "Configuring Homebrew in PATH for Apple Silicon Mac..."
        export PATH="/opt/homebrew/bin:$PATH"
    fi

    # Attempt to set up Homebrew PATH automatically for this session
    if [ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
        # For Linux/WSL
        echo "Configuring Homebrew in PATH for Linux..."
        export PATH="/home/linuxbrew/.linuxbrew/bin/:$PATH"
    fi
else
    echo "Homebrew is already installed."
fi

# Verify brew is now accessible
if ! command -v brew &>/dev/null; then
    echo "Failed to configure Homebrew in PATH. Please add Homebrew to your PATH manually."
    exit 1
fi

brew update
brew upgrade
brew upgrade --cask
brew cleanup


# Define an array of packages to install using Homebrew.
packages=(
	"gcc"
    "mise"
    "micro"
    "bat"
    "fish"
    "git"
    "eza",
    "jq",
    "tlrc",
    "mycli"
)

# Loop over the array to install each application.
for package in "${packages[@]}"; do
    if brew list --formula | grep -q "^$package\$"; then
        echo "$package is already installed. Skipping..."
    else
        echo "Installing $package..."
        brew install "$package"
    fi
done
