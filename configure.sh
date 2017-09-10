# timezone
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

# sync hardware clock
hwclock --systohc

# localizations
sed s/^#de_DE.UTF-8/de_DE.UTF-8/ /etc/locale.gen
locale-gen

echo "KEYMAP=de-latin1" > /etc/vconsole.conf
echo "tfink-laptop" > /etc/hostname

# add sd-lvm2 to initramfsnt/boot
sed s/block filesystems/block sd-lvm2 filesystems/ /etc/mkinitcpio.conf
mkinitcpio -p linux

# root password
passwd

pacman -Sy intel-ucode

# boot loader
bootctl install
nano /boot/loader/loader.conf
#default arch
#timeout 0
#editor 0

nano /boot/loader/entries/arch.conf
#title   Arch Linux
#linux   /vmlinuz-linux
#initrd  /intel-ucode.img
#initrd  /initramfs-linux.img
#options root=/dev/mapper/VolGroup00-root rw
