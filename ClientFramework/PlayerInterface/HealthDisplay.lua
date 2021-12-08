local module = {}

local player = game.Players.LocalPlayer
local playerGUI = player:WaitForChild("PlayerGui")

local character = player.Character or player.CharacterAdded:wait()

local healthBar = playerGUI:WaitForChild("HUDUI"):WaitForChild("Frame"):WaitForChild("Frame"):WaitForChild("ImageLabel"):WaitForChild("Frame1")

local tweenService = game:GetService("TweenService")

local function tweenObject(object, length, properties)

	local tInfo = TweenInfo.new(length, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0)
	local tween = tweenService:Create(object, tInfo, properties):Play()

end

function module.PlayerHealthChanged()
	
	if character.Humanoid.Health <= 2.5 then
		
		tweenObject(healthBar, .35, {Size = UDim2.new(character.Humanoid.Health/character.Humanoid.MaxHealth, 0, .4, -4)})
		
	else
		
		tweenObject(healthBar, .35, {Size = UDim2.new((character.Humanoid.Health/character.Humanoid.MaxHealth)-.025, -4, .4, -4)})
		
	end
	

end

character:WaitForChild("Humanoid").HealthChanged:Connect(module.PlayerHealthChanged)

return module
