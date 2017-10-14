!#/bin/bash
set -x -e

DEV=/dev/mmcblk0
BOOT_PARTITION=${DEV}p1
ROOT_PARTITION=${DEV}p2

echo "Partition ${DEV}"
sudo sfdisk ${DEV} <<EOF
label: dos
label-id: 0x74943e7a
device: ${DEV}
unit: sectors

${BOOT_PARTITION} : start=        2048, size=      204800, type=c
${ROOT_PARTITION} : start=      206848, size=    30724096, type=83
EOF

sync

echo "Format boot partition ${BOOT_PARTITION}"
sudo mkfs.vfat ${BOOT_PARTITION}

echo "Format root patition ${ROOT_PARTITION}"
sudo mkfs.ext4 -F ${ROOT_PARTITION}


mkdir -p root
sudo mount ${ROOT_PARTITION} root

mkdir -p boot
sudo mount ${BOOT_PARTITION} boot

if [ ! -f ArchLinuxARM-rpi-2-latest.tar.gz ]; then
    wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz
fi
sudo bsdtar -xpf ArchLinuxARM-rpi-2-latest.tar.gz -C root
sync

sudo mv root/boot/* boot

cat ~/.ssh/rpi3_rsa.pub >> root/home/alarm/.ssh/authorized_keys

sudo umount boot root



