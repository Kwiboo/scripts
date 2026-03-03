FROM ubuntu:noble AS base

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get dist-upgrade -y \
 && apt-get install -y locales sudo --no-install-recommends \
 && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8 \
 && update-locale LANG=en_US.UTF-8 LANGUAGE=en_US:en
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN apt-get update && apt-get install -y \
    build-essential \
    crossbuild-essential-arm64 \
    crossbuild-essential-armhf \
    autoconf \
    autoconf-archive \
    automake \
    bc \
    bison \
    cpio \
    fakeroot \
    flex \
    git \
    libncurses5-dev \
    libpython3.12-dev \
    libssl-dev \
    openssl \
    pip \
    rsync \
    swig \
    vim \
    vim-common \
    --no-install-recommends \
 && rm -rf /var/lib/apt/lists/*

RUN pip install dtschema yamllint --break-system-packages
USER ubuntu

FROM base AS armhf
ENV CROSS_COMPILE=arm-linux-gnueabihf- ARCH=arm

FROM base AS arm64
ENV CROSS_COMPILE=aarch64-linux-gnu- ARCH=arm64
