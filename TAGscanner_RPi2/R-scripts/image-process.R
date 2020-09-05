# This R-script reads a webcam-image and a hwrng-stream of the same size and creates a table of random numbers The random numbers are tested 
# with the ????-Scheme This script should be called from /home/pi/my_scripts/rng_from_cam_hwrng.sh because the image/stream is also taken 
# there

library(jpeg)
library(randtests)

# read complete image-file
my_jpg <- as.data.frame(readJPEG(source="/home/pi/my_scripts/cam.jpg", native=FALSE))

# cut channel 2 and 3
my_jpg <- my_jpg[,-c(101:300)]


# read binary, size equals 1 Byte (8bit)
my_bin <- readBin(file("/home/pi/my_scripts/my_rand.bin", "rb"), integer(), n = 10000, size = 2, signed = FALSE, endian = "little")


# Combine Image and hwrng-data; TODO: XOR-calculation
prod <- my_bin * my_jpg

# Make numeric
num_prod <- as.numeric(unlist(prod))


# Test the stuff with easy example

#test_prod <- prod[c(1:5),c(1:5)]
#print(test_prod)
#num_test_prod <- as.numeric(unlist(test_prod))
#print(num_test_prod)

# Perform run-test
runs.test(num_prod)


# write result
write(num_prod, file="/home/pi/my_scripts/R_random.out", sep = " ")
