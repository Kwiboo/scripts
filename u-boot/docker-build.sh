#!/bin/sh
set -e -x

# docker build --pull -f docker/Dockerfile -t u-boot-builder docker/
# docker run --rm --log-driver none --init -u ubuntu -h builder -v $HOME:$HOME -w `pwd` -it u-boot-builder

if [ -f u-boot-rockchip.bin ]; then
	rm u-boot-rockchip.bin
fi
if [ -f u-boot-rockchip-spi.bin ]; then
	rm u-boot-rockchip-spi.bin
fi

docker run --rm --log-driver none --init -u ubuntu -h builder -v $HOME:$HOME -w `pwd` -it u-boot-builder ./build.sh "${1:-mrproper}" ${2}

if [ -f u-boot-rockchip.bin ]; then
	dd if=/dev/zero of=uefi.img bs=1M count=128 conv=fsync
	mkfs.vfat uefi.img -F 32
	mmd -i uefi.img ::/EFI
	mmd -i uefi.img ::/EFI/BOOT
	#mcopy -i uefi.img bootaa64.efi ::/EFI/BOOT
	mcopy -i uefi.img u-boot-rockchip.bin ::/
	if [ -f u-boot-rockchip-spi.bin ]; then
		mcopy -i uefi.img u-boot-rockchip-spi.bin ::/
	fi
	mcopy -i uefi.img idbloader.img ::/
	if [ -f u-boot.itb ]; then
		mcopy -i uefi.img u-boot.itb ::/
	elif [ -f u-boot.img ]; then
		mcopy -i uefi.img u-boot.img ::/
	fi
	sync
	dd if=/dev/zero of=boot.img bs=1M count=160 conv=fsync
	parted -s boot.img mklabel gpt
	parted -s boot.img mkpart primary fat32 16MiB 144MiB
	#parted -s boot.img set 1 esp on
	parted -s boot.img set 1 legacy_boot on
	dd if=uefi.img of=boot.img bs=1M seek=16 conv=fsync,notrunc
	dd if=u-boot-rockchip.bin of=boot.img bs=32k seek=1 conv=fsync,notrunc
	gzip boot.img -f
fi
