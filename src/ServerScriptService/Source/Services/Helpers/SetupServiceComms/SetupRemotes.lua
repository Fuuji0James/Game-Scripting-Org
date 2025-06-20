-- {Most Recent: 12/5/2025} //FUUJI
-- Status: Prototype

return function(Component_Tag, ListOfEvents: {}, Parent)
	local Remotes = {}

	for Suffix_Name, Type in ListOfEvents do
		local Event = Instance.new(Type[1])

		if Type[1] == "RemoteFunction" then
			local Callback: () -> () = Type[2]
			Event.OnServerInvoke = Callback
		end

		if Type[1] == "BindableFunction" then
			local Callback: () -> () = Type[2]
			Event.OnInvoke = Callback
		end

		Event.Name = `{Component_Tag}_{Suffix_Name}`
		Remotes[Suffix_Name] = Event
		Event.Parent = Parent
	end

	return Remotes
end
