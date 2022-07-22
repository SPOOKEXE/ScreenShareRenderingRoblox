local HttpService = game:GetService('HttpService')

local Actor = script.Parent
local RenderData = Actor.Data.Value
local FrameObject = Actor.Frame.Value

RenderData = HttpService:JSONDecode(RenderData)

-- desynchronize and calculate data
task.desynchronize()
local cacheTable = {}
local pixelSizeUDim2 = UDim2.fromOffset(RenderData.pixelSize, RenderData.pixelSize)
for xPos, colorData in ipairs( RenderData.columnData ) do
	table.insert(cacheTable, {
		Color3.fromRGB(unpack(colorData)),
		UDim2.fromOffset(xPos * RenderData.pixelSize, RenderData.yPos * RenderData.pixelSize)
	})
end

-- resync and set properties of instances
task.synchronize()
for _, data in ipairs( cacheTable ) do
	local col, pos = unpack(data)
	local Frame = Actor.PixelFrame:Clone()
	Frame.BackgroundColor3 = col
	Frame.Size = pixelSizeUDim2
	Frame.Position = pos
	Frame.Parent = FrameObject
end

Actor:Destroy()

--[[
	for xPos, colorData in ipairs( RenderData.columnData ) do
		local Frame = Actor.PixelFrame:Clone()
		Frame.BackgroundColor3 = Color3.fromRGB(unpack(colorData))
		Frame.Size = pixelSizeUDim2
		Frame.Position = UDim2.fromOffset(xPos * RenderData.pixelSize, RenderData.yPos * RenderData.pixelSize)
		Frame.Parent = FrameObject
		-- every 300 frames, task.wait
		if (xPos % 300) == 0 then
			task.wait()
		end
	end
]]