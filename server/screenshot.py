
import numpy as np
import cv2
import os

from typing import Tuple
from PIL import Image, ImageGrab

directory = os.path.dirname(os.path.realpath(__file__)) + "/"

#resize_to = (220, 130)# in roblox tv screen

#resize_to = (192, 108) # note: keeps screenshot aspect ratio
resize_to = (320, 180)
#resize_to = (640, 360) # note: keeps screenshot aspect ratio
#resize_to = (1280, 720)  # note: keeps screenshot aspect ratio

def WriteSampleFile(image, filename):
	image_matrix = cv2.cvtColor(np.array(image), cv2.COLOR_RGB2BGR)
	cv2.imwrite(directory + filename, image_matrix)

def Get() -> Tuple[list, Image.Image]:
	image = ImageGrab.grab()
	#WriteSampleFile(image, 'screen.png') # default
	image.thumbnail(resize_to, Image.LANCZOS)
	#WriteSampleFile(image, 'screen_resized.png') # default

	image_matrix = cv2.cvtColor(np.array(image), cv2.COLOR_RGB2BGR)
	data = np.asarray(image_matrix).tolist()
	#with open(directory + "raw_data.json", "w") as file:
	#	file.write("".join(str(data)))
	return data, image

if __name__ == '__main__':
	data, img = Get()
	print(len(data))
