--- A Monitor with a binary value.
-- Provides a value of either true if the Control is activated, or false, if
-- its not. Does not provide any scaling, any portion of the Control activates,
-- the BinaryMonitor will be activated.
--
-- @author LastTalon
-- @version 0.1.1, 2020-10-01
-- @since 0.1
--
-- @module BinaryMonitor

local Console = require(game:GetService("ReplicatedStorage"):WaitForChild("Scripts"):WaitForChild("Console")).sourced("Binary Monitor")

-- Dependencies --
Console.log("Loading dependencies...")

local Monitor = require(script.Parent)
local InputType = require(script.Parent.Parent:WaitForChild("InputType"))

-- Variables --
Console.log("Initializing variables...")

local BinaryMonitor = Monitor.new()

-- Local Objects --
Console.log("Constructing objects...")

BinaryMonitor.__index = BinaryMonitor

--- The default constructor.
--
-- @return the new BinaryMonitor
function BinaryMonitor.new()
	local self = setmetatable({}, BinaryMonitor)
	return self
end

--- Transforms the value to true or false depending on the InputType.
-- For most InputTypes no transformation is done. For vector InputTypes
-- MouseMovement and GamepadDirection a non-zero vector is transformed to true,
-- while a zero vector is transformed to false.
--
-- @param input the input that produced the value being transformed
-- @param value the value being transformed
-- @return the transformed value. Either true or false.
-- @return the scaling factor. Always 0, no scaling is done.
function BinaryMonitor:transformValue(input, value)
	local type = input.Type
	if type == InputType.None or type == InputType.Keyboard or type == InputType.MouseButton or type == InputType.GamepadButton then
		return value, 0
	elseif type == InputType.MouseMovement or type == InputType.GamepadDirection then
		return value ~= Vector3.new(0, 0, 0), 0
	end
	return false, 0
end

--- Adds two binary values together.
-- Combines the values by treating 'or' as the adding operation. Either operand
-- being true will result in true, false otherwise.
--
-- @param lhs the left hand side operand of the add operation
-- @param rhs the right hand side operand of the add operation
-- @return the added value. True if lhs or rhs is true, false otherwise.
function BinaryMonitor:addValue(lhs, rhs)
	return lhs or rhs
end

--- Does no scaling.
-- The value is always returned as is.
--
-- @param value the value to be scaled
-- @return the original value with no scaling applied
function BinaryMonitor:scaleValue(value)
	return value
end

--- Gets the default value of false for a BinaryMonitor.
--
-- @return the default value. Always false.
function BinaryMonitor:defaultValue()
	return false
end

-- End --
Console.log("Done.")

return BinaryMonitor.new()
