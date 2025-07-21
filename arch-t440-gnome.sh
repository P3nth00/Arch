#!/bin/bash

# Check root
if [ "$(id -u)" -ne 0 ]; then
  echo -e "\e[31mRun as root!\e[0m" >&2
  exit 1
fi

# Configuration
HOSTNAME="thinkpad-t440"
USERNAME="yourusername"  # CHANGE THIS

# Colors
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
NC='\e[0m'

echo -e "${GREEN}=== Arch Linux for ThinkPad T440 (GNOME Wayland) ===${NC}"

# 1. Base Configuration
echo -e "${YELLOW}[1/6] System configuration...${NC}"
echo "$HOSTNAME" > /etc/hostname
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc
sed -i 's/^#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=br-abnt2" > /etc/vconsole.conf

# 2. Install Drivers
echo -e "${YELLOW}[2/6] Installing drivers...${NC}"
pacman -Sy --noconfirm \
  intel-ucode \
  mesa lib32-mesa vulkan-intel \
  networkmanager wpa_supplicant iwlwifi-firmware \
  bluez bluez-utils pipewire pipewire-pulse \
  tlp acpi_call

systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable tlp

# 3. Install GNOME
echo -e "${YELLOW}[3/6] Installing GNOME...${NC}"
pacman -S --noconfirm \
  gnome gnome-extra gdm \
  gnome-tweaks gnome-shell-extensions \
  xdg-user-dirs

systemctl enable gdm

# 4. Wayland Configuration
echo -e "${YELLOW}[4/6] Configuring Wayland...${NC}"
cat > /etc/gdm/custom.conf << 'EOL'
[daemon]
WaylandEnable=true
DefaultSession=gnome-wayland.desktop
EOL

# 5. Create User
echo -e "${YELLOW}[5/6] Creating user...${NC}"
useradd -m -G wheel -s /bin/bash "$USERNAME"
echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/wheel
passwd "$USERNAME"

# 6. Cleanup
echo -e "${YELLOW}[6/6] Cleaning up...${NC}"
paccache -rk1

echo -e "${GREEN}=== Installation Complete! ==="
echo "Recommended:"
echo "1. Reboot"
echo "2. Install extensions:"
echo "   https://extensions.gnome.org/"
echo "3. For TrackPoint tweaks:"
echo "   Install 'ThinkPad Assistant' extension${NC}"
