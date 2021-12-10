local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

UIS.MouseIconEnabled = false

local Player = game.Players.LocalPlayer

repeat wait() until Player.Character
repeat wait() until Player.Character.Humanoid
repeat wait() until Player.Character.HumanoidRootPart

local Character = Player.Character
local HumanoidRootPart = Character.HumanoidRootPart
local UpperTorso = Character.UpperTorso
local Humanoid = Character.Humanoid

Humanoid.AutoRotate = false

local Enabled = true

local Mouse = Player:GetMouse()

local Popper = true

local DeltaX = 0
local DeltaY = 0

local AngleH = 0
local AngleV = 0

local SensitivityY = 300
local SensitivityX = 300

local MobileSensitivityY = 150
local MobileSensitivityX = 150

local W = false
local A = false
local S = false
local D = false

local MaxY = 5*math.pi/12
local MinY = -5*math.pi/12

local mobileEnabled = not UIS.KeyboardEnabled

local Combinations = {

	{true, false, false, false, 0, 0},
	{true, true, false, false, math.pi/4},
	{false, true, false, false, math.pi/2},
	{false, true, true, false, 3*math.pi/4},
	{false, false, true, false, math.pi},
	{false, false, true, true, 5*math.pi/4},
	{false, false, false, true, 3*math.pi/2},
	{true, false, false, true, 7*math.pi/4}

}

local Cam = game.Workspace.CurrentCamera
Cam.CameraType = Enum.CameraType.Scriptable
UIS.MouseBehavior = Enum.MouseBehavior.LockCenter

local Offset = script.Parent.PlayerData.CameraOffset

Offset.Value = CFrame.new(0, 3.75, 9.5)

local function tweenObject(object,length,CFrame2)

	local tInfo = TweenInfo.new(length,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut,0,false,0)
	local tween = TweenService:Create(object,tInfo,{CoordinateFrame = CFrame2}):Play()

end

local function tweenObject2(object,length,CFrame2)

	local tInfo = TweenInfo.new(length,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut,0,false,0)
	local tween = TweenService:Create(object,tInfo,{CFrame = CFrame2}):Play()

end

local module = {}

if mobileEnabled == true then
	SensitivityX = MobileSensitivityX
	SensitivityY = MobileSensitivityY
end

function module.RenderStepped()
	
	if Enabled == false then return end
	
	AngleH = AngleH - DeltaX/SensitivityX
	DeltaX = 0
	AngleV = math.clamp(AngleV - DeltaY/SensitivityY, MinY, MaxY)
	DeltaY = 0

	local FinalCFrame = CFrame.new(HumanoidRootPart.Position) * CFrame.Angles(0, AngleH, 0) * CFrame.Angles(AngleV, 0, 0) * Offset.Value

	if Popper == true then

		local Direction = (FinalCFrame.p - Character.Head.Position).Unit * ((Offset.Value.p).Magnitude)
		local CheckRay = Ray.new(Character.Head.Position, Direction)
		local Part, Position = game.Workspace:FindPartOnRay(CheckRay, Character, false, true)
	
		if Part then
			local Distance = (Position - FinalCFrame.p).Magnitude
			FinalCFrame = FinalCFrame * CFrame.new(0, 0, -Distance)
		end

	end

	tweenObject(Cam,script.Parent.PlayerData.TweenLength.Value,FinalCFrame)
	
	for Num, Val in pairs(Combinations) do

		local DirectionVector = Cam.CoordinateFrame.lookVector
		local Position = HumanoidRootPart.Position
		local TargetCFrame = CFrame.new(HumanoidRootPart.Position, HumanoidRootPart.Position + Vector3.new(DirectionVector.X, 0, DirectionVector.Z))
		if TargetCFrame then
			tweenObject2(HumanoidRootPart,.05, TargetCFrame)
		else
			return
		end
	end		
	
end

function module.InputChanged(Input, Bool)
	
	if Enabled == false then return end
	
	if(Bool == false) then

		if(Input.UserInputType == Enum.UserInputType.MouseMovement) then

			if(DeltaX ~= Input.Delta.X) then

				DeltaX = Input.Delta.X
			end

			if(DeltaY ~= Input.Delta.Y) then

				DeltaY = Input.Delta.Y
			end
			
		elseif (Input.UserInputType == Enum.UserInputType.Gamepad1) then
						
			if Input.KeyCode == Enum.KeyCode.Thumbstick1 then return end
			
			if(DeltaX ~= Input.Position.X) then

				DeltaX = Input.Position.X
			end

			if(DeltaY ~= Input.Position.Y) then

				DeltaY = Input.Delta.Y
			end	

		end
	end
	
end

function module.SetCameraEnabled(sendModule,boolEnabled)
		
	if type(boolEnabled) == "boolean" then
		
		Enabled = boolEnabled
		
		if Enabled == false then
			
			Cam.CameraType = Enum.CameraType.Custom
			
			UIS.MouseBehavior = Enum.MouseBehavior.Default
			UIS.MouseIconEnabled = true
			
			Humanoid.AutoRotate = true
			
		elseif Enabled == true then
			
			Cam.CameraType = Enum.CameraType.Scriptable

			UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
			UIS.MouseIconEnabled = false

			Humanoid.AutoRotate = false
			
		end
		
		return "Sucessfully set Camera Enabled to "..tostring(boolEnabled).."."
		
	else
		
		return "Error in setting Camera Enabled; boolEnabled parameter invalid."
		
	end
end

function module.TouchMoved(touch, Bool)
	
	if Enabled == false then return end

	if(Bool == false) then

		if(DeltaX ~= touch.Delta.X) then
				
			DeltaX = touch.Delta.X
		end

		if(DeltaY ~= touch.Delta.Y) then

			DeltaY = touch.Delta.Y
		end
		
	end	
	
end

function module.AltKeyDown(key, bool)

	if bool == true then return end
	
	local Cam = game.Workspace.CurrentCamera
	Cam.CameraType = Enum.CameraType.Custom
	UIS.MouseBehavior = Enum.MouseBehavior.Default
	
end

function module.AltKeyUp(key, bool)
	
	if bool == true then return end
	
	local Cam = game.Workspace.CurrentCamera
	Cam.CameraType = Enum.CameraType.Scriptable
	UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
	
end

local renderConnection = RunService.RenderStepped:Connect(module.RenderStepped)
local touchConnection = UIS.TouchMoved:Connect(module.TouchMoved)

if UIS.KeyboardEnabled == true then
	local inputConnection = UIS.InputChanged:Connect(module.InputChanged)
	local escapeKeyConnect = UIS.InputBegan:Connect(function(input, gameprocessed)
		if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
		
		if input.KeyCode == Enum.KeyCode.LeftAlt then
				module.AltKeyDown(input, gameprocessed)
		end
	end)
	local escapeKeyConnectUp = UIS.InputEnded:Connect(function(input, gameprocessed)
		if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
		
		if input.KeyCode == Enum.KeyCode.LeftAlt then
				module.AltKeyUp(input, gameprocessed)
		end
	end)
			
else
	local renderConnection = RunService.RenderStepped:Connect(module.RenderStepped)
	local touchConnection = UIS.TouchMoved:Connect(module.TouchMoved)
end

function module.OnPlayerDeath()
	
	if UIS.KeyboardEnabled == true then
		
		inputConnection:Disconnect()
		escapeKeyConnect:Disconnect()
		escapeKeyConnectUp:Disconnect()
		
	else
		touchConnection:Disconnect()
		renderConnection:Disconnect()
		
	end
end

Humanoid.Died:Connect(module.OnPlayerDeath)

return module
