### Update: to renew certs, just SSH in and run: `sudo certbot renew` ###

(Auto-renewing isn't working, but it's not clear why, and maybe not worth the effort to fix.)

Log in to Raspberry Pi with username `pi` and password `XXXXXX`.

To get a valid SSL certificate, we're going to use Let's Encrypt's Certbot client with its DNS challenge because it can be done automatically with at least some registrars, including ours, Gandi.net. We want to use the DNS challenge because the alternative, the HTTP challenge, requires that your Pi be reachable on the open internet, which would be difficult to do with the Tufts wireless network, and in general, we want our Pi protected by the Tufts firewall.

Install Certbot and Gandi DNS plugin.

    sudo apt-get install python3-dev
    wget https://bootstrap.pypa.io/get-pip.py
    sudo python3 ./get-pip.py
    sudo pip3 install idna
    sudo pip3 install certbot-plugin-gandi

Get LiveDNS API key from Gandi.net.

Create `/etc/letsencrypt/gandi.ini` config file with the following contents and `chmod 600 gandi.ini` on it:

    certbot_plugin_gandi:dns_api_key=THE_API_KEY_GOES_HERE_BUT_IT_IS_SECRET

If `/etc/letsencrypt/` does not exist, run the `certbot` command below. It will fail, but it will create the directory with a bunch of config files inside the first time it runs.

Run `sudo certbot certonly -a certbot-plugin-gandi:dns --certbot-plugin-gandi:dns-credentials /etc/letsencrypt/gandi.ini -d p1.nolop.org`

    Saving debug log to /var/log/letsencrypt/letsencrypt.log
    Plugins selected: Authenticator certbot-plugin-gandi:dns, Installer None
    <snip>
    Obtaining a new certificate
    Performing the following challenges:
    dns-01 challenge for p1.nolop.org
    Waiting 10 seconds for DNS changes to propagate
    Waiting for verification...
    Cleaning up challenges

    IMPORTANT NOTES:
     - Congratulations! Your certificate and chain have been saved at:
       /etc/letsencrypt/live/p1.nolop.org/fullchain.pem
       Your key file has been saved at:
       /etc/letsencrypt/live/p1.nolop.org/privkey.pem
       Your cert will expire on 2019-09-05. To obtain a new or tweaked
       version of this certificate in the future, simply run certbot
       again. To non-interactively renew *all* of your certificates, run
       "certbot renew"
     - Your account credentials have been saved in your Certbot
       configuration directory at /etc/letsencrypt. You should make a
       secure backup of this folder now. This configuration directory will
       also contain certificates and private keys obtained by Certbot so
       making regular backups of this folder is ideal.

Install certificates into `/etc/ssl/snakeoil.pem` in the format that Haproxy requires (one file, `fullchain.pem` followed directly by `privkey.pem`). The odd name `snakeoil.pem` is used just because that's the filename that Haproxy is configured to look for in the default Octopi image.

    sudo cat /etc/letsencrypt/live/p1.nolop.org/fullchain.pem /etc/letsencrypt/live/p1.nolop.org/privkey.pem > /etc/ssl/snakeoil.pem
    sudo systemctl restart haproxy

(The copying of the keys above will probably fail with `permission denied` because the `>` redirect isn't executed as the superuser. This might also be why automatic renewal is broken, but maybe not.)

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

### Changing hostnames ###

    certbot revoke --cert-name p1.nolop.org
    certbot certonly -d p26.nolop.org # path to DNS info is /etc/letsencrypt/gandi.ini
    
Make sure that the hostname in `/etc/letsencrypt/renewal-hooks/post/install-cert-for-haproxy.sh` is updated with the correct hostname.

### Other useful SSL debugging techniques ###

Verify a certificate's contents

    openssl x509 -in fullchain.pem -text -noout

Check locally what certificate the server is sending out, avoiding any browser caches or whatever

    curl -kv --resolve p1.nolop.org:443:127.0.0.1 https://p1.nolop.org

