# use german keymap
loadkeys de-latin1-nodeadkeys

# connect to wireless network
ip link set wlp6s0 up
wpa_supplicant -B -i wlp6s0 -c<(wpa_passphrase "wireless network" "password")
dhcpcd wlp6s0

# set time
timedatectl set-ntp true

# clear disk and create partitions
sgdisk -Zg /dev/sda
sgdisk -n 1:0:+512M -t  /dev/sda
