#!/bin/bash
set -e -x

SCRIPTS_PATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}"))

pushd "$SCRIPTS_PATH/minsys"
docker build --pull -f docker/Dockerfile -t minsys-builder:arm64 --target arm64 docker/
docker build --pull -f docker/Dockerfile -t minsys-builder:armhf --target armhf docker/
popd

pushd "$SCRIPTS_PATH/u-boot"
docker build --pull -f docker/Dockerfile -t u-boot-builder docker/
popd
