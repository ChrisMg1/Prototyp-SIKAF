#!/bin/bash

if [ "$1" == "" ]; then
    ip_in="192.168.1.55"
else
    ip_in=$1
fi

echo "Positional Parameters"
echo '$0 = ' $0
echo '$1 = ' $ip_in

echo 'here bash'
for i in `seq 1 2`;
do
	echo $i 'time'
	sleep 0.5
done
