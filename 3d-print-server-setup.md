## Hardware ##

Raspberry Pi 3B+

## Software ##

Download Octopi 0.18.0 from https://octoprint.org/download/ (This is Octoprint 1.6.1, plus a bundle of plugins, all set up for the Pi.)

Install third-party plugins

1. Firmware updater 1.11.0
2. Octoprint Slicer 2.0.0
3. CuraEngine legacy 1.1.2
4. BetterHeaterTimeout 1.3.0

`/home/pi/oprint/bin/pip install https://github.com/OctoPrint/OctoPrint-FirmwareUpdater/archive/refs/tags/1.11.0.zip`
`/home/pi/oprint/bin/pip install https://github.com/kennethjiang/OctoPrint-Slicer/archive/refs/tags/2.0.0.zip`
`/home/pi/oprint/bin/pip install https://github.com/OctoPrint/OctoPrint-CuraEngineLegacy/archive/refs/tags/1.1.2.zip`
`/home/pi/oprint/bin/pip install https://github.com/tjjfvi/OctoPrint-BetterHeaterTimeout/releases/tag/v1.3.0`

Install `avrdude`, needed by firmware updater plugin

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

Install a slicer profile for Cura. Maybe some default settings for Octoprint too?

## Maintenance ##

Renew SSL certificate using `sudo certbot renew`
