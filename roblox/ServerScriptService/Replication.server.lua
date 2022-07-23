local HttpService = game:GetService('HttpService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local RemoteService = require(ReplicatedStorage:WaitForChild('RemoteService'))
local ReplicateRemote = RemoteService:GetRemote('Replicate', 'RemoteEvent', false) :: RemoteEvent

local CompressionModule = require(ReplicatedStorage:WaitForChild('Compression'))

local WhitelistIDs = {}

local function Handle(LocalPlayer : Player, Data : any?)
	if game.CreatorId == LocalPlayer.UserId or table.find(WhitelistIDs, LocalPlayer.UserId) then
		if typeof(Data) == 'string' then
			Data = HttpService:JSONDecode(Data)
		end
		Data['Data'] = CompressionModule.Decompress(Data['Data'])
		ReplicateRemote:FireAllClients(Data)
	end
end

ReplicateRemote.OnServerEvent:Connect(Handle)
