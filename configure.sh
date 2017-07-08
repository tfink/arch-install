# timezone
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

# sync hardware clock
hwclock --systohc

# localizations
nano /etc/locale.gen
#sed ...
locale-gen

echo "KEYMAP=de-latin1" > /etc/vconsole.conf
echo "tfink-laptop" > /etc/hostname

# add sd-lvm2 to initramfsnt/boot
nano /etc/mkinitcpio.conf
#sed ...
mkinitcpio -p linux

# root password
passwd

pacman -S intel-ucode

# boot loader
bootctl install
nano /boot/loader/loader.conf
#default arch
#timeout 0
#editor 0

nano /boot/loader/entries/arch-lvm.conf
#title   Arch Linux
#linux   /vmlinuz-linux
#initrd  /intel-ucode.img
#initrd  /initramfs-linux.img
#options root=/dev/mapper/VolGroup00-lvol_root rw
