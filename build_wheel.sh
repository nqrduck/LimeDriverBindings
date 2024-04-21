#!/bin/bash
set -ex  # will exit on any error and print all commands

yum install -y epel-release
yum update -y  # Update the system
yum groupinstall -y "Development Tools"
yum install -y cmake3 git libusb-devel hdf5-devel

# Clone and build LimeSuite
rm -rf LimeSuite
git clone https://github.com/myriadrf/LimeSuite.git
cd LimeSuite/build || exit
cmake3 ../ -DENABLE_GUI=OFF
make -j$(nproc)
make install
ldconfig