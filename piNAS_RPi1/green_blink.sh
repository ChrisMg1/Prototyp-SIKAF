#!/bin/bash
# blink LED on GPIO 24

echo "24" > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio24/direction

while :
do
echo "1" > /sys/class/gpio/gpio24/value
sleep 3
echo "0" > /sys/class/gpio/gpio24/value
sleep 0.5
done







