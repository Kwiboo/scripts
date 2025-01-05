#!/bin/sh
set -e -x

# docker build --pull -f docker/Dockerfile -t minsys-builder docker/
# docker run --rm --log-driver none --init -u ubuntu -h builder -v $HOME/minsys:/src -w /src -it minsys-builder

# cd linux
# make menuconfig
# make olddefconfig
# make -j$(nproc) all

# mkdir firmware sysroot rootfs

# cd musl
# ./configure --target=aarch64-linux-gnu --prefix=/src/sysroot

# cd linux
# make headers_install INSTALL_HDR_PATH=/src/sysroot

# cd busybox
# make menuconfig
# make install

# cd iperf
# CC=/src/sysroot/bin/musl-gcc ./configure --host=aarch64-linux-gnu --enable-static-bin --disable-shared --prefix=/src/rootfs/usr --with-sysroot=/src/sysroot
# CC=/src/sysroot/bin/musl-gcc make

# cd stress
# ./autogen.sh
# CC=/src/sysroot/bin/musl-gcc ./configure --host=aarch64-linux-gnu --enable-static --prefix=/src/rootfs/usr
# CC=/src/sysroot/bin/musl-gcc make

# cd tinymembench
# CC=/src/sysroot/bin/musl-gcc CFLAGS="-static -march=armv8-a" make

# cd pciutils
# make CROSS_COMPILE=$CROSS_COMPILE HOST=aarch64-Linux SYSINCLUDE=/src/sysroot/include ZLIB=no SHARED=no DNS=no PREFIX=/src/rootfs/usr CC=/src/sysroot/bin/musl-gcc CFLAGS="-static"
# make -n install PREFIX=/sys/rootfs/usr

# cp init rootfs
# fakeroot ./build_initramfs.sh

# qemu-system-aarch64 -M virt -m 2048 -smp 1 -cpu cortex-a72 -no-reboot -nographic -kernel linux/arch/arm64/boot/Image -append "console=ttyAMA0" -initrd initramfs.cpio.gz
