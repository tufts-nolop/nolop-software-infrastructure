#!/bin/bash
echo $HOSTNAME has the IP $(hostname -I) as of $(date +%c) > /dev/udp/66.228.35.229/8000

# listen on the server using: nc -luk -p 8000
