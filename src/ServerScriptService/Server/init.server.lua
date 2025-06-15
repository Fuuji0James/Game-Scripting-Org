-- {Most Recent: 20/5/2025} //FUUJI
-- Status: Proto

-- Requires
local SharedBasicPackages = game:GetService('ReplicatedFirst').Packs.BasicPackages_Shared
local ServerBasicPackages = game:GetService('ServerScriptService').Packs.BasicPackages_Server
local DebugFolder = SharedBasicPackages.Debugging -- dependent on the one in 'basic packages'

local ComponentHandler = require(ServerBasicPackages.ComponentHandler)
local ComponentsToLoad = ServerBasicPackages.Services["Client-Relaying Services"].Components:GetChildren()
-- Requires

--funcs
local OnPlayerAdded = require(script.Testing.PlayerAdded)
local ECS_Independent = require(script.Testing["ECS-Independent"])

OnPlayerAdded()
ECS_Independent()

for _, Service in ServerBasicPackages.Services:GetDescendants() do
	coroutine.wrap(function()
		if Service:IsA("ModuleScript") then
			local Ms = require(Service)

			if typeof(Ms) == 'table' then
				if Ms.Init then
					Ms:Init()
				end
			end
		end
	end)()
end

ComponentHandler.AddComponentToGame(ComponentsToLoad)


-- debugging (studio only)

if game:GetService("RunService"):IsStudio() then
	local LocalPublisher = require(DebugFolder.Utility.LocalPublisher)
	LocalPublisher:createLocalAnimationsStudio()
end