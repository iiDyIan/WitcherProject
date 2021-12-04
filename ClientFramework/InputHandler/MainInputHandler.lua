local userInputService = game:GetService("UserInputService")
local remoteLocation = game:GetService("ReplicatedStorage"):WaitForChild("EncryptedFunctions")

local interfaceHandler = require(script.Parent.Parent:WaitForChild("PlayerInterface"))

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local inputHandler = require(script.Parent)

local equipped = false

local attackDebounce = false
local parryStatus = false

local dodgeStatus = false
local rollStatus = false

local attackStatus = false
local bowStatus = false

local bowDebounce = false
local bowAimDebounce = false

local sprinting = false

local remote1 = remoteLocation:WaitForChild("LightAttack")
local remote2 = remoteLocation:WaitForChild("HeavyAttack")

local remote3 = remoteLocation:WaitForChild("Dodge")
local remote4 = remoteLocation:WaitForChild("Roll")

local remote5 = remoteLocation:WaitForChild("Parry")

local remote6 = remoteLocation:WaitForChild("BowAim")
local remote7 = remoteLocation:WaitForChild("BowAimEnd")
local remote8 = remoteLocation:WaitForChild("BowDraw")
local remote9 = remoteLocation:WaitForChild("BowDrawEnd")

local remote10 = remoteLocation:WaitForChild("EquipMelee")
local remote11 = remoteLocation:WaitForChild("UnequipMelee")

local remote12 = remoteLocation:WaitForChild("SprintEngage")
local remote13 = remoteLocation:WaitForChild("SprintDisengage")

local l2Down
local r2Down

l2Down = false
r2Down = false

local module = {}

function GetActiveGamepad()
	
	local activateGamepad = nil
	local navigationGamepads = {}

	navigationGamepads = userInputService:GetNavigationGamepads()

	if #navigationGamepads > 1 then
		for i = 1, #navigationGamepads do
			if activateGamepad == nil then
				activateGamepad = navigationGamepads[i]
			elseif navigationGamepads[i].Value < activateGamepad.Value then
				activateGamepad = navigationGamepads[i]
			end
		end
	else
		local connectedGamepads = {}

		connectedGamepads = userInputService:GetConnectedGamepads()

		if #connectedGamepads > 0 then
			for i = 1, #connectedGamepads do
				if activateGamepad == nil then
					activateGamepad = connectedGamepads[i]
				elseif connectedGamepads[i].Value < activateGamepad.Value then
					activateGamepad = connectedGamepads[i]
				end
			end
		end
		if activateGamepad == nil then
			activateGamepad = Enum.UserInputType.Gamepad1
		end
	end

	return activateGamepad
	
end

function module.UpdateL2(sendModule, bool)
	
	l2Down = bool
	
end

local function setCanShow(bool)
	
	local objects = workspace:WaitForChild("ArrowReloadObjects"):GetChildren()
	
	for i = 1,#objects do
		
		if objects[i].Name == "Barrel" then
			objects[i].CanShow.Value = bool
		end
		
	end
end

function module.AimBowBinding()
	
	if dodgeStatus == true then return end
	if bowAimDebounce == true then return end
	
	if equipped == true then return end
	
	bowAimDebounce = true
		
	script.Parent.Parent.PlayerData.CameraOffset.Value = CFrame.new(1.75, 2.5, 4)
	
	bowStatus = true
	setCanShow(false)
	
	remote6:InvokeServer(character)
	interfaceHandler:DisplayBow()

	repeat
		wait()
	until
	not userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) and not l2Down
	
	setCanShow(true)
	bowStatus = false
	
	interfaceHandler:HideBow()
	
	script.Parent.Parent.PlayerData.CameraOffset.Value = CFrame.new(0, 3.75, 9.5)
	
	remote7:InvokeServer(character)

	bowAimDebounce = false

end

function module.FireBowBinding()
		
	if bowStatus == false then 
		
		if userInputService:IsKeyDown(Enum.KeyCode.LeftShift) == true or userInputService:IsKeyDown(Enum.KeyCode.RightShift) then
			
			module.HeavyAttackBinding()
			
		else	
			
			module.LightAttackBinding()
			
		end
		
		return 
	end
	
	if equipped == true then return end
	
	if bowDebounce == true then return end
		
	remote8:FireServer(character)

	bowStatus = true
	local count = 0
		
	repeat
		wait()
		count = count + 1
		
	until
	not userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) and not r2Down
	
	
	if bowStatus == false then return end
	if bowDebounce == true then return end

	if count < 10 then 
		remote9:FireServer(character)
		return 
	end
		
	local mouse = player:GetMouse()
	
	remote9:FireServer(character, mouse.UnitRay.Direction, workspace.CurrentCamera.CFrame.Position)
		
end

function module.DodgeBinding()
	
	if bowStatus == true then return end
	if bowDebounce == true then return end
	if dodgeStatus == true then return end
	
	local keys = userInputService:GetKeysPressed()
	local finalKeys = {}
	
	for i = 1,#keys do
		if keys.UserInputType == Enum.UserInputType.Keyboard then
			if keys.KeyCode == Enum.KeyCode.W or keys.KeyCode == Enum.KeyCode.A or keys.KeyCode == Enum.KeyCode.S or keys.KeyCode == Enum.KeyCode.D then
				table.insert(finalKeys, keys.KeyCode)
			end
		end
	end
	
	local count = 0

	repeat
		wait()
		count = count + 1

	until
	not userInputService:IsKeyDown(Enum.KeyCode.Space) and not userInputService:IsGamepadButtonDown(GetActiveGamepad(), Enum.KeyCode.ButtonX) or count >= 12
	
	dodgeStatus = true
	
	if count < 10 then
		remote3:InvokeServer(finalKeys[1])
	else
		remote4:InvokeServer(finalKeys[1])
	end
		
	wait(1.5)
	
	dodgeStatus = false
	
end

function module.HeavyAttackBinding()
	
	if attackDebounce == true then return end
	
--	attackDebounce = true
	remote2:InvokeServer(character)
	attackDebounce = false

end

function module.LightAttackBinding()
	
	if attackDebounce == true then return end
	
--	attackDebounce = true
	remote1:InvokeServer(character)
	attackDebounce = false
	
end

function module.EquipBinding()
	
	if equipped == false  then
		
		remote10:InvokeServer(character)
		
		equipped = true
		
	elseif equipped == true then
		
		remote11:InvokeServer(character)
		
		equipped = false
	end
	
end

local sprinting = false

function module.SprintBinding()
		
	if sprinting == true then return end
	
	if equipped == true then return end
	
	if bowStatus == true then return end
	if bowDebounce == true then return end
	if dodgeStatus == true then return end
	
	local sprintEngage = remote12:FireServer()
			
	sprinting = true
	
	repeat
		wait(.05)
	until
	userInputService:IsKeyDown(Enum.KeyCode.LeftShift) == false and userInputService:IsGamepadButtonDown(GetActiveGamepad(), Enum.KeyCode.Thumbstick1) == false
		
	remote13:FireServer()
	
	sprinting = false
	
end

if not userInputService.GamepadEnabled then
	inputHandler:BindFunction(module.AimBowBinding, "InputBegan", "MouseButton2", nil)
	inputHandler:BindFunction(module.FireBowBinding, "InputBegan", "MouseButton1", nil)
	inputHandler:BindFunction(module.DodgeBinding, "InputBegan", "Keyboard", Enum.KeyCode.Space)
	inputHandler:BindFunction(module.EquipBinding, "InputBegan", "Keyboard", Enum.KeyCode.One)
	inputHandler:BindFunction(module.SprintBinding, "InputBegan", "Keyboard", Enum.KeyCode.LeftShift)
else
	inputHandler:BindFunction(module.AimBowBinding, "InputBegan", "Gamepad1", Enum.KeyCode.ButtonL2)
	inputHandler:BindFunction(module.FireBowBinding, "InputBegan", "Gamepad1", Enum.KeyCode.ButtonR2)
	inputHandler:BindFunction(module.DodgeBinding, "InputBegan", "Gamepad1", Enum.KeyCode.ButtonX)
	inputHandler:BindFunction(module.SprintBinding, "InputBegan", "Gamepad1", Enum.KeyCode.Thumbstick1)
end

userInputService.GamepadConnected:Connect(function(gamepad)
	
	if gamepad ~= Enum.UserInputType.Gamepad1 then return end
	
	inputHandler:UnbindFunction("MouseButton2", nil)
	inputHandler:UnbindFunction("MouseButton1", nil)
	inputHandler:UnbindFunction("Keyboard", Enum.KeyCode.Space)
	inputHandler:UnbindFunction("Keyboard", Enum.KeyCode.One)
	inputHandler:UnbindFunction("Keyboard", Enum.KeyCode.LeftShift)

	inputHandler:BindFunction(module.AimBowBinding, "InputBegan", "Gamepad1", Enum.KeyCode.ButtonL2)
	inputHandler:BindFunction(module.FireBowBinding, "InputBegan", "Gamepad1", Enum.KeyCode.ButtonR2)
	inputHandler:BindFunction(module.DodgeBinding, "InputBegan", "Gamepad1", Enum.KeyCode.ButtonX)
	inputHandler:BindFunction(module.SprintBinding, "InputBegan", "Gamepad1", Enum.KeyCode.Thumbstick1)

end)

userInputService.GamepadDisconnected:Connect(function(gamepad)
	
	if gamepad ~= Enum.UserInputType.Gamepad1 then return end

	inputHandler:UnbindFunction("Gamepad1",Enum.KeyCode.ButtonL2)
	inputHandler:UnbindFunction("Gamepad1",Enum.KeyCode.ButtonR2)
	inputHandler:UnbindFunction("Gamepad1", Enum.KeyCode.ButtonX)
	inputHandler:UnbindFunction("Gamepad1", Enum.KeyCode.Thumbstick1)

	inputHandler:BindFunction(module.AimBowBinding, "InputBegan", "MouseButton2", nil)
	inputHandler:BindFunction(module.FireBowBinding, "InputBegan", "MouseButton1", nil)
	inputHandler:BindFunction(module.DodgeBinding, "InputBegan", "Keyboard", Enum.KeyCode.Space)
	inputHandler:BindFunction(module.EquipBinding, "InputBegan", "Keyboard", Enum.KeyCode.One)
	inputHandler:BindFunction(module.SprintBinding, "InputBegan", "Keyboard", Enum.KeyCode.LeftShift)

end)

userInputService.InputBegan:Connect(function(input, gameprocessed)
	
	if gameprocessed then return end
	
	if input.UserInputType == Enum.UserInputType.Gamepad1 then
		
		if input.KeyCode == Enum.KeyCode.ButtonL2 then
			
			l2Down = true
			
		elseif input.KeyCode == Enum.KeyCode.ButtonR2 then
			
			r2Down = true
			
		end
		
	end
	
end)

userInputService.InputEnded:Connect(function(input, gameprocessed)

	if gameprocessed then return end

	if input.UserInputType == Enum.UserInputType.Gamepad1 then

		if input.KeyCode == Enum.KeyCode.ButtonL2 then

			l2Down = false
			
		elseif input.KeyCode == Enum.KeyCode.ButtonR2 then

			r2Down = false	
			
		end

	end

end)

return module
