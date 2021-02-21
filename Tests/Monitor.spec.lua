--- Tests for the Monitor module
--
-- @author LastTalon
-- @version 0.1.0, 2020-10-26
-- @since 0.2

return function()
	local module = game:GetService("StarterPlayer")
		:WaitForChild("StarterPlayerScripts"):WaitForChild("PlayerModule")
		:WaitForChild("ControlModule"):WaitForChild("ControlScheme")
	local monitorModule = module:WaitForChild("Monitor")
	local Monitor = require(monitorModule)
	local AxisMonitor = require(monitorModule:WaitForChild("AxisMonitor"))
	local BinaryMonitor = require(monitorModule:WaitForChild("BinaryMonitor"))
	local VectorMonitor = require(monitorModule:WaitForChild("VectorMonitor"))
	local Control = require(module:WaitForChild("Control"))
	local InputType = require(module:WaitForChild("InputType"))
	local DirectionMethod = require(module:WaitForChild("DirectionMethod"))

	describe("Monitor", function()
		it("should be able to be instantiated", function()
			local monitor = Monitor.new()
			expect(monitor).to.be.ok()
		end)

		it("should bind and unbind from Controls", function()
			local monitor = Monitor.new()
			local control = Control.new()
			expect(monitor:Bound()).to.equal(false)
			monitor:Bind(control)
			expect(monitor:Bound()).to.equal(true)
			monitor:Unbind()
			expect(monitor:Bound()).to.equal(false)
		end)

		it("should report its value", function()
			local monitor = Monitor.new()
			local value = 0

			function monitor:defaultValue()
				return value
			end

			function monitor:scaleValue(value)
				return value
			end

			function monitor:addValue(lhs, rhs)
				return lhs + rhs
			end

			function monitor:transformValue()
				return value, 0
			end

			monitor:Update()
			expect(monitor:GetValue()).to.equal(value)
			value = 1
			monitor:Update()
			expect(monitor:GetValue()).to.equal(value)
		end)

		it("should report if its value has been updated", function()
			local monitor = Monitor.new()
			local value = 0

			function monitor:defaultValue()
				return value
			end

			function monitor:scaleValue(value)
				return value
			end

			function monitor:addValue(lhs, rhs)
				return lhs + rhs
			end

			function monitor:transformValue()
				return value, 0
			end

			expect(monitor:Updated()).to.equal(false)
			monitor:Update()
			expect(monitor:Updated()).to.equal(true)
			expect(monitor:Updated()).to.equal(true)
			monitor:Update()
			expect(monitor:Updated()).to.equal(false)
			value = 1
			expect(monitor:Updated()).to.equal(false)
			monitor:Update()
			expect(monitor:Updated()).to.equal(true)
		end)

		it("should update for None", function()
			local monitor = Monitor.new()
			local control = Control.new()
			local input = control:Add("Test")
			input.Type = InputType.None
			local value = 0

			function monitor:defaultValue()
				return 0
			end

			function monitor:scaleValue(value)
				return value
			end

			function monitor:addValue(lhs, rhs)
				return lhs + rhs
			end

			function monitor:transformValue(passedInput, passedValue)
				expect(passedInput).to.equal(input)
				expect(passedValue).to.be.ok()
				return value, 0
			end

			monitor:Bind(control)
			monitor:Update()
			expect(monitor:GetValue()).to.equal(0)
			value = 1
			monitor:Update()
			expect(monitor:GetValue()).to.equal(1)
			monitor:Unbind()
		end)

		it("should update for Keyboard", function()
			local monitor = Monitor.new()
			local control = Control.new()
			local input = control:Add("Test")
			input.Type = InputType.Keyboard
			input.Code = 0
			local value = 0

			function monitor:defaultValue()
				return 0
			end

			function monitor:scaleValue(value)
				return value
			end

			function monitor:addValue(lhs, rhs)
				return lhs + rhs
			end

			function monitor:transformValue(passedInput, passedValue)
				expect(passedInput).to.equal(input)
				expect(passedValue).to.be.ok()
				return value, 0
			end

			monitor:Bind(control)
			monitor:Update()
			expect(monitor:GetValue()).to.equal(0)
			value = 1
			monitor:Update()
			expect(monitor:GetValue()).to.equal(1)
			monitor:Unbind()
		end)

		it("should update for MouseButton", function()
			local monitor = Monitor.new()
			local control = Control.new()
			local input = control:Add("Test")
			input.Type = InputType.MouseButton
			input.Code = 0
			local value = 0

			function monitor:defaultValue()
				return 0
			end

			function monitor:scaleValue(value)
				return value
			end

			function monitor:addValue(lhs, rhs)
				return lhs + rhs
			end

			function monitor:transformValue(passedInput, passedValue)
				expect(passedInput).to.equal(input)
				expect(passedValue).to.be.ok()
				return value, 0
			end

			monitor:Bind(control)
			monitor:Update()
			expect(monitor:GetValue()).to.equal(0)
			value = 1
			monitor:Update()
			expect(monitor:GetValue()).to.equal(1)
			monitor:Unbind()
		end)

		it("should update for MouseMovement with method None", function()
			local monitor = Monitor.new()
			local control = Control.new()
			local input = control:Add("Test")
			input.Type = InputType.MouseMovement
			input.Code = DirectionMethod.None
			local value = 0

			function monitor:defaultValue()
				return 0
			end

			function monitor:scaleValue(value)
				return value
			end

			function monitor:addValue(lhs, rhs)
				return lhs + rhs
			end

			function monitor:transformValue(passedInput, passedValue)
				expect(passedInput).to.equal(input)
				expect(passedValue).to.be.ok()
				return value, 0
			end

			monitor:Bind(control)
			monitor:Update()
			expect(monitor:GetValue()).to.equal(0)
			value = 1
			monitor:Update()
			expect(monitor:GetValue()).to.equal(1)
			monitor:Unbind()
		end)

		it("should update for MouseMovement with method Absolute", function()
			local monitor = Monitor.new()
			local control = Control.new()
			local input = control:Add("Test")
			input.Type = InputType.MouseMovement
			input.Code = DirectionMethod.Absolute
			local value = 0

			function monitor:defaultValue()
				return 0
			end

			function monitor:scaleValue(value)
				return value
			end

			function monitor:addValue(lhs, rhs)
				return lhs + rhs
			end

			function monitor:transformValue(passedInput, passedValue)
				expect(passedInput).to.equal(input)
				expect(passedValue).to.be.ok()
				return value, 0
			end

			monitor:Bind(control)
			monitor:Update()
			expect(monitor:GetValue()).to.equal(0)
			value = 1
			monitor:Update()
			expect(monitor:GetValue()).to.equal(1)
			monitor:Unbind()
		end)

		it("should update for MouseMovement with method Relative", function()
			local monitor = Monitor.new()
			local control = Control.new()
			local input = control:Add("Test")
			input.Type = InputType.MouseMovement
			input.Code = DirectionMethod.Relative
			local value = 0

			function monitor:defaultValue()
				return 0
			end

			function monitor:scaleValue(value)
				return value
			end

			function monitor:addValue(lhs, rhs)
				return lhs + rhs
			end

			function monitor:transformValue(passedInput, passedValue)
				expect(passedInput).to.equal(input)
				expect(passedValue).to.be.ok()
				return value, 0
			end

			monitor:Bind(control)
			monitor:Update()
			expect(monitor:GetValue()).to.equal(0)
			value = 1
			monitor:Update()
			expect(monitor:GetValue()).to.equal(1)
			monitor:Unbind()
		end)

		it("should error for MouseMovement with invalid method", function()
			local monitor = Monitor.new()
			local control = Control.new()
			local input = control:Add("Test")
			input.Type = InputType.MouseMovement
			local value = 0

			function monitor:defaultValue()
				return 0
			end

			function monitor:scaleValue(value)
				return value
			end

			function monitor:addValue(lhs, rhs)
				return lhs + rhs
			end

			function monitor:transformValue(passedInput, passedValue)
				expect(passedInput).to.equal(input)
				expect(passedValue).to.be.ok()
				return value, 0
			end

			monitor:Bind(control)
			expect(function() monitor:Update() end).to.throw()
			monitor:Unbind()
		end)

		it("should update for GamepadButton", function()
			local monitor = Monitor.new()
			local control = Control.new()
			local input = control:Add("Test")
			input.Type = InputType.GamepadButton
			input.Code = 0
			input.Device = Enum.UserInputType.Gamepad1
			local value = 0

			function monitor:defaultValue()
				return 0
			end

			function monitor:scaleValue(value)
				return value
			end

			function monitor:addValue(lhs, rhs)
				return lhs + rhs
			end

			function monitor:transformValue(passedInput, passedValue)
				expect(passedInput).to.equal(input)
				expect(passedValue).to.be.ok()
				return value, 0
			end

			monitor:Bind(control)
			monitor:Update()
			expect(monitor:GetValue()).to.equal(0)
			value = 1
			monitor:Update()
			expect(monitor:GetValue()).to.equal(1)
			monitor:Unbind()
		end)

		it("should update for GamepadDirection with method None", function()
			local monitor = Monitor.new()
			local control = Control.new()
			local input = control:Add("Test")
			input.Type = InputType.GamepadDirection
			input.Code = DirectionMethod.None
			input.Device = Enum.UserInputType.Gamepad1
			local value = 0

			function monitor:defaultValue()
				return 0
			end

			function monitor:scaleValue(value)
				return value
			end

			function monitor:addValue(lhs, rhs)
				return lhs + rhs
			end

			function monitor:transformValue(passedInput, passedValue)
				expect(passedInput).to.equal(input)
				expect(passedValue).to.be.ok()
				return value, 0
			end

			monitor:Bind(control)
			monitor:Update()
			expect(monitor:GetValue()).to.equal(0)
			value = 1
			monitor:Update()
			expect(monitor:GetValue()).to.equal(1)
			monitor:Unbind()
		end)

		it("should update for GamepadDirection with method Absolute", function()
			local monitor = Monitor.new()
			local control = Control.new()
			local input = control:Add("Test")
			input.Type = InputType.GamepadDirection
			input.Code = DirectionMethod.Absolute
			input.Device = Enum.UserInputType.Gamepad1
			local value = 0

			function monitor:defaultValue()
				return 0
			end

			function monitor:scaleValue(value)
				return value
			end

			function monitor:addValue(lhs, rhs)
				return lhs + rhs
			end

			function monitor:transformValue(passedInput, passedValue)
				expect(passedInput).to.equal(input)
				expect(passedValue).to.be.ok()
				return value, 0
			end

			monitor:Bind(control)
			monitor:Update()
			expect(monitor:GetValue()).to.equal(0)
			value = 1
			monitor:Update()
			expect(monitor:GetValue()).to.equal(1)
			monitor:Unbind()
		end)

		it("should update for GamepadDirection with method Relative", function()
			local monitor = Monitor.new()
			local control = Control.new()
			local input = control:Add("Test")
			input.Type = InputType.GamepadDirection
			input.Code = DirectionMethod.Relative
			input.Device = Enum.UserInputType.Gamepad1
			local value = 0

			function monitor:defaultValue()
				return 0
			end

			function monitor:scaleValue(value)
				return value
			end

			function monitor:addValue(lhs, rhs)
				return lhs + rhs
			end

			function monitor:transformValue(passedInput, passedValue)
				expect(passedInput).to.equal(input)
				expect(passedValue).to.be.ok()
				return value, 0
			end

			monitor:Bind(control)
			monitor:Update()
			expect(monitor:GetValue()).to.equal(0)
			value = 1
			monitor:Update()
			expect(monitor:GetValue()).to.equal(1)
			monitor:Unbind()
		end)

		it("should error for GamepadDirection with invalid method", function()
			local monitor = Monitor.new()
			local control = Control.new()
			local input = control:Add("Test")
			input.Type = InputType.GamepadDirection
			local value = 0

			function monitor:defaultValue()
				return 0
			end

			function monitor:scaleValue(value)
				return value
			end

			function monitor:addValue(lhs, rhs)
				return lhs + rhs
			end

			function monitor:transformValue(passedInput, passedValue)
				expect(passedInput).to.equal(input)
				expect(passedValue).to.be.ok()
				return value, 0
			end

			monitor:Bind(control)
			expect(function() monitor:Update() end).to.throw()
			monitor:Unbind()
		end)

		it("should update for Scheme", function()
			local monitor = Monitor.new()
			local control = Control.new()
			local input = control:Add("Test")
			input.Type = InputType.Scheme
			input.Code = 0
			local value = 0

			function monitor:defaultValue()
				return 0
			end

			function monitor:scaleValue(value)
				return value
			end

			function monitor:addValue(lhs, rhs)
				return lhs + rhs
			end

			function monitor:transformValue(passedInput, passedValue)
				expect(passedInput).to.equal(input)
				expect(passedValue).to.be.ok()
				return value, 0
			end

			monitor:Bind(control)
			monitor:Update()
			expect(monitor:GetValue()).to.equal(0)
			value = 1
			monitor:Update()
			expect(monitor:GetValue()).to.equal(1)
			monitor:Unbind()
		end)

		it("should error for invalid type", function()
			local monitor = Monitor.new()
			local control = Control.new()
			control:Add("Test")
			local value = 0

			function monitor:defaultValue()
				return 0
			end

			function monitor:scaleValue(value)
				return value
			end

			function monitor:addValue(lhs, rhs)
				return lhs + rhs
			end

			function monitor:transformValue(_, passedValue)
				expect(passedValue).to.be.ok()
				return value, 0
			end

			monitor:Bind(control)
			expect(function() monitor:Update() end).to.throw()
			monitor:Unbind()
		end)

		it("should update for multiple inputs", function()
			local monitor = Monitor.new()
			local control = Control.new()
			local input
			local amount = 10
			local value = 0
			for i=1, amount do
				input = control:Add("Test " .. i)
				input.Type = InputType.None
			end

			function monitor:defaultValue()
				return 0
			end

			function monitor:scaleValue(value)
				return value
			end

			function monitor:addValue(lhs, rhs)
				return lhs + rhs
			end

			function monitor:transformValue(_, passedValue)
				expect(passedValue).to.be.ok()
				return value, 0
			end

			monitor:Bind(control)
			monitor:Update()
			expect(monitor:GetValue()).to.equal(0)
			value = 1
			monitor:Update()
			expect(monitor:GetValue()).to.equal(amount)
			monitor:Unbind()
		end)

		describe("AxisMonitor", function()
			it("should update for None", function()
				local monitor = AxisMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.None

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("number")
				monitor:Unbind()
			end)

			it("should update for Keyboard", function()
				local monitor = AxisMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.Keyboard
				input.Code = 0

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("number")
				monitor:Unbind()
			end)

			it("should update for MouseButton", function()
				local monitor = AxisMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.MouseButton
				input.Code = 0

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("number")
				monitor:Unbind()
			end)

			it("should update for MouseMovement with method None", function()
				local monitor = AxisMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.MouseMovement
				input.Code = DirectionMethod.None

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("number")
				monitor:Unbind()
			end)

			it("should update for MouseMovement with method Absolute", function()
				local monitor = AxisMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.MouseMovement
				input.Code = DirectionMethod.Absolute

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("number")
				monitor:Unbind()
			end)

			it("should update for MouseMovement with method Relative", function()
				local monitor = AxisMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.MouseMovement
				input.Code = DirectionMethod.Relative

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("number")
				monitor:Unbind()
			end)

			it("should error for MouseMovement with invalid method", function()
				local monitor = AxisMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.MouseMovement

				monitor:Bind(control)
				expect(function() monitor:Update() end).to.throw()
				monitor:Unbind()
			end)

			it("should update for GamepadButton", function()
				local monitor = AxisMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.GamepadButton
				input.Code = 0
				input.Device = Enum.UserInputType.Gamepad1

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("number")
				monitor:Unbind()
			end)

			it("should update for GamepadDirection with method None", function()
				local monitor = AxisMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.GamepadDirection
				input.Code = DirectionMethod.None
				input.Device = Enum.UserInputType.Gamepad1

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("number")
				monitor:Unbind()
			end)

			it("should update for GamepadDirection with method Absolute", function()
				local monitor = AxisMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.GamepadDirection
				input.Code = DirectionMethod.Absolute
				input.Device = Enum.UserInputType.Gamepad1

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("number")
				monitor:Unbind()
			end)

			it("should update for GamepadDirection with method Relative", function()
				local monitor = AxisMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.GamepadDirection
				input.Code = DirectionMethod.Relative
				input.Device = Enum.UserInputType.Gamepad1

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("number")
				monitor:Unbind()
			end)

			it("should error for GamepadDirection with invalid method", function()
				local monitor = AxisMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.GamepadDirection

				monitor:Bind(control)
				expect(function() monitor:Update() end).to.throw()
				monitor:Unbind()
			end)

			it("should update for Scheme", function()
				local monitor = AxisMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.Scheme
				input.Code = 0

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("number")
				monitor:Unbind()
			end)

			it("should error for invalid type", function()
				local monitor = AxisMonitor.new()
				local control = Control.new()
				control:Add("Test")

				monitor:Bind(control)
				expect(function() monitor:Update() end).to.throw()
				monitor:Unbind()
			end)
		end)

		describe("BinaryMonitor", function()
			it("should update for None", function()
				local monitor = BinaryMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.None

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("boolean")
				monitor:Unbind()
			end)

			it("should update for Keyboard", function()
				local monitor = BinaryMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.Keyboard
				input.Code = 0

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("boolean")
				monitor:Unbind()
			end)

			it("should update for MouseButton", function()
				local monitor = BinaryMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.MouseButton
				input.Code = 0

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("boolean")
				monitor:Unbind()
			end)

			it("should update for MouseMovement with method None", function()
				local monitor = BinaryMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.MouseMovement
				input.Code = DirectionMethod.None

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("boolean")
				monitor:Unbind()
			end)

			it("should update for MouseMovement with method Absolute", function()
				local monitor = BinaryMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.MouseMovement
				input.Code = DirectionMethod.Absolute

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("boolean")
				monitor:Unbind()
			end)

			it("should update for MouseMovement with method Relative", function()
				local monitor = BinaryMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.MouseMovement
				input.Code = DirectionMethod.Relative

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("boolean")
				monitor:Unbind()
			end)

			it("should error for MouseMovement with invalid method", function()
				local monitor = BinaryMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.MouseMovement

				monitor:Bind(control)
				expect(function() monitor:Update() end).to.throw()
				monitor:Unbind()
			end)

			it("should update for GamepadButton", function()
				local monitor = BinaryMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.GamepadButton
				input.Code = 0
				input.Device = Enum.UserInputType.Gamepad1

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("boolean")
				monitor:Unbind()
			end)

			it("should update for GamepadDirection with method None", function()
				local monitor = BinaryMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.GamepadDirection
				input.Code = DirectionMethod.None
				input.Device = Enum.UserInputType.Gamepad1

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("boolean")
				monitor:Unbind()
			end)

			it("should update for GamepadDirection with method Absolute", function()
				local monitor = BinaryMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.GamepadDirection
				input.Code = DirectionMethod.Absolute
				input.Device = Enum.UserInputType.Gamepad1

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("boolean")
				monitor:Unbind()
			end)

			it("should update for GamepadDirection with method Relative", function()
				local monitor = BinaryMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.GamepadDirection
				input.Code = DirectionMethod.Relative
				input.Device = Enum.UserInputType.Gamepad1

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("boolean")
				monitor:Unbind()
			end)

			it("should error for GamepadDirection with invalid method", function()
				local monitor = BinaryMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.GamepadDirection

				monitor:Bind(control)
				expect(function() monitor:Update() end).to.throw()
				monitor:Unbind()
			end)

			it("should update for Scheme", function()
				local monitor = BinaryMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.Scheme
				input.Code = 0

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("boolean")
				monitor:Unbind()
			end)

			it("should error for invalid type", function()
				local monitor = BinaryMonitor.new()
				local control = Control.new()
				control:Add("Test")

				monitor:Bind(control)
				expect(function() monitor:Update() end).to.throw()
				monitor:Unbind()
			end)
		end)

		describe("VectorMonitor", function()
			it("should update for None", function()
				local monitor = VectorMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.None

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("userdata")
				expect(typeof(monitor:GetValue())).to.equal("Vector2")
				monitor:Unbind()
			end)

			it("should update for Keyboard", function()
				local monitor = VectorMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.Keyboard
				input.Code = 0

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("userdata")
				expect(typeof(monitor:GetValue())).to.equal("Vector2")
				monitor:Unbind()
			end)

			it("should update for MouseButton", function()
				local monitor = VectorMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.MouseButton
				input.Code = 0

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("userdata")
				expect(typeof(monitor:GetValue())).to.equal("Vector2")
				monitor:Unbind()
			end)

			it("should update for MouseMovement with method None", function()
				local monitor = VectorMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.MouseMovement
				input.Code = DirectionMethod.None

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("userdata")
				expect(typeof(monitor:GetValue())).to.equal("Vector2")
				monitor:Unbind()
			end)

			it("should update for MouseMovement with method Absolute", function()
				local monitor = VectorMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.MouseMovement
				input.Code = DirectionMethod.Absolute

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("userdata")
				expect(typeof(monitor:GetValue())).to.equal("Vector2")
				monitor:Unbind()
			end)

			it("should update for MouseMovement with method Relative", function()
				local monitor = VectorMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.MouseMovement
				input.Code = DirectionMethod.Relative

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("userdata")
				expect(typeof(monitor:GetValue())).to.equal("Vector2")
				monitor:Unbind()
			end)

			it("should error for MouseMovement with invalid method", function()
				local monitor = VectorMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.MouseMovement

				monitor:Bind(control)
				expect(function() monitor:Update() end).to.throw()
				monitor:Unbind()
			end)

			it("should update for GamepadButton", function()
				local monitor = VectorMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.GamepadButton
				input.Code = 0
				input.Device = Enum.UserInputType.Gamepad1

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("userdata")
				expect(typeof(monitor:GetValue())).to.equal("Vector2")
				monitor:Unbind()
			end)

			it("should update for GamepadDirection with method None", function()
				local monitor = VectorMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.GamepadDirection
				input.Code = DirectionMethod.None
				input.Device = Enum.UserInputType.Gamepad1

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("userdata")
				expect(typeof(monitor:GetValue())).to.equal("Vector2")
				monitor:Unbind()
			end)

			it("should update for GamepadDirection with method Absolute", function()
				local monitor = VectorMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.GamepadDirection
				input.Code = DirectionMethod.Absolute
				input.Device = Enum.UserInputType.Gamepad1

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("userdata")
				expect(typeof(monitor:GetValue())).to.equal("Vector2")
				monitor:Unbind()
			end)

			it("should update for GamepadDirection with method Relative", function()
				local monitor = VectorMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.GamepadDirection
				input.Code = DirectionMethod.Relative
				input.Device = Enum.UserInputType.Gamepad1

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("userdata")
				expect(typeof(monitor:GetValue())).to.equal("Vector2")
				monitor:Unbind()
			end)

			it("should error for GamepadDirection with invalid method", function()
				local monitor = VectorMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.GamepadDirection

				monitor:Bind(control)
				expect(function() monitor:Update() end).to.throw()
				monitor:Unbind()
			end)

			it("should update for Scheme", function()
				local monitor = VectorMonitor.new()
				local control = Control.new()
				local input = control:Add("Test")
				input.Type = InputType.Scheme
				input.Code = 0

				monitor:Bind(control)
				monitor:Update()
				expect(monitor:GetValue()).to.be.a("userdata")
				expect(typeof(monitor:GetValue())).to.equal("Vector2")
				monitor:Unbind()
			end)

			it("should error for invalid type", function()
				local monitor = VectorMonitor.new()
				local control = Control.new()
				control:Add("Test")

				monitor:Bind(control)
				expect(function() monitor:Update() end).to.throw()
				monitor:Unbind()
			end)
		end)
	end)
end
