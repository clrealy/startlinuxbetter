#!/usr/bin/env bash
set -e

echo "Debloating Ubuntu..."

# Purge Snap & block it from reinstalling
if command -v snap &> /dev/null; then
    echo "Purging Snap..."
    sudo snap remove --purge firefox gnome-3-38-2004 gtk-common-themes bare core20 snapd-desktop-integration 2>/dev/null || true
    sudo apt purge -y snapd
    sudo rm -rf ~/snap /var/snap /var/lib/snapd /var/cache/snapd

    sudo cat <<'NOSNAP' | sudo tee /etc/apt/preferences.d/nosnap.pref
Package: snapd
Pin: release a=*
Pin-Priority: -10
NOSNAP
fi

# Set up Flatpak + Flathub
echo "Setting up Flatpak..."
sudo apt update
sudo apt install -y flatpak
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Remove standard stock bloatware
echo "Purging stock app bloat..."
sudo apt purge -y \
    thunderbird \
    rhythmbox \
    shotwell \
    cheese \
    gnome-mines \
    gnome-sudoku \
    aisleriot \
    libreoffice* \
    remmina \
    transmission-gtk 2>/dev/null || true

# Clean up orphaned packages
sudo apt autoremove --purge -y
sudo apt clean

echo "Done! Deleting script file..."
rm -- "$0"
