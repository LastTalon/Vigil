--- An abstract Controller to be used by a Dispatcher.
-- The Controller is responsible for the update cycle of the Dispatcher that is
-- bound to it.
--
-- @author LastTalon
-- @version 0.1.0, 2020-10-19
-- @since 0.2
--
-- @module Controller
--
-- @see Dispatcher

local Console = require(game:GetService("ReplicatedStorage"):WaitForChild("Scripts"):WaitForChild("Console")).sourced("Controller")

-- Variables --
Console.log("Initializing variables...")

local Controller = {}

-- Local Objects --
Console.log("Constructing objects...")

Controller.__index = Controller

--- The default constructor.
-- Creates a new Controller, binding it to the dispatcher if one is provided.
--
-- @param dispatcher the dispatcher to bind
-- @return the new Controller
function Controller.new()
	local self = setmetatable({}, Controller)
	return self
end

--- Run the update cycle.
function Controller:update()
	self.Dispatcher:Update()
end

--- Binds a Dispatcher.
--
-- @param dispatcher the Dispatcher to bind
function Controller:Bind()
	Console.warn("Bind must be overridden and should not be called from Controller.")
end

--- Unbinds any Dispatcher.
-- Releases any additional resources associated with the update.
function Controller:Unbind()
	Console.warn("Unbind must be overridden and should not be called from Controller.")
end

function Controller:Bound()
	return self.dispatcher ~= nil
end

-- End --
Console.log("Done.")

return Controller
