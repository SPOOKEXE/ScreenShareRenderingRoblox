
local HttpService = game:GetService('HttpService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local RemoteService = require(ReplicatedStorage:WaitForChild('RemoteService'))
local ReplicateRemote = RemoteService:GetRemote('Replicate', 'RemoteEvent', false) :: RemoteEvent

while true do
	local data = false
	local success, err = pcall(function()
		data = HttpService:RequestAsync({
			Url = 'http://127.0.0.1:500',
			Method = 'POST',
			Headers = {
				['Content-Type'] = 'application/json'
			},
		})['Body']
	end)
	if success then
		ReplicateRemote:FireAllClients( HttpService:JSONDecode(data) )
	else
		warn('Could not connect to localhost ; ', err)
	end
	task.wait(15)
end


