--- Tests for the PlayerModule singleton
--
-- @author LastTalon
-- @version 0.1.0, 2020-10-20
-- @since 0.2

return function()
	local module = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts"):WaitForChild("PlayerModule")
	local PlayerModule = require(module)
	local CameraModule = require(module:WaitForChild("CameraModule"))
	local ControlModule = require(module:WaitForChild("ControlModule"))
	local DirectionModule = require(module:WaitForChild("DirectionModule"))

	describe("PlayerModule", function()
		it("should be able to be instantiated", function()
			local playerModule = PlayerModule.new()
			expect(playerModule).to.be.ok()
		end)

		it("should be a singleton", function()
			local playerModule = PlayerModule.new()
			expect(playerModule).to.equal(PlayerModule)
		end)

		it("should expose the CameraModule singleton", function()
			expect(PlayerModule.Cameras).to.equal(CameraModule)
		end)

		it("should expose the ControlModule singleton", function()
			expect(PlayerModule.Controls).to.equal(ControlModule)
		end)

		it("should expose the DirectionModule singleton", function()
			expect(PlayerModule.Direction).to.equal(DirectionModule)
		end)
	end)
end
