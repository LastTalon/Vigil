--- Tests for the Dispatcher module
--
-- @author LastTalon
-- @version 0.1.0, 2020-10-17
-- @since 0.2

return function()
	local module = game:GetService("ReplicatedStorage"):WaitForChild("Scripts"):WaitForChild("Dispatcher")
	local Dispatcher = require(module)
	local Connection = require(module:WaitForChild("Connection"))
	local Controller = require(module:WaitForChild("Controller"))
	local Command = require(module:WaitForChild("Command"))

	describe("Dispatcher", function()
		it("should be able to be instantiated", function()
			local dispatcher = Dispatcher.new()
			expect(dispatcher).to.be.ok()
		end)

		it("should be able to be bound and unbound", function()
			local dispatcher = Dispatcher.new()
			local connection = Connection.new()
			connection.Receive = {}
			connection.Receive.Connect = function() return 0 end
			connection.Receive.Disconnect = function() end
			expect(dispatcher:Bound()).to.equal(false)
			dispatcher:Bind(connection)
			expect(dispatcher:Bound()).to.equal(true)
			dispatcher:Unbind()
			expect(dispatcher:Bound()).to.equal(false)
			dispatcher = Dispatcher.new(connection)
			expect(dispatcher:Bound()).to.equal(true)
			dispatcher:Unbind()
			expect(dispatcher:Bound()).to.equal(false)
		end)

		it("should return the status of binding when being bound", function()
			local dispatcher = Dispatcher.new()
			local connection = Connection.new()
			connection.Receive = {}
			connection.Receive.Connect = function() return 0 end
			connection.Receive.Disconnect = function() end
			local bound = dispatcher:Bind(connection)
			expect(bound).to.equal(dispatcher:Bound())
			dispatcher:Unbind()
		end)

		it("should tick when updated", function()
			local dispatcher = Dispatcher.new()
			expect(dispatcher:Tick()).to.equal(0)
			for i = 1, 5 do
				dispatcher:Update()
				expect(dispatcher:Tick()).to.equal(i)
			end
		end)

		it("should register Commands", function()
			local dispatcher = Dispatcher.new()
			local command = Command.new()
			command.Name = "Test"
			expect(dispatcher:Register(command)).to.equal(true)
		end)

		it("should not register Commands twice", function()
			local dispatcher = Dispatcher.new()
			local command = Command.new()
			command.Name = "Test"
			expect(dispatcher:Register(command)).to.equal(true)
			expect(dispatcher:Register(command)).to.equal(false)
		end)

		it("should deregister Commands", function()
			local dispatcher = Dispatcher.new()
			local command = Command.new()
			command.Name = "Test"
			expect(dispatcher:Deregister(command)).to.equal(false)
			expect(dispatcher:Register(command)).to.equal(true)
			expect(dispatcher:Deregister(command)).to.equal(true)
			expect(dispatcher:Deregister(command)).to.equal(false)
			expect(dispatcher:Register(command)).to.equal(true)
			expect(dispatcher:Deregister(command.Name)).to.equal(true)
			expect(dispatcher:Deregister(command.Name)).to.equal(false)
		end)

		it("should fire all activations passed by a Command", function()
			local dispatcher = Dispatcher.new()
			local command = Command.new()
			local expectedActivations = {1, 2, 3}
			local activations = {}
			command.Name = "Test"

			function command:Update()
				return expectedActivations
			end

			function command:Listener(commandName, arguments, internal)
				if commandName == self.Name and internal then
					table.insert(activations, arguments)
				end
			end

			dispatcher:Register(command)
			dispatcher:Update()
			for index, value in ipairs(expectedActivations) do
				expect(value).to.equal(activations[index])
			end
		end)

		it("should report to its Connection when activated", function()
			local dispatcher = Dispatcher.new()
			local connection = Connection.new()
			local command = Command.new()
			local expectedReports = {1, 2, 3}
			local reports = {}
			connection.Receive = {}
			connection.Receive.Connect = function() return 0 end
			connection.Receive.Disconnect = function() end
			command.Name = "Test"
			command.Listener = function() end

			function connection:Report(commandName, arguments)
				if commandName == command.Name then
					table.insert(reports, arguments)
				end
			end

			function command:Update()
				return expectedReports
			end

			dispatcher:Register(command)
			dispatcher:Bind(connection)
			dispatcher:Update()
			for index, value in ipairs(expectedReports) do
				expect(value).to.equal(reports[index])
			end
			dispatcher:Unbind()
		end)

		it("should receive reports from its Connection", function()
			local dispatcher = Dispatcher.new()
			local connection = Connection.new()
			local command = Command.new()
			local expectedMessages = {1, 2, 3}
			local messages = {}
			connection.Receive = {}
			connection.Receive.Disconnect = function() end
			command.Name = "Test"
			command.Update = function() return {} end

			function connection.Receive:Connect(fn)
				for _, message in ipairs(expectedMessages) do
					fn(command.Name, message)
				end
				return 0
			end

			function command:Listener(commandName, arguments, internal)
				if commandName == self.Name and not internal then
					table.insert(messages, arguments)
				end
			end

			dispatcher:Register(command)
			dispatcher:Bind(connection)
			dispatcher:Update()
			for index, value in ipairs(expectedMessages) do
				expect(value).to.equal(messages[index])
			end
			dispatcher:Unbind()
		end)

		describe("Connection", function()
			it("should be able to be instantiated", function()
				local connection = Connection.new()
				expect(connection).to.be.ok()
				expect(connection.Report).to.be.a("function")
			end)
		end)

		describe("Controller", function()
			it("should be able to be instantiated", function()
				local controller = Controller.new()
				expect(controller).to.be.ok()
				expect(controller.Bind).to.be.a("function")
				expect(controller.Unbind).to.be.a("function")
			end)

			it("should be able to tell if its bound", function()
				local controller = Controller.new()
				expect(controller:Bound()).to.be.ok()
			end)
		end)

		describe("Command", function()
			it("should be able to be instantiated", function()
				local command = Command.new()
				expect(command).to.be.ok()
				expect(command.Update).to.be.a("function")
				expect(command.Listener).to.be.a("function")
			end)

			it("should be able to be updated", function()
				local command = Command.new()
				expect(command:Update(0)).to.be.a("table")
			end)
		end)
	end)
end
