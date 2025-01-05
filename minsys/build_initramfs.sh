#!/bin/bash
pushd rootfs
# Note: busybox may have created some of these during its install.
mkdir -p dev bin sbin etc proc sys usr/bin usr/sbin usr/share lib tmp
# TODO: Get the non-sudo equivalents.
mknod -m 622 ./dev/console c 5 1
mknod -m 666 ./dev/null c 1 3
# mknod /dev/tty c 5 0
cp -vR ../firmware ./lib
cp -v ../iperf/src/iperf3 ./usr/bin/
cp -v ../stress/src/stress ./usr/bin/
cp -v ../tinymembench/tinymembench ./usr/bin/
cp -v ../pciutils/lspci ./usr/bin/lspci-pciutils
cp -v ../pciutils/pci.ids ./usr/share/
find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../initramfs.cpio.gz
popd
