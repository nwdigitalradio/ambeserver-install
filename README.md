# ambeserver-install

Files, scripts and documentation for installing AMBEserver with the official NW Digital Radio [ThumbDV™](https://nwdigitalradio.com/product/thumbdv ).

## Assumptions and Defaults

This install assumes you have a recent generation ThumbDV™ which runs at 460800 bauds.  If you have a very early generation ThumbDV™ you will need to edit [ambeserver-ThumbDV.conf](etc/opendv/ambeserver-ThumbDV.conf) in the downloaded code before running install.sh or in /etc/opendv after running install.sh and change the speed to 230400 by commenting out the line **AMBESERVER_FLAGS="-s 460800"**

If you have a PiDV™ or an AMBE-3000 device from another company, you will need to use the alternate files from /etc/opendv in conjunction with **systemctl** to start, stop, enable, disable, and check status on AMBEserver.  This install starts AMBEserver for ThumbDV™, and enables it for automatic restart on boot, so you will need to disable it using **systemctl** if you don't want that behavior.

If these assumptions and defaults meet your system, then you can proceed with the simple install.

## Simple Install

From the command line in a terminal:

```
sudo apt-get install git
cd
git clone https://github.com/nwdigitalradio/ambeserver-install.git
cd ambeserver-install
sudo chmod +x install.sh
sudo ./install.sh
```

## If your AMBEserver fails to start

After these steps, if your AMBEserver doesn't start, try removing and replacing the ThumbDV™ from it's USB port, then check for /dev/ThumbDV with **ls -l /dev/ThumbDV** and then restart the AMBEserver for ThumbDV™.

```
sudo systemctl restart ambeserver@ThumbDV 
```

## Theory of Operation

AMBEserver is a pretty simple application, it is composed of a single executable that is compiled from the source [AMBEserver.c](usr/local/src/AMBEserver/AMBEserver.c) the install.sh copies this source to /usr/local/src/AMBEserver where it is compiled and placed in /usr/local/sbin as AMBEserver.

The AMBEserver simply makes access to the ThumbDV™ (or equivalent) available on a network port for client applications to access.  It supports one application stream at a time, taking as input PCM encoded audio and returning AMBE encoded data, and conversely takes in AMBE encoded data and returns PCM encoded audio.  So long as it performs that function, AMBEserver is operating properly, <u>all other functions are handled by the application</u>. If you are experiencing interface, audio, or network issues, troubleshoot the application.

The AMBEserver can be initiated from the command line, but it is preferred to use the **systemd** daemon manager.  Using the **systemctl** command.  To see all of the subcommands of systemctl, please view the manual page, by running

```
man systemctl
```

Using the included [service](etc/systemd/system/ambeserver@.service ) file, the operating parameters are taken from configuration files located in [/etc/opendv](etc/opendv). You may edit these files to use a different network port and device file.  If you need to create a new configuration, simply copy a configuration file and name it with ambeserver-*devicename*.conf where *devicename* is the device file in /dev such as

```
sudo cp /etc/opendv/ambeserver-ttyUSB0.conf /etc/opendv/ambeserver-ttyUSB1.conf
```

A special device is created by udev for the ThumbDV™ by the file [99-thumbdv.rules](etc/udev/rules.d/99-thumbdv.rules) as part of this install.  When a ThumbDV™ is plugged into a USB port, this rule causes udevd to detect it and create a link between /dev/ThumbDV and the enumerated USB port, e.g. /dev/ttyUSB0.  If the ThumbDV™ lands on a different USB port such as /dev/ttyUSB2, the link moves to that port.

## Support for the ThumbDV™ and PiDV™

For sales, returns, engineering, and hardware warranty please use the [support form](https://nwdigitalradio.com/support/).

For support of AMBEserver, please post your questions on [NW Digital Radio's AMBE Support Forum](https://nw-digital-radio.groups.io/g/ambe) where you will also find test programs in it's associated file section.

## Concerning the PiDV™

The PiDV™ is no longer in production.  However, you can use this install to operate AMBEserver with the PiDV™.

```
sudo systemctl disable ambeserver@ThumbDV
sudo systemctl stop ambeserver@ThumbDV
sudo systemctl enable ambeserver@ttyAMA0
sudo systemctl start ambeserver@ttyAMA0
sudo systemctl status ambeserver@ttyAMA0
```

Further information on the [wiki](https://nw-digital-radio.groups.io/g/ambe/wiki/1418).

## Test Scripts

To test the ThumbDV™ or PiDV™ use the included Python script [AMBEtest3.py](AMBEtest3.py). You will need to install Python using apt-get first. Turn off ambeserver using **systemctl stop ambeserver@*device*** and then run the script.

To test the AMBEserver, use the program [ambesocktest.py](ambesocktest.py). AMBEserver should be running for this test.  If your AMBEserver is not on port 2460 on localhost (127.0.0.1), you will need to edit the script.

