-- {Most Recent: 16/5/2025} //FUUJI
-- Status: Proto
-- This is going to house all of the basic actionutil functions


--Services
local RF = game:GetService('ReplicatedFirst')
local RS = game:GetService('ReplicatedStorage')
local CS = game:GetService('CollectionService')
local SSS = game:GetService('ServerScriptService')
local Players = game:GetService('Players')
--Services

-- Packs
local ServerBasicPackages = game:GetService('ServerScriptService').Packs.BasicPackages_Server
local SharedBasicPackages = game:GetService('ReplicatedFirst').Packs.BasicPackages_Shared
local SharedMovementPackages = RF.Packs.MovementPackages_Shared
local ServerMovementPackages = SSS.Packs.MovementPackages_Server
-- Packs

---

local AnimsFolder = SharedMovementPackages.Assets.Animations
local Helpers = RF.Packs.BasicPackages_Shared.Helpers
local ActionUtils = ServerMovementPackages.Utility.ActionUtils


local onInvoke = require(script.funcs.OnInvoke)
local getDataValues = require(script.funcs.GetDataValues)
local switchToSubset = require(script.funcs.SwitchToSubset)

---

--Modules
--local Types = require(game.ReplicatedStorage.Utility.GLOBAL.Types)
--local InputEnums = require(game.ReplicatedStorage.Utility.Movement.Enums)
local Tags = require(Helpers.TagList)
local Promise = require(RS.Libraries.PromiseV4)
local ComponentHandler = require(ServerBasicPackages.ComponentHandler)
local SetupRemotes = require(Helpers.Services.SetupRemotes)
--Modules


local R6_MovementComponent = {
	Tag = Tags.Components.Movement
}

R6_MovementComponent.__index = R6_MovementComponent

local function SetupFLC(self, Prefix: string, RemoteType: string) ---Folders then Listeners then Connections
	--Folders
	local ListenerFolder = Instance.new('Folder')
	ListenerFolder.Name = self.Tag.."_Remotes/Listeners"
	ListenerFolder.Parent = self['Player'].Remotes or self['Bot'].Remotes

	self['CreatedFolders'] = {['Listeners'] = ListenerFolder}	
	--Folders


	--Listeners
	local OnInvoke = function(...)
		onInvoke(self, ComponentHandler, ...)
	end

	self['Listeners'] = SetupRemotes(
		self.Tag,
		{
			[`{Prefix}ToServer`] = {`{RemoteType}Function`, OnInvoke};
		},
		self['CreatedFolders']['Listeners']
	)
	--Listeners

	--Connections
	self.Connections = {
		--//Switching to the right actionutil
		--self['MovementDataValues'].Changed:Connect(function(index: any, value: any)
		--	if index == 'Current_Set' then
		--		-- This is like your stance
		--		if value == 'Swimming' then
		--			switchToSubset(MainActionUtil.Set_Swimming, self)
		--		elseif value == 'Gliding' then
		--			switchToSubset(MainActionUtil.Set_Gliding, self)	
		--		end
		--	end
		--end),
		
		--self.Rig:FindFirstChildOfClass("Humanoid").Died:Once(function()
			
		--end),
	}
	--Connections
end

function R6_MovementComponent.new(Rig: Types.Rig_R6)
	-- Tag just got added to a rig

	local MainActionUtil = require(ActionUtils.Main)

	local self = setmetatable({
		--regular
		['Connections'] = nil;-- Houses all the connections so i can disconncet easily :)
		['Listeners'] = nil;-- This houses all cloned events so i can delete easily :)
		['CreatedFolders'] = nil;-- This houses all created folders so i can delete easily :)
		['ForceEnabled'] = true;
		--regular
	}, R6_MovementComponent)

	--unique
	self['AnimationsFolder'] = AnimsFolder
	self['MainActionUtil'] = MainActionUtil -- A big util basically
	self['MovementDataValues'] = getDataValues() -- CanDash, JumpHeight, etc..// With all the datavals in it		
	self['CurrentActionUtil'] = self['MainActionUtil'] -- Which subset you're using
	--unique

	--

	-- Determining the "Client"
	local Prefix = ''
	local RemoteType = ''

	local isPlayer = Rig:HasTag(Tags.PlayerTag)

	if isPlayer then
		self['Player'] = Players:GetPlayerFromCharacter(Rig) -- For easy syntax

		Prefix = "Client"
		RemoteType = "Remote"
	else
		self['Bot'] = Rig

		Prefix = "Server"
		RemoteType = "Bindable"
	end
	--Determining the "Client"

	self.Rig = Rig --or Rig.Rig
	SetupFLC(self, Prefix, RemoteType)

	print(`[Start] || Movement Component attributes for: {Rig.Name}`)
	print(self)	
	
	return self
end

function R6_MovementComponent:Destroy(Message: string)
	local Name = self.Rig.Name
	
	-- Destroying remotes
	for _, Remote: Instance in self['Listeners'] do
		if not Remote then continue end
		if typeof(Remote) == "Instance" then
			Remote:Destroy()
		end
	end
	
	-- Destroying Folders
	for _, Folder: Folder in self.CreatedFolders do
		if not Folder then continue end
		if typeof(Folder) == "Instance" then
			Folder:Destroy()
		end
	end
	
	-- Destroying Connections
	for _, Connection: RBXScriptConnection in self.Connections do
		if not Connection then continue end
		if typeof(Connection) == "RBXScriptConnection" then
			Connection:Disconnect()
		end
	end
	
	setmetatable(self, nil)
	
	print(`[End] || Movement Component for {Name} was Destroyed due to '{Message or 'Unknown Disconnection'}'.`)
end

--


return R6_MovementComponent
