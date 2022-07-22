
local function CombineArrays(...)
	local args = {...}
	local body = {}
	for _, array in ipairs( args ) do
		array = table.clone(array) -- clone the table
		table.move(array, 1, #array, #body, body) -- move it all into one
	end
	return body
end

-- // Class // --
local Class = {}
Class.__index = Class

function Class.New(MaxCached : number?)
	MaxCached = MaxCached or 20

	local self = setmetatable({
		TemplateInstance = false, -- template instance

		__InUseInstances = {}, -- items in use
		__CachedInstances = {}, -- items free in cache
		__MaxCache = MaxCached -- maximum items
	}, Class)

	return self
end

function Class:SetTemplate(TemplateInstance : Instance)
	assert(typeof(TemplateInstance) == 'Instance', 'Passed Instance is not an Instance.')
	self.TemplateInstance = TemplateInstance
end

function Class:CreateFromTemplate()
	local Template = self.TemplateInstance:Clone()
	Template.Parent = script
	return Template
end

function Class:ReleaseInstance(PassedInstance)
	assert(typeof(self.TemplateInstance) == 'Instance', 'Assign a template instance with ":SetTemplate(Instance)" before utilising this function.')
	-- remove from current used
	local Index = table.find(self.__InUseInstances, PassedInstance)
	if Index then
		table.remove(self.__InUseInstances, Index)
	end
	-- add to cached instances if there is room
	-- garbage collects otherwise
	if #self.__CachedInstances < self.__MaxCache then
		table.insert(self.__CachedInstances, PassedInstance)
	end
end

function Class:ReleaseAll()
	for _, _Instance in ipairs( self.__InUseInstances ) do
		table.insert(self.__CachedInstances, _Instance)
	end
	self.__InUseInstances = {}
end

function Class:GetObject() : Instance
	assert(typeof(self.TemplateInstance) == 'Instance', 'Assign a template instance with ":SetTemplate(Instance)" before utilising this function.')
	local ActiveInstance = self.__CachedInstances[1]
	if ActiveInstance then
		table.remove(self.__CachedInstances, 1)
	else
		-- create from scratch
		ActiveInstance = self:CreateFromTemplate()
	end
	table.insert(self.__InUseInstances, ActiveInstance)
	return ActiveInstance
end

function Class:GetInstances()
	return CombineArrays(self.__InUseInstances, self.__CachedInstances)
end

function Class:Populate()
	for i = 1, (self.__MaxCache - #self:GetInstances()), 1 do
		table.insert(self.__CachedInstances, self:CreateFromTemplate())
		if (i % 1000) == 0 then
			task.wait()
		end
	end
end

return Class