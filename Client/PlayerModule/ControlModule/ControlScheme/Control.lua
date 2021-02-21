--- A control mapping of user inputs.
-- Keeps several Inputs that represent a single control action. Includes the
-- name, description, and set of Inputs. This is used to represent a particular
-- action in a game a user can perform when some combination of user input is
-- given.
--
-- @author LastTalon
-- @version 0.1.1, 2020-11-06
-- @since 0.1
--
-- @module Control
-- @field Inputs the set of Inputs that triggers this Control
-- @field Name the name of this Control
-- @field Description the description of this Control
-- @field Method the ControlMethod for this Control
--
-- @see Input
-- @see ControlMethod

local Console = require(game:GetService("ReplicatedStorage"):WaitForChild("Scripts"):WaitForChild("Console")).sourced("Control")

-- Dependencies --
Console.log("Loading dependencies...")

local Input = require(script.Parent:WaitForChild("Input"))

-- Variables --
Console.log("Initializing variables...")

local Control = {}

-- Local Objects --
Console.log("Constructing objects...")

Control.__index = Control

--- The parameterized constructor.
-- Creates a new empty control object with all parameters set.
--
-- @param name the name of the Control
-- @param description the description of the Control
-- @param method the ControlMethod of the Control
-- @return the new Control
function Control.new(name, description, method)
	local self = setmetatable({}, Control)
	self.InputSet = {}
	self.Name = name
	self.Description = description
	self.Method = method
	return self
end

--- Adds a new Input to this control.
-- Adds the specified Input. If none is specified it creates a new Input. It
-- then returns the Input that was added.
--
-- @param id the id of the Input
-- @param input the Input to add
-- @return the Input added
function Control:Add(id, input)
	input = input or Input.new()
	self.InputSet[id] = input
	return input
end

--- Gets and Input of this control.
-- Gets the Input at the specified id.
--
-- @param id the id of hte Input
-- @return the Input
function Control:Get(id)
	return self.InputSet[id]
end

--- Removes an Input from this control.
-- Removes the Input with the specified id.
--
-- @param id the id of the Input to remove
function Control:Remove(id)
	self.InputSet[id] = nil
end

--- The iterator for this Control
-- Iterates over all Inputs in this Control.
--
-- @return the iterator
function Control:Inputs()
	return pairs(self.InputSet)
end

--- Sets this Control's Monitor and binds it.
--
-- @param monitor the Monitor
function Control:SetMonitor(monitor)
	if self.monitor ~= nil then
		self.monitor:Unbind()
	end
	self.monitor = monitor
	if monitor ~= nil then
		monitor:Bind(self)
	end
end

--- Gets this Control's Monitor.
--
-- @return the Monitor
function Control:GetMonitor()
	return self.monitor
end

-- End --
Console.log("Done.")

return Control
