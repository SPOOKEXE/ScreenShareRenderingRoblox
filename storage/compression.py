
import json

from math import floor
from screenshot import Get

def compress_image(data) -> str:
	compressed = []
	matrix = []
	counter = 0
	DIV_NUM = 5 # divide this
	for yIndex in range(len(data)):
		yData = data[yIndex]
		row_compressed = []
		for xIndex in range(len(yData)):
			pixel_data = yData[xIndex]
			index = ".".join('%s' %id for id in pixel_data)
			try:
				cached = matrix[index]
			except:
				cached = None
			if cached != None:
				row_compressed.append(cached)
			else:
				counter += 1
				n = counter / DIV_NUM
				if (n%1) == 0:
					n = floor(n)
				row_compressed.append(n)
				matrix.append(index)
		compressed.append(row_compressed)
	return "{}*{}*{}".format(DIV_NUM, json.dumps(matrix), json.dumps(compressed))

def decompress_image(data : str) -> list:
	div_num, col_mat, pix_data = data.split('*')
	col_mat : list = json.loads(col_mat)
	pix_data : list = json.loads(pix_data)
	div_num = int(div_num)
	extracted = []
	for yIndex in range(len(pix_data)):
		yData = pix_data[yIndex]
		row_decompressed = []
		for xIndex in range(len(yData)):
			pixel_n = floor(yData[xIndex] * div_num) - 1
			row_decompressed.append( list(map(int, col_mat[pixel_n].split("."))) )
		extracted.append(row_decompressed)
	return extracted

if __name__ == '__main__':
	pixel_data, img = Get()
	compressed_str_data = compress_image(pixel_data)
	#print(compressed_pixel_data)
	#print(len(str(pixel_data)), len(compressed_str_data))
	print(compressed_str_data)
	decompressed_pixel_data = decompress_image(compressed_str_data)
	#print(len(str(pixel_data)), len(decompressed_pixel_data), str(decompressed_pixel_data) == str(pixel_data))
