#!/bin/bash
set -e -x

if [ "$1" = "mrproper" ]; then
	make mrproper
	exit 0
elif [ "$1" = "sync" ]; then
	grep -l "${2:-ROCKCHIP}" -R configs/ | tools/qconfig.py -s -v -d -
	exit 0
fi

CROSS_COMPILE=aarch64-linux-gnu-

if [[ "$1" =~ rk3588 ]]; then
	export BINMAN_INDIRS=../rkbin/
	export ROCKCHIP_TPL=$(confget -f ../rkbin/RKBOOT/RK3588MINIALL.ini -s LOADER_OPTION FlashData)
	export BL31=$(confget -f ../rkbin/RKTRUST/RK3588TRUST.ini -s BL31_OPTION PATH)
elif [[ "$1" =~ rk3576 ]]; then
	export BINMAN_INDIRS=../rkbin/
	export ROCKCHIP_TPL=$(confget -f ../rkbin/RKBOOT/RK3576MINIALL.ini -s LOADER_OPTION FlashData)
	export BL31=$(confget -f ../rkbin/RKTRUST/RK3576TRUST.ini -s BL31_OPTION PATH)
elif [[ "$1" =~ rk3566 || "$1" =~ generic-rk3568 ]]; then
	export BINMAN_INDIRS=../rkbin/
	export ROCKCHIP_TPL=$(confget -f ../rkbin/RKBOOT/RK3566MINIALL.ini -s LOADER_OPTION FlashData)
	export BL31=$(confget -f ../rkbin/RKTRUST/RK3568TRUST.ini -s BL31_OPTION PATH)
elif [[ "$1" =~ rk3568 ]]; then
	export BINMAN_INDIRS=../rkbin/
	export ROCKCHIP_TPL=$(confget -f ../rkbin/RKBOOT/RK3568MINIALL.ini -s LOADER_OPTION FlashData)
	export BL31=$(confget -f ../rkbin/RKTRUST/RK3568TRUST.ini -s BL31_OPTION PATH)
elif [[ "$1" =~ rk3528 ]]; then
	export BINMAN_INDIRS=../rkbin/
	export ROCKCHIP_TPL=$(confget -f ../rkbin/RKBOOT/RK3528MINIALL.ini -s LOADER_OPTION FlashData)
	export BL31=$(confget -f ../rkbin/RKTRUST/RK3528TRUST.ini -s BL31_OPTION PATH)
elif [[ "$1" =~ rk3399 || "$1" =~ chromebook_bob || "$1" =~ chromebook_kevin ]]; then
	export BINMAN_INDIRS=../rkbin/
	export ROCKCHIP_TPL=$(confget -f ../rkbin/RKBOOT/RK3399MINIALL.ini -s LOADER_OPTION FlashData)
	export BL31=$(confget -f ../rkbin/RKTRUST/RK3399TRUST.ini -s BL31_OPTION PATH)
	#export TEE=../optee_os/out/arm-plat-rockchip/core/tee.bin
	#export BL31=../arm-trusted-firmware/build/rk3399/release/bl31/bl31.elf
elif [[ "$1" =~ rk3368 ]]; then
	export BINMAN_INDIRS=../rkbin/
	export ROCKCHIP_TPL=$(confget -f ../rkbin/RKBOOT/RK3368MINIALL.ini -s LOADER_OPTION FlashData)
	export BL31=$(confget -f ../rkbin/RKTRUST/RK3368TRUST.ini -s BL31_OPTION PATH)
elif [[ "$1" =~ rk3328 ]]; then
	export BINMAN_INDIRS=../rkbin/
	export ROCKCHIP_TPL=$(confget -f ../rkbin/RKBOOT/RK3328MINIALL.ini -s LOADER_OPTION FlashData)
	export BL31=$(confget -f ../rkbin/RKTRUST/RK3328TRUST.ini -s BL31_OPTION PATH)
elif [[ "$1" =~ rk3308 ]]; then
	export BINMAN_INDIRS=../rkbin/
	export ROCKCHIP_TPL=$(confget -f ../rkbin/RKBOOT/RK3308MINIALL.ini -s LOADER_OPTION FlashData)
	export BL31=$(confget -f ../rkbin/RKTRUST/RK3308TRUST.ini -s BL31_OPTION PATH)
elif [[ "$1" =~ rk3288 ]]; then
	export BINMAN_INDIRS=../rkbin/
	export ROCKCHIP_TPL=$(confget -f ../rkbin/RKBOOT/RK3288MINIALL.ini -s LOADER_OPTION FlashData)
	CROSS_COMPILE=arm-linux-gnueabihf-
elif [[ "$1" =~ px30 ]]; then
	export BINMAN_INDIRS=../rkbin/
	export ROCKCHIP_TPL=$(confget -f ../rkbin/RKBOOT/PX30MINIALL.ini -s LOADER_OPTION FlashData)
	export BL31=$(confget -f ../rkbin/RKTRUST/PX30TRUST.ini -s BL31_OPTION PATH)
elif [[ "$1" =~ px5 ]]; then
	export BINMAN_INDIRS=../rkbin/
	export ROCKCHIP_TPL=$(confget -f ../rkbin/RKBOOT/PX5MINIALL.ini -s LOADER_OPTION FlashData)
	export BL31=$(confget -f ../rkbin/RKTRUST/RK3368TRUST.ini -s BL31_OPTION PATH)
elif [[ "$1" =~ rk3 || "$1" =~ rv1 ]]; then
	CROSS_COMPILE=arm-linux-gnueabihf-
fi

if [ -f u-boot.itb ]; then
	rm u-boot.itb
fi
if [ -f u-boot.img ]; then
	rm u-boot.img
fi

make -j$(nproc) \
     CROSS_COMPILE=$CROSS_COMPILE KCFLAGS="-Werror" KBUILD_VERBOSE=0 \
     ${1}_defconfig \
     savedefconfig \
     all \
     u-boot-initial-env

if [ -f u-boot.itb ]; then
	tools/mkimage -l u-boot.itb
elif [ -f u-boot.img ]; then
	tools/mkimage -l u-boot.img
fi

diff -u configs/${1}_defconfig defconfig || :
