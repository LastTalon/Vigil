--- An abstract Command to be issued through a Dispatcher.
-- The Command is updated by the Dispatcher and listens to the Dispatcher for
-- other commands to respond to. This is an abstract class and should be used
-- to inherit from in other commands. It should not be instantiated directly.
--
-- @author LastTalon
-- @version 0.1.1, 2020-10-01
-- @since 0.1
--
-- @module Command
-- @field Name the name of this Command
--
-- @see Dispatcher

local Console = require(game:GetService("ReplicatedStorage"):WaitForChild("Scripts"):WaitForChild("Console")).sourced("Command")

-- Variables --
Console.log("Initializing variables...")

local Command = {}

-- Local Objects --
Console.log("Constructing objects...")

Command.__index = Command

--- The default constructor.
-- Creates a new Command with a blank name.
--
-- @return the new Command
function Command.new()
	local self = setmetatable({}, Command)
	return self
end

--- Updates the Command.
-- Performs all Command updates. Determines if the Command activates. The
-- command can activate multiple times with a single update. This should not be
-- called from the abstract class Command and should be overridden. This should
-- typically not be called directly and should be called by the associated
-- Dispatcher.
--
-- @param tick the current tick of the update
-- @return a table of all activations for this update
function Command:Update()
	Console.warn("Update must be overridden and should not be called from Command.")
	return {}
end

--- A listener for all Commands in the attached Dispatcher
-- Listens for incoming Commands and reacts accordingly. Often used to
-- determine whether or how to activate on the next update. This should
-- typically not be called directly and shoudl be called by the associated
-- Dispatcher.
--
-- @param ... all parameters passed by the activating command
function Command:Listener()
	Console.warn("Listener must be overridden and should not be called from Command.")
end

-- End --
Console.log("Done.")

return Command
