--- Tests for the Event module
--
-- @author LastTalon
-- @version 0.1.0, 2020-10-16
-- @since 0.2

return function()
	local Event = require(game:GetService("ReplicatedStorage"):WaitForChild("Scripts"):WaitForChild("Event"))

	describe("Event", function()
		it("should be able to be instantiated", function()
			local event = Event.new()
			expect(event).to.be.ok()
		end)

		it("should expose a registrar", function()
			local event = Event.new()
			expect(event.Registrar).to.be.ok()
			expect(event.Registrar.Connect).to.equal(event.Connect)
			expect(event.Registrar.Disconnect).to.equal(event.Disconnect)
		end)

		it("should expose an activator", function()
			local event = Event.new()
			expect(event.Activator).to.be.ok()
			expect(event.Activator.Fire).to.equal(event.Fire)
		end)

		it("should allow callbacks to be connected", function()
			local event = Event.new()
			expect(function() event:Connect(function() end) end).never.to.throw()
		end)

		it("should provide an id to reference a connection", function()
			local event = Event.new()
			expect(event:Connect(function() end)).to.be.ok()
		end)

		it("should allow firing", function()
			local event = Event.new()
			local fired = false
			event:Connect(function()
				expect(fired).to.equal(false)
				fired = true
			end)
			expect(fired).to.equal(false)
			event:Fire()
			expect(fired).to.equal(true)
		end)

		it("should allow callbacks to be disconnected", function()
			local event = Event.new()
			local fired = false
			local callback = event:Connect(function()
				fired = true
			end)
			expect(fired).to.equal(false)
			event:Fire()
			expect(fired).to.equal(true)
			fired = false
			event:Disconnect(callback)
			expect(fired).to.equal(false)
			event:Fire()
			expect(fired).to.equal(false)
		end)

		it("should allow passing parameters to callbacks when fired", function()
			local event = Event.new()
			local p1, p2, p3
			event:Connect(function(first, second, third)
				expect(first).to.equal(p1)
				expect(second).to.equal(p2)
				expect(third).to.equal(p3)
			end)
			event:Fire()
			event:Fire(p1, p2, p3)
			p1 = 1
			p2 = 3
			p3 = 6
			event:Fire(p1, p2, p3)
		end)

		it("should not propagate errors from callbacks", function()
			local event = Event.new()
			event:Connect(function()
				error("Uh oh!")
			end)
			expect(function() event:Fire() end).never.to.throw()
		end)

		it("should not be delayed by yielding callbacks", function()
			local event = Event.new()
			local mainDelayed = false
			local callbackDelayed = false
			event:Connect(function()
				expect(callbackDelayed).to.equal(false)
				wait(0.5)
				expect(callbackDelayed).to.equal(true)
				mainDelayed = true
			end)
			event:Fire()
			expect(mainDelayed).to.equal(false)
			callbackDelayed = true
			wait(1)
			expect(mainDelayed).to.equal(true)
		end)
	end)
end
