
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local RemoteService = require(ReplicatedStorage:WaitForChild('RemoteService'))
local ReplicateRemote = RemoteService:GetRemote('Replicate', 'RemoteEvent', false)

local Latest = 0

local function RenderPixels(PixelDataArray)
	print(PixelDataArray)
end

ReplicateRemote.OnClientEvent:Connect(function(Data)
	--print(Data)
	if Data.Timestamp < Latest then
		return
	end
	Latest = Data.Timestamp
	--local Uncompressed = Decompress(Data)
	RenderPixels(Data)
end)
