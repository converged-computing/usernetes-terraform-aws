#!/bin/bash

# Note that I'm erring on installing too many things, a lot of these are flux deps
# and I figure we might eventually want or need. This could be cleaned up further.
export DEBIAN_FRONTEND=noninteractive
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
dpkg-reconfigure locales

sudo apt-get update && \
    sudo apt-get install -y \
    apt-utils dialog nfs-kernel-server nfs-common firewalld

# Debian free firmware
sudo echo "deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware" >> /etc/apt/sources.list
sudo echo "deb-src http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware" >> /etc/apt/sources.list
sudo echo "deb http://deb.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list
sudo echo "deb-src http://deb.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list
sudo echo "deb http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list
sudo echo "deb-src http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list

# apt-get update
# apt-get install -y firmware-iwlwifi firmware-amd-graphics firmware-misc-nonfree

# Update grub
# cat /etc/default/grub | grep GRUB_CMDLINE_LINUX=
# grep -v "GRUB_CMDLINE_LINUX=" /etc/default/grub > /tmp/grub
# echo GRUB_CMDLINE_LINUX="systemd.unified_cgroup_hierarchy=1" >> /tmp/grub
# sudo mv /tmp/grub /etc/default/grub 
# sudo update-grub
# cat /etc/default/grub | grep GRUB_CMDLINE_LINUX=
sudo sed -i -e 's/^GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="systemd.unified_cgroup_hierarchy=1"/' /etc/default/grub
sudo update-grub

# Install fuse
sudo apt-get update && sudo apt-get install -y fuse

# Utilities
sudo apt-get update && \
    sudo apt-get -qq install -y --no-install-recommends \
        locales \
        ca-certificates \
        socat \
        wget \
        man \
        git \
        flex \
        ssh \
        sudo \
        vim \
        lcov \
        ccache \
        lua5.2 \
        jq && \

# Compilers, autotools
sudo apt-get update && \
    sudo apt-get -qq install -y --no-install-recommends \
        build-essential \
        pkg-config \
        autotools-dev \
        libtool \
        autoconf \
        automake \
        make \
        cmake \
        clang \
        clang-tidy \
        gcc g++ && \

# Python
# NOTE: sudo pip install is necessary to get differentiated installations of
# python binary components for multiple python3 variants, --ignore-installed
# makes it ignore local versions of the packages if your home directory is
# mapped into the container and contains the same libraries
sudo apt-get install -y \
    libffi-dev \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    python3-markupsafe \
    python3-coverage \
    python3-cffi \
    python3-ply \
    python3-six \
    python3-jsonschema \
    python3-sphinx \
    python3-yaml

# This is for rootless docker
sudo apt-get install -y \
     uidmap \
     dbus-user-session && \
     sudo rm -rf /var/lib/apt/lists/*

# install docker (this is in place of rootless)
# apt-get update && apt-get install ca-certificates curl gnupg
# install -m 0755 -d /etc/apt/keyrings
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
# chmod a+r /etc/apt/keyrings/docker.gpg

# echo \
#  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
#  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
#  tee /etc/apt/sources.list.d/docker.list > /dev/null

# apt-get update
# apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# docker run hello-world

# This is for rootless docker
curl -o install.sh -fsSL https://get.docker.com
# This needs to be run outside packer - seems to have sed command that fails
# AMI without running install is ami-0fd94d7228a016b65
# AMI with running installl is ami-0a71a4436084046bc
sudo sh install.sh
# This is run by the user
# dockerd-rootless-setuptool.sh install
