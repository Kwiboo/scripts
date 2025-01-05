FROM ubuntu:noble

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get dist-upgrade -y \
 && apt-get install -y locales sudo \
 && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8 \
 && update-locale LANG=en_US.UTF-8 LANGUAGE=en_US:en
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN apt-get update && apt-get install -y \
    build-essential crossbuild-essential-arm64 libncurses5-dev bc cpio fakeroot vim vim-common flex bison libssl-dev rsync \
    pip swig libpython3.12-dev autoconf autoconf-archive automake \
    --no-install-recommends \
 && rm -rf /var/lib/apt/lists/*

RUN pip install dtschema yamllint --break-system-packages

ENV CROSS_COMPILE=aarch64-linux-gnu- ARCH=arm64

USER ubuntu
