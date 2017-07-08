# use german keymap
loadkeys de-latin1-nodeadkeys

# connect to wireless network
ip link set wlp6s0 up
wpa_supplicant -B -i wlp6s0 -c<(wpa_passphrase "wireless network" "password")
dhcpcd wlp6s0

# set time
timedatectl set-ntp true

# clear disk and create partitions
sgdisk -Z /dev/sda
sgdisk -n 0:0:+512M -t 0:ef00 -c 0:"EFI System partition" /dev/sda
sgdisk -n 0:0:+24G -t 0:8200 -c 0:"Swap" /dev/sda
sgdisk -n 0:0:0 -t 0:8300 -c 0:"Data" /dev/sda
partprobe /dev/sda

# setup LVM
vgcreate VolGroup00 /dev/sda3
lvcreate -L 10G VolGroup00 lvol_var
lvcreate -L 10G VolGroup00 lvol_tmp
lvcreate -L 100%FREE VolGroup00 lvol_root

# format partitions, volumes and swap
mkfs.fat -F 32 /dev/sda1
mkfs.ext4 -L "root" /dev/mapper/VolGroup00-lvol_root
mkfs.ext4 -L "var" /dev/mapper/VolGroup00-lvol_var
mkfs.ext4 -L "tmp" /dev/mapper/VolGroup00-lvol_tmp
mkswap /dev/sda2
swapon /dev/sda2

# mount
mount /dev/mapper/VolGroup00-lvol_root /mnt
mkdir -p /mnt/boot /mnt/var /mnt/tmp
mount /dev/sda1 /mnt/boot
mount /dev/mapper/VolGroup00-lvol_var /mnt/var
mount /dev/mapper/VolGroup00-lvol_tmp /mnt/tmp

# install packages
pacstrap /mnt base

# genreate mount file
genfstab -L /mnt >> /mnt/etc/fstab

# go into installed system
arch-chroot /mnt
