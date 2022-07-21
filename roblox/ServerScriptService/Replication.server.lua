

local ReplicatedStorage = game:GetService('ReplicatedStorage')

local RemoteService = require(ReplicatedStorage:WaitForChild('RemoteService'))
local ReplicateRemote = RemoteService:GetRemote('Replicate', 'RemoteEvent', false) :: RemoteEvent

local WhitelistIDs = {}

local function Handle(LocalPlayer : Player, Data : any?)
	if game.CreatorId == LocalPlayer.UserId or table.find(WhitelistIDs, LocalPlayer.UserId) then
		ReplicateRemote:FireAllClients(Data)
	end
end

ReplicateRemote.OnServerEvent:Connect(Handle)
