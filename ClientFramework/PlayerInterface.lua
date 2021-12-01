local tweenService = game:GetService("TweenService")
local debrisService = game:GetService("Debris")

local clientInformation = require(script.ClientInformation)
local markerDisplay = require(script.MarkerDisplay)
local healthDisplay = require(script.HealthDisplay)

local player = game.Players.LocalPlayer

local ui = player:WaitForChild("PlayerGui"):WaitForChild("CombatUI")
local hudui = player:WaitForChild("PlayerGui"):WaitForChild("HUDUI")

local powerFrame = hudui:WaitForChild("Frame"):WaitForChild("Frame"):WaitForChild("ImageLabel"):WaitForChild("Frame2")

local remote1 = game:GetService("ReplicatedStorage"):WaitForChild("EncryptedFunctions"):WaitForChild("UpdatePower")
local remote2 = game:GetService("ReplicatedStorage"):WaitForaChild("EncryptedFunctions"):WaitForChild("DisplayDamageUI")

local function tweenObject(length,object,properties)
	
	local tInfo = TweenInfo.new(length,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,0,false,0)
	local tween = tweenService:Create(object,tInfo,properties):Play()
	
end

local module = {}

local bowEnabled = false

function module.DisplayBow()
	
	if not ui then return end
	if not ui:FindFirstChild("Bow") then return end
	if not ui:FindFirstChild("Bow"):FindFirstChild("Frame2") then return end
	
	tweenObject(.2,ui.Bow.Frame,{BackgroundTransparency = 0.05})
	tweenObject(.2,ui.Bow.Frame2,{BackgroundTransparency = 0.05})

	tweenObject(.2,ui.Bow.Frame.Frame,{BackgroundTransparency = .2})
	tweenObject(.2,ui.Bow.Frame2.Frame,{BackgroundTransparency = .2})

	tweenObject(.2,ui.Bow.ImageLabel,{ImageTransparency = 0.05})
	tweenObject(.2,ui.Bow.ImageLabel.ImageLabel,{ImageTransparency = .2})
	
	bowEnabled = true
	
end

function module.HideBow()
	
	if not ui then return end
	if not ui:FindFirstChild("Bow") then return end
	if not ui:FindFirstChild("Bow"):FindFirstChild("Frame2") then return end
	
	tweenObject(.25,ui.Bow.Frame,{BackgroundTransparency = 1})
	tweenObject(.25,ui.Bow.Frame2,{BackgroundTransparency = 1})
	
	tweenObject(.25,ui.Bow.Frame.Frame,{BackgroundTransparency = 1})
	tweenObject(.25,ui.Bow.Frame2.Frame,{BackgroundTransparency = 1})
	
	tweenObject(.25,ui.Bow.ImageLabel,{ImageTransparency = 1})
	tweenObject(.25,ui.Bow.ImageLabel.ImageLabel,{ImageTransparency = 1})
	
	bowEnabled = false
	
end

function module.UpdatePower(powerLevel)
	
	if not powerFrame then return end
	if not powerFrame:FindFirstChild("Frame4") then return end
	if not powerFrame:FindFirstChild("Frame4"):FindFirstChild("AccentFrame") then return end
	
	if powerLevel >= 400 then
		
		tweenObject(.125, powerFrame.Frame1.AccentFrame, {Size = UDim2.new(1,0,1,0)})
		tweenObject(.125, powerFrame.Frame2.AccentFrame, {Size = UDim2.new(1,0,1,0)})
		tweenObject(.125, powerFrame.Frame3.AccentFrame, {Size = UDim2.new(1,0,1,0)})
		tweenObject(.125, powerFrame.Frame4.AccentFrame, {Size = UDim2.new(1,0,1,0)})
		
	elseif powerLevel > 300 then
		
		tweenObject(.125, powerFrame.Frame1.AccentFrame, {Size = UDim2.new(1,0,1,0)})
		tweenObject(.125, powerFrame.Frame2.AccentFrame, {Size = UDim2.new(1,0,1,0)})
		tweenObject(.125, powerFrame.Frame3.AccentFrame, {Size = UDim2.new(1,0,1,0)})
		tweenObject(.125, powerFrame.Frame4.AccentFrame, {Size = UDim2.new((powerLevel - 300)/100,0,1,0)})
		
	elseif powerLevel > 200 then
		
		tweenObject(.125, powerFrame.Frame1.AccentFrame, {Size = UDim2.new(1,0,1,0)})
		tweenObject(.125, powerFrame.Frame2.AccentFrame, {Size = UDim2.new(1,0,1,0)})
		tweenObject(.125, powerFrame.Frame3.AccentFrame, {Size = UDim2.new((powerLevel - 200)/100,0,1,0)})
		tweenObject(.125, powerFrame.Frame4.AccentFrame, {Size = UDim2.new(0,0,1,0)})
		
	elseif powerLevel > 100 then
		
		tweenObject(.125, powerFrame.Frame1.AccentFrame, {Size = UDim2.new(1,0,1,0)})
		tweenObject(.125, powerFrame.Frame2.AccentFrame, {Size = UDim2.new((powerLevel - 100)/100,0,1,0)})
		tweenObject(.125, powerFrame.Frame3.AccentFrame, {Size = UDim2.new(0,0,1,0)})
		tweenObject(.125, powerFrame.Frame4.AccentFrame, {Size = UDim2.new(0,0,1,0)})
		
	elseif powerLevel > 0 then
		
		tweenObject(.125, powerFrame.Frame1.AccentFrame, {Size = UDim2.new((powerLevel)/100,0,1,0)})
		tweenObject(.125, powerFrame.Frame2.AccentFrame, {Size = UDim2.new(0,0,1,0)})
		tweenObject(.125, powerFrame.Frame3.AccentFrame, {Size = UDim2.new(0,0,1,0)})
		tweenObject(.125, powerFrame.Frame4.AccentFrame, {Size = UDim2.new(0,0,1,0)})
		
	end
	
end

function module.IndicateBowHostile()
	
	if not player.Character then return end
	if not player.Character:FindFirstChild("Humanoid") then return end
	if player.Character:FindFirstChild("Humanoid").Health <= 0 then return end
	
	if not ui then return end
	if not ui:FindFirstChild("Bow") then return end
	if not ui:FindFirstChild("Bow"):FindFirstChild("Frame2") then return end
	
	local mouse = player:GetMouse()
	if mouse.Target then
		if mouse.Target.Parent then
			
			if not mouse.Target.Parent.Parent then return end
			
			if mouse.Target:FindFirstAncestorOfClass("Model") then
				
				if mouse.Target:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
				
					if bowEnabled == true then
						
						tweenObject(.075, ui.Bow.ImageLabel, {ImageColor3 = Color3.fromRGB(230,0,0)})
						tweenObject(.075, ui.Bow.Frame, {BackgroundColor3 = Color3.fromRGB(230,0,0)})
						tweenObject(.075, ui.Bow.Frame2, {BackgroundColor3 = Color3.fromRGB(230,0,0)})
						
						return
						
					end	
				end	
			end	
		end
	end
	
	tweenObject(.075, ui.Bow.ImageLabel, {ImageColor3 = Color3.fromRGB(230, 230, 230)})
	tweenObject(.075, ui.Bow.Frame, {BackgroundColor3 = Color3.fromRGB(230, 230, 230)})
	tweenObject(.075, ui.Bow.Frame2, {BackgroundColor3 = Color3.fromRGB(230, 230, 230)})
	
end

function module.DisplayHitmarker()
	
	if not ui then return end
	if not ui:FindFirstChild("Bow") then return end
	if not ui:FindFirstChild("Bow"):FindFirstChild("Frame2") then return end
	
	tweenObject(.225, ui.Bow.Frame.HitmarkerFrame, {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 0})
	tweenObject(.225, ui.Bow.Frame2.HitmarkerFrame, {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 0})
	
	wait(.3)
	
	if not ui then return end
	if not ui:FindFirstChild("Bow") then return end
	if not ui:FindFirstChild("Bow"):FindFirstChild("Frame2") then return end
	
	tweenObject(.175, ui.Bow.Frame.HitmarkerFrame, {Size = UDim2.new(0,0,1,0), BackgroundTransparency = 1, Position = UDim2.new(0,0,.5,0), AnchorPoint = Vector2.new(0,.5)})
	tweenObject(.175, ui.Bow.Frame2.HitmarkerFrame, {Size = UDim2.new(0,0,1,0), BackgroundTransparency = 1, Position = UDim2.new(1,0,.5,0), AnchorPoint = Vector2.new(1,.5)})
	
	
	wait(.2)
	
	if not ui then return end
	if not ui:FindFirstChild("Bow") then return end
	if not ui:FindFirstChild("Bow"):FindFirstChild("Frame2") then return end
	
	ui.Bow.Frame.HitmarkerFrame.Position = UDim2.new(1,0,.5,0)
	ui.Bow.Frame2.HitmarkerFrame.Position = UDim2.new(0,0,.5,0)

	ui.Bow.Frame.HitmarkerFrame.AnchorPoint = Vector2.new(1,.5)
	ui.Bow.Frame2.HitmarkerFrame.AnchorPoint = Vector2.new(0,.5)

end

function module.PopupDamage(humanoid, damageLimb, damage)
	
	local randomRotation = math.random(1,20)
	local randomOffset = math.random(1,2)
	
	if randomOffset == 1 then
		randomRotation = randomRotation
	else
		randomRotation = randomRotation * -1	
	end
	
	local damagePopup = game:GetService("ReplicatedStorage"):WaitForChild("DamagePopup"):Clone()
	
	damagePopup.Frame.TextLabel.Text = damage
	damagePopup.Frame.TextLabel.TextLabel.Text = damage
	
	damagePopup.Parent = damageLimb
	
	tweenObject(.25, damagePopup.Frame.TextLabel, {TextTransparency = 0, Rotation = randomRotation, Position = UDim2.new(.5,0,.5,0)})
	tweenObject(.25, damagePopup.Frame.TextLabel.TextLabel, {TextTransparency = 0, Rotation = randomRotation})

	debrisService:AddItem(damagePopup, .325)
	
	module.DisplayHitmarker()
	
end

game:GetService("UserInputService").InputChanged:Connect(module.IndicateBowHostile)

remote1.OnClientEvent:Connect(module.UpdatePower)
remote2.OnClientEvent:Connect(module.PopupDamage)

return module
