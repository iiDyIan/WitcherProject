local module = {}

local statusDict = {}
local activityTable = {}

local animationModule = require(script.Parent.Parent:WaitForChild('AnimationHandler'))
local hitboxModule = require(script:WaitForChild("HitBoxHandler"))

local remoteStorage = game:GetService("ReplicatedStorage"):WaitForChild("EncryptedFunctions")

local remote1 = remoteStorage:WaitForChild("LightAttack")
local remote2 = remoteStorage:WaitForChild("HeavyAttack")

local remote3 = remoteStorage:WaitForChild("EquipMelee")
local remote4 = remoteStorage:WaitForChild("UnequipMelee")

local remote5 = remoteStorage:WaitForChild("Parry")

local hitBoxConnections = {}

local sequenceDict = {
	
	[1] = "A",
	[2] = "B",
	[3] = "C",
	
}

local function fetchAnimation(sequence, attack, attackType)
	
	local animationName
	
	if attackType == 0 then
		
		animationName = "LightAttack"
		
	elseif attackType == 1 then
		
		animationName = "HeavyAttack"
		
	end
	
	animationName = animationName..attack..sequenceDict[sequence]
	
	return animationName
	
end

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
	
	local hitBox = hitboxModule:CreateHitbox(weapon, character)

	local function OnHit(hit)
		
		if not hit then return end
		if not hit.Parent then return end
		if not hit.Parent.Parent then return end
		
		if math.abs(activityTable[character.Name][1] - os.time()) >= 2 then return end
		
		local hitCharacter
		
		if hit:FindFirstAncestorOfClass("Model") then
			hitCharacter = hit:FindFirstAncestorOfClass("Model"):FindFirstChildOfClass("Humanoid").Parent
		end
		
		if not hitCharacter then return end
		
		local attackType = activityTable[4]
		
		if not hitCharacter:FindFirstChild("Dodging") then return end
		if not hitCharacter:FindFirstChild("Parrying") then return end

		if attackType == 0 then
			
			-- light attack
			
			if hitCharacter:FindFirstChild("Parrying").Value == true then
				
				-- get parried loser
				
				return
				
			elseif hitCharacter:FindFirstChild("Dodging").Value == true then
				
				-- dodged
				
				return
					
			else
				
				-- record hit
				
				return
				
			end
			
		elseif attackType == 1 then
			
			-- heavy attack
						
			if hitCharacter:FindFirstChild("Dodging").Value == true then
				
				-- dodged
				
				return
					
			else
				
				-- record hit
				
				return
				
			end

		end
	end
	
	local connection = hitBox.OnHit:Connect(OnHit)
	hitBoxConnections[character.Name] = connection
	
	return "Weapon equipped."

end

function module.StartUnequip(character)

	if statusDict[character.Name] ~= 3 then return end

	statusDict[character.Name] = 8
	
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
	
	hitboxModule:DeleteHitbox(character)
	
	if hitBoxConnections[character.Name] then
		hitBoxConnections[character.Name]:Disconnect()
		hitBoxConnections[character.Name] = nil
	end
	
	return "Weapon unequipped."
	
end

function module.DetermineAttack(character, attackType)
	
	local priorActivityTable = activityTable[character.Name]
	local sequence
	local attack

	if math.abs(priorActivityTable[1] - os.time()) >= 5 then

		if priorActivityTable[2] < 3 then
			sequence = priorActivityTable[2] + 1
		else
			sequence = 1
		end

	elseif activityTable[character.Name] < 6 then

		attack = priorActivityTable[3] + 1

	else

		sequence = sequence + 1
		attack = 1

	end

	activityTable[character.Name] = {

		os.time(),
		sequence,
		attack,
		attackType,

	}
	
	return activityTable[character.Name]
	
end

function module.EngageHeavy(character)

	if not statusDict[character.Name] == 3 then return end

	statusDict[character.Name] = 5
	
	local attackTable = module.DetermineAttack(character, 1)
	local animationName = fetchAnimation(attackTable[2], attackTable[3], attackTable[4])
	
	character.Primary.Primary.Trail.Color = script.HeavyTrail.Color
	character.Primary.Primary.Trail.Enabled = true
	
	local animation = animationModule:PlayAnimation(character:WaitForChild("Humanoid"), "SwordClass", animationName)
	activityTable[character.Name][5] = animation
	
	wait(animation.Length)
	
	character.Primary.Primary.Trail.Enabled = false
	
	activityTable[character.Name][5] = nil
	
	return
		
end

function module.EngageLight(character)

	if not statusDict[character.Name] == 3 then return end

	statusDict[character.Name] = 6

	local attackTable = module.DetermineAttack(character, 0)
	local animationName = fetchAnimation(attackTable[2], attackTable[3], attackTable[4])

	character.Primary.Primary.Trail.Color = script.HeavyTrail.Color
	character.Primary.Primary.Trail.Enabled = true

	local animation = animationModule:PlayAnimation(character:WaitForChild("Humanoid"), "SwordClass", animationName)
	activityTable[character.Name][5] = animation

	wait(animation.Length)

	character.Primary.Primary.Trail.Enabled = false

	activityTable[character.Name][5] = nil
	
end

function module.EngageParry(character)

	if not statusDict[character.Name] == 3 then return end

	statusDict[character.Name] = 8
	
end

remote1.OnServerInvoke = module.EngageLight
remote2.OnServerInvoke = module.EngageHeavy

remote3.OnServerInvoke = module.StartEquip
remote4.OnServerInvoke = module.StartUnequip

remote5.OnServerInvoke = module.EngageParry

return module
