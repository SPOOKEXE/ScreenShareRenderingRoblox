
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
	Instance.new('UIAspectRatioConstraint', ContainerFrame).AspectRatio = 1 -- keep it square
	local GridLayout = Instance.new('UIListLayout')
	GridLayout.SortOrder = Enum.SortOrder.LayoutOrder
	GridLayout.Parent = ContainerFrame
end

local TemplateLabel = Instance.new('TextLabel') do
	TemplateLabel.BackgroundTransparency = 1
	TemplateLabel.BorderSizePixel = 0
	TemplateLabel.Size = UDim2.fromScale(0.5, 0.5)
	TemplateLabel.Name = 'PixelLabel'
	TemplateLabel.Text = ''
	TemplateLabel.RichText = true
	TemplateLabel.TextSize = 16
	TemplateLabel.Font = Enum.Font.SourceSansBold
	PixelCache:SetTemplate(TemplateLabel)
end

local BASE_PIXEL_TEXT = '<font color="rgb(%s, %s, %s)">█</font>'

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
			table.insert(textArray, { {} }) -- adds default pixel concat table
		end
		-- every 25 pixels, create a new label in the same row
		local hasRowFinished = (xIndex > #PixelDataArray[yIndex])
		if (counter % 25 == 0) or hasRowFinished then
			if hasRowFinished then
				print('row finished')
				yIndex += 1
				if yIndex > #PixelDataArray then
					break
				end
				xIndex = 1
				table.insert(textArray, { {} }) -- add another row, using default
			else
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
	print(typeof(PixelDataArray))
	print('X: ', #PixelDataArray[1], ' Y:', #PixelDataArray)

	local renderStringMatrix = Module.ProcessData(PixelDataArray)
	print(renderStringMatrix)

	local resolutionY = #PixelDataArray
	local resolutionX = #PixelDataArray[1]

	--[[
		local pixelSize = math.min( ContainerFrame.AbsoluteSize.X / resolutionX, ContainerFrame.AbsoluteSize.Y / resolutionY )
		pixelSize = math.min(1, math.round(pixelSize))

		-- update template to have correct size (for any new pixels)
		PixelCache.TemplateInstance.Size = UDim2.fromOffset( pixelSize, pixelSize)
		-- update all active and cached pixels to have the correct size
		for _, Label in ipairs( PixelCache:GetInstances() ) do
			Label.Size = UDim2.fromScale(1, pixelSize / ContainerFrame.AbsoluteSize.X) -- do this for all pixels
		end
	]]

	local LabelSizeX = ContainerFrame.AbsoluteSize.X / #renderStringMatrix[1]
	for rowNumber, rowLabels in ipairs( renderStringMatrix ) do

		for labelNumber, labelStrTable in ipairs( rowLabels ) do

			local pixelString = table.concat(labelStrTable, '')



		end

	end

end

return Module

