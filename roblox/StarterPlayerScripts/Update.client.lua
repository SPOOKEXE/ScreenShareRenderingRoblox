
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local CompressionModule = require(ReplicatedStorage:WaitForChild('Compression'))
local RemoteService = require(ReplicatedStorage:WaitForChild('RemoteService'))
local ReplicateRemote = RemoteService:GetRemote('Replicate', 'RemoteEvent', false)

--local TextLabelModule = require(script.Parent:WaitForChild('Render'))
--local RenderFramesModule = require(script.Parent.RenderFrames)
local BoxAdornmentModule = require(script.Parent.RenderBoxAdornments)

local Latest = 0
ReplicateRemote.OnClientEvent:Connect(function(Data)
	--print(Data)
	if (not Data) or (Data.Timestamp < Latest) then
		return
	end
	Latest = Data.Timestamp
	local Uncompressed = Data.Data
	--[[print(#Data.Data)
	local Uncompressed = CompressionModule.Decompress(Data.Data)
	print(#Uncompressed, type(Uncompressed))]]
	--task.defer(TextLabelModule.LoadPixels, Uncompressed)
	--task.defer(RenderFramesModule.LoadPixels, Uncompressed)
	task.defer(BoxAdornmentModule.LoadPixels, Uncompressed)
end)
