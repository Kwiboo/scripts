i#!/bin/bash
set -e -x

# mkdir -p ~/labgrid
# cd ~/labgrid
# python3 -m venv .
# bin/pip install git+https://github.com/Kwiboo/labgrid.git@rockchip --upgrade

DEVICE=$1
ARGS="${@:2}"

if [ ! -f "devices/$DEVICE.conf" ]; then
        echo "Unknown device '$DEVICE'" >&2
        exit 1
fi

eval $(confget -f "devices/$DEVICE.conf" -s base -l -S)
if [ -n "$SOC" -a -f "devices/$SOC.conf" ]; then
	eval $(confget -f "devices/base.conf" -s labgrid -l -S)
	eval $(confget -f "devices/$SOC.conf" -s labgrid -l -S)
fi
eval $(confget -f "devices/$DEVICE.conf" -s labgrid -l -S)

export LG_COORDINATOR LG_PLACE

~/labgrid/bin/labgrid-client -v -c ~/labgrid/ramboot-template.yaml ${ARGS:--s cycle con}
