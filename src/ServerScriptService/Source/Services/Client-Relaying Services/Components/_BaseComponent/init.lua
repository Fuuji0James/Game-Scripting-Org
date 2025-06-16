-- BASE COMPONENT THAT OFFSHOOTS INTO INDIVIDUALS (Movement, Combat, etc.)
local SSS = game:GetService("ServerScriptService")
local RF = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")

local ComponentFolder = SSS.Source.Services["Client-Relaying Services"].Components
local ComponentSets = ComponentFolder.ComponentSets

local Tags = require(RF._Shared.TagList)
local SetupFolders = require(SSS.Source.Services.Helpers.SetupServiceComms.SetupFolders)
local SetupRemotes = require(SSS.Source.Services.Helpers.SetupServiceComms.SetupRemotes)

local BaseComponent = {}

BaseComponent.__index = BaseComponent

function BaseComponent.new(Name: string, Rig: Model, OnInvoke)
	local Component = {
		Name = Name,
		Connections = nil,
		Listeners = nil,
		CreatedFolders = nil,
		[`{Name}Set`] = require(ComponentSets[`{Name}Set`]),
		[`{Name}DataValues`] = nil,

		IsClient = nil,
	}

	-- Determining the Client

	local Prefix
	local RemoteType

	local isPlayer = Rig:HasTag(Tags.PlayerTag)

	if isPlayer then
		Component["Player"] = Players:GetPlayerFromCharacter(Rig) -- For easy syntax

		Prefix = "Client"
		RemoteType = "Remote"
	else
		Component["Bot"] = Rig

		Prefix = "Server"
		RemoteType = "Bindable"
	end

	-- Setting up folders/listeners

	Component.CreatedFolders = SetupFolders(Name, Component["Player"] or Component["Bot"])
	Component.Listeners = SetupRemotes(Name, {
		[`{Prefix}ToServerEvent`] = { `{RemoteType}Event`, nil },
		[`{Prefix}ToServer`] = { `{RemoteType}Function`, OnInvoke },
	}, Component.CreatedFolders[1])

	return Component
end

function BaseComponent:Destroy(Message: string)
	local Name = self.Rig.Name

	-- Destroying remotes
	for _, Remote: Instance in self["Listeners"] do
		if not Remote then
			continue
		end
		if typeof(Remote) == "Instance" then
			Remote:Destroy()
		end
	end

	-- Destroying Folders
	for _, Folder: Folder in self.CreatedFolders do
		if not Folder then
			continue
		end
		if typeof(Folder) == "Instance" then
			Folder:Destroy()
		end
	end

	-- Destroying Connections
	for _, Connection: RBXScriptConnection in self.Connections do
		if not Connection then
			continue
		end
		if typeof(Connection) == "RBXScriptConnection" then
			Connection:Disconnect()
		end
	end

	setmetatable(self, nil)

	print(`[End] || Movement Component for {Name} was Destroyed due to '{Message or "Unknown Disconnection"}'.`)
end

return BaseComponent
