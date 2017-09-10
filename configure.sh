# timezone
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

# sync hardware clock
hwclock --systohc

# localizations
sed -i s/^#de_DE.UTF-8/de_DE.UTF-8/ /etc/locale.gen
locale-gen

echo "KEYMAP=de-latin1-nodeadkeys" > /etc/vconsole.conf
echo "tfink-srv-1" > /etc/hostname

# add sd-lvm2 to initramfs/boot
sed s/block filesystems/block sd-lvm2 filesystems/ /etc/mkinitcpio.conf
mkinitcpio -p linux

# root password
passwd

pacman -S --noconfirm intel-ucode

# boot loader
bootctl install
cat <<EOT >> /boot/loader/loader.conf
default arch
timeout 0
editor 0
EOT

cat <<EOT >> /boot/loader/entries/arch.conf
title   Arch Linux
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux.img
options root=/dev/mapper/VolGroup00-root rw
EOT
