local RunningCooldowns = {}

return function(Timeout: number, DataValues: {}, DebounceValues: {}, Callback: () -> ())
	-- If they dont have the cooldown value in their table, roblox adds it as false
	
	if DebounceValues then
		for _, DebounceValue in DebounceValues do
			
			if DataValues[DebounceValue] == nil then
				warn(`Movement value: {DebounceValue} doesnt exist, see 'MovementDataValues' for more:`, DataValues)
				continue
			end
			
			DataValues[DebounceValue] = not DataValues[DebounceValue]
		end
	end
	
	
	task.delay(Timeout, function()
		if DebounceValues then
			coroutine.wrap(function()
				if Callback then
					Callback()
				end
			end)()
			
			for _, DebounceValue in DebounceValues do
				DataValues[DebounceValue] = not DataValues[DebounceValue]
			end
		end
	end)	
end
