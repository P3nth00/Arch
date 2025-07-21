Arch Linux Optimized for ThinkPad T440


Complete installation script to transform your ThinkPad T440 into a powerful Linux machine with:
✅ GNOME Wayland or KDE Plasma (lightweight and modern)
✅ 100% working drivers (Wi-Fi, TrackPoint, audio, battery)
✅ Performance optimizations for 8GB RAM and SSD
✅ Enhanced security (firewall, fail2ban, AppArmor)

🚀 How to Install (1 command)
Run as root in an already installed Arch Linux system (chroot or fresh install):

For GNOME (Wayland):
bash
curl -L https://raw.githubusercontent.com/P3nth00/arch-t440-optimized/main/arch-t440-gnome-wayland.sh | bash  
For KDE Plasma:
bash
curl -L https://raw.githubusercontent.com/P3nth00/arch-t440-optimized/main/arch-t440-ultimate.sh | bash  
⚠️ Prerequisites:

Base Arch Linux installed (official guide)

Internet connection (iwctl for Wi-Fi)

✨ What the Script Does
🔧 Full Hardware Support
Component	Status	Details
Graphics	✅ Intel HD 4400	Vulkan, VA-API, HW acceleration
TrackPoint	✅ Optimal config	Sensitivity adjusted
Touchpad	✅ Libinput	Multitouch gestures
Wi-Fi	✅ Intel Dual-Band	5GHz support
Battery	✅ TLP + optimizations	Up to 30% longer life
🛠️ Included Features
Desktop: GNOME 45 or KDE Plasma 6 (minimalist)

Security: Firewall (UFW), fail2ban, AppArmor

Multimedia: PipeWire (low-latency audio), codecs

Utilities:

htop, neofetch, gparted

Firefox, LibreOffice, GIMP

Steam (+ Proton for Windows games)

⚡ Optimizations
SSD: Automatic TRIM, reduced swap usage

CPU: powersave governor on battery

Memory: Tweaks for 8GB RAM

📥 Manual Installation (Step-by-Step)
Boot from Arch Linux USB

bash
iwctl station wlan0 connect "YOUR_NETWORK"  # Connect Wi-Fi  
ping archlinux.org  # Test internet  
Partitioning (example for 256GB SSD):

bash
cfdisk /dev/nvme0n1  # Create partitions:  
# - EFI (500M, type EFI)  
# - SWAP (4GB, type Linux Swap)  
# - / (remainder, type Linux filesystem)  
mkfs.fat -F32 /dev/nvme0n1p1  
mkswap /dev/nvme0n1p2  
mkfs.ext4 /dev/nvme0n1p3  
mount /dev/nvme0n1p3 /mnt  
swapon /dev/nvme0n1p2  
Install base system:

bash
pacstrap /mnt base linux linux-firmware intel-ucode nano  
genfstab -U /mnt >> /mnt/etc/fstab  
arch-chroot /mnt  
Run the script:

bash
curl -LO https://raw.githubusercontent.com/P3nth00/arch-t440-optimized/main/arch-t440-gnome-wayland.sh  
chmod +x arch-t440-gnome-wayland.sh  
./arch-t440-gnome-wayland.sh  
Finalize:

bash
passwd  # Set root password  
exit  
umount -R /mnt  
reboot  
❓ Frequently Asked Questions
1. Can I dual boot with Windows?
Yes! Shrink Windows partition with gparted and leave free space for Arch.

2. The T440 touchpad is bad. How to improve it?
We recommend replacing it with the T450 model (with physical buttons).

3. How to update the system later?
bash
sudo pacman -Syu  
