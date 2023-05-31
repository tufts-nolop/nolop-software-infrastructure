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

Download Octopi from https://octoprint.org/download/

Installs for P9-P12 will use OctoPi (stable) 0.18.0 with Octoprint 1.7.3, installed directly through the Raspberry Pi imager.

In the imager, pick OctoPi for installation: `Choose OS > Other specific-purpose OS > 3D printing > OctoPi (stable)`

In the imager, click the gear icon to set the hostname to pX, enable SSH, and set the password for user `pi`.

Copy `octopi-wpa-supplicant.txt` to `/boot/octopi-wpa-supplicant.txt`

Edit `/boot/octopi-wpa-supplicant.txt` so that it has the correct wifi password (which we can't store on the internet) from the Nolop whiteboard.

Add the line `enable_uart=1` at the bottom of `/boot/config.txt`

Connect via a console cable to the UART at speed 115200.

### Octoprint configuration

Tell Brandon the IP address of the printer and get him to set up pX.nolop.org to point to that IP.

Open pX.nolop.org in a browser and go through the Octoprint setup wizard.

username: `admin`
password: THAT SECRET PASSWORD WE DON'T PUBLISH ON THE INTERNET

Enable connectivity check, I guess?

Enable anonymous usage tracking.

Enable plugin blacklist processing.

Accept the default printer profile because we'll change that later.


Copy over the contents of the profile from https://github.com/tufts-nolop/nolop-software-infrastructure/blob/master/printerProfiles/nolop_prusa_mk3_1.profile as below.

```
rm ~/.octoprint/printerProfiles/_default.profile
cd ~/.octoprint/printerProfiles
wget https://raw.githubusercontent.com/tufts-nolop/nolop-software-infrastructure/master/printerProfiles/nolop_prusa_mk3_1.profile
```

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
5. OctoPrint ipOnConnect 0.2.4

* `/home/pi/oprint/bin/pip install https://github.com/OctoPrint/OctoPrint-FirmwareUpdater/archive/refs/tags/1.11.0.zip`
* `/home/pi/oprint/bin/pip install https://github.com/kennethjiang/OctoPrint-Slicer/archive/refs/tags/2.0.0.zip`
* `/home/pi/oprint/bin/pip install https://github.com/OctoPrint/OctoPrint-CuraEngineLegacy/archive/refs/tags/1.1.2.zip`
* `/home/pi/oprint/bin/pip install https://github.com/tjjfvi/OctoPrint-BetterHeaterTimeout/archive/refs/tags/v1.3.0.zip`
* `/home/pi/oprint/bin/pip install https://github.com/jneilliii/OctoPrint-ipOnConnect/archive/refs/tags/0.2.4.zip`

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
## Set up SSL ##

To get a valid SSL certificate, we're going to use Let's Encrypt's Certbot client with its DNS challenge because it can be done automatically with at least some registrars, including ours, Gandi.net. We want to use the DNS challenge because the alternative, the HTTP challenge, requires that your Pi be reachable on the open internet, which would be difficult to do with the Tufts wireless network, and in general, we want our Pi protected by the Tufts firewall.

Install Certbot and Gandi DNS plugin: `/home/pi/oprint/bin/pip3 install certbot-plugin-gandi`

Run the `certbot` command below. It will fail, but it will create the `/etc/letsencrypt` directory with a bunch of config files inside the first time it runs.

`sudo /home/pi/oprint/bin/certbot certonly -a certbot-plugin-gandi:dns --certbot-plugin-gandi:dns-credentials /etc/letsencrypt/gandi.ini -d p9.nolop.org`

NOTE:

```
Plugin legacy name certbot-plugin-gandi:dns may be removed in a future version. Please use dns instead.
Certbot is moving to remove 3rd party plugins prefixes. Please use --authenticator dns-gandi --dns-gandi-credentials
```

Get Gandi LiveDNS API key from another printer or Gandi.net.

Create `/etc/letsencrypt/gandi.ini` config file with the following contents and `chmod 600 gandi.ini` on it:

    certbot_plugin_gandi:dns_api_key=THE_API_KEY_GOES_HERE_BUT_IT_IS_SECRET

Run the certbot command again; this time it should work.

Install certificates into `/etc/ssl/snakeoil.pem` in the format that Haproxy requires (one file, `fullchain.pem` followed directly by `privkey.pem`). The odd name `snakeoil.pem` is used just because that's the filename that Haproxy is configured to look for in the default Octopi image.

    sudo -s
    cat /etc/letsencrypt/live/p1.nolop.org/fullchain.pem /etc/letsencrypt/live/p1.nolop.org/privkey.pem > /etc/ssl/snakeoil.pem
    systemctl restart haproxy

Just for reference, `snakeoil.pem` should look like this:

    root@octopi:/etc/ssl# ls -l snakeoil.pem
    -rw-r--r-- 1 root root 5254 Jun 10 14:33 snakeoil.pem

For certificate renewal, we want a file called something like `install-cert-for-haproxy.sh` in `/etc/letsencrypt/renewal-hooks/post/` that contains:

    #!/bin/sh
    sudo cat /etc/letsencrypt/live/p1.nolop.org/fullchain.pem /etc/letsencrypt/live/p1.nolop.org/privkey.pem > /etc/ssl/snakeoil.pem
    sudo systemctl restart haproxy

Also, `sudo chmod 750 /etc/letsencrypt/renewal-hooks/post/install-cert-for-haproxy.sh` so that the script has permissions like this:

    -rwxr-x--- 1 root root 170 Jun 10 15:56 install-cert-for-haproxy.sh

You can test renewal with `sudo certbot renew --dry-run`

Relevant to your interests:

    https://github.com/obynio/certbot-plugin-gandi
    https://serversforhackers.com/c/letsencrypt-with-haproxy

### Auto-renewal ###

In `/lib/systemd/system`, make `certbot.timer` and `certbot.service`.

    -rw-r--r-- 1 root root  233 Apr 28 23:02 certbot.service
    -rw-r--r-- 1 root root  155 Apr 28 23:02 certbot.timer

`certbot.timer`:

    [Unit]
    Description=Run certbot twice daily
    
    [Timer]
    OnCalendar=*-*-* 00,12:00:00
    RandomizedDelaySec=3600
    Persistent=true
    
    [Install]
    WantedBy=timers.target

`certbot.service`:

    [Unit]
    Description=Certbot
    Documentation=file:///usr/share/doc/python-certbot-doc/html/index.html
    Documentation=https://letsencrypt.readthedocs.io/en/latest/
    [Service]
    Type=oneshot
    ExecStart=/usr/local/bin/certbot -q renew
    PrivateTmp=true

Check that the path to `certbot` is right, because some of the printers have `certbot` installed in weird places.

Then start and enable the timer.

    systemctl start certbot.timer
    systemctl enable certbot.timer

Verify that the timer is running using `systemctl list-timers --all`

From https://community.letsencrypt.org/t/cerbot-cron-job/23895/5

### Changing hostnames ###

    certbot revoke --cert-name p1.nolop.org
    certbot certonly -d p26.nolop.org # path to DNS info is /etc/letsencrypt/gandi.ini
    
Make sure that the hostname in `/etc/letsencrypt/renewal-hooks/post/install-cert-for-haproxy.sh` is updated with the correct hostname.

### Other useful SSL debugging techniques ###

Verify a certificate's contents

    openssl x509 -in fullchain.pem -text -noout

Check locally what certificate the server is sending out, avoiding any browser caches or whatever

    curl -kv --resolve p1.nolop.org:443:127.0.0.1 https://p1.nolop.org

## Maintenance ##

Renew SSL certificate using `sudo certbot renew`
On Octoprint 0.18.0 and newer, `certbot` is installed as part of Octoprint, so use `sudo /home/pi/oprint/bin/certbot renew`

(Auto-renewing isn't working, but it's not clear why, and maybe not worth the effort to fix.)

(The newer certbot also complains about the Gandi DNS plugin being depreceated. Hmmm.)

