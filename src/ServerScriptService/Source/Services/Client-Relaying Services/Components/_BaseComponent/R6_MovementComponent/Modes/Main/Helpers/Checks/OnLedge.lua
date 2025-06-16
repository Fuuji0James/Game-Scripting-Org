return function(Item: BasePart|Humanoid, InAir: boolean, Depth: number, distFromStart: number)
	-- On Ledge
	if InAir == true then return end
	
	-- This runs automatically assuming you're not in the air
	
	if Item:IsA('Humanoid') then
		Item = Item.RootPart
	end
	
	local Parent = Item:FindFirstAncestorWhichIsA('Model')
	if Parent == workspace then Parent = Item end
	
	local Start = Item.CFrame.Position + Item.CFrame.LookVector * (distFromStart or 2)
	local Vector = Vector3.new(0,-1,0) * (Depth or 20)
	local p = RaycastParams.new()
	p.FilterDescendantsInstances = {Parent}
	p.FilterType = Enum.RaycastFilterType.Exclude
	p.IgnoreWater = true
	
	return (workspace:Raycast(Start, Vector, p) == nil)
end