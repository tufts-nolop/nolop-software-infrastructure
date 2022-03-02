## Hardware ##

As of February 2022, all the printers are connected to Raspberry Pi 3B+ servers running OctoPi.

The Pi is mounted to the Prusa with a custom aluminum bracket that Brandon machined. The Pi attaches with a total of 8 M2.5 bolts, 4 of length 5 mm through the Pi into 4 hex standoffs and 4 of length 10 mm through the bracket into the same standoffs.

The bracket mounts to the Prusa with two M3 bolts.

**Relevant parts**

* McMaster 91292A009, M2.5 x 0.45 mm stainless SHCS, length 5 mm
* McMaster 91292A014, M2.5 x 0.45 mm stainless SHCS, length 10 mm
* McMaster 95947A005, M2.5 x 0.45 mm aluminum threaded standoff, length 10 mm
* McMaster 91292A113, M3 x 0.5 mm stainless SHCS, length 10 mm

## Software ##

Download Octopi 0.18.0 from https://octoprint.org/download/ (This is Octoprint 1.6.1, plus a bundle of plugins, all set up for the Pi.)

Installs for P9-P12 will use OctoPi (stable) 0.18.0 with Octoprint 1.7.3, installed directly through the Raspberry Pi imager.

Use the imager to install OctoPi, enable SSH, and set the password for user `pi`.

Copy `octopi-wpa-supplicant.txt` to `/boot/octopi-wpa-supplicant.txt`

Connect via a console cable to the UART at speed 115200.

### Fix WPA2 Enterprise support ###

Edit `/lib/dhcpcd/dhcpcd-hooks/10-wpa_supplicant` so that the line that contains `nl80211,wext` instead contains `wext,nl80211`. (This is fixed in newer releases of Raspberry Pi OS, but the version that OctoPi is based on is still using Debian 10.6 "Buster", from September 2020. The older printers are running on Debian 9.4 "Stretch", from 2018, before this bug was introduced.)

### Octoprint configuration

Tell Brandon the IP address of the printer and get him to set up pX.nolop.org to point to that IP.

Open pX.nolop.org in a browser and go through the Octoprint setup wizard.

username: `admin`
password: THAT SECRET PASSWORD WE DON'T PUBLISH ON THE INTERNET

Enable connectivity check, I guess?

Enable anonymous usage tracking.

Enable plugin blacklist processing.

Accept the default printer profile because we'll change that later.

`mv ~/.octoprint/printerProfiles/_default.profile ~/.octoprint/printerProfiles/nolop_prusa_mk3_1.profile`

Copy over the contents of the profile from https://github.com/tufts-nolop/nolop-software-infrastructure/blob/master/printerProfiles/nolop_prusa_mk3_1.profile

Set up users like this:

```
source ~/oprint/bin/activate
octoprint user add nolop
service octoprint restart
```

Edit `~/.octoprint/users.yaml` so that the user `nolop` has the correct API key so our Nolop printer dashboard will work.

Install third-party plugins

1. Firmware updater 1.11.0
2. Octoprint Slicer 2.0.0
3. CuraEngine legacy 1.1.2
4. BetterHeaterTimeout 1.3.0

* `/home/pi/oprint/bin/pip install https://github.com/OctoPrint/OctoPrint-FirmwareUpdater/archive/refs/tags/1.11.0.zip`
* `/home/pi/oprint/bin/pip install https://github.com/kennethjiang/OctoPrint-Slicer/archive/refs/tags/2.0.0.zip`
* `/home/pi/oprint/bin/pip install https://github.com/OctoPrint/OctoPrint-CuraEngineLegacy/archive/refs/tags/1.1.2.zip`
* `/home/pi/oprint/bin/pip install https://github.com/tjjfvi/OctoPrint-BetterHeaterTimeout/releases/tag/v1.3.0`

(The BetterHeaterTimeout plugin failed to install from the command line, so installed through web interface instead.)

Install `avrdude`, needed by firmware updater plugin

`sudo apt install avrdude`

Settings for firmware update:

* Atmel 8-bit processor
* ATMEGA 2450
* /usr/bin/avrdude
* wiring

Set up SSL cert.

### Cura Slicer setup

Run the CuraEngine Legacy plugin setup. Enter `/usr/local/bin/cura_engine` as the path to the executable.

Build Cura Legacy

```
git clone -b legacy https://github.com/Ultimaker/CuraEngine.git
cd CuraEngine
make
cd build
sudo cp ./CuraEngine /usr/local/bin/cura_engine
```

Copy two slicer profiles into `~/.octoprint/slicingProfiles/curalegacy` 

```
wget https://raw.githubusercontent.com/tufts-nolop/nolop-software-infrastructure/master/slicingProfiles/curalegacy/nolop_prusa_pla.profile
wget https://raw.githubusercontent.com/tufts-nolop/nolop-software-infrastructure/master/slicingProfiles/curalegacy/nolop_prusa_tpu.profile
```

## Maintenance ##

Renew SSL certificate using `sudo certbot renew`
