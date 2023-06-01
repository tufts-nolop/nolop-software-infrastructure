## Hardware ##

From at least February 2022 through May 2023, all the printers are connected to Raspberry Pi 3B+ servers running OctoPi.

The Pi is mounted to the Prusa with a custom aluminum bracket that Brandon machined. The Pi attaches with a total of 8 M2.5 bolts, 4 of length 5 mm through the Pi into 4 hex standoffs and 4 of length 10 mm through the bracket into the same standoffs.

The bracket mounts to the Prusa with two M3 bolts.

**Relevant parts**

* McMaster 91292A009, M2.5 x 0.45 mm stainless SHCS, length 5 mm
* McMaster 91292A014, M2.5 x 0.45 mm stainless SHCS, length 10 mm
* McMaster 95947A005, M2.5 x 0.45 mm aluminum threaded standoff, length 10 mm
* McMaster 91292A113, M3 x 0.5 mm stainless SHCS, length 10 mm

## Software ##

Install the Raspberry Pi Imager.

In the imager, pick OctoPi for installation: `Choose OS > Other specific-purpose OS > 3D printing > OctoPi (stable)`

In the imager, click the gear icon to set the hostname to pX, enable SSH, and set the password for user `pi`.

Copy `octopi-wpa-supplicant.txt` to `/boot/octopi-wpa-supplicant.txt` on the boot partition.

Edit `/boot/octopi-wpa-supplicant.txt` so that it has the correct wifi password (which we can't store on the internet) from the Nolop whiteboard.

Add the line `enable_uart=1` at the bottom of `/config.txt` on the boot partition.

### Octoprint configuration

To be able to run Ansible, copy your host key to all the printers.

`ssh-copy-id pi@p1.nolop.org`

Set up users like this:

```
source ~/oprint/bin/activate
octoprint user add nolop
service octoprint restart
```

Edit `~/.octoprint/users.yaml` so that the user `nolop` has the correct API key so our Nolop printer dashboard will work. Also change the admin account so that it is actually an admin.

Tell Brandon the IP address of the printer and get him to set up pX.nolop.org to point to that IP.

Accept the default printer profile because we'll change that later.

Copy over the contents of the profile from https://github.com/tufts-nolop/nolop-software-infrastructure/blob/master/printerProfiles/nolop_prusa_mk3_1.profile as below.

```
rm ~/.octoprint/printerProfiles/_default.profile
cd ~/.octoprint/printerProfiles
wget https://raw.githubusercontent.com/tufts-nolop/nolop-software-infrastructure/master/printerProfiles/nolop_prusa_mk3_1.profile
```

```
Installing plugin "CuraEngine Legacy" from https://github.com/OctoPrint/OctoPrint-CuraLegacy/archive/master.zip...
/home/pi/oprint/bin/python -m pip --disable-pip-version-check install file:///tmp/tmpie4pn9b5/OctoPrint-CuraEngineLegacy-master.zip --no-cache-dir
```

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

## Set up SSL ##

To get a valid SSL certificate, we're going to use Let's Encrypt's Certbot client with its DNS challenge because it can be done automatically with at least some registrars, including ours, Gandi.net. We want to use the DNS challenge because the alternative, the HTTP challenge, requires that your Pi be reachable on the open internet, which would be difficult to do with the Tufts wireless network, and in general, we want our Pi protected by the Tufts firewall.

Install Certbot and Gandi DNS plugin: `/home/pi/oprint/bin/pip3 install certbot-plugin-gandi`

Run the `certbot` command below. It will fail, but it will create the `/etc/letsencrypt` directory with a bunch of config files inside the first time it runs.

`sudo /home/pi/oprint/bin/certbot certonly --authenticator dns-gandi --dns-gandi-credentials /etc/letsencrypt/gandi.ini -d p1.nolop.org`

Get Gandi LiveDNS API key from another printer or Gandi.net.

Run the certbot command again; this time it should work.

### Changing hostnames ###

    certbot revoke --cert-name p1.nolop.org
    certbot certonly -d p26.nolop.org # path to DNS info is /etc/letsencrypt/gandi.ini
    
Make sure that the hostname in `/etc/letsencrypt/renewal-hooks/post/install-cert-for-haproxy.sh` is updated with the correct hostname.

### Other useful SSL debugging techniques ###

Verify a certificate's contents

    openssl x509 -in fullchain.pem -text -noout

Check locally what certificate the server is sending out, avoiding any browser caches or whatever

    curl -kv --resolve p1.nolop.org:443:127.0.0.1 https://p1.nolop.org
