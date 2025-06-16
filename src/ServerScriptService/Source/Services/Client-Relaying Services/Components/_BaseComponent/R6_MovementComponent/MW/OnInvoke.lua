-- {Most Recent: 10/5/2025} //FUUJI
-- Status: Proto

local Promise = require(game:GetService('ReplicatedStorage').Libraries.PromiseV4)

return function(self, ComponentHandler, Plr: Player, Input: string, ...) -- Request sent
	local args = {...}
	local ActionUtil = self['CurrentActionSet']	
	--
	
	if not self.ForceEnabled then print(`Movement has been foribly turned off for {self['Player'].Name or self.Rig.Name}`) return end
	if not ActionUtil.Enabled then print(`{ActionUtil.Name} is disabled for {self.Rig}`) return end
	
	--
	local Action = ActionUtil[Input] -- The name would be the same
	if not Action then print(`@FUUJI has gotta make this {Input} - System!`) return end

	local CanPerformAction: boolean

	local promisedInput = Promise.new(function(resolve, reject, onCancel)
		local _, ErrorMsg = pcall(function()
			CanPerformAction = Action(self, unpack(args))
		end)

		if not ErrorMsg then
			resolve(CanPerformAction)
		else
			reject(ErrorMsg)
		end
	end)

	if promisedInput then
		local Performed: boolean	
		
		promisedInput:andThen(function(bool)
			Performed = bool
		end):catch(function(ErrorMsg)
			warn(ErrorMsg)
		end)

		return Performed
	else
		print("Promise did not run??")
		return false
	end
end