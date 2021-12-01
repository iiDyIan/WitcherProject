local module = {}

local statusDict = {}

local animationModule = require(script.Parent.Parent:WaitForChild('AnimationHandler'))

local remoteStorage = game:GetService("ReplicatedStorage"):WaitForChild("EncryptedFunctions")

local remote1 = remoteStorage:WaitForChild("LightAttack")
local remote2 = remoteStorage:WaitForChild("HeavyAttack")

local remote3 = remoteStorage:WaitForChild("LightAttack")
local remote4 = remoteStorage:WaitForChild("HeavyAttack")

local remote5 = remoteStorage:WaitForChild("Parry")

function module.init(sendModule, character, weapon)
	
	local torso = character:WaitForChild("UpperTorso")

	local primary = weapon:Clone()

	primary.Parent = character
	primary.Name = "Primary"

	local m6d = script.Primary:Clone()

	m6d.Part0 = character.UpperTorso
	m6d.Part1 = primary.Primary

	m6d.Parent = character.UpperTorso
	m6d.Name = "Primary"

	statusDict[character.Name] = 1

end

function module.StartEquip(character)

	if statusDict[character.Name] ~= 1 then return end

	statusDict[character.Name] = 2

	if not character:FindFirstChild("Primary") then return "Primary weapon not identified." end

	local weapon = character:FindFirstChild("Primary")

	animationModule:PlayAnimation(character.Humanoid, "SwordClass", "Equip")

	wait(18/60)

	if character:FindFirstChild("UpperTorso") then
		if character:FindFirstChild("UpperTorso"):FindFirstChild("Primary") then
			character:FindFirstChild("UpperTorso"):FindFirstChild("Primary"):Destroy()
		end
	end

	local equipM6D = script.EquipPrimary:Clone()

	equipM6D.Part0 = character:FindFirstChild("RightHand")
	equipM6D.Part1 = weapon.Primary	

	equipM6D.Parent = character:FindFirstChild("RightHand")

	wait(18/60)

	animationModule:PlayAnimation(character.Humanoid, "SwordClass", "Idle")
	
	statusDict[character.Name] = 3

	return "Weapon equipped."

end

function module.StartUnequip(character)

	if statusDict[character.Name] ~= 3 then return end

	statusDict[character.Name] = 4
	
	if not character:FindFirstChild("Primary") then return "Primary weapon not identified." end

	local weapon = character:FindFirstChild("Primary")

	animationModule:PlayAnimation(character.Humanoid, "SwordClass", "Unequip")

	wait(18/60)

	if character:FindFirstChild("RightHand") then
		if character:FindFirstChild("RightHand"):FindFirstChild("EquipPrimary") then
			character:FindFirstChild("RightHand"):FindFirstChild("EquipPrimary"):Destroy()
		end
	end

	local primaryM6D = script.Primary:Clone()

	primaryM6D.Part0 = character:FindFirstChild("UpperTorso")
	primaryM6D.Part1 = weapon.Primary	

	primaryM6D.Parent = character:FindFirstChild("UpperTorso")

	wait(19/60)

	animationModule:StopAnimation(character.Humanoid, "SwordClass", "Idle")
	
	statusDict[character.Name] = 1
	
	return "Weapon unequipped."
	
end

function module.EngageHeavy(character)

	if not statusDict[character.Name] == 3 then return end

	

end

function module.EngageLight(character)

	if not statusDict[character.Name] == 3 then return end

end

function module.EngageParry(character)

	if not statusDict[character.Name] == 3 then return end


end

return module
