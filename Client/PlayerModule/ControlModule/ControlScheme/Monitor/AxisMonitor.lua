--- A Monitor with an axis value.
-- Provides a floating point value for the Control being activated. This can be
-- thought of as a 1 dimensional vector.
--
-- @author LastTalon
-- @version 0.1.1, 2020-10-01
-- @since 0.1
--
-- @module AxisMonitor

local Console = require(game:GetService("ReplicatedStorage"):WaitForChild("Scripts"):WaitForChild("Console")).sourced("Axis Monitor")

-- Dependencies --
Console.log("Loading dependencies...")

local Monitor = require(script.Parent)
local BinaryMonitor = require(script.Parent:WaitForChild("BinaryMonitor"))
local InputType = require(script.Parent.Parent:WaitForChild("InputType"))
local Direction = require(script.Parent.Parent:WaitForChild("AxisDirection"))

-- Constants --
Console.log("Initializing constants...")

-- Direction floats
local directional_value = {
	[Direction.Up] = 1.0,
	[Direction.Down] = -1.0
}

-- Variables --
Console.log("Initializing variables...")

local AxisMonitor = Monitor.new()

-- Local Objects --
Console.log("Constructing objects...")

AxisMonitor.__index = AxisMonitor

--- The default constructor.
--
-- @return the new AxisMonitor
function AxisMonitor.new()
	local self = setmetatable({}, AxisMonitor)
	return self
end

--- Transforms the value to a floating point number.
-- For most binary InputTypes true is transformed to 1 and false transformed to
-- 0. For vector InputTypes the vector is transformed to a single axis of the
-- vector. For scheme InputTypes the scheme's Monitor is updated and the value
-- retrieved. An offset is applied to all InputTypes and all InputTypes get an
-- equal scale.
--
-- @param input the input that produced the value being transformed
-- @param value the value being transformed
-- @return the transformed value. A floating point number.
-- @return the scaling factor. Always 1, all scaling is even.
function AxisMonitor:transformValue(input, value)
	local inputType = input.Type
	local offset = (input.Offset or 0)
	if inputType == InputType.None or inputType == InputType.Keyboard or inputType == InputType.MouseButton or inputType == InputType.GamepadButton then
		return ((value and 1) or 0) + offset, 1
	elseif inputType == InputType.MouseMovement or inputType == InputType.GamepadDirection then
		if input.Code == Enum.KeyCode.ButtonL2 or input.Code == Enum.KeyCode.ButtonR2 then
			return value.Z + offset, 1
		else
			return value.Y + offset, 1
		end
	elseif inputType == InputType.Scheme then
		local valueType = type(value)
		if valueType == "boolean" then
			value = value and 1 or 0
		elseif valueType == "userdata" then
			local robloxType = typeof(valueType)
			if robloxType == "Vector2" or robloxType == "Vector3" then
				value = value.X
			else
				Console.error("AxisMonitor encountered an unresolvable " .. robloxType .. " userdata type from scheme Input")
			end
		elseif valueType ~= "number" then
			Console.error("AxisMonitor encountered an unresolvable " .. valueType .. " type from scheme Input")
		end
		return value + offset, 1
	end
	return 0, 1
end

--- Adds two axis values together.
-- Combines the values using floating point addition.
--
-- @param lhs the left hand side operand of the add operation
-- @param rhs the right hand side operand of the add operation
-- @return the added value.
function AxisMonitor:addValue(original, new)
	return original + new
end

--- Scales an Input's value by a scaling factor.
-- Scales using floating point division.
--
-- @param value the value to be scaled
-- @param scale the scaling factor
-- @return the scaled value
function AxisMonitor:scaleValue(value, scale)
	return value / scale
end

--- Gets the default value of 0 for a AxisMonitor.
--
-- @return the default value. Always 0.
function AxisMonitor:defaultValue()
	return 0
end

--- Creates a Monitor for any entries with binary schemes.
--
-- @param entry the entry to process
-- function AxisMonitor:processEntry(entry)
-- 	if entry.Type == InputType.Scheme then
-- 		local scheme = entry.Code
-- 		entry.Code = {}
-- 		for id, _ in pairs(Direction) do
-- 			if scheme.ControlSet[id] ~= nil then
-- 				local monitor = BinaryMonitor.new()
-- 				monitor:Bind(scheme.ControlSet[id])
-- 				entry.Code[id] = monitor
-- 			end
-- 		end
-- 	end
-- end

-- End --
Console.log("Done.")

return AxisMonitor.new()
