#!/bin/bash
set -e -x

SCRIPTS_PATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}"))
DEVICES_PATH=$SCRIPTS_PATH/devices

DEVICE=${1:-mrproper}
ARGS=${@:2}

if [[ $DEVICE == mrproper ]]; then
	docker run --rm --log-driver none --init -u ubuntu -h builder -v "$HOME:$HOME" -w $PWD \
		-it u-boot-builder make mrproper
	exit 0
elif [[ ! -f "$DEVICES_PATH/$DEVICE.conf" ]]; then
	echo "Unknown device '$DEVICE'" >&2
	exit 1
fi

SOC=${DEVICE/-*/}
eval $(confget -f "$DEVICES_PATH/$DEVICE.conf" -s base -l -S)
if [[ -n $SOC && -f "$DEVICES_PATH/$SOC.conf" ]]; then
	eval $(confget -f "$DEVICES_PATH/base.conf" -s u-boot -l -S)
	eval $(confget -f "$DEVICES_PATH/$SOC.conf" -s u-boot -l -S)
fi
eval $(confget -f "$DEVICES_PATH/$DEVICE.conf" -s u-boot -l -S)

export CROSS_COMPILE
export BINMAN_INDIRS=$(realpath ~/rkbin/)
if [[ -n $RKBOOT ]]; then
	export ROCKCHIP_TPL=$(confget -f ~/rkbin/RKBOOT/$RKBOOT -s LOADER_OPTION FlashData)
fi
if [[ -n $RKTRUST ]]; then
	export BL31=$(confget -f ~/rkbin/RKTRUST/$RKTRUST -s BL31_OPTION PATH)
fi

rm -v u-boot.itb u-boot.img u-boot-rockchip*.bin tpl/u-boot-tpl.dtb spl/u-boot-spl.dtb u-boot.dtb || :

docker run --rm --log-driver none --init -u ubuntu -h builder -v "$HOME:$HOME" -w $PWD \
	-e CROSS_COMPILE -e BINMAN_INDIRS -e ROCKCHIP_TPL -e BL31 \
	-it u-boot-builder make -j$(nproc) \
	$TARGET $TARGET_EXTRA $ARGS \
	savedefconfig all u-boot-initial-env

if [[ -f u-boot.itb ]]; then
	tools/mkimage -l u-boot.itb
elif [[ -f u-boot.img ]]; then
	tools/mkimage -l u-boot.img
fi

if [[ -f u-boot-rockchip.bin ]]; then
	tools/mkimage -l u-boot-rockchip.bin
fi

if [[ -f "configs/$TARGET" && -f defconfig ]]; then
	diff -u "configs/$TARGET" defconfig || :
fi

if [[ -f tpl/u-boot-tpl.dtb && -f spl/u-boot-spl.dtb && -f u-boot.dtb ]]; then
	python3 "$SCRIPTS_PATH/u-boot/checkdtb.py" --tpl tpl/u-boot-tpl.dtb --spl spl/u-boot-spl.dtb u-boot.dtb
elif [[ -f spl/u-boot-spl.dtb && -f u-boot.dtb ]]; then
	python3 "$SCRIPTS_PATH/u-boot/checkdtb.py" --spl spl/u-boot-spl.dtb u-boot.dtb
elif [[ -f u-boot.dtb ]]; then
	python3 "$SCRIPTS_PATH/u-boot/checkdtb.py" u-boot.dtb
fi

if [[ -d /srv/u-boot ]]; then
	mkdir -p "/srv/u-boot/$DEVICE/"
	cp -v u-boot-rockchip*.bin "/srv/u-boot/$DEVICE/" || :
elif [[ -f u-boot-rockchip.bin ]]; then
	dd if=/dev/zero of=uefi.img bs=1M count=128 conv=fsync
	mkfs.vfat uefi.img -F 32
	mmd -i uefi.img ::/EFI
	mmd -i uefi.img ::/EFI/BOOT
	mcopy -i uefi.img u-boot-rockchip.bin ::/
	if [[ -f u-boot-rockchip-spi.bin ]]; then
		mcopy -i uefi.img u-boot-rockchip-spi.bin ::/
	fi
	mcopy -i uefi.img idbloader.img ::/
	if [[ -f u-boot.itb ]]; then
		mcopy -i uefi.img u-boot.itb ::/
	elif [[ -f u-boot.img ]]; then
		mcopy -i uefi.img u-boot.img ::/
	fi
	sync
	dd if=/dev/zero of=boot.img bs=1M count=160 conv=fsync
	parted -s boot.img mklabel gpt
	parted -s boot.img mkpart primary fat32 16MiB 144MiB
	parted -s boot.img set 1 legacy_boot on
	dd if=uefi.img of=boot.img bs=1M seek=16 conv=fsync,notrunc
	dd if=u-boot-rockchip.bin of=boot.img bs=32k seek=1 conv=fsync,notrunc
	gzip boot.img -f
fi
