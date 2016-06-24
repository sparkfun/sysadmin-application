#!/bin/bash
#package script for RH00242 Lab
read -p "Please enter lab Name: " LABNAME
read -p "Please enter semester (eg: fa2011): " SEMESTER
read -p "Please enter distro used (eg: Ubuntu): " DISTRO
read -p "Please enter Version : " VERSION
PACKAGE="$LABNAME-$DISTRO-$VERSION-$SEMESTER-image.tar.gz"
tar --preserve -cvzf $PACKAGE --exclude=/proc --exclude=/sys --exclude=/dev --exclude=/mnt --exclude=lost+found --exclude=/home --exclude=/tmp --exclude=$PACKAGE --exclude=package_image.sh /
