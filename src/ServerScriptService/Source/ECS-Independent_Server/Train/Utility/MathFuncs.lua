-- {Most Recent: 26/5/2025} //FUUJI
-- Status: Must Edit
-- FP
-- Dont forget custom typing when youre done bro!

local MathFuncs = {}


--Services
local RF = game:GetService('ReplicatedFirst')
local RS = game:GetService('ReplicatedStorage')
local CS = game:GetService('CollectionService')
--Services

-- Packs
local SharedBasicPackages = game:GetService('ReplicatedFirst').Packs.BasicPackages_Shared
-- Packs

--Modules
local BezierUtils = require(SharedBasicPackages.Utility.BezierUtils)
--Modules

local function MakeCurvesAndStraights(ControlPoints: {}) : {BezierUtils.BezierTable} | {BezierUtils.BezierTable} | {BezierUtils.BezierTable} | {number}
	local StraightsTable: { BezierUtils.BezierTable } = {} -- Bezier and length of bezier is 1 entry
	local CurvesTable: { BezierUtils.BezierTable } = {} -- Bezier and length of bezier is 1 entry
	
	-- Straights
	for PointIndex, PointProperties: {} in ControlPoints do
		if PointProperties.StartsAStraight then	
			local _controlPoints = {
				[PointIndex] = ControlPoints[PointIndex].Pos,
				[PointIndex+1] = ControlPoints[PointIndex+1].Pos
			}
			
			local BezierTable = BezierUtils:CreateBezierFunc(_controlPoints, nil, PointIndex, PointIndex+1)
			local BezierLength = vector.magnitude(_controlPoints[PointIndex+1] - _controlPoints[PointIndex])
			 
			StraightsTable[PointIndex] = BezierTable
						
			-- Edge case: incase of isolated control point at the end
			if ControlPoints[PointIndex+2] == #ControlPoints then
				_controlPoints[PointIndex+2] = ControlPoints[PointIndex+2].Pos
				
				--
				
				BezierTable = BezierUtils:CreateBezierFunc(_controlPoints, nil, PointIndex+1, PointIndex+2)
				BezierLength =  vector.magnitude(_controlPoints[PointIndex+2] - _controlPoints[PointIndex+1])
				
				StraightsTable[PointIndex+1] = BezierTable
			end
			-- Edge case: incase of isolated control point at the end
		end
	end
	
	-- Curves // Figure out why 1 = nil and fix that // What if its just 1 point?
	local JumpToIndex = -1 -- this is the index it jumps to upon adding all the control points to the bezier (i.e where the curve)
	
	for CurveStartIndex, PointProperties: {} in ControlPoints do
		if PointProperties.StartsAStraight == false and CurveStartIndex >= JumpToIndex and ControlPoints[CurveStartIndex+1] then -- Meaning it starts a curve	
			-- finding the last control point index
			local CurveEndIndex : number
			
			for PointIndex = CurveStartIndex, #ControlPoints  do
				if (ControlPoints[PointIndex].StartsAStraight) then CurveEndIndex = PointIndex break 
					
				elseif (not ControlPoints[PointIndex + 1]) then CurveEndIndex = #ControlPoints break 
				elseif (ControlPoints[PointIndex].RestartsCurve) then CurveEndIndex = PointIndex-1 end 
			end
			
			JumpToIndex = CurveEndIndex
			
			-- adding them to the control points list			
			local CurveControlPoints: {vector} = {}
			
			for PointIndex = CurveStartIndex, #ControlPoints do 
				if PointIndex <= CurveEndIndex then -- then it must be a point inbetween the curve and its endpoint
					CurveControlPoints[PointIndex] = ControlPoints[PointIndex].Pos
				end
			end
			
			local BezierTable = BezierUtils:CreateBezierFunc(CurveControlPoints, nil, CurveStartIndex, CurveEndIndex)
			
			CurvesTable[CurveStartIndex] = BezierTable
		end
	end	
	
	return CurvesTable, StraightsTable
end

local function GetAllCentrePositions(Bezier: BezierUtils.UsableBezier, spacing: number, totalLength, placeAtStart:boolean) -- all beziers would take distance now and not time
	local CentrePositions: BezierUtils.ArrayPointProperties = {}
	local AccumulatedDistance = 0
	
	if placeAtStart then
		table.insert(CentrePositions, {['Distance'] = 0, ['Pos'] = Bezier(0)})  -- this is the first pos
	end	
	
	--//Sum gotta be wrong here bru ;-;
	for i = spacing, totalLength, spacing do
		AccumulatedDistance += spacing
		AccumulatedDistance = math.min(AccumulatedDistance, totalLength)
		local pos = Bezier(AccumulatedDistance)
		
		table.insert(CentrePositions, {['Distance'] = AccumulatedDistance, ['Pos'] = pos})  -- this is the first pos
	end	
	
	return CentrePositions
end	

--***Looping between last and first points
local function MakeCircuitBezier(BezierTable: BezierUtils.CompositeBezierTable, FinalIndex): BezierUtils.BezierTable
	local TransitionControlPoints = {
		[1] = BezierTable.CompositeBezier(BezierTable.TotalLength-1),
		[3] = BezierTable.CompositeBezier(1)
	}
	
	local midpoint = (TransitionControlPoints[1] - TransitionControlPoints[3])/2
	local interpolatedGrad = (
		BezierTable.CompositeGradient(BezierTable.TotalLength):Lerp(BezierTable.CompositeGradient(1), .5)
	).Unit
	
	local cp1 = midpoint * interpolatedGrad
	cp1 = vector.create(cp1.x, math.lerp(TransitionControlPoints[1].y, TransitionControlPoints[3].y, .5), cp1.z)
	
	TransitionControlPoints[2] = cp1
	
	return BezierUtils:CreateBezierFunc(TransitionControlPoints, nil, 1, 3)
end

--

--***If CreatesCircuit is true, then make sure the points are physically close so the last transition looks good
function MathFuncs:CreateTrainBezier(ControlPoints: {vector}, Spacing:number, CreatesCircuit:boolean):	BezierUtils.CompositeBezierTable
	local CurvesTable: { BezierUtils.BezierTable }, 
	StraightsTable: { BezierUtils.BezierTable } = MakeCurvesAndStraights(ControlPoints) 
	
	local AllBeziers: { BezierUtils.BezierTable } = {}
	
	for i=1, #ControlPoints do
		if CurvesTable[i] then AllBeziers[i] = CurvesTable[i] 
		elseif StraightsTable[i] then AllBeziers[i] = StraightsTable[i] end
	end
	
	local BezierTable: BezierUtils.CompositeBezierTable = BezierUtils:CreateCompositeBezier(AllBeziers)

	if CreatesCircuit and #ControlPoints > 2 then
		AllBeziers[#ControlPoints] = MakeCircuitBezier(BezierTable, #ControlPoints)
		BezierTable = BezierUtils:CreateCompositeBezier(AllBeziers)
	end
	
	local RingPositions = GetAllCentrePositions(BezierTable.CompositeBezier, Spacing, BezierTable.TotalLength)-- should give back a list of point properties

	
	return BezierTable, RingPositions
end

return MathFuncs
