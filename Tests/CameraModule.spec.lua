--- Tests for the CameraModule singleton
--
-- @author LastTalon
-- @version 0.1.0, 2020-10-20
-- @since 0.2

return function()
	local CameraModule = require(game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("CameraModule"))

	describe("CameraModule", function()
		it("should be able to be instantiated", function()
			local cameraModule = CameraModule.new()
			expect(cameraModule).to.be.ok()
		end)

		it("should be a singleton", function()
			local cameraModule = CameraModule.new()
			expect(cameraModule).to.equal(CameraModule)
		end)

		-- Further design is needed.
	end)
end
