
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local HttpService = game:GetService('HttpService')

local RemoteService = require(ReplicatedStorage:WaitForChild('RemoteService'))
local ReplicateRemote = RemoteService:GetRemote('Replicate', 'RemoteEvent', false)

local ScreenModule = require(script.Parent:WaitForChild('Render'))

local Latest = 0
ReplicateRemote.OnClientEvent:Connect(function(Data)
	--print(Data)
	if (not Data) or (Data.Timestamp < Latest) then
		return
	end
	Latest = Data.Timestamp
	--local Uncompressed = Decompress(Data)
	task.defer(ScreenModule.LoadPixels, HttpService:JSONDecode( Data.Data ))
end)
