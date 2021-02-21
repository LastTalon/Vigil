--- Dispatches Commands over Connections
-- Sends and receives any Commands between each other and over any bound
-- Connection as well as any listeners. Allows creation of a network of
-- Commands for communication between client and server, forming the backbone
-- of a protocol.
--
-- @author LastTalon
-- @version 0.2.0, 2020-10-19
-- @since 0.1
--
-- @module Dispatcher
-- @field OnCommand the Event registrar
--
-- @see Command
-- @see Connection
-- @see Event

local Console = require(game:GetService("ReplicatedStorage"):WaitForChild("Scripts"):WaitForChild("Console")).sourced("Dispatcher")

-- Dependencies --
Console.log("Loading dependencies...")

local Event = require(game:GetService("ReplicatedStorage"):WaitForChild("Scripts"):WaitForChild("Event"))

-- Variables --
Console.log("Initializing variables...")

local Dispatcher = {}

-- Local Objects --
Console.log("Constructing objects...")

Dispatcher.__index = Dispatcher

--- The Dispatcher constructor.
-- Creates a new Dispatcher, optionally binding it.
--
-- @param connection binds this Dispatcher if provided
-- @return the new Dispatcher
function Dispatcher.new(connection)
	local self = setmetatable({}, Dispatcher)
	self.event = Event.new()
	self.commands = {}
	self.unprocessed = {}
	self.tick = 0
	self.OnCommand = self.event.Registrar
	self:Bind(connection)
	return self
end

--- Receives command activations to be processed.
--
-- @param command the name of the Command to process
-- @param arguments the arguments passed with the Command
function Dispatcher:receive(command, arguments)
	local activation = {}
	activation.name = command
	activation.arguments = arguments
	table.insert(self.unprocessed, activation)
end

--- Updates the Dispatcher.
-- Progresses the Dispatcher's tick, updates all commands registered with this
-- Dispatcher and processes all commands for any listeners.
--
-- This should not normally be called directly, and should, instead, be called
-- by a Controller.
--
-- @see Controller
function Dispatcher:Update()
	self.tick = self.tick + 1
	for _, command in pairs(self.commands) do
		for _, arguments in ipairs(command:Update(self.tick)) do
			if self.connection then
				self.connection:Report(command.Name, arguments)
			end
			self.event:Fire(command.Name, arguments, true)
		end
	end
	for _, activation in ipairs(self.unprocessed) do
		self.event:Fire(activation.name, activation.arguments, false)
	end
	self.unprocessed = {}
end

function Dispatcher:Tick()
	return self.tick
end

--- Binds the Dispatcher to a Connection.
--
-- @param connection the Connection to bind to
-- @return true if the Connection was bound, false otherwise
function Dispatcher:Bind(connection)
	if not self.connection and connection ~= nil then
		self.connection = connection
		self.connectionEvent = connection.Receive:Connect(function(...) self:receive(...) end)
		return true
	end
	return false
end

--- Unbinds the Dispatcher.
function Dispatcher:Unbind()
	if self.connection then
		self.connection.Receive:Disconnect(self.connectionEvent)
		self.connection = nil
	end
end

--- Tells if the Dispatcher are currently bound to a Connection.
--
-- @return true if the Dispatcher is bound, false otherwise
function Dispatcher:Bound()
	return self.connection ~= nil
end

--- Registers a Command with this Dispatcher.
-- Automatically registers the Command's listener and updates the Command when
-- the Dispatcher updates.
--
-- @param command the Command to register
function Dispatcher:Register(command)
	if not self.commands[command.Name] then
		self.commands[command.Name] = command
		self.OnCommand:Connect(function(...) command:Listener(...) end)
		return true
	end
	return false
end

--- Deregisters a Command from this Dispatcher.
--
-- @param command the Command or name of the Command to deregister
function Dispatcher:Deregister(command)
	if type(command) == "string" then
		if self.commands[command] then
			self.commands[command] = nil
			return true
		end
	elseif self.commands[command.Name] then
		self.commands[command.Name] = nil
		return true
	end
	return false
end

-- End --
Console.log("Done.")

return Dispatcher
