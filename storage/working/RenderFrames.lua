
local LocalPlayer = game:GetService('Players').LocalPlayer

local ReplicatedStorage = game:GetService('ReplicatedStorage')

local PixelCache = require(ReplicatedStorage:WaitForChild('ObjectCache')).New(25000)

local ScreenGui = Instance.new('ScreenGui') do
	ScreenGui.Name = 'PixelRender'
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.Parent = LocalPlayer:WaitForChild('PlayerGui')
end

local ContainerFrame = Instance.new('Frame') do
	ContainerFrame.Name = 'PixelContainer'
	ContainerFrame.BackgroundTransparency = 1
	ContainerFrame.BorderSizePixel = 0
	ContainerFrame.Size = UDim2.fromScale(0.8, 0.8)
	ContainerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	ContainerFrame.Position = UDim2.fromScale(0.5, 0.5)
	ContainerFrame.Parent = ScreenGui
end

local AspectRatio = Instance.new('UIAspectRatioConstraint') do
	AspectRatio.AspectRatio = 1
	AspectRatio.AspectType = Enum.AspectType.ScaleWithParentSize
	AspectRatio.Parent = ContainerFrame
end

local TemplateFrame = Instance.new('Frame') do
	TemplateFrame.BackgroundTransparency = 0
	TemplateFrame.BackgroundColor3 = Color3.new()
	TemplateFrame.BorderSizePixel = 0
	TemplateFrame.Size = UDim2.fromScale(0.1, 0.1)
	TemplateFrame.Name = 'PixelFrame'
	TemplateFrame.Parent = script
end

PixelCache:SetTemplate(TemplateFrame)
PixelCache:Populate()

-- // Module // --
local Module = {}

function Module.LoadPixels( PixelDataArray )
	print('X: ', #PixelDataArray[1], ' Y:', #PixelDataArray)

	-- print(PixelDataArray)

	local xResolution = #PixelDataArray[1]
	local yResolution = #PixelDataArray

	AspectRatio.AspectRatio = xResolution / yResolution

	local pixelSize = math.round( math.min( ContainerFrame.AbsoluteSize.X / xResolution, ContainerFrame.AbsoluteSize.Y / yResolution ) )
	local pixelSizeUDim2 = UDim2.fromOffset(pixelSize, pixelSize)

	for yPos, columnData in ipairs( PixelDataArray ) do
		for xPos, colorData in ipairs( columnData ) do
			local Frame = PixelCache:GetObject()
			Frame.BackgroundColor3 = Color3.fromRGB(unpack(colorData))
			Frame.Size = pixelSizeUDim2
			Frame.Position = UDim2.fromOffset(xPos * pixelSize, yPos * pixelSize)
			Frame.Parent = ContainerFrame
			-- every 1000 frames, task.wait
			if ((xPos * yPos) % 5000) == 0 then
				task.wait()
			end
		end
	end

	PixelCache:ReleaseAll()
end

return Module

