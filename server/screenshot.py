
import numpy as np
import cv2
import os

from PIL import Image
from pyautogui import screenshot

directory = os.path.dirname(os.path.realpath(__file__)) + "/"

def GetRaw():
	image = Image.open(directory + "screen.png")
	data = str(np.asarray(image).tolist())
	with open(directory + "raw_data.json", "w") as file:
		file.write(str(data))
	# return compress(data)
	return data

def Update():
	# take screenshot using pyautogui
	image = screenshot()
	image = cv2.cvtColor(np.array(image), cv2.COLOR_RGB2BGR)
	cv2.imwrite(directory + "screen.png", image)

if __name__ == '__main__':
	Update()
	ByteData = GetRaw()
	print(len(ByteData))
