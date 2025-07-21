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

echo -e "${GREEN}=== Arch Linux for ThinkPad T440 (KDE Plasma) ===${NC}"

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

# 3. Install KDE Plasma
echo -e "${YELLOW}[3/6] Installing KDE Plasma...${NC}"
pacman -S --noconfirm \
  plasma-desktop sddm \
  konsole dolphin kate \
  plasma-nm plasma-pa \
  breeze breeze-gtk \
  ark unzip

systemctl enable sddm

# 4. Input Configuration
echo -e "${YELLOW}[4/6] Configuring TrackPoint...${NC}"
cat > /etc/X11/xorg.conf.d/20-thinkpad.conf << 'EOL'
Section "InputClass"
    Identifier "TrackPoint"
    MatchProduct "TPPS/2 IBM TrackPoint"
    Driver "libinput"
    Option "AccelSpeed" "-0.3"
    Option "NaturalScrolling" "true"
EndSection
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
echo "2. Install additional apps:"
echo "   sudo pacman -S firefox libreoffice-fresh"
echo "3. For gaming:"
echo "   sudo pacman -S steam gamemode${NC}"
