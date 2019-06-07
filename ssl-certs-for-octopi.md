Log in to Raspberry Pi with username `pi` and password `XXXXXX`.

Install Certbot and Gandi DNS plugin

    sudo apt-get update
    sudo apt-get install python3-pip
    sudo apt-get install certbot
    pip3 install certbot-plugin-gandi

Get LiveDNS API key from Gandi.net.

Create a gandi.ini config file with the following contents and `chmod 600 gandi.ini` on it:

    certbot_plugin_gandi:dns_api_key=APIKEY
