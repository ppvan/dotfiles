#!/usr/bin/env fish

set dotfile_dir (dirname (realpath (status --current-filename)))

# ---------------------------------------------config section----------------------------------------------

function setup_shell
    # Setup shell config files
    for config_file in .bashrc .bash_profile .bash_prompt .bash_alias
        set -l file_path "$dotfile_dir/$config_file"
        set -l dot_file "$HOME/$config_file"
        echo "Link $dot_file -> $file_path"
        rm -f "$dot_file"
        ln -s "$file_path" "$dot_file"
    end
    
    # Setup fish config directory
    echo "Link fish shell config dir"
    set -l link "$HOME/.config/fish"
    set -l fish_config_dir (realpath "$dotfile_dir/.config/fish")
    rm -rf "$link"
    ln -sf "$fish_config_dir" "$link"
    echo "Link $link -> $fish_config_dir"
end

function setup_desktopfiles
    # Setup desktop files
    set -l desktop_src_dir "$dotfile_dir/.local/share/applications"
    set -l desktop_dest_dir "$HOME/.local/share/applications"
    
    # Create destination directory if it doesn't exist
    mkdir -p "$desktop_dest_dir"
    
    # Find all .desktop files and create symlinks
    for file in $desktop_src_dir/*.desktop
        if test -f "$file"
            set -l filename (basename "$file")
            set -l link_path "$desktop_dest_dir/$filename"
            rm -f "$link_path"
            ln -s "$file" "$link_path"
            echo "Link $link_path -> $file"
        end
    end
end

function backup_packages
    echo "Backup packages to $dotfile_dir/packages.txt"
    dnf --cacheonly repoquery --userinstalled --qf "%{name}" | sort > "$dotfile_dir/packages.txt"
    echo "Done"

    echo "Backup flatpak apps"
    flatpak list --app --columns=application > flatpak-apps.txt
    echo "Done"
end

function install_dnf_packages
    echo "Sync dnf packages"
    sudo dnf install -y (cat "$dotfile_dir/packages.txt")
end

function install_flatpak_packages
    echo "Sync flatpak apps"
    while read -l line
        flatpak install flathub $line
    end < "$dotfile_dir/flatpak-apps.txt"
end

function install_gnome_extensions
    set -l cachedir "$dotfile_dir/.cache"
    set -l extensions 3740 19 779 2890 3210 3193 3843 307 5489

    # Create cache directory
    mkdir -p $cachedir
    cd $cachedir; or exit

    # Install Colloid Icon Theme
    echo "Installing Colloid Icon Theme"
    git clone --depth 1 https://github.com/vinceliuice/Colloid-icon-theme.git
    cd Colloid-icon-theme; or exit
    ./install.sh -s catppuccin

    # Install Colloid GTK Theme
    cd $cachedir; or exit
    git clone --depth 1 https://github.com/vinceliuice/Colloid-gtk-theme.git
    cd Colloid-gtk-theme; or exit
    ./install.sh -n Colloid -s standard --tweaks normal -l

    # Install Marble Shell Theme
    cd $cachedir; or exit
    git clone --depth 1 https://github.com/imarkoff/Marble-shell-theme.git
    cd Marble-shell-theme; or exit
    python install.py -a

    # Install cursor theme
    cd $cachedir; or exit
    wget "https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7/Bibata-Modern-Ice.tar.xz"
    tar xvf Bibata-Modern-Ice.tar.xz
    cp -rf Bibata-Modern-Ice/ "$HOME/.local/share/icons"


    # Install extensions
    cd $cachedir; or exit
    rm -f ./install-gnome-extensions.sh
    wget -N -q "https://raw.githubusercontent.com/ToasterUwU/install-gnome-extensions/master/install-gnome-extensions.sh" -O ./install-gnome-extensions.sh
    chmod +x install-gnome-extensions.sh
    ./install-gnome-extensions.sh $extensions

    # Load extensions settings
    cd $dotfiledir; or exit
    # load conig
    dconf load -f / < "$dotfile_dir/gnome-settings.conf"

    # Cleanup
    rm -rf $cachedir
end


# ---------------------------------------------Script main---------------------------------

# Check if directory exists
if not test -d "$dotfile_dir"
    echo "Error: Directory '$dotfile_dir' does not exist"
    exit 1
end

# Run setup functions
setup_shell
setup_desktopfiles
install_dnf_packages
install_flatpak_packages
install_gnome_extensions