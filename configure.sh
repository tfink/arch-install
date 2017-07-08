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

# add sd-lvm2 to initramfs
nano /etc/mkinitcpio.conf
#sed ...
mkinitcpio -p linux

# root password
passwd

# boot loader
bootctl install
