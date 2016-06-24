#!/bin/bash
#Luke Wood
#Computer Support Specialist
#University of Wyoming
#Script to get cuda compliling to run on RH00242-LNX labnodes.

#Check to see if script is ran as root
if [ "$(id -u)" !="0"]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi
#Install missing packages from the nvidia installer howto.
apt-get -y install freeglut3-dev build-essential libx11-dev libxmu-dev libxi-dev libgl1-mesa-glx libglu1-mesa libglu1-mesa-dev libgl-dev
#Copies new environment path to /etc/ this will require all users to log to make this effective.
cp environment /etc/
#This step relinks the libGL.so in /usr/lib to libGL.so.270.41.19 from the nvidia-dev driver.
rm /usr/lib/libGL.so
ln -s /usr/lib/libGL.so.270.41.19 /usr/lib/libGL.so
echo "System should now be ready to compile CUDA code"
exit 0
