#!/bin/sh
# install all files in the folder using rpm2cpio

# get the list of all files in the folder
parent_dir=~/rpm
cd ~/centos
for file in $parent_dir/*.rpm
do
    echo "Installing $file"
    rpm2cpio $file | cpio -idmv
done