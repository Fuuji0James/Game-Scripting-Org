-- {Most Recent: 13/5/2025} //FUUJI
-- Status: Must Edit

local FastSignal = require(game:GetService(`ReplicatedStorage`).Libraries.FastSignal)

local ActionUtility = {
	['PlayingAnimations'] = {}, -- This can be checked w/ the changed func, allowing for anims to stack
	['Animations'] = {},
	
	['_MyChasis'] = nil, -- Chasis for vehicles and other movement stuff
	['ActivePromises'] = {}, -- We need this for move canceling
	
	['Signals'] = {
		['OnPerfectCancel'] = FastSignal.new(), -- since we want the max to increase too
		['OnNormalCancel'] = FastSignal.new(),
	},
}

local function StartAsync(DataTable)
	-- Sets up connections, async timers
end

function ActionUtility:Start(DataTable)
end	

return ActionUtility