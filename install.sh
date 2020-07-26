#!/bin/bash
if [ "$(id -u)" != "0" ]; then
	   echo "This script must be run as root" 1>&2
	      exit 1
fi
echo "Installing latest build-essent tools"
apt install build-essential -y
cp -r usr /
INSTALLBASE=`pwd`
echo "Leaving " $INSTALLBASE
cd /usr/local/src/AMBEserver
echo "Compileing AMBEsserver in"
pwd
gcc -o AMBEserver AMBEserver.c
ls -l
echo "Installing to: "
install AMBEserver /usr/local/sbin && which AMBEserver
echo "Returning to " $INSTALLBASE
cd $INSTALLBASE

ODV=opendv
ID=`grep $ODV /etc/passwd`
if [ -z ${ID} ];then
	echo "$ODV does not exist"
	echo "Creating user $ODV with group dialout"
	useradd -G dialout -s /bin/false -m $ODV
	grep $ODV /etc/passwd /etc/group
else
        echo "Found user $ODV"
        D=`grep dialout /etc/group | grep $ODV`
        if [ -z ${D} ]; then
		echo "$ODV is not a member of dialout group"
		echo "Adding to dialout"
		usermod -G dialout $ODV
		grep $ODV /etc/passwd /etc/group

	else
		echo "$ODV is in dialout group"
	fi
fi
echo "Copying configuration, service, and support files"
ls -R etc
cp -r etc /
systemctl restart udev
ls -l /dev/ThumbDV
echo "Endabling ThumbDV™ ..."
systemctl start ambeserver@ThumbDV
systemctl enable ambeserver@ThumbDV
systemctl status ambeserver@ThumbDV
