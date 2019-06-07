Log in to Raspberry Pi with username `pi` and password `XXXXXX`.

Install Certbot and Gandi DNS plugin

    wget https://bootstrap.pypa.io/get-pip.py
    sudo python3 ./get-pip.py
    sudo pip3 install certbot
    sudo pip3 install certbot-plugin-gandi

Get LiveDNS API key from Gandi.net.

Create `/home/pi/gandi.ini` config file with the following contents and `chmod 600 gandi.ini` on it:

        certbot_plugin_gandi:dns_api_key=APIKEY

Run `certbot`

    sudo certbot certonly -a certbot-plugin-gandi:dns --certbot-plugin-gandi:dns-credentials gandi.ini -d p1.nolop.org
    Saving debug log to /var/log/letsencrypt/letsencrypt.log
    Plugins selected: Authenticator certbot-plugin-gandi:dns, Installer None
    Enter email address (used for urgent renewal and security notices) (Enter 'c' to
    cancel): XXXXXXX@pingswept.org

    - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Please read the Terms of Service at
    https://letsencrypt.org/documents/LE-SA-v1.2-November-15-2017.pdf. You must
    agree in order to register with the ACME server at
    https://acme-v02.api.letsencrypt.org/directory
    - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    (A)gree/(C)ancel: A

    - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Would you be willing to share your email address with the Electronic Frontier
    Foundation, a founding partner of the Let's Encrypt project and the non-profit
    organization that develops Certbot? We'd like to send you email about our work
    encrypting the web, EFF news, campaigns, and ways to support digital freedom.
    - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    (Y)es/(N)o: n
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
     - If you like Certbot, please consider supporting our work by:

       Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
       Donating to EFF:                    https://eff.org/donate-le

Relevant to your interests:

    https://github.com/obynio/certbot-plugin-gandi
