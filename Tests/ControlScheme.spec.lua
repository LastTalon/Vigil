--- Tests for the ControlScheme module
--
-- @author LastTalon
-- @version 0.1.0, 2020-10-26
-- @since 0.2

return function()
	local module = game:GetService("StarterPlayer")
	:WaitForChild("StarterPlayerScripts"):WaitForChild("PlayerModule")
	:WaitForChild("ControlModule"):WaitForChild("ControlScheme")
	local ControlScheme = require(module)
	local Control = require(module:WaitForChild("Control"))
	local Monitor = require(module:WaitForChild("Monitor"))
	local Input = require(module:WaitForChild("Input"))

	describe("ControlScheme", function()
		it("should be able to be instantiated", function()
			local controlScheme = ControlScheme.new()
			expect(controlScheme).to.be.ok()
		end)

		it("should allow adding Controls", function()
			local controlScheme = ControlScheme.new()
			local control = Control.new()
			local returnedControl = controlScheme:Add("Test", control)
			expect(returnedControl).to.equal(control)
			expect(controlScheme:Get("Test")).to.equal(control)
		end)

		it("should automatically create a Control when one is added", function()
			local controlScheme = ControlScheme.new()
			local control = controlScheme:Add("Test")
			expect(control).to.be.ok()
			expect(controlScheme:Get("Test")).to.equal(control)
		end)

		it("should allow removing Controls", function()
			local controlScheme = ControlScheme.new()
			controlScheme:Add("Test")
			expect(controlScheme:Get("Test")).to.be.ok()
			controlScheme:Remove("Test")
			expect(controlScheme:Get("Test")).never.to.be.ok()
		end)

		it("should provide an iterator for its Controls", function()
			local controlScheme = ControlScheme.new()
			local total = 10
			for i = 1, total do
				controlScheme:Add("Test " .. i)
			end
			local count = 0
			for id, control in controlScheme:Controls() do
				count = count + 1
				expect(id:sub(1, 5)).to.equal("Test ")
				expect(control).to.be.ok()
			end
			expect(count).to.equal(total)
		end)

		describe("Control", function()
			it("should be able to be instantiated", function()
				local control = Control.new()
				expect(control).to.be.ok()
			end)

			it("should allow adding Inputs", function()
				local control = Control.new()
				local input = Input.new()
				local returnedInput = control:Add("Test", input)
				expect(returnedInput).to.be.ok()
				expect(control:Get("Test")).to.equal(input)
			end)

			it("should automatically create a Input when one is added", function()
				local control = Control.new()
				local input = control:Add("Test")
				expect(input).to.be.ok()
				expect(control:Get("Test")).to.equal(input)
			end)

			it("should allow removing Inputs", function()
				local control = Control.new()
				control:Add("Test")
				expect(control:Get("Test")).to.be.ok()
				control:Remove("Test")
				expect(control:Get("Test")).never.to.be.ok()
			end)

			it("should provide an iterator for its Inputs", function()
				local control = Control.new()
				local total = 10
				for i = 1, total do
					control:Add("Test " .. i)
				end
				local count = 0
				for id, input in control:Inputs() do
					count = count + 1
					expect(id:sub(1, 5)).to.equal("Test ")
					expect(input).to.be.ok()
				end
				expect(count).to.equal(total)
			end)

			it("should be able to set a Monitor", function()
				local control = Control.new()
				local monitor = Monitor.new()
				expect(control:GetMonitor()).never.to.be.ok()
				expect(monitor:Bound()).to.equal(false)
				control:SetMonitor(monitor)
				expect(control:GetMonitor()).to.equal(monitor)
				expect(monitor:Bound()).to.equal(true)
				control:SetMonitor()
				expect(control:GetMonitor()).never.to.be.ok()
				expect(monitor:Bound()).to.equal(false)
			end)
		end)

		describe("Input", function()
			it("should be able to be instantiated", function()
				local input = Input.new()
				expect(input).to.be.ok()
			end)
		end)
	end)
end
