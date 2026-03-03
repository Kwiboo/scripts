FROM ubuntu:noble

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
    gcc-arm-none-eabi \
    bc \
    bison \
    confget \
    device-tree-compiler \
    flex \
    git \
    libgnutls28-dev \
    libssl-dev \
    openssl \
    python3-asteval \
    python3-cryptography \
    python3-dev \
    python3-pyelftools \
    python3-setuptools \
    swig \
    uuid-dev \
    vim \
    vim-common \
    --no-install-recommends \
 && rm -rf /var/lib/apt/lists/*

USER ubuntu
