--- Tests for the Logger module
--
-- @author LastTalon
-- @version 0.1.0, 2020-10-16
-- @since 0.2

return function()
	local Logger = require(game:GetService("ReplicatedStorage"):WaitForChild("Scripts"):WaitForChild("Logger"))

	describe("Logger", function()
		it("should be able to be instantiated", function()
			local log = Logger.new()
			expect(log).to.be.ok()
		end)

		it("should log arbitrary data", function()
			local log = Logger.new()
			expect(function() log:Log() end).never.to.throw()
			expect(function() log:Log(1) end).never.to.throw()
			expect(function() log:Log({}) end).never.to.throw()
			expect(function() log:Log("a") end).never.to.throw()
			expect(function() log:Log(nil) end).never.to.throw()
			expect(function() log:Log(true) end).never.to.throw()
			expect(function() log:Log(function() end) end).never.to.throw()
			expect(function() log:Log(Instance.new("Folder")) end).never.to.throw()
			expect(function() log:Log(coroutine.create(function() end)) end).never.to.throw()
			expect(function() log:Log(1, 1, 1 ,1 ,1) end).never.to.throw()
		end)

		it("should provide an iterator", function()
			local log = Logger.new()
			local iterator, invariant, control = log:Entries()
			expect(iterator).to.be.a("function")
			expect(invariant).to.be.ok()
			expect(control).to.be.ok()
		end)

		it("should iterate over any logs added", function()
			local log = Logger.new()
			local items = {1, 2, 3, 4, 5}
			local count = 0
			for _, _ in log:Entries() do
				count = count + 1
			end
			expect(count).to.equal(0)
			for _, item in ipairs(items) do
				log:Log(item)
			end
			count = 0
			for index, entry in log:Entries() do
				count = count + 1
				expect(entry[2]).to.equal(items[index])
			end
			expect(count).to.equal(5)
		end)

		it("should log items into tables", function()
			local log = Logger.new()
			log:Log("A")
			log:Log()
			for _, entry in log:Entries() do
				expect(entry).to.be.a("table")
			end
		end)

		it("should always log a unix timestamp before other values", function()
			local log = Logger.new()
			log:Log(1)
			log:Log()
			for _, entry in log:Entries() do
				expect(entry[1]).to.be.a("number")
			end
		end)
	end)
end
