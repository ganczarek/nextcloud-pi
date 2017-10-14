#!/usr/bin/env bash
set -x -e

DEV=/dev/mmcblk0
BOOT_PARTITION=${DEV}p1
ROOT_PARTITION=${DEV}p2

echo "Partition ${DEV}"
sudo sfdisk ${DEV} <<EOF
,100M,c
;
EOF

echo "Format boot partition ${BOOT_PARTITION}"
sudo mkfs.vfat ${BOOT_PARTITION}

echo "Format root patition ${ROOT_PARTITION}"
sudo mkfs.f2fs -f ${ROOT_PARTITION}

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
sync

sudo bash -c 'cat <<EOF >> root/etc/fstab
/dev/mmcblk0p2  /       f2fs    defaults,noatime,discard    0   0
tmpfs           /tmp    tmpfs   nodev,nosuid,size=2G    0   0
EOF'

sudo mkdir root/home/alarm/.ssh/
sudo tee -a root/home/alarm/.ssh/authorized_keys < ~/.ssh/rpi3_rsa.pub

sudo umount boot root