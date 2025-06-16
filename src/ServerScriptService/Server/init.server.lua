local Lighting = game:GetService("Lighting")
-- {Most Recent: 20/5/2025} //FUUJI
-- Status: Proto

-- Requires
local DebugFolder = game:GetService("ReplicatedStorage").Libraries["Debugging Tools"] -- dependent on the one in 'basic packages'
local Source = game:GetService("ServerScriptService").Source

local ComponentHandler = require(script.MW.ComponentHandler)
local ComponentsToLoad = Source.Services["Client-Relaying Services"].Components:GetChildren()
-- Requires

--funcs
local OnPlayerAdded = require(script.Testing.PlayerAdded)
local ECS_Independent = require(script.MW["ECS-Independent"])

OnPlayerAdded()
ECS_Independent()

for _, Service in Source.Services:GetDescendants() do
	coroutine.wrap(function()
		if Service:IsA("ModuleScript") then
			local Ms = require(Service)

			if typeof(Ms) == "table" then
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
