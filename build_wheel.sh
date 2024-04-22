#!/bin/bash
set -ex  # will exit on any error and print all commands

# Function to install packages on Enterprise Linux (CentOS, RHEL)
install_enterprise_linux() {
    yum install -y epel-release
    yum update -y  # Update the system
    yum groupinstall -y "Development Tools"
    yum install -y cmake git libusbx-devel hdf5-devel gcc-c++ python3-devel python3-numpy swig
}

# Function to install packages on Debian-based systems (Debian, Ubuntu)
install_debian() {
    apt update -y  # Update the system
    apt install -y build-essential cmake git libusb-1.0-0-dev libhdf5-dev g++ libpython3-dev python3-numpy swig
}

# Function to install packages on Alpine Linux
install_alpine() {
    apk update  # Update the system
    apk add --no-cache build-base git libusb-dev hdf5-dev g++ python3-dev py3-numpy swig
}

# Determine the Linux distribution and install packages accordingly
if [ -f "/etc/redhat-release" ]; then
    # Enterprise Linux (CentOS, RHEL)
    install_enterprise_linux
elif [ -f "/etc/debian_version" ]; then
    # Debian-based distribution (Debian, Ubuntu)
    install_debian
elif grep -qi alpine /etc/os-release; then
    # Alpine Linux
    install_alpine
else
    echo "Unsupported distribution"
    exit 1
fi

# Clone and build SoapySDR
rm -rf SoapySDR
git clone https://github.com/pothosware/SoapySDR.git
cd SoapySDR || exit
mkdir build
cd build || exit
cmake ..
make -j$(nproc)
make install -j$(nproc)
#On debian we need to run ldconfig
if [ -f "/etc/debian_version" ]; then
    ldconfig
fi

cd ../..

# Clone and build LimeSuite
rm -rf LimeSuite
git clone https://github.com/myriadrf/LimeSuite.git
cd LimeSuite/build || exit
cmake ../ -DENABLE_GUI=OFF
make -j$(nproc)
make install

# In debian we need ldconfig
if [ -f "/etc/debian_version" ]; then
    ldconfig
fi