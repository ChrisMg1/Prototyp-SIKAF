#!/bin/bash

# read value from file or directly from sensor

# value1=`cat /home/pi/my_scripts/sensor_input.txt`
value1=$(cat /sys/bus/w1/devices/28-000004e4f21a/w1_slave | grep  -E -o ".{0,0}t=.{0,5}" | cut -c 3-)

echo "un-reounded raw value is"
echo $value1


# round value

value2=$(echo "$value1" | bc -l | xargs printf "%1.0f")
echo "rounded value is"
echo $value2

# limit to major/minor size

echo "check size"

if (( "$value2" > 65535 ));
then
echo "value2 gt 65535, reducing..."
value2=65535
else
echo "value2 st 50, ok..."
fi

if (( "$value2" < 0 ));
then
echo "value2 st 0, resizing..."
value2=0
else
echo "value2 gt 0, ok..."
fi

# output so far...

echo "processed value decimal:"
echo $value2

# convert to hex

value3=`printf "%04x" $value2`

echo "value hex:"
echo $value3

# write to beacon-source as input file

rm /home/pi/my_scripts/beacon_content_major.ibc
echo -n "$value3" | cut -c1-2 | tr -d '\n' >> /home/pi/my_scripts/beacon_content_major.ibc
echo -n " " >> /home/pi/my_scripts/beacon_content_major.ibc
echo -n "$value3" | cut -c3-4 >> /home/pi/my_scripts/beacon_content_major.ibc
