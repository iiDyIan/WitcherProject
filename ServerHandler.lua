local bowHandler = require(script:WaitForChild("CombatHandler"):WaitForChild("BowHandler"))
local weaponHandler = require(script:WaitForChild("CombatHandler"):WaitForChild("WeaponHandler"))
local powerHandler = require(script:WaitForChild("CombatHandler"):WaitForChild("PowerHandler"))
local dodgeHandler = require(script:WaitForChild("CombatHandler"):WaitForChild("DodgeHandler"))

local animationHandler = require(script:WaitForChild("AnimationHandler"))

local weapons = game:GetService("ServerStorage"):WaitForChild("Assets"):WaitForChild("PrimaryWeapons")

local players = game:GetService("Players")

local function onCharacterAdded(character)
	
	while character.Parent == nil do
		character.AncestryChanged:wait()
	end
	
	powerHandler:DestroyPlayerPower(character.Name)	
	
	bowHandler:SetUpPlayerBow(character)
	weaponHandler:SetUpPlayerPrimary(character, weapons:WaitForChild("Swords"):WaitForChild("UlferbertSword"):WaitForChild("Primary"))

	powerHandler:EstablishPlayerPower(character.Name)
	animationHandler:GenerateAnimations(character:WaitForChild("Humanoid"))
	
	wait(2)	
	
	local characterBits = character:GetChildren()
	
	for i = 1,#characterBits do
					
		if characterBits[i].ClassName == "MeshPart" or characterBits[i].ClassName == "Part" then
			
			characterBits[i].Color = Color3.fromRGB(255,255,255)

		end
		
	end
	
end


local function onPlayedAdded(player)
	
	player.CharacterAdded:Connect(onCharacterAdded)
	
end

players.PlayerAdded:Connect(onPlayedAdded)


local encryptedFunctions = require(script:WaitForChild("EncryptedFunctions"))
