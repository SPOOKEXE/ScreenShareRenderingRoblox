
import json
import os

from math import floor
from screenshot import Get

compressed_str = '5*["123.123.123","123.55.123"]*3^3^[0.2, 0.2, 0.2]'

class list(list):
	def find(self, value):
		if self.count(value) == 0:
			return None
		return self.index(value)

def compress_image(data) -> str:
	# DUMP
	with open(os.path.dirname(os.path.realpath(__file__)) + "/dump0.json", "w") as file:
		file.write("\n\n\n".join([json.dumps(data)]))
	# variables
	color_matrix = list()
	pixel_array = []
	size_y, size_x = len(data), len(data[1])
	DIVIDER_NUM = 5
	# process
	counter = 0
	for yIndex in range(len(data)):
		yData = data[yIndex]
		for xIndex in range(len(yData)):
			pixel_data = yData[xIndex]
			index = ".".join('%s' %id for id in pixel_data)
			cache_index = color_matrix.find(index)
			if cache_index == None:
				counter += 1
				n = counter / DIVIDER_NUM
				# if n % 1 == 0:
				# 	n = floor(n)
				pixel_array.append(n)
				color_matrix.append(index)
			else:
				pixel_array.append(cache_index)
	return "{}^{}^{}^{}^{}".format(
		size_y,
		size_x,
		DIVIDER_NUM,
		json.dumps(color_matrix),
		pixel_array
	)

def decompress_image(data : str) -> list:
	SIZE_Y, SIZE_X, DIV_N, COLOR_MATRIX, PIXEL_ARRAY = data.split("^")
	directory = os.path.dirname(os.path.realpath(__file__))

	# DUMP
	with open(directory + "/dump1.json", "w") as file:
		file.write("\n\n\n".join([SIZE_Y, SIZE_X, DIV_N, COLOR_MATRIX, PIXEL_ARRAY]))
	# print(SIZE_Y, SIZE_X, DIV_N, COLOR_MATRIX, PIXEL_ARRAY)

	# convert all color matrix strings to lists
	# print(COLOR_MATRIX)
	COLOR_MATRIX = json.loads(COLOR_MATRIX)
	new_matrix = []
	for color_str in COLOR_MATRIX:
		new_matrix.append( list(map(int, color_str.split("."))) )
	COLOR_MATRIX = new_matrix
	# print(len(COLOR_MATRIX))

	# DUMP
	with open(directory + "/dump2.json", "w") as file:
		file.write("\n\n\n".join([json.dumps(COLOR_MATRIX)]))

	# convert compressed pixel list
	# to uncompressed pixel list
	raw_pixel_data = []
	#DIV_N = float(DIV_N)
	for index_number in json.loads(PIXEL_ARRAY):
		new_number = index_number# * DIV_N
		raw_pixel_data.append(list.copy(COLOR_MATRIX[int(new_number)]))

	# DUMP
	with open(directory + "/dump3.json", "w") as file:
		file.write("\n\n\n".join([SIZE_Y, SIZE_X, json.dumps(raw_pixel_data)]))

	# sort into rows/columns
	SIZE_X = int(SIZE_X)
	fully_sorted = []
	counter = -1
	for pixel_data in raw_pixel_data:
		counter += 1
		if counter == 0 or counter % SIZE_X == 0:
			fully_sorted.append([])
		fully_sorted[len(fully_sorted)-1].append(pixel_data)

	# DUMP
	SIZE_Y = int(SIZE_Y)
	print(len(fully_sorted), SIZE_Y, len(fully_sorted[1]), SIZE_X)
	with open(directory + "/dump4.json", "w") as file:
		file.write(json.dumps(raw_pixel_data))

	return fully_sorted

if __name__ == '__main__':
	pixel_data, img = Get()
	compressed_str_data = compress_image(pixel_data)

	#print(compressed_str_data)
	#print(len(str(pixel_data)), len(compressed_str_data))

	decompressed_pixel_data = decompress_image(compressed_str_data)
	print(len(str(pixel_data)), len(str(decompressed_pixel_data)), str(decompressed_pixel_data) == str(pixel_data))
	print(len(pixel_data), len(pixel_data[1]))
	print(len(decompressed_pixel_data), len(decompressed_pixel_data[1]))

	# recreate the image and compare
	import numpy as np
	from PIL import Image

	directory = os.path.dirname(os.path.realpath(__file__))
	
	recreation = Image.fromarray(np.asarray(decompressed_pixel_data))
	recreation.save(directory + "recreation.png")
	os.open(directory + "recreation.png")
