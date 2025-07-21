# 🚀 Arch Linux Otimizado para ThinkPad T440

Scripts completos para transformar um ThinkPad T440 em uma máquina Linux potente e segura, com excelente compatibilidade de hardware.

---

## ✅ Funcionalidades

- Suporte completo ao GNOME Wayland ou KDE Plasma
- Drivers funcionando (Wi‑Fi, TrackPoint, áudio, bateria)
- Otimizações para 8 GB de RAM e SSD
- Segurança reforçada (firewall, fail2ban, AppArmor)
- Roda direto em chroot ou instalação limpa

---

## 📦 Conteúdo do Projeto

- `arch-t440-gnome.sh` – instalação com GNOME Wayland  
- `arch-t440-kde.sh` – instalação com KDE Plasma  
- `LICENSE` – Licença MIT

---

## ⚙️ Requisitos

- ThinkPad T440  
- Instalação base do Arch Linux concluída  
- Conexão com a internet (ex: `iwctl`)  
- Acesso root (chroot ou sistema instalado)

---

## 🚀 Instalação Automática

Execute como root em um sistema Arch (chroot ou instalado):

### GNOME Wayland:

```bash
bash <(curl -L https://raw.githubusercontent.com/P3nth00/arch-t440-optimized/main/arch-t440-gnome-wayland.sh)
```

### KDE Plasma:

```bash
bash <(curl -L https://raw.githubusercontent.com/P3nth00/arch-t440-optimized/main/arch-t440-ultimate.sh)
```

---

## 🧩 O que o Script Faz

| Componente   | Descrição |
|-------------|-----------|
| Vídeo       | Intel HD 4400 com VA‑API, Vulkan e aceleração |
| TrackPoint  | Sensibilidade ajustada |
| Touchpad    | Libinput com multitoque |
| Wi‑Fi       | Suporte Intel 5 GHz |
| Bateria     | TLP com ajustes para maior duração |
| Ambiente    | GNOME 45 ou KDE Plasma 6 (leve e limpo) |
| Segurança   | UFW, fail2ban e AppArmor |
| Áudio       | PipeWire + codecs |
| Utilitários | `htop`, `neofetch`, `gparted` |
| Apps        | Firefox, LibreOffice, GIMP |
| Jogos       | Steam + Proton |
| Otimizações | TRIM no SSD, swap reduzido, escalonador de CPU |

---

## 🛠️ Instalação Manual (Passo a Passo)

### 1. Conecte à Internet

```bash
iwctl station wlan0 connect "SEU_WIFI"
ping archlinux.org
```

### 2. Particione o Disco

- EFI: 500 MiB  
- Swap: 4 GiB  
- Root: restante

### 3. Formate e Monte

```bash
mkfs.fat -F32 /dev/nvme0n1p1
mkswap /dev/nvme0n1p2
mkfs.ext4 /dev/nvme0n1p3

mount /dev/nvme0n1p3 /mnt
swapon /dev/nvme0n1p2
```

### 4. Instale o Sistema Base

```bash
pacstrap /mnt base linux linux-firmware intel-ucode nano
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
```

### 5. Baixe e execute o script desejado (GNOME ou KDE)

### 6. Finalize

- Defina a senha do root
- Saia do chroot
- Desmonte os pontos de montagem
- Reinicie o sistema

---

## ❓ FAQ

**Posso usar dual‑boot com Windows?**  
Sim. Use o GParted para reduzir a partição do Windows e instale o Arch no espaço livre.

**Meu touchpad é ruim. Alguma dica?**  
Troque pelo touchpad do ThinkPad T450 — ele tem botões físicos.

**Como atualizo o sistema?**  
```bash
sudo pacman -Syu
```

---

## 📝 Licença

Este projeto está licenciado sob a Licença MIT. Consulte o arquivo `LICENSE` para mais informações.

---

## 📌 Sobre

Projeto pessoal criado para configurar e otimizar rapidamente o Arch Linux no **ThinkPad T440**, com suporte completo ao hardware e foco em desempenho, segurança e experiência de uso.
