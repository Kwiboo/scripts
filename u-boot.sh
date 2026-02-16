#!/bin/bash
set -e -x

DEVICE=$1

if [ ! -f "devices/$DEVICE.conf" ]; then
        echo "Unknown device '$DEVICE'" >&2
        exit 1
fi

eval $(confget -f "devices/$DEVICE.conf" -s base -l -S)
if [ -n "$SOC" -a -f "devices/$SOC.conf" ]; then
	eval $(confget -f "devices/base.conf" -s u-boot -l -S)
	eval $(confget -f "devices/$SOC.conf" -s u-boot -l -S)
fi
eval $(confget -f "devices/$DEVICE.conf" -s u-boot -l -S)

export BINMAN_INDIRS=$(realpath ~/rkbin/)
export ROCKCHIP_TPL=$(confget -f rkbin/RKBOOT/$RKBOOT -s LOADER_OPTION FlashData)
export BL31=$(confget -f rkbin/RKTRUST/$RKTRUST -s BL31_OPTION PATH)
export CROSS_COMPILE

pushd u-boot

rm -v u-boot-rockchip*.bin || :

docker run --rm --log-driver none --init -u ubuntu -h builder -v $HOME:$HOME -w $HOME/u-boot -e CROSS_COMPILE -e BINMAN_INDIRS -e ROCKCHIP_TPL -e BL31 -it u-boot-builder ../u-boot-build.sh $TARGET $TARGET_EXTRA

if [ -f u-boot.itb ]; then
	tools/mkimage -l u-boot.itb
elif [ -f u-boot.img ]; then
	tools/mkimage -l u-boot.img
fi

if [ -f u-boot-rockchip.bin ]; then
	tools/mkimage -l u-boot-rockchip.bin
fi

if [ -f  configs/$TARGET ]; then
	diff -u configs/$TARGET defconfig || :
fi

mkdir -p /srv/u-boot/$DEVICE/
cp -v u-boot-rockchip*.bin /srv/u-boot/$DEVICE/

popd
