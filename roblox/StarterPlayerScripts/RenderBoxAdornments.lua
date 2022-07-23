
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local TVScreenModel = ReplicatedStorage:WaitForChild('TVScreen')
TVScreenModel = TVScreenModel:Clone()
TVScreenModel.Parent = workspace

-- // Module // --
local Module = {}

function Module.LoadPixels( PixelData )
	for y, yData in ipairs( PixelData ) do
		for x, pixelData in ipairs( yData ) do
			local pixel_instance = TVScreenModel.PrimaryPart:FindFirstChild(x..':'..y) :: BoxHandleAdornment?
			if pixel_instance then
				local B, G, R = unpack(pixelData)
				pixel_instance.Color = BrickColor.new(Color3.fromRGB(R, G, B))
			end
		end
	end
end

return Module