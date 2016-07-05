#Set Up Pi Glow on Xbian before there was an easy installer
#Credit on python scripts: https://github.com/pimoroni/piglow/
#run each line manually.
#1) Install Xbian
#2) boot, change resolution
#3) power, spam esc key....
#4) username:xbian password:raspberry
#5) http://falldeaf.com/2013/11/the-xbmc-piglow-information-display-addon/
#6) sudo date --set 1998-11-02; sudo date --set 21:08:00



sudo apt-get install python-dev python-pip python-setuptools python-dev build-essential python-smbus python-psutil -y

#set date to today's date, or set up ntp
sudo date --set 2015-5-27
sudo date --set 11:25:00

sudo easy_install -U distribute
sudo pip install RPi.GPIO

#append these lines to the bottom of the file
#i2c-dev
#i2c-bcm2708
sudo echo "i2c-dev" >> /etc/modules
sudo echo "i2c-bcm2708" >> /etc/modules


#comment out the lines above, if they are there.
#nvm, just make the file blank. got nothing else to lose.
sudo echo "" > /etc/modprobe.d/raspi-blacklist.conf


sudo reboot -h

mkdir piglow
cd piglow
wget https://raw.github.com/Boeeerb/PiGlow/master/piglow.py
wget https://raw.github.com/Boeeerb/PiGlow/master/Examples/test.py
sudo python test.py

wget https://raw.github.com/Boeeerb/PiGlow/master/Examples
wget https://raw.github.com/Boeeerb/PiGlow/master/Examples/all.py
wget https://raw.github.com/Boeeerb/PiGlow/master/Examples/arm.py
wget https://raw.github.com/Boeeerb/PiGlow/master/Examples/clock.py
wget https://raw.github.com/Boeeerb/PiGlow/master/Examples/cpu.py
wget https://raw.github.com/Boeeerb/PiGlow/master/Examples/cycle.py
wget https://raw.github.com/Boeeerb/PiGlow/master/Examples/cycle2.py
wget https://raw.github.com/Boeeerb/PiGlow/master/Examples/halloween.py
wget https://raw.github.com/Boeeerb/PiGlow/master/Examples/indiv.py
wget https://raw.github.com/Boeeerb/PiGlow/master/Examples/indiv2.py

#start up the piglow to show CPU usage..... it's so cool!!!
sudo crontab -e
@reboot /usr/bin/python /home/xbian/piglow/cpu.py
