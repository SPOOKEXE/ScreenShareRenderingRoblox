local Players = game:GetService('Players')

local HttpService = game:GetService('HttpService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local RemoteService = require(ReplicatedStorage:WaitForChild('RemoteService'))
local ReplicateRemote = RemoteService:GetRemote('Replicate', 'RemoteEvent', false) :: RemoteEvent

local Latest = false

-- for all active players, update them
ReplicateRemote:FireAllClients( Latest )

-- for all players joining, update them
Players.PlayerAdded:Connect(function(LocalPlayer)
	ReplicateRemote:FireClient( LocalPlayer, Latest )
end)

-- update function
local function UpdateData()

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
		Latest = HttpService:JSONDecode(data)
		ReplicateRemote:FireAllClients( Latest )
	else
		warn('Could not connect to localhost ; ', err)
	end
end

--[[ -- new thread for it
task.defer(function()
	while true do
		task.wait(2)
		-- new thread so no delay in loop
		task.defer(UpdateData)
	end
end)
]]

--[[ manual trigger 1 ]]
local B = Instance.new('BoolValue')
B.Changed:Connect(UpdateData)
B.Parent = workspace

--[[ manual trigger 2 ]]
local R = Instance.new('RemoteEvent')
R.OnServerEvent:Connect(UpdateData)
R.Parent = workspace

-- workspace.RemoteEvent:FireServer()