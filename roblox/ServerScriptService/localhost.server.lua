
local HttpService = game:GetService('HttpService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local RemoteService = require(ReplicatedStorage:WaitForChild('RemoteService'))
local ReplicateRemote = RemoteService:GetRemote('Replicate', 'RemoteEvent', false) :: RemoteEvent

while true do
	local success, data = pcall(function()
		return HttpService:GetAsync('http://127.0.0.1:500')['Data']
	end)
	if success then
		ReplicateRemote:FireAllClients(data)
	else
		warn('Could not connect to localhost ; ', data)
	end
	task.wait(1)
end
