#!/bin/bash

set -e

echo "[+] Formateando particiones..."
mkfs.vfat -F 32 /dev/sda1
mkfs.ext4 /dev/sda2
mkswap /dev/sda3

echo "[+] Montando particiones..."
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

echo "[+] Instalando paquetes base..."
pacstrap /mnt linux linux-firmware networkmanager grub wpa_supplicant base base-devel

echo "[+] Generando fstab..."
genfstab -U /mnt > /mnt/etc/fstab

echo "[+] Preparando entorno chroot..."

arch-chroot /root
passwd

useradd -m j4chury
ls /home/

passwd j4chury

echo "[+] Añadiendo usuario j4chury al grupo wheel..."
usermod -aG wheel j4chury

echo "[+] Instalando sudo y editores..."
pacman -Sy --noconfirm sudo vim nano

echo "[+] Configurando consola..."
echo 'KEYMAP=la-latin1' > /etc/vconsole.conf

echo "[+] Instalando GRUB..."
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

echo "[+] Configurando hostname..."
echo j4chury > /etc/hostname

echo "[+] Instalando fastfetch..."
pacman -Sy --noconfirm fastfetch

echo
echo "POSTERIOR: (HACER MANUALMENTE)"
echo "---------------------------------------"
echo "nano /etc/sudoers   # Descomentar '%wheel ALL=(ALL:ALL) ALL'"
echo "nano /etc/locale.gen  # Descomentar es_CO.UTF-8 y en_US.UTF-8"
echo "locale-gen"
echo
echo "nano /etc/hosts:"
echo "127.0.0.1       localhost"
echo "::1             localhost"
echo "127.0.0.1       j4chury.localhost j4chury"
echo
echo "reboot now"
echo "---------------------------------------"
EOF

chmod +x /mnt/root/setup.sh

echo "[+] Entrando a chroot para finalizar configuración..."
arch-chroot /mnt /root/setup.sh
