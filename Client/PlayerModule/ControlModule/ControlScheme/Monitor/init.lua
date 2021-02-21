--- An abstract Monitor for tracking inputs.
-- A monitor is used to keep track of the inputs of a single Control. This is an
-- abstract class and should be used to inherit from in other monitors. It
-- should not be instantiated directly.
--
-- @author LastTalon
-- @version 0.1.1, 2020-10-01
-- @since 0.1
--
-- @module Monitor

local Console = require(game:GetService("ReplicatedStorage"):WaitForChild("Scripts"):WaitForChild("Console")).sourced("Monitor")

-- Dependencies --
Console.log("Loading dependencies...")

local UserInputService = game:GetService("UserInputService")

local InputType = require(script.Parent:WaitForChild("InputType"))
local DirectionMethod = require(script.Parent:WaitForChild("DirectionMethod"))

-- Functions --
Console.log("Constructing functions...")

local function getDeviceInput(code, device)
	local inputs = UserInputService:GetGamepadState(device)
	for _, input in ipairs(inputs) do
		if input.KeyCode == code then
			return input
		end
	end
end

-- Variables --
Console.log("Initializing variables...")

local Monitor = {}

-- Local Objects --
Console.log("Constructing objects...")

Monitor.__index = Monitor

--- The default constructor.
-- Creates a new, unbound Monitor.
--
-- @return the new Monitor
function Monitor.new()
	local self = setmetatable({}, Monitor)
	self.updated = false
	return self
end

--- Tells if this Monitor is currently bound.
--
-- @return true if bound, false otherwise
function Monitor:Bound()
	return self.control ~= nil
end

--- Gets this Monitor's value.
--
-- @return the value
function Monitor:GetValue()
	return self.value
end

--- Tells if this Monitor's value has changed.
-- This will be true if the value of the input changed during the last update.
--
-- @return true if updated, false otherwise
function Monitor:Updated()
	return self.updated
end

--- Updates the value of this Monitor.
-- Gathers all Inputs and updates the value of this Monitor's input based on
-- the scaling of this Monitor. This method should not typically be called
-- directly and should be called by the ControlModule.
--
-- @return the value
-- @throws error when an input has an invalid enum
--
-- @see Input
-- @see ControlModule
function Monitor:Update()
	local value = self:defaultValue()
	local scale = 0

	if self:Bound() then
		for _, input in self.control:Inputs() do
			local inputValue
			local valid = true

			-- Get specific input
			if input.Type == InputType.None then
				inputValue = false
			elseif input.Type == InputType.Keyboard then
				inputValue = UserInputService:IsKeyDown(input.Code)
			elseif input.Type == InputType.MouseButton then
				inputValue = UserInputService:IsMouseButtonPressed(input.Code)
			elseif input.Type == InputType.MouseMovement then
				if input.Code == DirectionMethod.None then
					inputValue = Vector3.new(0, 0, 0)
				elseif input.Code == DirectionMethod.Absolute then
					inputValue = UserInputService:GetMouseLocation()
				elseif input.Code == DirectionMethod.Relative then
					inputValue = UserInputService:GetMouseDelta()
				else
					Console.error("Input has invalid direction method.")
					valid = false
				end
			elseif input.Type == InputType.GamepadButton then
				inputValue = UserInputService:IsGamepadButtonDown(input.Device, input.Code)
			elseif input.Type == InputType.GamepadDirection then
				if input.Code == DirectionMethod.None then
					inputValue = Vector3.new(0, 0, 0)
				elseif input.Code == DirectionMethod.Absolute then
					local deviceInput = getDeviceInput(input.Code, input.Device)
					if deviceInput == nil then
						inputValue = Vector3.new(0, 0, 0)
					else
						inputValue = deviceInput.Position
					end
				elseif input.Code == DirectionMethod.Relative then
					local deviceInput = getDeviceInput(input.Code, input.Device)
					if deviceInput == nil then
						inputValue = Vector3.new(0, 0, 0)
					else
						inputValue = deviceInput.Delta
					end
				else
					Console.error("Input has invalid direction method.")
					valid = false
				end
			elseif input.Type == InputType.Scheme then
				inputValue = input.Code
			else
				Console.error("Input has invalid type.")
				valid = false
			end

			if valid then
				local inputScale
				inputValue, inputScale = self:transformValue(input, inputValue)
				value = self:addValue(value, inputValue)
				scale = scale + inputScale
			end
		end
	end

	value = self:scaleValue(value, scale)
	self.updated = self.value ~= value
	self.value = value
end

--- Binds a Control to this Monitor.
-- Only one Control can be bound at a time. At the time of binding all Inputs
-- of the Control are processed and added to the Monitor. Any changes to the
-- Control after its bound will not be reflected in the Monitor's operation.
--
-- @param control the Control to bind
function Monitor:Bind(control)
	if not self:Bound() then
		self.control = control
	end
end

--- Unbinds this Monitor from any Control it may be bound to.
-- Automatically resets this Monitor.
function Monitor:Unbind()
	self.control = nil
end

--- Transforms an Input's value for this Monitor based on its InputType.
-- The Monitor, InputType, and offset of the Input are used to transform the
-- value accordingly during the transform step of this Monitor's update.
-- Typically this means converting the value to the appropriate type and'
-- applying the offset accordingly. During this process a scaling factor may be
-- produced. This should not be called from the abstract class Monitor and
-- should be overridden. This should typically not be called directly and
-- should be called by the associated Monitor's update.
--
-- @param input the input that produced the value being transformed
-- @param value the value being transformed
-- @return the transformed value
-- @return the scaling factor
function Monitor:transformValue()
	Console.warn("updateInput must be overridden and should not be called from Monitor.")
end

--- Adds two Inputs' values together based on this Monitor type.
-- Occurs during the accumulation step of this Monitor's update. This should
-- not be called from the abstract class Monitor and should be overridden. This
-- should typically not be called directly and should be called by the
-- associated Monitor's update.
--
-- @param lhs the left hand side operand of the add operation
-- @param rhs the right hand side operand of the add operation
-- @return the added value
function Monitor:addValue()
	Console.warn("addValue must be overridden and should not be called from Monitor.")
end

--- Scales an Input's value by a scaling factor.
-- Occurs during the scaling step of this Monitor's update. The scaling factor
-- is the same type of scaling factor returned by transformValue. This should
-- not be called from the abstract class Monitor and should be overridden. This
-- should typically not be called directly and should be called by the
-- associated Monitor's update.
--
-- @param value the value to be scaled
-- @param scale the scaling factor
-- @return the scaled value
function Monitor:scaleValue()
	Console.warn("scaleValue must be overridden and should not be called from Monitor.")
end

--- Gets the default value for this Monitor.
-- Occurs during the initialization step of this Monitor's update.
--
-- @return the default value
function Monitor:defaultValue()
	Console.warn("defaultValue must be overridden and should not be called from Monitor.")
end

-- End --
Console.log("Done.")

return Monitor.new()
