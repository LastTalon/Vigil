--- The direction module.
--
-- @author LastTalon
-- @version 0.1.0, 2020-11-05
-- @since 0.1
--
-- @module DirectionModule

local Console = require(game:GetService("ReplicatedStorage"):WaitForChild("Scripts"):WaitForChild("Console")).sourced("Direction Module")

-- Variables --
Console.log("Initializing variables...")

local DirectionModule = {}
local instance

-- Local Objects --
Console.log("Constructing objects...")

DirectionModule.__index = DirectionModule

--- The contructor for the singleton.
-- Creates a new singleton if none exists. Always returns the same object
-- initially created.
--
-- @return the singleton
function DirectionModule.new()
	if instance == nil then
		local self = setmetatable({}, DirectionModule)
		instance = self
	end
	return instance
end

-- End --
Console.log("Done.")

return DirectionModule.new()
