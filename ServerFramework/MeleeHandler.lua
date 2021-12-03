local module = {}

local statusDict = {}
local activityTable = {}

local animationModule = require(script.Parent.Parent:WaitForChild('AnimationHandler'))
local hitboxModule = require(script:WaitForChild("HitBoxHandler"))
local damageModule = require(script.Parent:WaitForChild("DamageHandler"))

local remoteStorage = game:GetService("ReplicatedStorage"):WaitForChild("EncryptedFunctions")

local remote1 = remoteStorage:WaitForChild("LightAttack")
local remote2 = remoteStorage:WaitForChild("HeavyAttack")

local remote3 = remoteStorage:WaitForChild("EquipMelee")
local remote4 = remoteStorage:WaitForChild("UnequipMelee")

local remote5 = remoteStorage:WaitForChild("Parry")

local damageDebounce = {}
local hitBoxConnections = {}
local queueList = {}

local sequenceDict = {
	
	"A",
	"B",
	"C",
	
}

local attackTypeTranslate = {
	
	[0] = "LightSwordStrike",
	[1] = "HeavySwordStrike",
	
}

local function fetchAnimation(sequence, attack, attackType)
	
	local animationName
	
	if attackType == 0 then
		
		animationName = "LightAttack"
		
	elseif attackType == 1 then
		
		animationName = "HeavyAttack"
		
	end
	
	animationName = animationName..tostring(attack)..tostring(sequenceDict[sequence])
	
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
	
	activityTable[character.Name] = {
		
		os.time(),
		1,
		1,
		1,
		
	}
	
	queueList[character.Name] = false
	statusDict[character.Name] = 1

end

function module.StartEquip(sendModule, character)

	if statusDict[character.Name] ~= 1 then return statusDict[character.Name] end

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
				
		if (os.time() - activityTable[character.Name][1]) >= 2 then return end
				
		local hitCharacter
		
		if hit:FindFirstAncestorOfClass("Model") then
			hitCharacter = hit:FindFirstAncestorOfClass("Model"):FindFirstChildOfClass("Humanoid").Parent
		end
		
		if not hitCharacter then return end
				
		local attackType = activityTable[character.Name][4]
				
		if not hitCharacter:FindFirstChild("Dodging") then return end
		if not hitCharacter:FindFirstChild("Parrying") then return end
		
		print(1)
		
		--if not damageDebounce[character.Name] then return end
		if damageDebounce[character.Name][hitCharacter.Name] == true then return end
		
		print(2)
		
		if attackType == 0 then
			
			if hitCharacter:FindFirstChild("Parrying").Value == true then
				
				print("Hit, but effectively parried.")
				
				return
				
			elseif hitCharacter:FindFirstChild("Dodging").Value == true then
				
				print("Hit, but player was dodging! (a)")
				
				return
					
			else
				
				damageModule:DamageHumanoid(character.Name, hitCharacter:FindFirstChild("Humanoid"), hit, attackTypeTranslate[attackType])
				damageDebounce[character.Name][hitCharacter.Name] = true

				return
				
			end
			
		elseif attackType == 1 then
									
			if hitCharacter:FindFirstChild("Dodging").Value == true then
				
				print("Hit, but player was dodging! (b)")
				
				return
					
			else
				
				damageModule:DamageHumanoid(character.Name, hitCharacter:FindFirstChild("Humanoid"), hit, attackTypeTranslate[attackType])
				damageDebounce[character.Name][hitCharacter.Name] = true

				return
				
			end

		end
	end
	
	local connection = hitBox.OnHit:Connect(OnHit)
	hitBoxConnections[character.Name] = {connection, hitBox}
	
	return "Weapon equipped."

end

function module.StartUnequip(sendModule, character)

	if statusDict[character.Name] ~= 3 then return statusDict[character.Name] end

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
		if hitBoxConnections[character.Name][1] then
			hitBoxConnections[character.Name]:Disconnect()
			hitBoxConnections[character.Name] = nil
		end
	end
	
	return "Weapon unequipped."
	
end

function module.DetermineAttack(character, attackType)
	
	local priorActivityTable = activityTable[character.Name]
	local sequence
	local attack
	
	if (os.time() - priorActivityTable[1]) >= .4 then

		if priorActivityTable[2] < 3 then
			sequence = priorActivityTable[2] + 1
		else
			sequence = 1
		end
		
	else

		sequence = priorActivityTable[2]

	end

	if sequence ~= priorActivityTable[2] then

		attack = 1

	elseif priorActivityTable[3] <= 5 then

		attack = priorActivityTable[3] + 1

	else

		if priorActivityTable[2] < 3 then
			sequence = priorActivityTable[2] + 1
			attack = 1
		else
			sequence = 1		
			attack = 1
		end
	
	end	

	activityTable[character.Name] = {

		os.time(),
		sequence,
		attack,
		attackType,

	}
	
	return activityTable[character.Name]
		
		
end

function module.EngageHeavy(sendModule, character)

	if statusDict[character.Name] ~= 3 then 
		if queueList[character.Name] == true then

			return

		else

			queueList[character.Name] = true

			repeat
				wait(.05)
			until
			statusDict[character.Name] == 3

		end
	end

	queueList[character.Name] = false
	statusDict[character.Name] = 5
	
	local attackTable = module.DetermineAttack(character, 1)
	local animationName = fetchAnimation(attackTable[2], attackTable[3], attackTable[4])
	
	character.Primary.Primary.Trail.Color = script.HeavyTrail.Color
	character.Primary.Primary.Trail.Enabled = true
	
	local animation = animationModule:PlayAnimation(character:WaitForChild("Humanoid"), "SwordClass", animationName)
	
	if animation.Length then
		
		damageDebounce[character.Name] = {}

		hitBoxConnections[character.Name][2]:HitStart()
		
		activityTable[character.Name][5] = animation
		activityTable[character.Name][1] = activityTable[character.Name][1] + animation.Length
		
	end
	
	wait(animation.Length)
	
	statusDict[character.Name] = 3
	character.Primary.Primary.Trail.Enabled = false
	
	activityTable[character.Name][5] = nil
	
	hitBoxConnections[character.Name][2]:HitStop()
	
	return
		
end

function module.EngageLight(sendModule, character)

	if statusDict[character.Name] ~= 3 then 
		if queueList[character.Name] == true then
			
			return
				
		else
			
			queueList[character.Name] = true
			
			repeat
				wait(.05)
			until
			statusDict[character.Name] == 3
				
		end
	end
	
	queueList[character.Name] = false
	statusDict[character.Name] = 6

	local attackTable = module.DetermineAttack(character, 0)
	local animationName = fetchAnimation(attackTable[2], attackTable[3], attackTable[4])

	character.Primary.Primary.Trail.Color = script.DefaultTrail.Color
	character.Primary.Primary.Trail.Enabled = true
	
	local animation = animationModule:PlayAnimation(character:WaitForChild("Humanoid"), "SwordClass", animationName)
	
	if animation.Length then
		
		damageDebounce[character.Name] = {}
		
		hitBoxConnections[character.Name][2]:HitStart()
		
		activityTable[character.Name][5] = animation
		activityTable[character.Name][1] = activityTable[character.Name][1] + animation.Length

	end
	
	wait(animation.Length)
	
	statusDict[character.Name] = 3
	character.Primary.Primary.Trail.Enabled = false

	activityTable[character.Name][5] = nil
	
	hitBoxConnections[character.Name][2]:HitStop()
	
	return
	
end

function module.EngageParry(sendModule, character)

	if statusDict[character.Name] ~= 3 then return end

	statusDict[character.Name] = 8
	
end

remote1.OnServerInvoke = module.EngageLight
remote2.OnServerInvoke = module.EngageHeavy

remote3.OnServerInvoke = module.StartEquip
remote4.OnServerInvoke = module.StartUnequip

remote5.OnServerInvoke = module.EngageParry

return module
