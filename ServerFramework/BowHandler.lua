local bows = game:GetService("ServerStorage"):WaitForChild("Assets"):WaitForChild("Bows")

local weldModule = require(game:GetService("ReplicatedStorage"):WaitForChild("WeldHandler"))
local animationModule = require(game:GetService("ServerScriptService"):WaitForChild("ServerHandler"):WaitForChild("AnimationHandler"))
local projectileModule = require(script.Parent.Projectiles)

local arrowSpeedModifier = 200

local remote1
local remote2
local remote3
local remote4

remote1 = game:GetService("ReplicatedStorage"):WaitForChild("EncryptedFunctions"):WaitForChild("BowAim")
remote2 = game:GetService("ReplicatedStorage"):WaitForChild("EncryptedFunctions"):WaitForChild("BowAimEnd")

remote3 = game:GetService("ReplicatedStorage"):WaitForChild("EncryptedFunctions"):WaitForChild("BowDraw")
remote4 = game:GetService("ReplicatedStorage"):WaitForChild("EncryptedFunctions"):WaitForChild("BowDrawEnd")

local module = {}

local BowC0s = {}
local arrowC0s = {}
local stringC0s = bows:WaitForChild("DefaultBow"):WaitForChild("Bow"):WaitForChild("stringmid"):WaitForChild("Handle").C0

local debounce = {}
local debounce2 = {}
local debounce3 = {}
local debounce4 = {}

local debounce5 = {}
local debounce6 = {}

function module.SetUpPlayerBow(sendModule,character)
	
	local torso = character:WaitForChild("UpperTorso")
	
	local bow = bows:WaitForChild("DefaultBow"):Clone()
	
	bow.Parent = character
	bow.Name = "Bow"
	
	weldModule:Weld(bow.Middle, torso)
		
end

function module.GrabArrow(character)
	
	if debounce2[character.Name] == true then
		return
	end
	
	debounce[character.Name] = true
	
	local bow = nil

	if character:FindFirstChild("Bow") then
		bow = character:FindFirstChild("Bow")
	end

	if not bow then return end
	
	if bow.Quiver.Arrows.CurrentArrowCount.Value <= 0 then return end
	if bow.Quiver.Arrows.CurrentArrowCount.Value > bow.Quiver.Arrows.MaxArrowCount.Value then return end
	if bow.Quiver.Arrows.MaxArrowCount.Value > 12 then return end
	
	local arrowC0 = bow.Quiver.Primary["Arrow"..bow.Quiver.Arrows.CurrentArrowCount.Value].C0
	
	local humanoid = character:WaitForChild("Humanoid")	
	
	local stopAnim = animationModule:StopAnimation(humanoid, "DrawBow", "DrawBowLoop")	

	local playAnim = animationModule:PlayAnimation(humanoid, "GrabArrow", "Primary")
	bow.Bow.Handle.ArrowGrab:Play()
	
	wait(playAnim.Length/2)
	
	weldModule:LocateAndDestroyWelds(bow.Quiver.Primary, "Arrow"..tostring(bow.Quiver.Arrows.CurrentArrowCount.Value))
	weldModule:Weld(character:FindFirstChild("RightHand"), bow.Quiver.Arrows["Arrow"..bow.Quiver.Arrows.CurrentArrowCount.Value], nil, script.ArrowWeld.C0)
	
	bow.Bow.Handle.ArrowRack:Play()
	
	wait(playAnim.Length/2)
	
	debounce[character.Name] = false
	
	return arrowC0
	
end

function module.PutAwayArrow(character)
	
	--[[
	if debounce[character.Name] == true then
				
		repeat
			wait(.1)
		until
		debounce[character.Name] == false		

	end
	]]
	local bow

	if character:FindFirstChild("Bow") then
		bow = character:FindFirstChild("Bow")
	end

	if not bow then return end
	
	if bow.Quiver.Arrows.CurrentArrowCount.Value <= 0 then return end
	
	if not arrowC0s[character.Name] then return end
	
	debounce2[character.Name] = true
	
	local humanoid = character:WaitForChild("Humanoid")
	local playAnim = animationModule:PlayAnimation(humanoid, "PutAwayArrow", "Primary")
	
	bow.Bow.Handle.ArrowGrab:Play()
	
	wait(playAnim.Length/2)
	
	weldModule:LocateAndDestroyWelds(character:WaitForChild("RightHand"), "Arrow"..bow.Quiver.Arrows.CurrentArrowCount.Value)
	weldModule:Weld(bow.Quiver.Primary, bow.Quiver.Arrows["Arrow"..bow.Quiver.Arrows.CurrentArrowCount.Value],  nil, arrowC0s[character.Name])
	
	arrowC0s[character.Name] = nil
	
	wait(playAnim.Length/2)
	
	debounce2[character.Name] = false
	
	return
end

function module.EquipPlayerBow(sendModule, character)
		
	if debounce6[character.Name] == true then

		repeat
			wait(.1)
		until
		debounce6[character.Name] == false

	end	
	local bow
	
	if character:FindFirstChild("Bow") then
		bow = character:FindFirstChild("Bow")
	end
	
	if not bow then return end
	
	BowC0s[character.Name] = {bow.Middle.Handle.C0,bow.Middle.Handle.C1}
	
	debounce5[character.Name] = true
	
	local humanoid = character:WaitForChild("Humanoid")
	local playAnim = animationModule:PlayAnimation(humanoid, "EquipBow", "Primary")
	
	bow.Bow.Handle.Equip:Play()
	
	wait(playAnim.Length/2)
	
	weldModule:LocateAndDestroyWelds(bow.Middle, "Handle")
	weldModule:Weld(character:WaitForChild("LeftHand"), bow.Bow.Handle, CFrame.new(.5,0,0)*CFrame.Angles(math.rad(90),math.rad(0),math.rad(0)))
	
	wait(playAnim.Length/2)
	
	local playAnim = animationModule:PlayAnimation(humanoid, "EquipBow", "BowReadyBegin")
	
	wait(playAnim.Length)
	
	local playAnim = animationModule:PlayAnimation(humanoid, "EquipBow", "BowReady")
	
	arrowC0s[character.Name] = module.GrabArrow(character)

	debounce5[character.Name] = false
	
	wait(.25)
	
	return
end



function module.UnequipPlayerBow(sendModule, character)
	
	local bow

	if character:FindFirstChild("Bow") then
		bow = character:FindFirstChild("Bow")
	end
		
	if not bow then return end
		
	if not BowC0s[character.Name] then return end
	
	debounce6[character.Name] = true	
	
	local humanoid = character:WaitForChild("Humanoid")
		
	local stopAnim = animationModule:StopAnimation(humanoid, "EquipBow", "BowReady")
		
	module.ReleaseBowDraw(character)
		
	local playAnim = animationModule:PlayAnimation(humanoid, "UnequipBow", "Primary")
	
	bow.Bow.Handle.Equip:Play()
	
	wait(playAnim.Length/2)
		
	weldModule:LocateAndDestroyWelds(character:WaitForChild("LeftHand"), "Handle")
	weldModule:Weld(bow.Middle, bow.Bow.Handle, BowC0s[character.Name][1])
		
	BowC0s[character.Name] = nil
		
	wait(playAnim.Length/2)
	
	module.PutAwayArrow(character)
	
	debounce6[character.Name] = false	
	
	wait(.25)
	
	return
end



function module.ExternalReleaseBowDraw(sendModule, character, mousePoint, cameraObjectPos)
		
	if mousePoint then
		cameraObjectPos = Vector3.new(cameraObjectPos.X, cameraObjectPos.Y-1.25, cameraObjectPos.Z)
		module.FireBow(character, mousePoint, cameraObjectPos)
	else
		module.RealExternalReleaseBowDraw(character)
	end
	
end

function module.FireBow(character, mousePoint, cameraObject)
	
	if debounce3[character.Name] == true then return end
	
	local bow

	if character:FindFirstChild("Bow") then
		bow = character:FindFirstChild("Bow")
	end

	if not bow then return end
	
	if bow.Quiver.Arrows.CurrentArrowCount.Value <= 0 then return end
	
	local humanoid = character:WaitForChild("Humanoid")
	
	debounce3[character.Name] = true
	
	local stopAnim = animationModule:StopAnimation(humanoid, "DrawBow", "DrawBowLoop")

	local playAnim = animationModule:PlayAnimation(humanoid, "DrawBow", "FireBow")
	
	bow.Bow.Handle.Release:Play()
	
	debounce4[character.Name] = false

	wait(playAnim.Length/5)
	
	bow.Quiver.Arrows["Arrow"..bow.Quiver.Arrows.CurrentArrowCount.Value]:Destroy()
	bow.Quiver.Arrows.CurrentArrowCount.Value = bow.Quiver.Arrows.CurrentArrowCount.Value - 1
	
	weldModule:LocateAndDestroyWelds(character:WaitForChild("RightHand"), "stringmid")
	weldModule:Weld(bow.Bow.stringmid, bow.Bow.Handle, nil, stringC0s)
	
	local stopAnim = animationModule:StopAnimation(humanoid, "DrawBow", "DrawBowLoop")
	
	projectileModule:Fire(mousePoint, bow.Bow.stringmid.Attachment1, cameraObject, character.Name)
	
	wait((playAnim.Length/5)*4+.1)
	
	local stopAnim = animationModule:StopAnimation(humanoid, "DrawBow", "DrawBowLoop")

	module.GrabArrow(character)
	
	debounce3[character.Name] = false
	
end

function module.DrawBow(sendModule, character)
	
	if debounce4[character.Name] == true then return end
	
	if debounce3[character.Name] == true then

		repeat
			wait(.1)
		until
		debounce3[character.Name] == false		

	end	
	local bow

	if character:FindFirstChild("Bow") then
		bow = character:FindFirstChild("Bow")
	end

	if not bow then return end
	
	debounce4[character.Name] = true
	
	local humanoid = character:WaitForChild("Humanoid")
	
	if bow.Quiver.Arrows.CurrentArrowCount.Value <= 0 then 
		local stopAnim = animationModule:StopAnimation(humanoid, "DrawBow", "DrawBowLoop")
		return 
	end
	
	local playAnim = animationModule:PlayAnimation(humanoid, "DrawBow", "DrawBow")
	
	bow.Bow.Handle.Pull:Play()
	
	wait(playAnim.Length/5)
		
	weldModule:LocateAndDestroyWelds(bow.Bow.stringmid, "Handle")
	weldModule:Weld(character:WaitForChild("RightHand"), bow.Bow.stringmid)
	
	wait(((playAnim.Length/5)*4)-.05)
	
	if animationModule:IsAnimationPlaying(humanoid, "DrawBow", "DrawBow") == true then
		local playAnim = animationModule:PlayAnimation(humanoid, "DrawBow", "DrawBowLoop")
	else
		
	end
	wait(.01)
	
	return
end

function module.ReleaseBowDraw(character)
	
	local bow

	if character:FindFirstChild("Bow") then
		bow = character:FindFirstChild("Bow")
	end
		
	if not bow then return end
			
	local humanoid = character:WaitForChild("Humanoid")
	local stopAnim = animationModule:StopAnimation(humanoid, "DrawBow", "DrawBowLoop")	
		
	weldModule:LocateAndDestroyWelds(character:WaitForChild("RightHand"), "stringmid")
	weldModule:Weld(bow.Bow.stringmid, bow.Bow.Handle, nil, stringC0s)
		
	module.PutAwayArrow(character)
		
	debounce3[character.Name] = false
	debounce4[character.Name] = false
	
	local stopAnim = animationModule:StopAnimation(humanoid, "DrawBow", "DrawBowLoop")	
		
	return
	
end

function module.RealExternalReleaseBowDraw(character)
	
	wait(.25)
	
	local bow

	if character:FindFirstChild("Bow") then
		bow = character:FindFirstChild("Bow")
	end
		
	if not bow then return end
			
	local humanoid = character:WaitForChild("Humanoid")
	local stopAnim = animationModule:StopAnimation(humanoid, "DrawBow", "DrawBow")	
	local stopAnim = animationModule:StopAnimation(humanoid, "DrawBow", "DrawBowLoop")	

	weldModule:LocateAndDestroyWelds(character:WaitForChild("RightHand"), "stringmid")
	weldModule:Weld(bow.Bow.stringmid, bow.Bow.Handle, nil, stringC0s)
	
	--module.PutAwayArrow(character)

	debounce3[character.Name] = false
	debounce4[character.Name] = false
	
	local stopAnim = animationModule:StopAnimation(humanoid, "DrawBow", "DrawBow")	
	local stopAnim = animationModule:StopAnimation(humanoid, "DrawBow", "DrawBowLoop")	
		
	return

end

remote1.OnServerInvoke = module.EquipPlayerBow
remote2.OnServerInvoke = module.UnequipPlayerBow

remote3.OnServerEvent:Connect(module.DrawBow)
remote4.OnServerEvent:Connect(module.ExternalReleaseBowDraw)

return module
