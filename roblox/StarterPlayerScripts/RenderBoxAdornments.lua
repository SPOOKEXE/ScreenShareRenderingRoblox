
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local TVScreenModel = ReplicatedStorage:WaitForChild('TVScreen')
TVScreenModel = TVScreenModel:Clone()
TVScreenModel.Parent = workspace

local ScreenPixels = TVScreenModel.PrimaryPart

local PixelCache = {}

-- // Module // --
local Module = {}

function Module.LoadPixels( PixelData )
	for y, yData in ipairs( PixelData ) do
		for x, pixelData in ipairs( yData ) do
			-- skip colors that are already set to what we need
			local indexValue = x..':'..y
			local colorValue = table.concat(pixelData, '-')
			if PixelCache[indexValue] == colorValue then
				continue
			end
			PixelCache[indexValue] = colorValue
			-- set the color to the new color
			local pixel_instance = ScreenPixels:FindFirstChild(indexValue)
			if pixel_instance then
				pixel_instance.Color3 = Color3.fromRGB(unpack(pixelData))
			end
			-- helps performance
			if (x * y) % 2500 == 0 then
				task.wait()
			end
		end
	end
end

return Module