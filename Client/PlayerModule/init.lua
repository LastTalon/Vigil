--- The main player module.
-- A singleton object responsible for initializing and providing access to
-- other client singletons, namely the ControlModule and CameraModule.
--
-- @author LastTalon
-- @version 0.1.0, 2020-04-28
-- @since 0.1
--
-- @module ControlModule
-- @field Cameras the CameraModule singleton
-- @field Controls the ControlModule singleton

local Console = require(game:GetService("ReplicatedStorage"):WaitForChild("Scripts"):WaitForChild("Console")).sourced("Player Module")

-- Dependencies --
Console.log("Loading dependencies...")

local Cameras = require(script:WaitForChild("CameraModule"))
local Controls = require(script:WaitForChild("ControlModule"))
local Direction = require(script:WaitForChild("DirectionModule"))

-- Variables --
Console.log("Initializing variables...")

local PlayerModule = {}
local instance

-- Local Objects --
Console.log("Constructing objects...")

PlayerModule.__index = PlayerModule

--- The contructor for the singleton.
-- Creates a new singleton if none exists. Always returns the same object
-- initially created.
--
-- @return the singleton
function PlayerModule.new()
	if instance == nil then
		local self = setmetatable({}, PlayerModule)
		self.Cameras = Cameras
		self.Controls = Controls
		self.Direction = Direction
		instance = self
	end
	return instance
end

-- End --
Console.log("Done.")

return PlayerModule.new()
