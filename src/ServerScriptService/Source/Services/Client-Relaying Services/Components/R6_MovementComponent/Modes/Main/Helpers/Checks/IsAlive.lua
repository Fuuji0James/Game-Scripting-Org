return function(Health: number|Humanoid)
	-- Is Alive
	if typeof(Health) == 'Instance' then if Health:IsA('Humanoid') then
			Health = Health.Health
		end
	end
	return (Health > 0)
end