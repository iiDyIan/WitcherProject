local userInputService = game:GetService("UserInputService")

local bindings = {
	
	["MouseButton1"] = {},
	["MouseButton2"] = {},
	["MouseButton3"] = {},
	
	["MouseWheel"] = {},
	["MouseMovement"] = {},
	["Keyboard"] = {},
	
	["Touch"] = {},
	["Accelerometer"] = {},
	["Gyro"] = {},
	
	["Gamepad1"] = {},
	["Gamepad2"] = {},
	["Gamepad3"] = {},
	["Gamepad4"] = {},
	["Gamepad5"] = {},
	["Gamepad6"] = {},
	["Gamepad7"] = {},
	["Gamepad8"] = {},
	
}

local module = {}

function module.OnInputBegan(input,gameProcessed)
		
	if gameProcessed then return end
	
	local bindingName = string.gsub(tostring(input.UserInputType), "Enum.UserInputType.", "")
		
	if bindings[bindingName] then
				
		if input.UserInputType == Enum.UserInputType.Keyboard then
			
			if bindings["Keyboard"][input.KeyCode] then
				
				if bindings["Keyboard"][input.KeyCode][2] == "InputBegan" then
					
					bindings["Keyboard"][input.KeyCode][1]()
					
				end
				
			end	
			
		elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
			
			if bindings["MouseButton2"] then
				
				if bindings["MouseButton2"][2] == "InputBegan" then
					
					bindings["MouseButton2"][1]()
					
				end
				
			end
			
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then

			if bindings["MouseButton1"] then

				if bindings["MouseButton1"][2] == "InputBegan" then

					bindings["MouseButton1"][1]()

				end

			end	
			
		elseif input.UserInputType == Enum.UserInputType.Gamepad1 then

			if bindings["Gamepad1"][input.KeyCode] then

				if bindings["Gamepad1"][input.KeyCode][2] == "InputBegan" then

					bindings["Gamepad1"][input.KeyCode][1]()
					
				end
			end		
			
		end
	end	
end

function module.OnInputEnded(input,gameProcessed)
	
	if gameProcessed then return end

	local bindingName = string.gsub(tostring(input.UserInputType), "Enum.UserInputType.", "")

	if bindings[bindingName] then
				
		if input.UserInputType == Enum.UserInputType.Keyboard then
						
			if bindings["Keyboard"][input.KeyCode] then
								
				if bindings["Keyboard"][input.KeyCode][2] == "InputEnded" then
										
					bindings["Keyboard"][input.KeyCode][1]()
					
				end
				
			end

		elseif input.UserInputType == Enum.UserInputType.MouseButton2 then

			if bindings["MouseButton2"] then
				
				if bindings["MouseButton2"][2] == "InputEnded" then
					
					bindings["MouseButton2"][1]()

				end
			end
			
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then

			if bindings["MouseButton1"] then

				if bindings["MouseButton1"][2] == "InputEnded" then

					bindings["MouseButton1"][1]()

				end
			end		
			
		elseif input.UserInputType == Enum.UserInputType.Gamepad1 then

			if bindings["Gamepad1"][input.KeyCode] then

				if bindings["Gamepad1"][input.KeyCode][2] == "InputEnded" then

					bindings["Gamepad1"][input.KeyCode][1]()

				end
			end	

		end
	end	
end

function module.InternalUpdateBindings()
	
	userInputService.InputBegan:Connect(module.OnInputBegan)
	userInputService.InputEnded:Connect(module.OnInputEnded)
	
end

function module.BindFunction(moduleTable,bindedFunction,triggerEvent,inputType,inputEnum)
		
	if bindings[inputType] then
		
		if inputEnum then
			bindings[inputType][inputEnum] = {bindedFunction,triggerEvent}
		else
			bindings[inputType] = {bindedFunction,triggerEvent}
		end
				
		return "Binded function to user input event successfully."
		
	else
		
		return "Error in setting binding; inputType parameter invalid."
		
	end
	
end

function module.UnbindFunction(moduleTable,inputType,inputEnum)
	
	if bindings[inputType] then
		
		if inputEnum then
		
			if bindings[inputType][inputEnum] then
				
				bindings[inputType][inputEnum] = nil	
				
				return "Sucessfully unbinded user input function."
				
			else
				
				return "Error in unbinding function; inputEnum parameter invalid."
				
			end
			
		else
			
			bindings[inputType] = {}
			
			return "Sucessfully unbinded user input function."
			
		end
		
	else
		
		return "Error in unbinding function; inputType parameter invalid."
		
	end
	
end

module.InternalUpdateBindings()

return module
