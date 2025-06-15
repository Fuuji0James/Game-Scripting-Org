-- {Most Recent: 23/5/2025} //FUUJI
-- Status: Proto
-- It looks bare rn, but it'll have alot mroe stuff for other things that dont use tags

local MiscellaneousSystemsFolder = game:GetService('ReplicatedStorage')["ECS-Independent Systems"]

local TrainClass = require(MiscellaneousSystemsFolder.Train.TrainsModule)

return function()
	-- Train ways
	local Points = {}
	
	for i, part in workspace.Positions:GetChildren() do
		if part:IsA("Part") then
			Points[tonumber(part.Name)] = part
		end
	end
	
	local TrainID, BezierTable = TrainClass.new(Points, true, 75)	
	task.delay(10, function()
		TrainClass.MoveTrain(TrainID, 100, .15)
	end)
	-- Train ways
end