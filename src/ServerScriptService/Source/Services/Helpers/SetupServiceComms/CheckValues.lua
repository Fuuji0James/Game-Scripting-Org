local Tags = require(game:GetService("ReplicatedStorage").Utility.GLOBAL.Tags)
local ComponentHandler = require(game:GetService("ReplicatedStorage").Packages.ComponentHandler)

return function(Tag, Character, ValuesToBeChecked)
	local listOfDataValues = {
		[Tags.Components.Combat] = ComponentHandler.GetComponentsFromInstance(Character, Tags.Components.Combat)['CombatDataValues'];
		[Tags.Components.Movement] = ComponentHandler.GetComponentsFromInstance(Character, Tags.Components.Movement)['MovementDataValues']
	}
	
	local specifiedDataValues = listOfDataValues[Tag]
	
	for i, v in pairs(ValuesToBeChecked) do
		if specifiedDataValues[i] ~= v then
			return false
		end
		return true
	end
end