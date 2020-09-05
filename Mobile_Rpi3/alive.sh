#!/bin/bash

# find starting timestamp: a)every minute (no options) or b)custom (with options)
if [ "$1" == "" ]; then
    time_in="60"
else
    time_in=$1
fi
echo 'time in = ' $time_in
while :
do
TIMESTAMP=$(date "+%Y%m%d%H%M%S")
echo $TIMESTAMP

REMAINDER=$(expr $TIMESTAMP % $time_in)
echo -n "remainder is "
echo $REMAINDER

if [ "$REMAINDER" == 0 ]; then
echo "starting log"
break

fi
sleep 1
done


# Start logging
while :

do


now_file="/home/pi/my_scripts/logfiles/"$(date +"%Y%m%d")"_alive.log"

echo "$(date);$(vcgencmd measure_temp);alive;1" >> $now_file

# echo "$(date)"

sleep $time_in

done
