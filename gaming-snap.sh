#!/usr/bin/env bash
set -e

echo "Setting up AMD GPU drivers & Snap gaming environment..."

# 1. Enable 32-bit architecture & install AMD GPU Mesa Drivers + Vulkan
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y \
    mesa-vulkan-drivers \
    mesa-vulkan-drivers:i386 \
    libgl1-mesa-dri \
    libgl1-mesa-dri:i386 \
    libglx-mesa0 \
    libglx-mesa0:i386 \
    vulkan-tools \
    gamemode \
    mangohud \
    protontricks

# 2. Ensure snapd is installed & active
if ! command -v snap &> /dev/null; then
    sudo apt install -y snapd
fi

# 3. Install gaming Snaps
echo "Installing Snaps..."
sudo snap install steam
sudo snap install lutris
sudo snap install heroic

# 4. Create confirmation file in user home directory
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
- GameMode & MangoHud (APT)
- Protontricks (APT)

Status: AMD Drivers & Gaming Apps Ready! 🎮🔥
EOF
chown "${SUDO_USER:-$USER}" "$USER_HOME/gaming_ready.txt" 2>/dev/null || true

echo "Setup complete! Created ~/gaming_ready.txt"
echo "Self-destructing script file..."
rm -- "$0"
