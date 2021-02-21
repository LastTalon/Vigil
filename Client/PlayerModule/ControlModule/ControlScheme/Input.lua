--- A user input definition.
-- Represents an input that a user could provide. Defines the particular user
-- input conditions that will trigger this Input.
--
-- @author LastTalon
-- @version 0.1.0, 2020-04-16
-- @since 0.1
--
-- @module Input
-- @field Type the InputType of this Input
-- @field Code the code for this input. A code may not be necessary depending on
-- the input type. Should be an Enum.KeyCode, ControlScheme,
-- Enum.UserInputType, DirectionMethod, or nil.
-- @field Offset the amount to displace this Input's value by before being
-- used. Should be a UDim, UDim2, or nil.
-- @field Devices the array of devices this Input should trigger for. Should be
-- an array of Enum.UserInputType.
--
-- @see Control

local Console = require(game:GetService("ReplicatedStorage"):WaitForChild("Scripts"):WaitForChild("Console")).sourced("Input")

-- Variables --
Console.log("Initializing variables...")

local Input = {}

-- Local Objects --
Console.log("Constructing objects...")

Input.__index = Input

--- The parameterized constructor.
-- Creates a new Input object with all of its fields set.

-- @param type the type of the new Input
-- @param code the code of the new Input
-- @param offset the offset of the new Input
-- @param devices the array of devices of the new Input
-- @return the new Input
function Input.new(type, code, offset, devices)
	local self = setmetatable({}, Input)
	self.Type = type
	self.Code = code
	self.Offset = offset
	self.Devices = devices
	return self
end

-- End --
Console.log("Done.")

return Input
