
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
	return self.TemplateInstance:Clone()
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

local function CombineArrays(...)
	local args = {...}
	local body = {}
	for _, array in ipairs( args ) do
		array = table.clone(array) -- clone the table
		table.move(array, 1, #array, #body, body) -- move it all into one
	end
	return body
end

function Class:GetInstances()
	return CombineArrays(self.__InUseInstances, self.__CachedInstances)
end

return Class