return function(Part: BasePart|Humanoid)
	-- In Air
	if Part:IsA('Humanoid') then
		Part = Part.RootPart
	end
	
	local ModelAnscestor = Part:FindFirstAncestorWhichIsA('Model')
	
	if ModelAnscestor == workspace then ModelAnscestor = Part end
	
	--
	local perams = RaycastParams.new();
	perams.FilterDescendantsInstances = {ModelAnscestor};
	perams.FilterType = Enum.RaycastFilterType.Exclude;
	perams.RespectCanCollide = true;
	perams.IgnoreWater = false;
	--

	local RayStart = Part.CFrame.Position; -- 3.5 studs ahead of player
	local RayDirection = -Part.CFrame.UpVector * 1; -- We just tell the ray to go straight down
	local RayResult = workspace:Raycast(RayStart, RayDirection * 3.5, perams); -- We ray 10 studs downwards

	return (RayResult == nil)
end