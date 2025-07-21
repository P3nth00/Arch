
markdown
Copiar
Editar
# Arch Linux Otimizado para ThinkPad T440 🚀

Scripts completos para transformar um ThinkPad T440 em uma máquina Linux potente e segura, com excelente compatibilidade de hardware.

✅ Suporta GNOME Wayland ou KDE Plasma  
✅ Drivers funcionando (Wi‑Fi, TrackPoint, áudio, bateria)  
✅ Otimizações para 8GB RAM e SSD  
✅ Segurança reforçada (firewall, fail2ban, AppArmor)  
✅ Roda no Linux (chroot ou instalação limpa)

---

## 📦 Conteúdo
- `arch-t440-gnome.sh` – script para instalação com GNOME Wayland  
- `arch-t440-kde.sh` – script para instalação com KDE Plasma  
- `LICENSE` – Licença MIT

---

## ⚙️ Requisitos
- ThinkPad T440  
- Instalação base do Arch Linux feita (via guia oficial)  
- Conexão com internet (ex: `iwctl`)  
- Acesso root no sistema chroot ou já instalado

---

## 🚀 Instalação em 1 comando

Execute como root no ambiente Arch (chroot ou já instalado). Exemplo:

Para GNOME Wayland:
```bash
bash <(curl -L https://raw.githubusercontent.com/P3nth00/arch-t440-optimized/main/arch-t440-gnome-wayland.sh)
Para KDE Plasma:

bash
Copiar
Editar
bash <(curl -L https://raw.githubusercontent.com/P3nth00/arch-t440-optimized/main/arch-t440-ultimate.sh)
🧩 O que o script faz
Componentes	Detalhes
Vídeo	Intel HD 4400 com VA‑API, Vulkan e aceleração
TrackPoint	Sensibilidade ajustada
Touchpad	Libinput com multitoque
Wi‑Fi	Suporte para bandeiras Intel 5 GHz
Bateria	TLP + ajustes para durar até 30% mais
Ambiente	GNOME 45 ou KDE Plasma 6 (configuração minimalista)
Segurança	UFW, fail2ban e AppArmor
Áudio	PipeWire + codecs multimídia
Utilitários	htop, neofetch, gparted
Apps básicos	Firefox, LibreOffice, GIMP
Jogos	Steam com Proton para jogos Windows
Otimizações	TRIM no SSD, swap reduzido, escalonador de CPU

🛠️ Instalação Manual (Passo‑a‑passo)
Conecte à internet

bash
Copiar
Editar
iwctl station wlan0 connect "SEU_WIFI"
ping archlinux.org
Particione o SSD (ex: EFI 500 MiB, swap 4 GiB, root resto)

Formate e monte:

bash
Copiar
Editar
mkfs.fat -F32 /dev/nvme0n1p1
mkswap /dev/nvme0n1p2
mkfs.ext4 /dev/nvme0n1p3
mount /dev/nvme0n1p3 /mnt
swapon /dev/nvme0n1p2
Instale sistema base:

bash
Copiar
Editar
pacstrap /mnt base linux linux-firmware intel-ucode nano
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
Baixe e execute o script desejado (GNOME ou KDE).

Finalize: defina senha root, exit chroot, desmonte e reinicie.

❓ FAQ
Posso usar dual‑boot com Windows?
Sim — basta reduzir sua partição Windows com o gparted e reservar espaço para o Arch.

Meu touchpad é ruim, o que faço?
Recomenda-se trocar o touchpad pelo modelo do T450 (com botões físicos).

Como atualizar o sistema depois?

bash
Copiar
Editar
sudo pacman -Syu
📝 Licença
Licenciado sob MIT. Veja o arquivo LICENSE para detalhes.

📌 Sobre
Otimizador personal para o ThinkPad T440, criado por você para uso pessoal e ou compartilhamento. Scripts que abordam instalação, suporte a hardware, segurança e experiência de desktop completa.
