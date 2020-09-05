#!/bin/bash

if [ "$1" == "" ]; then
    ip_in="localhost"
else
    ip_in=$1
fi

echo "Positional Parameters:"
echo '$0 = ' $0
echo '$1 = ' $ip_in

echo "starting..."

while true; do
    ping_string=`ping $ip_in -c 1 | grep received`
    now_file_G5="/home/pi/my_scripts/logfiles/"$(date +"%Y%m%d")"_G5-received.log"
    now_distance=`cat /home/pi/my_scripts/x_distance.var`
    echo "$(date +"%Y-%m-%d %H:%M:%S.%3N");$ip_in;${ping_string:23:1};$now_distance" >> $now_file_G5
    echo -n "pinged $ip_in"
    if [ ${ping_string:23:1} == "1" ]; then
        echo " ...SUCCESS!"
    else
        echo " ...FAILED!"
    fi
    sleep 1
done
