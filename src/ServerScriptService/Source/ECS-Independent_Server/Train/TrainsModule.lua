-- {Most Recent: 26/5/2025} //FUUJI
-- OOP
-- Status: Must Edit

--Services
local RF = game:GetService('ReplicatedFirst')
local RS = game:GetService('ReplicatedStorage')
local CS = game:GetService('CollectionService')
local RunS = game:GetService('RunService')
--Services

-- Packs
local SharedBasicPackages = game:GetService('ReplicatedFirst').Packs.BasicPackages_Shared
-- Packs

-- Modules
local SpawnObjectUtil = require(script.Parent.Utility.SpawnObjects)
local MathFuncs = require(script.Parent.Utility.MathFuncs)
local VisualizerCache = require(RS.Libraries.VisualizerCache)
-- Modules

----Class Creation

local Class = {
	CreatedTrains = {},
	Debugging = true
}


function initTrain(PositionsToUse: {Instance|vector}, CreatesCircuit: boolean, RingSpacingDistance: number)
	local ControlPoints = {}

	---

	if typeof(PositionsToUse[1]) == "Instance" then
		-- Looks for part properties
		for i, Part in PositionsToUse do
			local PointProperties = {}
			PointProperties.Pos = Part.Position
			PointProperties.StartsAStraight = Part:GetAttribute("StartsAStraight") -- This uses the next part in the seq. and forms a straight using the current one
			PointProperties.RestartsCurve = Part:GetAttribute("RestartsCurve")
			
			ControlPoints[i] = PointProperties
		end
	elseif type(PositionsToUse[1]) == "vector" then
		-- Uses it blindly
	else
		warn("Positions cannot be parsed")
	end
	
	
	local CompBezierTable, RingPositions = MathFuncs:CreateTrainBezier(ControlPoints, RingSpacingDistance, CreatesCircuit)
	
	if Class.Debugging then
		local function CompBezVisuals()
			-- How many segments to visualize
			local segments = 100
			local step = CompBezierTable.TotalLength / segments

			-- Clean up previously used adornments
			for i = #VisualizerCache._AdornmentInUse, 1, -1 do
				local adornment = table.remove(VisualizerCache._AdornmentInUse, i)
				VisualizerCache:ReturnAdornment(adornment)
			end

			-- Draw the curve
			local lastPos = CompBezierTable.CompositeBezier(0)

			for i = 1, segments do
				local d = i * step
				local currentPos = CompBezierTable.CompositeBezier(d)

				local adornmentData = VisualizerCache:GetAdornment()

				if adornmentData then
					local dir = currentPos - lastPos
					local cframe = CFrame.lookAt(lastPos, currentPos)

					adornmentData.Adornment.CFrame = cframe
					adornmentData.Adornment.Length = dir.Magnitude
				end

				lastPos = currentPos
				task.wait()
			end
		end
		
		local function RingTangentVisuals()
			for i, t: {['Pos']: vector, ['Distance']: number} in RingPositions do

				local currentPos:vector = t.Pos
				local lookat: vector = CompBezierTable.CompositeGradient(t.Distance)
				local adornmentData = VisualizerCache:GetAdornment(Color3.fromRGB(21, 255, 41))

				if adornmentData then
					adornmentData.Adornment.CFrame = CFrame.lookAt(currentPos, currentPos + lookat)
					adornmentData.Adornment.Length = 20
					local p = Instance.new("Part", workspace)
					p.Anchored = t
					p.CFrame = adornmentData.Adornment.CFrame
				end
			end		
		end
		
		coroutine.wrap(function()
			CompBezVisuals()
			RingTangentVisuals()
		end)()
	end
	
	--- Spawning
	
	local TrainID = SpawnObjectUtil:SpawnTraincart(ControlPoints[1], CompBezierTable.CompositeBezier) -- make the thing face the right way
	local RingsFolder
	
	RingsFolder = SpawnObjectUtil:SpawnRings(TrainID, RingPositions, CompBezierTable) -- //should just send over the ringpos as a table
	

	print("Total curve length:", math.ceil(CompBezierTable.TotalLength), "studs")	
	if RingSpacingDistance >= CompBezierTable.TotalLength then warn("Spacing too large for this distance") end
	
	Class.CreatedTrains[TrainID] = {CompBezierTable, RingPositions}
	
	return TrainID, CompBezierTable
end

function moveTrainUsingRunService(TrainID: number, speed: number, snapSpeed: number)
	local distance = 0
	local TrainModel: Model = workspace.AllTrainAssets[TrainID]['Traincart']

	local CompBezTable = Class.CreatedTrains[TrainID][1]

	local prevDirection = CompBezTable.CompositeGradient(distance)

	RunS.PostSimulation:Connect(function(dt)
		distance += dt * speed
		distance %= CompBezTable.TotalLength
		
		local pos = CompBezTable.CompositeBezier(distance)
		local targetDirection = CompBezTable.CompositeGradient(distance)
		
		snapSpeed = math.clamp(snapSpeed, 0, 1)
		
		local smoothedDirection = prevDirection:Lerp(targetDirection, snapSpeed)
		smoothedDirection = smoothedDirection.Unit

		-- Apply new orientation
		TrainModel:PivotTo(CFrame.new(pos, pos + smoothedDirection))

		-- Update direction for next frame
		prevDirection = smoothedDirection
	end)
end


Class.new = initTrain
Class.MoveTrain = moveTrainUsingRunService

return Class