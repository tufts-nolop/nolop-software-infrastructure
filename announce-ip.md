
On a Raspberry Pi:

`{ cat /etc/hostname ; echo 'has the IP ' ; hostname -I ; } > /dev/udp/66.228.35.229/8000`

Currently prints result as 3 separate lines, which is slightly confusing. Should also add a timestamp. The final command should probably be run by cron, I guess? Or Supervisor?

Maybe should also send data to multiple different servers, just for robustness as stuff changes in the future.

On the server at 66.228.35.229

`nc -luk -p 8000`
