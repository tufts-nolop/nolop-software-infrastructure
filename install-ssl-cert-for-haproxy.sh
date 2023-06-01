#!/bin/sh
sudo cat /etc/letsencrypt/live/p1.nolop.org/fullchain.pem /etc/letsencrypt/live/p1.nolop.org/privkey.pem > /etc/ssl/snakeoil.pem
sudo systemctl restart haproxy