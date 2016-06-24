#!/bin/bash
#You must make this script executable by using chmod +x on it.

if [ $(id -u) -ne 0 ]; then
  echo "This script must run under root user."
  exit 1
fi

USER="<fill in UWYO user name here>"
URL="wyosecure.uwyo.edu/2f" #this is if you need 2 factor auth.

openconnect --juniper $URL -u $USER
echo "To terminate session use CTRL+C, or close session terminal."
