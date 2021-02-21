--- The main control module.
-- A singleton object responsible for accepting all inputs from the player and
-- interpretting controls. It recieves input from the user and fires
-- corresponding events. Recieves input based on provided ControlSchemes.
--
-- @author LastTalon
-- @version 0.1.1, 2020-11-14
-- @since 0.1
--
-- @module ControlModule

local Console = require(game:GetService("ReplicatedStorage"):WaitForChild("Scripts"):WaitForChild("Console")).sourced("Control Module")

-- Dependencies --
Console.log("Loading dependencies...")

local Player = game:GetService("Players").LocalPlayer
local SharedScripts = game:GetService("ReplicatedStorage"):WaitForChild("Scripts")

local Event = require(SharedScripts:WaitForChild("Event"))

-- Functions --
Console.log("Constructing functions...")

-- The default move listener.
local function onMove(value)
	Player:Move(value)
end

-- The default direction listener.
local function onDirection(value)
	-- TODO: Add default direction listener.
end

-- The default camera listener.
local function onCamera(value)
	-- TODO: Add default camera listener.
end

-- Variables --
Console.log("Initializing variables...")

local ControlModule = {}
local instance

-- Local Objects --
Console.log("Constructing objects...")

ControlModule.__index = ControlModule

--- The constructor for the singleton.
-- Creates a new singleton if none exists. This always returns same object
-- initially created.
--
-- @return the singleton
function ControlModule.new()
	if instance == nil then
		local self = setmetatable({}, ControlModule)
		self.bindings = {}
		self.event = Event.new()
		self.OnCommand = self.event.Registrar
		instance = self
	end
	return instance
end

--- A generic listener function that activates another listener on a specific
-- command.
function ControlModule.ListenForCommand(command, fn)
	local listener = function(trigger, value)
		if trigger == command then
			fn(value)
		end
	end
	return listener
end

--- Sets the command name for the move action.
-- Sets the default move action to be active and activate on the provided
-- command name.
--
-- @param command the name of the command to activate on
function ControlModule:SetMove(command)
	if self.moveListener == nil then
		self.moveListener = self.OnCommand:Connect(self.ListenForCommand(command, onMove))
	end
end

--- Deactivates the default move action.
function ControlModule:UnsetMove()
	if self.moveListener ~= nil then
		self.OnCommand:Disconnect(self.moveListener)
		self.moveListener = nil
	end
end

--- Sets the command name for the direction action.
-- Sets the default direction action to be active and activate on the provided
-- command name.
--
-- @param command the name of the command to activate on
function ControlModule:SetDirection(command)
	if self.directionListener == nil then
		self.directionListener = self.OnCommand:Connect(self.ListenForCommand(command, onDirection))
	end
end

--- Deactivates the default direction action.
function ControlModule:UnsetDirection()
	if self.directionListener ~= nil then
		self.OnCommand:Disconnect(self.directionListener)
		self.directionListener = nil
	end
end

--- Sets the command name for the camera action.
-- Sets the default camera action to be active and activate on the provided
-- command name.
--
-- @param command the name of the command to activate on
function ControlModule:SetCamera(command)
	if self.cameraListener == nil then
		self.cameraListener = self.OnCommand:Connect(self.ListenForCommand(command, onCamera))
	end
end

--- Deactivates the default camera action.
function ControlModule:UnsetCamera()
	if self.cameraListener ~= nil then
		self.OnCommand:Disconnect(self.cameraListener)
		self.cameraListener = nil
	end
end

--- Tells if any ControlScheme is currently bound.
--
-- @return true if a ControlScheme is bound, false otherwise
function ControlModule:Bound()
	return #self.bindings ~= 0
end

--- Provides the active ControlScheme.
--
-- @return the active ControlScheme if one exists, nil otherwise
function ControlModule:BoundTo()
	return self.bindings[#self.bindings]
end

--- Binds the ControlScheme to be monitored.
-- The ControlScheme will be added to the top of the binding stack, overriding
-- previously bound ControlSchemes.
--
-- @param scheme the ControlScheme to bind
function ControlModule:Bind(scheme)
	table.insert(self.bindings, scheme)
end

--- Unbinds the most recently bound ControlScheme.
-- The previous most recently bound ControlScheme will become active.
function ControlModule:Unbind()
	if self:Bound() then
		table.remove(self.bindings)
	end
end

--- Unbinds all ControlSchemes.
function ControlModule:UnbindAll()
	self.bindings = {}
end

--- Updates the ControlModule and active ControlScheme.
function ControlModule:Update()
	if self:Bound() then
		local controlScheme = self:BoundTo()
		for name, control in controlScheme:Controls() do
			local monitor = control:GetMonitor()
			if monitor ~= nil then
				monitor:Update()
				if monitor:Updated() then
					self.event:Fire(name, monitor:Value())
				end
			else
				Console.warn("Control " .. name .. " in active ControlScheme has no Monitor.")
			end
		end
	end
end

-- End --
Console.log("Done.")

return ControlModule.new()
