local Promise = require(game.ReplicatedStorage.Packages.Utility.PromiseV4)
local MaxPossibleRunTimes = math.huge

return function(Signals: {RBXScriptSignal}, MaxRunTimes: number, Callbacks: {(any) -> (boolean)})
	local TimesRan = 0
	
	if MaxRunTimes == -1 then
		MaxRunTimes = MaxPossibleRunTimes
	end
	
	if Signals then
		for i, Signal: RBXScriptSignal in Signals do
			if typeof(Signal) == 'RBXScriptSignal' then
				Promise.new(function(resolve, reject, onCancel)
					local Fn = Callbacks[i] or Callbacks[i-1] or Callbacks
					local C

					C = Signal:Connect(function(...)
						local Success = Fn(...)

						TimesRan += 1

						if Success == true or TimesRan >= (MaxRunTimes or MaxPossibleRunTimes) then C:Disconnect() end
					end)
				end)
			elseif typeof(Signal) == "number" then
				task.delay(Signal, function()
					Callbacks[i]()
				end)
			end
		end	
			
	elseif Signals == nil then
		Callbacks[1]()
	end
end