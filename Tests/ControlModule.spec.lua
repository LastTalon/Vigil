--- Tests for the ControlModule singleton
--
-- @author LastTalon
-- @version 0.1.0, 2020-10-20
-- @since 0.2

return function()
	local module = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule")
	local controlSchemeModule = module:WaitForChild("ControlScheme")
	local ControlModule = require(module)
	local ControlScheme = require(controlSchemeModule)
	local Monitor = require(controlSchemeModule:WaitForChild("Monitor"))

	describe("ControlModule", function()
		it("should be able to be instantiated", function()
			local controlModule = ControlModule.new()
			expect(controlModule).to.be.ok()
		end)

		it("should be a singleton", function()
			local controlModule = ControlModule.new()
			expect(controlModule).to.equal(ControlModule)
		end)

		it("should bind and unbind ControlSchemes", function()
			local controlScheme = ControlScheme.new()
			expect(ControlModule:Bound()).to.equal(false)
			expect(ControlModule:BoundTo()).to.equal(nil)
			ControlModule:Bind(controlScheme)
			expect(ControlModule:Bound()).to.equal(true)
			expect(ControlModule:BoundTo()).to.equal(controlScheme)
			ControlModule:Unbind()
			expect(ControlModule:Bound()).to.equal(false)
			expect(ControlModule:BoundTo()).to.equal(nil)
		end)

		it("should layer bindings when binding new ControlSchemes", function()
			local controlScheme = ControlScheme.new()
			local otherScheme = ControlScheme.new()
			otherScheme.Name = "Other"
			expect(ControlModule:Bound()).to.equal(false)
			expect(ControlModule:BoundTo()).to.equal(nil)
			ControlModule:Bind(controlScheme)
			expect(ControlModule:Bound()).to.equal(true)
			expect(ControlModule:BoundTo()).to.equal(controlScheme)
			ControlModule:Bind(otherScheme)
			expect(ControlModule:Bound()).to.equal(true)
			expect(ControlModule:BoundTo()).to.equal(otherScheme)
			ControlModule:UnbindAll()
			expect(ControlModule:Bound()).to.equal(false)
			expect(ControlModule:BoundTo()).to.equal(nil)
		end)

		it("should unbind the most recently bound ControlScheme when unbinding", function()
			local controlScheme = ControlScheme.new()
			local otherScheme = ControlScheme.new()
			otherScheme.Name = "Other"
			expect(ControlModule:Bound()).to.equal(false)
			expect(ControlModule:BoundTo()).to.equal(nil)
			ControlModule:Bind(controlScheme)
			expect(ControlModule:Bound()).to.equal(true)
			expect(ControlModule:BoundTo()).to.equal(controlScheme)
			ControlModule:Bind(otherScheme)
			expect(ControlModule:Bound()).to.equal(true)
			expect(ControlModule:BoundTo()).to.equal(otherScheme)
			ControlModule:Unbind()
			expect(ControlModule:Bound()).to.equal(true)
			expect(ControlModule:BoundTo()).to.equal(controlScheme)
			ControlModule:Unbind()
			expect(ControlModule:Bound()).to.equal(false)
			expect(ControlModule:BoundTo()).to.equal(nil)
		end)

		it("should update Monitors in its active ControlScheme", function()
			local controlScheme = ControlScheme.new()
			local monitor = Monitor.new()
			local updated = false

			function monitor:Update()
				updated = true
				return false
			end

			function monitor:Updated()
				return false
			end

			function monitor:GetValue()
				return false
			end

			local control = controlScheme:Add("Test")
			control:SetMonitor(monitor)

			ControlModule:Bind(controlScheme)
			expect(updated).to.equal(false)
			ControlModule:Update()
			expect(updated).to.equal(true)
			ControlModule:Unbind()
		end)

		it("should provide a default Move", function()
			expect(function()
				ControlModule:UnsetMove()
				ControlModule:SetMove("Test")
				ControlModule:UnsetMove()
			end).never.to.throw()
		end)

		it("should provide a default Camera", function()
			expect(function()
				ControlModule:UnsetCamera()
				ControlModule:SetCamera("Test")
				ControlModule:UnsetCamera()
			end).never.to.throw()
		end)

		it("should provide a default Direction", function()
			expect(function()
				ControlModule:UnsetDirection()
				ControlModule:SetDirection("Test")
				ControlModule:UnsetDirection()
			end).never.to.throw()
		end)

		it("should provide a static listener for a specific command", function()
			local passed
			local listener = ControlModule.ListenForCommand("Test", function(value) passed = value end)
			expect(listener).to.be.a("function")
			expect(passed).never.to.be.ok()
			listener("Test", true)
			expect(passed).to.equal(true)
		end)
	end)
end
