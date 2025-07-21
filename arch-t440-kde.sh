#!/bin/bash

# Verificação de root
if [ "$(id -u)" -ne 0 ]; then
  echo -e "\e[31mERRO: Este script deve ser executado como root!\e[0m"
  exit 1
fi

# Configurações básicas
HOSTNAME="thinkpad-t440"
USERNAME="seu_usuario"  # Altere antes de executar!

# Cores para mensagens
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
NC='\e[0m'

# Função para verificar erro
check_error() {
  if [ $? -ne 0 ]; then
    echo -e "${RED}Erro no comando: $1${NC}"
    exit 1
  fi
}

echo -e "${GREEN}=== INSTALAÇÃO ARCH LINUX PARA THINKPAD T440 ==="
echo -e "=== Ambiente KDE Plasma + Otimizações + Segurança ===${NC}\n"

## 1. CONFIGURAÇÃO INICIAL DO SISTEMA
echo -e "${YELLOW}[1/8] Configurando sistema base...${NC}"

# Configurar hostname
echo "$HOSTNAME" > /etc/hostname
check_error "Configurar hostname"

# Configurar locale
sed -i 's/^#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
check_error "Configurar locale"

# Configurar teclado ABNT2
echo "KEYMAP=br-abnt2" > /etc/vconsole.conf
localectl set-keymap br-abnt2
check_error "Configurar teclado"

# Configurar fuso horário
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc
check_error "Configurar fuso horário"

## 2. INSTALAÇÃO DE DRIVERS ESSENCIAIS
echo -e "${YELLOW}[2/8] Instalando drivers essenciais...${NC}"

# Atualizar base de dados
pacman -Sy --noconfirm
check_error "Atualizar pacman"

# Instalar microcode e drivers
pacman -S --noconfirm \
  intel-ucode \
  mesa lib32-mesa \
  vulkan-intel lib32-vulkan-intel \
  libva-intel-driver lib32-libva-intel-driver \
  intel-media-driver \
  xf86-video-intel \
  networkmanager wpa_supplicant wireless_tools iw \
  iwlwifi-firmware \
  bluez bluez-utils blueman \
  alsa-utils pipewire pipewire-alsa pipewire-pulse wireplumber \
  sof-firmware \
  tlp acpi_call tpacpi-bat \
  smartmontools
check_error "Instalar drivers"

# Configurar NetworkManager
systemctl enable NetworkManager
systemctl enable bluetooth

## 3. INSTALAÇÃO DO AMBIENTE GRÁFICO (KDE PLASMA OTIMIZADO)
echo -e "${YELLOW}[3/8] Instalando KDE Plasma otimizado...${NC}"

# Pacotes essenciais do KDE (versão minimalista)
pacman -S --noconfirm \
  xorg-server xorg-xinit xorg-xkill \
  plasma-desktop sddm sddm-kcm \
  kwin kscreen \
  dolphin konsole kate \
  plasma-nm plasma-pa \
  kdegraphics-thumbnailers \
  ffmpegthumbs \
  ark unzip unrar p7zip \
  spectacle gwenview \
  breeze breeze-gtk breeze-icons \
  powerdevil \
  plasma-systemmonitor \
  ksysguard
check_error "Instalar KDE Plasma"

# Remover componentes pesados opcionais (reduzir consumo de RAM)
pacman -Rs --noconfirm kdeconnect korganizer kmail kontact ktorrent kmahjongg kmines kpat
check_error "Remover componentes pesados"

# Configurar SDDM
systemctl enable sddm

# Configurar KDE para ser mais leve
cat > /etc/sddm.conf << 'EOL'
[Autologin]
Relogin=false
Session=
User=

[General]
HaltCommand=
RebootCommand=

[Theme]
Current=breeze
CursorTheme=breeze_cursors
DisableAvatarsThreshold=7
EnableAvatars=true
ThemeDir=/usr/share/sddm/themes

[Users]
DefaultPath=/usr/local/sbin:/usr/local/bin:/usr/bin
HideShells=
HideUsers=
MaximumUid=60000
MinimumUid=1000
RememberLastSession=true
RememberLastUser=true
EOL

## 4. CONFIGURAÇÃO DO TOUCHPAD E TRACKPOINT
echo -e "${YELLOW}[4/8] Configurando dispositivos de entrada...${NC}"

pacman -S --noconfirm xf86-input-libinput
check_error "Instalar libinput"

# Configuração avançada do TrackPoint e Touchpad
cat > /etc/X11/xorg.conf.d/50-thinkpad.conf << 'EOL'
Section "InputClass"
    Identifier      "TrackPoint"
    MatchProduct    "TPPS/2 IBM TrackPoint|DualPoint Stick|Synaptics Inc. Composite TouchPad / TrackPoint |ThinkPad USB Keyboard with TrackPoint|USB Trackpoint pointing device"
    MatchDevicePath "/dev/input/event*"
    Driver          "libinput"
    Option          "AccelSpeed"         "-0.3"
    Option          "AccelProfile"       "flat"
    Option          "MiddleEmulation"    "true"
EndSection

Section "InputClass"
    Identifier      "TouchPad"
    MatchIsTouchpad "on"
    Driver          "libinput"
    Option          "Tapping"           "on"
    Option          "ClickMethod"       "clickfinger"
    Option          "NaturalScrolling"  "true"
    Option          "DisableWhileTyping" "true"
    Option          "MiddleEmulation"   "true"
    Option          "ScrollMethod"      "twofinger"
EndSection
EOL

## 5. SEGURANÇA AVANÇADA
echo -e "${YELLOW}[5/8] Configurando segurança avançada...${NC}"

# Instalar pacotes de segurança
pacman -S --noconfirm \
  firewalld fail2ban clamav rkhunter \
  ufw gufw \
  apparmor audit \
  keepassxc \
  seahorse \
  openssh
check_error "Instalar pacotes de segurança"

# Configurar firewall
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
ufw enable
systemctl enable ufw

# Configurar fail2ban
systemctl enable fail2ban

# Configurar AppArmor
systemctl enable apparmor
systemctl start apparmor

# Configurações de kernel para segurança
cat > /etc/sysctl.d/99-security.conf << 'EOL'
# Proteções básicas
kernel.kptr_restrict = 2
kernel.dmesg_restrict = 1
kernel.printk = 3 3 3 3
kernel.unprivileged_bpf_disabled = 1
net.core.bpf_jit_harden = 2

# Proteção contra exploits
vm.mmap_min_addr = 65536
vm.unprivileged_userfaultfd = 0
kernel.kexec_load_disabled = 1
kernel.sysrq = 0
kernel.unprivileged_userns_clone = 0

# Network security
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_rfc1337 = 1
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1
EOL

sysctl --system

## 6. OTIMIZAÇÕES DE DESEMPENHO
echo -e "${YELLOW}[6/8] Aplicando otimizações de desempenho...${NC}"

# Configurar TLP para melhor gerenciamento de energia
cat > /etc/tlp.conf << 'EOL'
TLP_ENABLE=1
TLP_DEFAULT_MODE=BAT
TLP_PERSISTENT_DEFAULT=1
CPU_SCALING_GOVERNOR_ON_AC=powersave
CPU_SCALING_GOVERNOR_ON_BAT=powersave
ENERGY_PERF_POLICY_ON_AC=balance_performance
ENERGY_PERF_POLICY_ON_BAT=power
DISK_DEVICES="sda sdb"
DISK_APM_LEVEL_ON_AC="254 254"
DISK_APM_LEVEL_ON_BAT="128 128"
MAX_LOST_WORK_SECS_ON_AC=15
MAX_LOST_WORK_SECS_ON_BAT=60
SCHED_POWERSAVE_ON_AC=0
SCHED_POWERSAVE_ON_BAT=1
NMI_WATCHDOG=0
RUNTIME_PM_ON_AC=on
RUNTIME_PM_ON_BAT=auto
USB_AUTOSUSPEND=1
RESTORE_DEVICE_STATE_ON_STARTUP=1
EOL

systemctl enable tlp
systemctl mask systemd-rfkill.service
systemctl mask systemd-rfkill.socket

# Configurar CPU governor
pacman -S --noconfirm cpupower
systemctl enable cpupower

# Configurações de memória e swap
echo "vm.swappiness=10" >> /etc/sysctl.d/99-sysctl.conf
echo "vm.vfs_cache_pressure=50" >> /etc/sysctl.d/99-sysctl.conf
echo "vm.dirty_writeback_centisecs=6000" >> /etc/sysctl.d/99-sysctl.conf
sysctl --system

# Habilitar TRIM para SSD
systemctl enable fstrim.timer

# Otimizações para sistemas com 8GB RAM
cat > /etc/sysctl.d/99-memory.conf << 'EOL'
# Otimizações de memória para 8GB RAM
vm.min_free_kbytes=65536
vm.watermark_scale_factor=200
vm.page-cluster=0
vm.dirty_ratio=10
vm.dirty_background_ratio=5
vm.swappiness=10
vm.vfs_cache_pressure=50
EOL

## 7. INSTALAÇÃO DE UTILITÁRIOS E APLICATIVOS
echo -e "${YELLOW}[7/8] Instalando utilitários e aplicativos...${NC}"

# Utilitários básicos
pacman -S --noconfirm \
  htop neofetch bashtop \
  git base-devel \
  rsync openssh \
  ntfs-3g exfat-utils \
  unzip unrar p7zip \
  lm_sensors \
  gparted \
  nano vim \
  wget curl \
  firefox \
  libreoffice-fresh \
  gimp \
  vlc \
  keepassxc \
  telegram-desktop \
  qbittorrent

# Ferramentas de desenvolvimento (opcional)
pacman -S --noconfirm \
  code \
  python \
  nodejs npm \
  docker docker-compose

# Configurar Docker (se instalado)
if pacman -Qi docker > /dev/null ; then
  systemctl enable docker
  usermod -aG docker $USERNAME
fi

## 8. CONFIGURAÇÃO FINAL
echo -e "${YELLOW}[8/8] Aplicando configurações finais...${NC}"

# Criar usuário (se não existir)
if ! id "$USERNAME" &>/dev/null; then
  useradd -m -G wheel,audio,video,storage,power,network,libvirt -s /bin/bash "$USERNAME"
  echo -e "${BLUE}Defina a senha para o usuário $USERNAME:${NC}"
  passwd "$USERNAME"
fi

# Configurar sudo para o usuário
echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/wheel
echo "Defaults timestamp_timeout=30" >> /etc/sudoers.d/wheel

# Limpar cache pacman
paccache -rk1

# Mensagem final
echo -e "${GREEN}\n=== INSTALAÇÃO CONCLUÍDA COM SUCESSO! ===${NC}"
echo -e "Recomendações pós-instalação:"
echo -e "1. Reinicie o sistema"
echo -e "2. Configure o KDE Plasma conforme suas preferências"
echo -e "3. Para jogos, instale:"
echo -e "   - steam gamemode lib32-gamemode"
echo -e "4. Ative o Firewall:"
echo -e "   - sudo ufw enable"
echo -e "5. Para melhor experiência com o touchpad, considere substituí-lo pelo modelo do T450"
echo -e "\n${BLUE}Seu ThinkPad T440 está pronto para uso!${NC}"
