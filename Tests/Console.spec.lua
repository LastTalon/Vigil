--- Tests for the Console module
--
-- @author LastTalon
-- @version 0.1.0, 2020-10-16
-- @since 0.2

return function()
	local Console = require(game:GetService("ReplicatedStorage"):WaitForChild("Scripts"):WaitForChild("Console"))

	describe("Console", function()
		it("should allow setting the default output on and off", function()
			Console.setDefaultOutput(false)
			expect(Console.getDefaultOutput()).to.equal(false)
			Console.setDefaultOutput(true)
			expect(Console.getDefaultOutput()).to.equal(true)
			Console.setDefaultOutput()
			expect(Console.getDefaultOutput()).to.equal(false)
			Console.setDefaultOutput(true)
		end)

		it("should allow logging of messages", function()
			Console.setDefaultOutput(true)
			expect(function() Console.log("Hello!") end).never.to.throw()
		end)

		it("should allow logging of warnings", function()
			Console.setDefaultOutput(true)
			expect(function() Console.warn("Careful!") end).never.to.throw()
		end)

		it("should allow logging of errors", function()
			Console.setDefaultOutput(true)
			expect(function() Console.error("Stop right there!") end).to.throw("Stop right there!")
		end)

		it("should provide an iterator", function()
			Console.setDefaultOutput(false)
			local iterator, invariant, control = Console.entries()
			expect(iterator).to.be.a("function")
			expect(invariant).to.be.ok()
			expect(control).to.be.ok()
			Console.setDefaultOutput(true)
		end)

		it("should iterate over anything logged", function()
			Console.setDefaultOutput(false)
			local messages = {"Hello, world!", "How are you?", "Goodbye."}
			for _, message in ipairs(messages) do
				Console.log(message)
			end
			local found = {}
			for _, entry in Console.entries() do
				for index, message in ipairs(messages) do
					if entry[2] == message then
						found[index] = true
					end
				end
			end
			for index, _ in ipairs(messages) do
				expect(found[index]).to.be.ok()
			end
			Console.setDefaultOutput(true)
		end)

		it("should log items into tables", function()
			Console.setDefaultOutput(false)
			Console.log("Hello!")
			for _, entry in Console.entries() do
				expect(entry).to.be.a("table")
			end
			Console.setDefaultOutput(true)
		end)

		it("should always log a unix timestamp first", function()
			Console.setDefaultOutput(false)
			Console.log("Hello!")
			for _, entry in Console.entries() do
				expect(entry[1]).to.be.a("number")
			end
			Console.setDefaultOutput(true)
		end)

		it("should always log the message second", function()
			Console.setDefaultOutput(false)
			Console.log("Hello!")
			for _, entry in Console.entries() do
				expect(entry[2]).to.be.a("string")
			end
			Console.setDefaultOutput(true)
		end)

		it("should always log the source of the message third", function()
			Console.setDefaultOutput(false)
			Console.log("Hello!", "ConsoleSpec")
			for _, entry in Console.entries() do
				if entry[3] ~= nil then
					expect(entry[2]).to.be.a("string")
				end
			end
			Console.setDefaultOutput(true)
		end)

		it("should always log the message type fourth", function()
			Console.setDefaultOutput(false)
			Console.log("Hello!")
			for _, entry in Console.entries() do
				expect(entry[4]).to.be.a("number")
			end
			Console.setDefaultOutput(true)
		end)

		it("should provide a sourced wrapper", function()
			local sourced = Console.sourced("ConsoleSpec")
			expect(sourced).to.be.ok()
			expect(sourced.log).to.be.a("function")
			expect(sourced.warn).to.be.a("function")
			expect(sourced.error).to.be.a("function")
		end)
	end)
end
