#!/usr/bin/env bash
set -e

echo "Debloating Linux Mint..."

# Remove Mint-specific default app bloat
echo "Purging stock app bloat..."
sudo apt purge -y \
    hexchat \
    thunderbird \
    rhythmbox \
    pix \
    drawing \
    simple-scan \
    hypnotix \
    celluloid \
    warpinator \
    libreoffice* \
    aisleriot \
    gnome-mahjongg \
    gnome-mines \
    gnome-sudoku 2>/dev/null || true

# Clean up orphaned packages and caches
sudo apt autoremove --purge -y
sudo apt clean

# Disable background update timers to save CPU/RAM
sudo systemctl disable --now apt-daily.timer apt-daily-upgrade.timer 2>/dev/null || true

echo "Done! Deleting script file..."
rm -- "$0"
