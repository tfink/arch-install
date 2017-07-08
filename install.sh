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
sgdisk -n 0:0:+16G -t 0:8200 -c 0:"Swap" /dev/sda
sgdisk -n 0:0:0 -t 0:8300 -c 0:"Data" /dev/sda
partprobe /dev/sda
