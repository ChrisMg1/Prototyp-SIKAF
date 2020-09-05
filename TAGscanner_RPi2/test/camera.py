from picamera import PiCamera
from time import sleep

camera = PiCamera()


camera.annotate_text = "my appartment"
camera.start_preview()
camera.image_effect = 'none'
sleep(10)
camera.stop_preview()
