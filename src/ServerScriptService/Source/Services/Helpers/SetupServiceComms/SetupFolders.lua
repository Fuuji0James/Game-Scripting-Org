return function(ComponentTag, Parent)
	-- This sets up all the folders that a given rig/client would use
	
	local AddListenerFolder = function(parent)
		local Folder = Instance.new("Folder")
		Folder.Name = ComponentTag.."_Remotes/Listeners"
		Folder.Parent = parent
		return Folder
	end
	
	return {AddListenerFolder(Parent)}
end