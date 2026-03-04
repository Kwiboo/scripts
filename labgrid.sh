#!/bin/bash
set -e -x

SCRIPTS_PATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}"))
DEVICES_PATH=$SCRIPTS_PATH/devices
LABGRID_PATH=/home/labgrid

DEVICE=$1
ARGS=${@:2}

if [[ ! -f "$DEVICES_PATH/$DEVICE.conf" ]]; then
	echo "Unknown device '$DEVICE'" >&2
	exit 1
fi

LG_PLACE=$DEVICE
SOC=${DEVICE/-*/}
eval $(confget -f "$DEVICES_PATH/$DEVICE.conf" -s base -l -S)
if [[ -n $SOC && -f "$DEVICES_PATH/$SOC.conf" ]]; then
	eval $(confget -f "$DEVICES_PATH/base.conf" -s labgrid -l -S)
	eval $(confget -f "$DEVICES_PATH/$SOC.conf" -s labgrid -l -S)
fi
eval $(confget -f "$DEVICES_PATH/$DEVICE.conf" -s labgrid -l -S)

export LG_COORDINATOR LG_PLACE

"$LABGRID_PATH/bin/labgrid-client" -c "$SCRIPTS_PATH/labgrid/$LG_TEMPLATE" ${ARGS:--v -s cycle con}
