#!/usr/bin/env bash
set -e

echo "Setting up AMD GPU drivers, udev rules, & Flatpak gaming environment..."

# 1. Detect the real user's home and desktop folders (even if run with sudo)
REAL_USER="${SUDO_USER:-$USER}"
USER_HOME=$(eval echo "~$REAL_USER")

if [ -d "$USER_HOME/Desktop" ]; then
    TARGET_DIR="$USER_HOME/Desktop"
else
    TARGET_DIR="$USER_HOME"
fi

# 2. Enable 32-bit architecture & install AMD GPU Mesa Drivers + Vulkan + Controller udev rules
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y \
    steam-devices \
    mesa-vulkan-drivers \
    mesa-vulkan-drivers:i386 \
    libgl1-mesa-dri \
    libgl1-mesa-dri:i386 \
    libglx-mesa0 \
    libglx-mesa0:i386 \
    vulkan-tools

# 3. Ensure Flatpak & Flathub are ready
sudo apt install -y flatpak
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# 4. Install Flatpak gaming apps
echo "Installing Flatpaks..."
flatpak install -y flathub \
    com.valvesoftware.Steam \
    net.lutris.Lutris \
    com.heroicgameslauncher.hgl \
    net.davidotek.pupgui2 \
    org.freedesktop.Platform.VulkanLayer.MangoHud \
    com.usebottles.bottles

# 5. Create confirmation file directly on the Desktop
cat <<'EOF' > "$TARGET_DIR/gaming_ready.txt"
========================================
 Gaming Setup Complete (Flatpaks)
========================================
Installed Drivers & System Rules:
- AMD Mesa Vulkan Drivers (32-bit & 64-bit)
- Steam Devices udev rules (Controller Fix)

Installed Tools:
- Steam
- Lutris
- Heroic Games Launcher
- ProtonUp-Qt
- MangoHud
- Bottles

Status: AMD Drivers & Gaming Apps Ready! 🎮🔥
EOF

# Fix file ownership so it belongs to your user instead of root
chown "$REAL_USER:$REAL_USER" "$TARGET_DIR/gaming_ready.txt" 2>/dev/null || true

echo "Setup complete! Created confirmation file at $TARGET_DIR/gaming_ready.txt"
echo "Self-destructing script file..."
rm -- "$0"
