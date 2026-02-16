#!/bin/bash
set -e -x

if [ "$1" = "mrproper" ]; then
	make mrproper
	exit 0
fi

make -j$(nproc) \
     CROSS_COMPILE=$CROSS_COMPILE KBUILD_VERBOSE=0 BINMAN_VERBOSE=0 \
     ${@:1} \
     savedefconfig \
     all \
     u-boot-initial-env

