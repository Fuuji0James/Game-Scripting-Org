-- {Most Recent: 26/05/2025} // FUUJI
-- Status: Must Edit

local Utility = {}
Utility.__index = Utility

local TemplateFolder = game.ServerStorage.Assets["ECS-Independent Systems"]
local _RingTemplate = TemplateFolder:WaitForChild('Ring')
local _TraincartTemplate = TemplateFolder:WaitForChild("Traincart")


local RF = game:GetService('ReplicatedFirst')
local RS = game:GetService('ReplicatedStorage')
local CS = game:GetService('CollectionService')
local RunS = game:GetService('RunService')
--Services

-- Packs
local SharedBasicPackages = game:GetService('ReplicatedFirst').Packs.BasicPackages_Shared
-- Packs

local BezierUtils = require(SharedBasicPackages.Utility.BezierUtils)

function Utility.new()
	local self = {}

	self.AllTrainAssets = Instance.new("Folder", workspace)
	self.TrainIDs = {} -- unique ID for trains so they can't be on the same track
	
	--
	
	self.AllTrainAssets.Name = "AllTrainAssets"

	return setmetatable(self, Utility)
end

function Utility:SpawnRings(TrainID: number, CentrePositions: BezierUtils.ArrayPointProperties, BezierTable)	
	if not self.AllTrainAssets[TrainID] then print(`ID not found in list: {self.AllTrainAssets:GetChildren()}`) print("Spawn traincart first.") return end
	
	local RingsFolder = self.AllTrainAssets[TrainID]:FindFirstChild("Rings") or Instance.new('Folder', self.AllTrainAssets[TrainID])
	RingsFolder.Name = "Rings"
	
	for i, Point in CentrePositions do
		local NewRing = _RingTemplate:Clone()
		local LookAtPos:vector = BezierTable.CompositeGradient(Point.Distance)
		--print(LookAtPos)
		NewRing:PivotTo(CFrame.new(Point.Pos, Point.Pos + LookAtPos))
		-- add tags for flashing lights replication, ui, etc.
		NewRing.PrimaryPart.Anchored = true
		NewRing.Parent = RingsFolder
	end
	
	self.TrainIDs[TrainID]['RingsFolder'] = RingsFolder
	
	return RingsFolder
end

function Utility:SpawnTraincart(StartPoint: {}, BezierFunc)
	local TrainID = #self.TrainIDs + 1
	
	local TrainCartFolder = Instance.new('Folder', self.AllTrainAssets)
	TrainCartFolder.Name = `{TrainID}`
	
	local NewTraincart = _TraincartTemplate:Clone()
	
	local LookatPos = BezierFunc(4)
	
	NewTraincart:PivotTo(CFrame.new(StartPoint.Pos, LookatPos))
	NewTraincart.PrimaryPart.Anchored = true
	NewTraincart.Parent = TrainCartFolder
	
	self.TrainIDs[TrainID] = {
		['MainFolder'] = TrainCartFolder,
		['RingsFolder'] = nil,
		['RailsFolder'] = nil
	}
	
	return TrainID
end

return Utility.new() -- incase more than 1 train exists, we want it to use the same meta
