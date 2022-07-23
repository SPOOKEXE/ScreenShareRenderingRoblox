
local LocalPlayer = game:GetService('Players').LocalPlayer

local ReplicatedStorage = game:GetService('ReplicatedStorage')

local PixelCache = require(ReplicatedStorage:WaitForChild('ObjectCache')).New(5000)

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
	ContainerFrame.Size = UDim2.fromScale(0.5, 0.5)
	ContainerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	ContainerFrame.Position = UDim2.fromScale(0.5, 0.5)
	ContainerFrame.Parent = ScreenGui
end

local AspectRatio = Instance.new('UIAspectRatioConstraint') do
	AspectRatio.AspectRatio = 1 -- keep it square
	AspectRatio.AspectType = Enum.AspectType.ScaleWithParentSize
	AspectRatio.Parent = ContainerFrame
end

local TemplateLabel = Instance.new('TextLabel') do
	TemplateLabel.BackgroundTransparency = 1
	TemplateLabel.BorderSizePixel = 0
	TemplateLabel.Size = UDim2.fromScale(0.5, 0.5)
	TemplateLabel.Name = 'PixelLabel'
	TemplateLabel.Text = ''
	TemplateLabel.RichText = true
	TemplateLabel.TextScaled = true
	TemplateLabel.Font = Enum.Font.SourceSansBold
	PixelCache:SetTemplate(TemplateLabel)
end

local BASE_PIXEL_TEXT = '<font color="rgb(%s, %s, %s)">█</font>'
local PIXELS_PER_LABEL = 80

local PIXEL_TEXT_SIZE_X = 4
local PIXEL_TEXT_SIZE_Y = 5

-- // Module // --
local Module = {}

function Module.ProcessData( PixelDataArray )
	local yIndex = 1
	local xIndex = 1
	local counter = 0
	local textArray = {}
	--[[
		{ -- matrix
			{ -- each row
				{}, {}. {} -- each pixel concat table
			},
			{ -- each row
				{}, {}. {} -- each pixel concat table
			},
		}
	]]
	while yIndex <= #PixelDataArray do
		if counter == 0 then
			table.insert(textArray, {}) -- adds default pixel concat table
		end
		-- every 'PIXELS_PER_LABEL' pixels, create a new label in the same row
		local hasRowFinished = (xIndex > #PixelDataArray[yIndex])
		if (counter % PIXELS_PER_LABEL == 0) or hasRowFinished then
			if hasRowFinished then
				--print('row finished')
				yIndex += 1
				if yIndex > #PixelDataArray then
					break
				end
				xIndex = 1
				table.insert(textArray, { {} }) -- add another row, using default
			else
				--print('new concat table')
				table.insert(textArray[#textArray], {}) -- add another label concat table
				counter = 0
			end
		end
		local currentRowPixelStrData = textArray[#textArray]
		currentRowPixelStrData = currentRowPixelStrData[#currentRowPixelStrData]
		local r, g, b = unpack(PixelDataArray[yIndex][xIndex])
		table.insert(currentRowPixelStrData, string.format(BASE_PIXEL_TEXT, r, g, b))
		-- print( counter, yIndex, xIndex, string.format(BASE_PIXEL_TEXT, r, g, b))
		xIndex += 1
		counter += 1
	end
	return textArray
end

function Module.LoadPixels( PixelDataArray )
	print('X: ', #PixelDataArray[1], ' Y:', #PixelDataArray)

	local renderStringMatrix = Module.ProcessData(PixelDataArray)

	local resolutionX = #PixelDataArray[1]
	local resolutionY = #PixelDataArray

	AspectRatio.AspectRatio = (resolutionX / resolutionY)

	-- TODO: convert to scale

	local xPadding = -1
	local yPadding = -1
	for rowNumber, rowLabels in ipairs( renderStringMatrix ) do
		local xoffset = 0
		for xindex, labelStrTable in ipairs( rowLabels ) do
			local LabelSizeX = (PIXEL_TEXT_SIZE_X * #labelStrTable)
			local pixelString = table.concat(labelStrTable, '')
			local Label = PixelCache:GetObject()
			Label.Text = pixelString
			Label.Size = UDim2.fromOffset(LabelSizeX, PIXEL_TEXT_SIZE_Y)
			Label.Position = UDim2.fromOffset(
				(xoffset + ((xindex-1) * xPadding)),
				(((rowNumber-1) * PIXEL_TEXT_SIZE_Y) + ((rowNumber-1) * yPadding))
			)
			Label.Parent = ContainerFrame
			xoffset += LabelSizeX
		end
	end

	PixelCache:ReleaseAll()

end

return Module

