
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local RemoteService = require(ReplicatedStorage:WaitForChild('RemoteService'))
local ReplicateRemote = RemoteService:GetRemote('Replicate', 'RemoteEvent', false)

local StringCompression = require(ReplicatedStorage:WaitForChild('Compression'))

ReplicateRemote.OnClientEvent:Connect(print)
