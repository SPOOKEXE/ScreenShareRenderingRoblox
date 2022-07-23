
local HttpService = game:GetService('HttpService')

local function httpEncode(value : any) : string
	return HttpService:JSONEncode(value)
end

local function httpDecode(value : any) : string
	return HttpService:JSONDecode(value)
end

-- // Module // --
local Module = {}

function Module.Decompress( data : string ) : table
	local div_num, col_mat, pix_data = unpack(data.split('*'))
	col_mat = httpDecode(col_mat)
	pix_data = httpDecode(pix_data)
	div_num = tonumber(div_num)
	local extracted = {}
	for _, yData in ipairs( pix_data ) do
		local row_decompressed = {}
		for xIndex, pixel_n in ipairs( yData ) do
			pixel_n = math.floor(yData[xIndex] * div_num) - 1
			local r, g, b = unpack(col_mat[pixel_n].split("."))
			table.insert(row_decompressed, {tonumber(r), tonumber(g), tonumber(b)})
		end
		table.insert(extracted, row_decompressed)
	end
	return extracted
end

function Module.Compress( data : table ) : string
	local compressed = {}
	local matrix = {}
	local counter = 0
	local DIV_NUM = 5
	for _, yData in ipairs( data ) do
		local row_compressed = {}
		for _, pixel_data in ipairs( yData ) do
			local index = table.concat(pixel_data, '.')
			local n = matrix[index]
			if not n then
				counter += 1
				n = counter / DIV_NUM
				if (n%1) == 0 then
					n = math.floor(n)
				end
				table.insert(matrix, index)
			end
			table.insert(row_compressed, n)
		end
		table.insert(compressed, row_compressed)
	end
	return string.format("%s*%s*%s", httpEncode(matrix), httpEncode(compressed))
end

return Module


