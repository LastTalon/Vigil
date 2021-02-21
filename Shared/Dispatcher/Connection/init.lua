--- An abstract Connection to be used by a Dispatcher.
-- The Connection provides an interface between the Dispatcher and an external
-- recipient. It handles interface details while the Dispatcher remains
-- recipient agnostic.
--
-- @author LastTalon
-- @version 0.1.0, 2020-10-19
-- @since 0.2
--
-- @module Connection
-- @field Receive the event registrar of the connection
--
-- @see Dispatcher

local Console = require(game:GetService("ReplicatedStorage"):WaitForChild("Scripts"):WaitForChild("Console")).sourced("Connection")

-- Variables --
Console.log("Initializing variables...")

local Connection = {}

-- Local Objects --
Console.log("Constructing objects...")

Connection.__index = Connection

--- The default constructor.
-- Creates a new Connection.
--
-- @return the new Connection
function Connection.new()
	local self = setmetatable({}, Connection)
	return self
end

--- Fire an activation.
--
-- @param command the command being activated
-- @param arguments the arguments to be passed with the command
function Connection:activate(command, arguments)
	self.event:Fire(command, arguments)
end

--- Reports an activation.
-- The activation is then passed to whatever interface is being connected to.
--
-- @param command the command being activated
-- @param arguments arguments to be passed with the command
function Connection:Report()
	Console.warn("Report must be overridden and should not be called from Connection.")
end

-- End --
Console.log("Done.")

return Connection
