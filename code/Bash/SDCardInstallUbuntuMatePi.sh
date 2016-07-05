# Commands to put Ubuntu Mate on my Pi's SD card.
xz -d ubuntu-mate-16.04-desktop-armhf-raspberry-pi.img.xz
diskutil
diskutil list
diskutil unmountDisk /dev/disk2
sudo dd bs=1m if=./ubuntu-mate-16.04-desktop-armhf-raspberry-pi.img of=/dev/disk2 status=progress
#wait 9 years.
#eject. Yay.
