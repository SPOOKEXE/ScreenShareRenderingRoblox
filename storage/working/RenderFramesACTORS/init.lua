
local HttpService = game:GetService('HttpService')

local LocalPlayer = game:GetService('Players').LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild('PlayerGui')

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

do
	local TemplateFrame = Instance.new('Frame')
	TemplateFrame.BackgroundTransparency = 0
	TemplateFrame.BackgroundColor3 = Color3.new()
	TemplateFrame.BorderSizePixel = 0
	TemplateFrame.Size = UDim2.fromScale(0.1, 0.1)
	TemplateFrame.Name = 'PixelFrame'
	TemplateFrame.Parent = script.Actor
end

-- // Module // --
local Module = {}

function Module.LoadPixels( PixelDataArray )
	print('X: ', #PixelDataArray[1], ' Y:', #PixelDataArray)

	local xResolution = #PixelDataArray[1]
	local yResolution = #PixelDataArray

	AspectRatio.AspectRatio = xResolution / yResolution

	local pixelSize = math.round( math.min( ContainerFrame.AbsoluteSize.X / xResolution, ContainerFrame.AbsoluteSize.Y / yResolution ) )
	for yPos, columnData in ipairs( PixelDataArray ) do
		local actorInstance = script.Actor:Clone()
		actorInstance.Name = yPos
		actorInstance.Frame.Value = ContainerFrame
		actorInstance.Data.Value = HttpService:JSONEncode({
			pixelSize = pixelSize,
			yPos = yPos,
			columnData = columnData
		})
		actorInstance.Parent = PlayerGui
		actorInstance.Render.Disabled = false
	end

end

return Module

