#!/bin/bash

for i in "A" "P" "R";
do
	# get image
	raspistill -w 100 -h 100 --colfx 128:128 -o /home/pi/my_scripts/cam.jpg

	# write binary file from rng with blocksize(bs) = 1Byte (= 8bit) and 10.000 blocks (for 10.000 px from above image)
	dd if=/dev/hwrng of=/home/pi/my_scripts/my_rand.bin bs=2 count=10000

	# run R-script for combination
	Rscript /home/pi/my_scripts/R-scripts/image-process.R

	# Housekeeping
	cp /home/pi/my_scripts/R_random.out /home/pi/my_scripts/key_$i.out
	rm /home/pi/my_scripts/R_random.out
	rm /home/pi/my_scripts/cam.jpg
	rm /home/pi/my_scripts/my_rand.bin
done
