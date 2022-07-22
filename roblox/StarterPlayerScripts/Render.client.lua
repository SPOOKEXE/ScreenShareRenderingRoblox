
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local HttpService = game:GetService('HttpService')

local RemoteService = require(ReplicatedStorage:WaitForChild('RemoteService'))
local ReplicateRemote = RemoteService:GetRemote('Replicate', 'RemoteEvent', false)

local function RenderPixels(PixelDataArray)
	print(typeof(PixelDataArray))
	print('X: ', #PixelDataArray[1], ' Y:', #PixelDataArray)
end

local Latest = 0
ReplicateRemote.OnClientEvent:Connect(function(Data)
	--print(Data)
	if Data.Timestamp < Latest then
		return
	end
	Latest = Data.Timestamp
	--local Uncompressed = Decompress(Data)
	RenderPixels( HttpService:JSONDecode( Data.Data ))
end)
