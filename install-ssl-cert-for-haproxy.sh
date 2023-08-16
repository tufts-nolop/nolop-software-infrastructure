#!/bin/sh
sudo cat /etc/letsencrypt/live/{{ ansible_host }}/fullchain.pem /etc/letsencrypt/live/{{ ansible_host }}/privkey.pem > /etc/ssl/snakeoil.pem
sudo systemctl restart haproxy