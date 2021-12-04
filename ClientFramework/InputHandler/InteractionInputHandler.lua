local module = {}

local inputHandler = require(script.Parent)

local userInputService = game:GetService("UserInputService")

local torchEnabled = false
local callingForHorse = false

local remote1 
local remote2

remote1 = game:GetService("ReplicatedStorage"):WaitForChild("EncryptedFunctions"):WaitForChild("SetTorchEnabled")
remote2 = game:GetService("ReplicatedStorage"):WaitForChild("EncryptedFunctions"):WaitForChild("CallForHorse")

function module.SetTorchEnabled()

	if torchEnabled == false then
		local count = 0

		repeat

			wait()
			count = count + 1

		until
		count >= 15 or not userInputService:IsKeyDown(Enum.KeyCode.R)

		if count >= 15 then
			torchEnabled = true
			remote1:InvokeServer(torchEnabled)
		else
			return
		end

	else
		
		local count = 0

		repeat

			wait()
			count = count + 1

		until
		count >= 15 or not userInputService:IsKeyDown(Enum.KeyCode.R)

		if count >= 15 then
			torchEnabled = false
			remote2:InvokeServer(torchEnabled)
		else
			return
		end
	end
end

function module.CallForHose()

	local count = 0

	repeat

		wait()
		count = count+1

	until
	count >= 20 or not userInputService:IsKeyDown(Enum.KeyCode.Q)

	if count >= 20 then
		
		remote2:InvokeServer()
	else
		return
	end
end

inputHandler:BindFunction(module.SetTorchEnabled, "InputBegan", "Keyboard", Enum.KeyCode.R)
inputHandler:BindFunction(module.CallForHose, "InputBegan", "Keyboard", Enum.KeyCode.Q)

userInputService.GamepadConnected:Connect(function(gamepad)
	
	if gamepad ~= Enum.UserInputType.Gamepad1 then return end
	
	inputHandler:BindFunction(module.SetTorchEnabled, "InputBegan", "Gamepad1", Enum.KeyCode.ButtonY)
	inputHandler:BindFunction(module.CallForHose, "InputBegan", "Gamepad1", Enum.KeyCode.DPadDown)
	
	inputHandler:UnbindFunction("Keyboard",Enum.KeyCode.R)
	inputHandler:UnbindFunction("Keyboard",Enum.KeyCode.Q)

end)

userInputService.GamepadDisconnected:Connect(function(gamepad)
	
	if gamepad ~= Enum.UserInputType.Gamepad1 then return end
	
	inputHandler:UnbindFunction("Keyboard",Enum.KeyCode.ButtonY)
	inputHandler:UnbindFunction("Keyboard",Enum.KeyCode.DPadDown)
	
	inputHandler:BindFunction(module.SetTorchEnabled, "InputBegan", "Keyboard", Enum.KeyCode.R)
	inputHandler:BindFunction(module.CallForHose, "InputBegan", "Keyboard", Enum.KeyCode.Q)
	
end)

return module
