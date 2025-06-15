-- {Most Recent: 13/05/2025}
-- Status: Must Edit

return function(ModuleScript, DataTable: self)
	-- Switch from one moveset type to another
	-- It just replaces functions

	local Set = require(ModuleScript)

	if Set.Start then
		Set.Start(DataTable)
		DataTable['CurrentMoveSet'].Enabled = false

		-- after Switching

		DataTable['CurrentMoveSet'] = Set
		DataTable['CurrentMoveSet'].Enabled = true
	else
		warn(`Add the dang start function please: {ModuleScript}`)
	end

	--return DataTable
end