#!/bin/bash

# find arch/arm/dts -type f -name rk356*-u-boot.dtsi -exec ./checkdtsi-sort.sh {} \;

A=$(grep "^&" $1)
B=$(grep "^&" $1 | LC_ALL=C sort)

if [ "$A" != "$B" ]; then
	echo "$1"
	echo "$A" > a.order
	echo "$B" > b.order
	diff -u a.order b.order
fi
