DEVICE="/dev/sda"
PARTITION_PREFIX="/sev/sda"

PARTITION_SIZE_BOOT="+512M"
PARTITION_SIZE_SWAP="+16G"

LVM_SIZE_VAR="10G"
LVM_SIZE_TMP="10G"
LVM_SIZE_ROOT="100%FREE"

# use german keymap
loadkeys de-latin1-nodeadkeys

# connect to wireless network
ip link set wlp6s0 up
wpa_supplicant -B -i wlp6s0 -c<(wpa_passphrase "wireless network" "password")
dhcpcd wlp6s0

# set time
timedatectl set-ntp true

# clear disk and create partitions
sgdisk -Z $DEVICE
sgdisk -n 0:0:${PARTITION_SIZE_BOOT} -t 0:ef00 -c 0:"EFI System partition" $DEVICE
sgdisk -n 0:0:${PARTITION_SIZE_SWAP} -t 0:8200 -c 0:"Swap" $DEVICE
sgdisk -n 0:0:0 -t 0:8300 -c 0:"Data" $DEVICE
partprobe $DEVICE

# setup LVM
vgcreate VolGroup00 ${PARTITION_PREFIX}3
lvcreate -L ${LVM_SIZE_VAR} --name=var VolGroup00
lvcreate -L ${LVM_SIZE_TMP} --name=tmp VolGroup00
lvcreate -L ${LVM_SIZE_ROOT} --name=root VolGroup00

# format partitions, volumes and swap
mkfs.fat -F 32 ${PARTITION_PREFIX}1
mkfs.ext4 -L "root" /dev/VolGroup00/root
mkfs.ext4 -L "var" /dev/VolGroup00/var
mkfs.ext4 -L "tmp" /dev/VolGroup00/tmp
mkswap ${PARTITION_PREFIX}2
swapon ${PARTITION_PREFIX}2

# mount
mount /dev/VolGroup00/root /mnt
mkdir -p /mnt/boot /mnt/var /mnt/tmp
mount ${PARTITION_PREFIX}1 /mnt/boot
mount /dev/VolGroup00/var /mnt/var
mount /dev/VolGroup00/tmp /mnt/tmp

# install packages
pacstrap /mnt base

# genreate mount file
genfstab -L /mnt >> /mnt/etc/fstab

# go into installed system
arch-chroot /mnt
