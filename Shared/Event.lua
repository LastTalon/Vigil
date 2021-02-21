--- An general purpose event.
-- It can accept multiple listener functions that all actiavte when fired. It
-- includes a registrar and activator that allow a separation of listeners and
-- activators.
--
-- @author LastTalon
-- @version 0.1.0, 2020-03-31
-- @since 0.1
--
-- @module Event
-- @field Registrar allows connecting and disconnecting listeners. Has the same
-- Connect and Disconnect methods as the Event.
-- @field Activator allows firing the Event. Has the same Fire method as the
-- Event.

local Console = require(game:GetService("ReplicatedStorage"):WaitForChild("Scripts"):WaitForChild("Console")).sourced("Event")

-- Variables --
Console.log("Initializing variables...")

local Event = {}

-- Local Objects --
Console.log("Constructing objects...")

Event.__index = Event

--- The default Event constructor.
-- Creates a new empty Event with a registrar and activator.
--
-- @return the new Event
function Event.new()
	local self = setmetatable({}, Event)
	self.listeners = {}
	self.Registrar = {}
	self.Registrar.listeners = self.listeners
	self.Registrar.Connect = self.Connect
	self.Registrar.Disconnect = self.Disconnect
	self.Activator = {}
	self.Activator.listeners = self.listeners
	self.Activator.Fire = self.Fire
	return self
end

--- Connects a new listener.
-- The listener will be activated every time the event fires. Activation order
-- of listeners is not guaranteed, but all listeners will activate at the same
-- time before execution resumes elsewhere.
--
-- @param fn the listening function to connect
-- @return the id of the listener
function Event:Connect(fn)
	table.insert(self.listeners, fn)
	return #self.listeners
end

--- Disconnects a listener.
-- Disconnects a listener that was perviously connected so that it will no
-- longer fire when the Event is activated.
--
-- @param id the id of the listener to disconnect
function Event:Disconnect(id)
	table.remove(self.listeners, id)
end

--- Fires the Event and activates any listeners.
-- Immediately activates and blocks until all listeners are activated.
--
-- @param ... parameters to pass to all listeners
function Event:Fire(...)
	for _, fn in ipairs(self.listeners) do
		coroutine.resume(coroutine.create(fn), ...)
	end
end

-- End --
Console.log("Done.")

return Event
