--- Tests for the DirectionModule singleton
--
-- @author LastTalon
-- @version 0.1.0, 2020-10-20
-- @since 0.2

return function()
	local DirectionModule = require(game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("DirectionModule"))

	describe("DirectionModule", function()
		it("should be able to be instantiated", function()
			local directionModule = DirectionModule.new()
			expect(directionModule).to.be.ok()
		end)

		it("should be a singleton", function()
			local directionModule = DirectionModule.new()
			expect(directionModule).to.equal(DirectionModule)
		end)

		-- Further design is needed.
	end)
end
