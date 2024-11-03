#!/usr/bin/env fish

set dotfile_dir (dirname (realpath (status --current-filename)))

echo "Backup packages to packages.txt"
dnf --cacheonly repoquery --userinstalled --qf "%{name}" | sort > "$dotfile_dir/packages.txt" &

echo "Backup flatpak apps to flatpak-apps.txt"
flatpak list --app --columns=application > "$dotfile_dir/flatpak-apps.txt" &

echo "Backup gnome config to gnome-settings.conf"
dconf dump / > "$dotfile_dir/gnome-settings.conf" &

wait
echo "Done"
