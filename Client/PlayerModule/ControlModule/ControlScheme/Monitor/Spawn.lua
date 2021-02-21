--- A Monitor spawning function.
-- Spawns the appropriate type of Monitor for the Control provided and
-- automatically binds it to the Monitor.
--
-- @author LastTalon
-- @version 0.1.0, 2020-04-14
-- @since 0.1
--
-- @module Spawn
--
-- @see Monitor

local Console = require(game:GetService("ReplicatedStorage"):WaitForChild("Scripts"):WaitForChild("Console")).sourced("Monitor Spawn")

-- Dependencies --
Console.log("Loading dependencies...")

local Method = require(script.Parent.Parent:WaitForChild("ControlMethod"))
local BinaryMonitor = require(script.Parent:WaitForChild("BinaryMonitor"))
local AxisMonitor = require(script.Parent:WaitForChild("AxisMonitor"))
local VectorMonitor = require(script.Parent:WaitForChild("VectorMonitor"))

-- Functions --
Console.log("Constructing functions...")

local function Spawn(control)
	local monitor
	if control.Method == Method.Binary then
		monitor = BinaryMonitor.new()
	elseif control.Method == Method.Axis then
		monitor = AxisMonitor.new()
	elseif control.Method == Method.Vector then
		monitor = VectorMonitor.new()
	end
	if monitor ~= nil then
		monitor.Control = control
	end
	return monitor
end

-- End --
Console.log("Done.")

return Spawn
