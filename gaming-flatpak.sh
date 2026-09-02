#!/usr/bin/env bash
set -e

echo "Setting up AMD GPU drivers & Flatpak gaming environment..."

# 1. Install AMD GPU Mesa Drivers & Vulkan libraries
sudo apt update
sudo apt install -y \
    mesa-vulkan-drivers \
    mesa-vulkan-drivers:i386 \
    libgl1-mesa-dri \
    libgl1-mesa-dri:i386 \
    libglx-mesa0 \
    libglx-mesa0:i386 \
    vulkan-tools

# 2. Ensure Flatpak & Flathub are ready
sudo apt install -y flatpak
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# 3. Install Flatpak gaming apps (fixed ID for ProtonUp-Qt)
echo "Installing Flatpaks..."
flatpak install -y flathub \
    com.valvesoftware.Steam \
    net.lutris.Lutris \
    com.heroicgameslauncher.hgl \
    net.davidhi.ProtonUp-Qt \
    org.freedesktop.Platform.VulkanLayer.MangoHud \
    io.github.bottlesdev.bottles

# 4. Create confirmation file in user home directory
cat <<'EOF' > "$HOME/gaming_ready.txt"
========================================
 Gaming Setup Complete (Flatpaks)
========================================
Installed Drivers & Tools:
- AMD Mesa Vulkan Drivers (32-bit & 64-bit)
- Steam
- Lutris
- Heroic Games Launcher
- ProtonUp-Qt
- MangoHud
- Bottles

Status: AMD Drivers & Gaming Apps Ready! 🎮🔥
EOF

echo "Setup complete! Created ~/gaming_ready.txt"
echo "Self-destructing script file..."
rm -- "$0"
