--- A Monitor with an vector value.
-- Provides a two dimensional vector value for the Control being activated.
--
-- @author LastTalon
-- @version 0.1.1, 2020-10-01
-- @since 0.1
--
-- @module VectorMonitor

local Console = require(game:GetService("ReplicatedStorage"):WaitForChild("Scripts"):WaitForChild("Console")).sourced("Vector Monitor")

-- Dependencies --
Console.log("Loading dependencies...")

local Monitor = require(script.Parent)
local AxisMonitor = require(script.Parent:WaitForChild("AxisMonitor"))
local InputType = require(script.Parent.Parent:WaitForChild("InputType"))
local Direction = require(script.Parent.Parent:WaitForChild("VectorDirection"))

-- Constants --
Console.log("Initializing constants...")

-- Direction vectors
local directional_value = {
	[Direction.Vertical] = Vector2.new(0, 1),
	[Direction.Horizontal] = Vector2.new(1, 0)
}

-- Variables --
Console.log("Initializing variables...")

local VectorMonitor = Monitor.new()

-- Local Objects --
Console.log("Constructing objects...")

VectorMonitor.__index = VectorMonitor

--- The default constructor.
--
-- @return the new VectorMonitor
function VectorMonitor.new()
	local self = setmetatable({}, VectorMonitor)
	return self
end

--- Transforms the value to a Vector2.
-- For most binary InputTypes true is transformed to (0, 1) and false
-- transformed to (0, 0). For vector InputTypes the Vector3 is transformed to
-- Vector2 with the axes being dropped depending on the InputType. For scheme
-- InputTypes the scheme's Monitor is updated and the value retrieved. An
-- offset is applied to all InputTypes and all InputTypes get an equal scale.
--
-- @param input the input that produced the value being transformed
-- @param value the value being transformed
-- @return the transformed value. A Vector2.
-- @return the scaling factor. Always 1, all scaling is even.
function VectorMonitor:transformValue(input, value)
	local type = input.Type
	local offset = (input.Offset or Vector2.new(0, 0))
	if type == InputType.None or type == InputType.Keyboard or type == InputType.MouseButton or type == InputType.GamepadButton then
		return ((value and Vector2.new(0, 1)) or Vector2.new(0, 0)) + offset, 1
	elseif type == InputType.MouseMovement or type == InputType.GamepadDirection then
		if input.Code == Enum.KeyCode.ButtonL2 or input.Code == Enum.KeyCode.ButtonR2 then
			return Vector2.new(0, value.Z) + offset, 1
		else
			return Vector2.new(value.X, value.Y) + offset, 1
		end
	elseif type == InputType.Scheme then
		local schemeValue = Vector2.new(0, 0)
		for id, enum in pairs(Direction) do
			local monitor = input.Code[id]
			schemeValue = schemeValue + (directional_value[enum] * monitor:Update())
		end
		return schemeValue + offset, 1
	end
	return Vector2.new(0, 0), 1
end

--- Adds two vector values together.
-- Combines the values using vector addition.
--
-- @param lhs the left hand side operand of the add operation
-- @param rhs the right hand side operand of the add operation
-- @return the added value.
function VectorMonitor:addValue(original, new)
	return original + new
end

--- Scales an Input's value by a scaling factor.
-- Scales using scalar division.
--
-- @param value the value to be scaled
-- @param scale the scaling factor
-- @return the scaled value
function VectorMonitor:scaleValue(value, scale)
	return value / scale
end

--- Gets the default value of (0, 0) for a VectorMonitor.
--
-- @return the default value. Always (0, 0).
function VectorMonitor:nullValue()
	return Vector2.new(0, 0)
end

--- Creates a Monitor for any entries with axis schemes.
--
-- @param entry the entry to process
function VectorMonitor:processEntry(entry)
	if entry.Type == InputType.Scheme then
		local scheme = entry.Code
		entry.Code = {}
		for id, _ in pairs(Direction) do
			if scheme.ControlSet[id] ~= nil then
				local monitor = AxisMonitor.new()
				monitor:Bind(scheme.ControlSet[id])
				entry.Code[id] = monitor
			end
		end
	end
end

--- Does no cleaning.
-- VectorMonitor keeps no special state, so no special cleaning is needed.
function VectorMonitor:clean()
end

-- End --
Console.log("Done.")

return VectorMonitor.new()
