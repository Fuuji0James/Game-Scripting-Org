return function(Plr: Player)
	if Plr:IsA("Player") then
		-- Get the values from datastore...
		-- But for now we just return the default values
		return require(script.DefaultMovementValues)
	else
		-- Return default values for all npcs // Might change later
		return require(script.DefaultMovementValues)
	end
end
