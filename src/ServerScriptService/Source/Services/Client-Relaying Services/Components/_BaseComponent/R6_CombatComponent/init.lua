local RF = game:GetService("ReplicatedFirst")
local RS = game:GetService("ReplicatedStorage")

local Libraries = RS.Libraries

local Promise = require(Libraries.PromiseV4)
local Tags = require(RF._Shared.TagList)

local Combat = {
	Tag = Tags.Components.Combat,
}

Combat.__index = Combat

return Combat
