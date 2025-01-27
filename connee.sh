#!/bin/bash

sudo tee /etc/apt/sources.list > /dev/null <<EOF
deb http://deb.debian.org/debian bookworm main non-free-firmware
deb-src http://deb.debian.org/debian bookworm main non-free-firmware

deb http://deb.debian.org/debian-security/ bookworm-security main non-free-firmware
deb-src http://deb.debian.org/debian-security/ bookworm-security main non-free-firmware

deb http://deb.debian.org/debian bookworm-updates main non-free-firmware
deb-src http://deb.debian.org/debian bookworm-updates main non-free-firmware
EOF

mkdir /var/log/journal

export TZ="Europe/Rome"
echo "Europe/Rome" | sudo tee /etc/timezone
sudo ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime
sudo dpkg-reconfigure -f noninteractive tzdata

echo "homeassistant" | sudo tee /etc/hostname
sudo sed -i '/^#host-name=/c\host-name=homeassistant' /etc/avahi/avahi-daemon.conf

sudo systemctl restart avahi-daemon

sudo journalctl --vacuum-size=100M
sudo journalctl --vacuum-time=1w

##sysctl optimization
ekill echo "net.ipv6.conf.all.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf
echo "net.ipv6.conf.lo.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

#disable non-used-service
sudo systemctl disable cups
sudo systemctl disable udisks2 #da testare
sudo systemctl disable exim4

sudo dpkg --configure -a && apt-get install --fix-missing
sudo apt-get update && sudo apt-get -o Dpkg::Options::="--force-confold" --yes --quiet upgrade -y  && sudo apt-get remove mosquitto -y && sudo apt-get install nano preload -y && sudo apt-get autoremove -y && sudo apt-get autoclean -y

#wget del file del backup
#wget --no-check-certificate 'https://drive.google.com/uc?export=download&id=1V3SlHab-miyu16l5iWq4iz2bNBrb7pf7' -O file.sh
#docker cp FILE_BACKUP $(docker ps -q -f "name=homeassistant"):/data/backup
#ha backup reload
#ha backup restore 8e4e5163


#CAPIRE COME SCARICARE IL FILE DI GOOGLE
https://drive.google.com/file/d/1V3SlHab-miyu16l5iWq4iz2bNBrb7pf7/view?usp=drive_link

wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=11IYg0XgUBnOV1xwigEg8or4LNNOl8Rbk' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=11IYg0XgUBnOV1xwigEg8or4LNNOl8Rbk" -O FILENAME && rm -rf /tmp/cookies.txt
