
On a Raspberry Pi:

`echo $HOSTNAME has the IP $(hostname -I) as of $(date +%c) > /dev/udp/66.228.35.229/8000`

Should probably be run by cron, I guess? Or Supervisor?

Maybe should also send data to multiple different servers, just for robustness as stuff changes in the future.

On the server at 66.228.35.229

`nc -luk -p 8000`
