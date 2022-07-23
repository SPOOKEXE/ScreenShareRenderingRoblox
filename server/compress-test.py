
import json

compressed_str = '5*["123.123.123","123.55.123"]*3^3^[0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.4, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2]'

DIV_NUM, COL_MATRIX, PIXELS_COMPRESSED = compressed_str.split('*')

# 3^3^[0.2,0.2,0.2,0.2,0.4,0.2,..(26 times)..,0.2]

PIXEL_LIST_SIZE_Y, PIXEL_LIST_SIZE_X, PIXEL_DATA = PIXELS_COMPRESSED.split('^')

print(DIV_NUM, COL_MATRIX, PIXEL_LIST_SIZE_Y, PIXEL_LIST_SIZE_X, PIXEL_DATA)

### UNCOMPRESSED

# column
# row (contains list of lists that are pixels)

# [
# 	[
# 		[123, 123, 123],
# 		[123, 123, 123],
# 		[123, 123, 123]
# 	],
# 	[
# 		[123, 123, 123],
# 		[123, 55, 123],
# 		[123, 123, 123]
# 	],
# 	[
# 		[123, 123, 123],
# 		[123, 123, 123],
# 		[123, 123, 123]
# 	]
# ]

### COMPRESSED

# "5*[123.123.123,123.55.123]*3^3^[0.2,0.2,0.2,0.2,0.4,0.2,..(26 times)..,0.2]"
