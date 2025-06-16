return function(Item: BasePart|Humanoid)
	-- Is Swimming
	if Item:IsA('Humanoid') then
		return (Item:GetState() == Enum.HumanoidStateType.Swimming)
	elseif Item:IsA('BasePart') then
		--Do voxel stuff
		
		local min = Item.Position - (1 * Item.Size)
		local max = Item.Position + (1 * Item.Size)	
		local region = Region3.new(min,max):ExpandToGrid(4)
		local material = workspace.Terrain:ReadVoxels(region,4)[1][1][1]
		
		return (material.Name == 'Water')
	end
end