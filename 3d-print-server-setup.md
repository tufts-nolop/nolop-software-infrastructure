## Hardware ##

Raspberry Pi 3B+

## Software ##

Download Octopi 0.18.0 from https://octoprint.org/download/

Install plugins

1. Firmware updater
2. Octoprint Slicer
3. Cura legacy?

Install `avrdude` for firmware updates to Prusa MK3S printers

`sudo apt install avrdude`

Settings for firmware update:

* Atmel 8-bit processor
* ATMEGA 2450
* /usr/bin/avrdude
* wiring

Copy over `user.yaml` to `/home/pi/.octoprint/user.yaml`

Copy `wpa_supplicant.conf` to `/etc/wpa_supplicant/wpa_supplicant.conf`

Set up SSL cert.

Find the IP address; something like 10.12.14.223. Tell Brandon to set `pX.nolop.org` to point to the IP.

## Maintenance ##

Renew SSL certificate using `sudo certbot renew`
