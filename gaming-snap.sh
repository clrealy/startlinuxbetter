#!/usr/bin/env bash
set -e

echo "Setting up AMD GPU drivers & Snap gaming environment..."

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

# 2. Ensure snapd is installed
if ! command -v snap &> /dev/null; then
    sudo apt install -y snapd
fi

# 3. Install Snaps
echo "Installing Snaps..."
sudo snap install steam
sudo snap install lutris
sudo snap install heroic

# 4. Install system performance utilities
echo "Installing GameMode & MangoHud..."
sudo apt install -y gamemode mangohud

# 5. Create confirmation file in target user's home directory
USER_HOME=$(eval echo "~${SUDO_USER:-$USER}")
cat <<'EOF' > "$USER_HOME/gaming_ready.txt"
========================================
 Gaming Setup Complete (Snaps)
========================================
Installed Drivers & Tools:
- AMD Mesa Vulkan Drivers (32-bit & 64-bit)
- Steam (Snap)
- Lutris (Snap)
- Heroic Games Launcher (Snap)
- GameMode (APT)
- MangoHud (APT)
- You should definitely use the debloat script
- it gives flatpak support
- fuck canonical and fuck libreoffice

Status: AMD Drivers & Gaming Apps Ready! 🎮🔥
EOF
chown "${SUDO_USER:-$USER}" "$USER_HOME/gaming_ready.txt" 2>/dev/null || true

echo "Setup complete! Created ~/gaming_ready.txt"
echo "Self-destructing script file..."
rm -- "$0"
