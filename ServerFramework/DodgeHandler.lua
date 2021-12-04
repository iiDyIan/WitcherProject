local module = {}

local remote = game:GetService("ReplicatedStorage"):WaitForChild("EncryptedFunctions"):WaitForChild("Dodge")
local remote2 = game:GetService("ReplicatedStorage"):WaitForChild("EncryptedFunctions"):WaitForChild("Roll")

local remote3 = game:GetService("ReplicatedStorage"):WaitForChild("EncryptedFunctions"):WaitForChild("SprintEngage")
local remote4 = game:GetService("ReplicatedStorage"):WaitForChild("EncryptedFunctions"):WaitForChild("SprintDisengage")

local animationModule = require(game:GetService("ServerScriptService"):WaitForChild("ServerHandler"):WaitForChild("AnimationHandler"))

local tweenService = game:GetService("TweenService")

local function tweenObject(length, object, properties)
	
	local tInfo = TweenInfo.new(length, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0)
	local tween = tweenService:Create(object, tInfo, properties):Play()
	
end

local function getSprintSpeed(player)
	
	local character = player.Character
	local playerTeam = player.TeamColor
	
	local workspaceObjects = workspace:GetChildren()
	
	local characterTable = {}
	local sprintSpeed = 20
	
	for i = 1,#workspaceObjects do
		if workspaceObjects[i].ClassName == "Model" then
			if game:GetService("Players"):FindFirstChild(workspaceObjects[i].Name) then
				if not game:GetService("Players"):FindFirstChild(workspaceObjects[i].Name).TeamColor == playerTeam then
				
					table.insert(characterTable, workspaceObjects[i].Name)
					
				end	
			end
		end
	end
	
	for i = 1,#characterTable do
		
		if (characterTable[i].HumanoidRootPart.Position - character.HumanoidRootPart.Position).magnitude <= 25 then
			if sprintSpeed > 17 then
				sprintSpeed = sprintSpeed - 0.5
			end
		end
	end
	
	return sprintSpeed
	
end

local function engageSprint(player)
	
	if not player then return end
	if not player.Character then return end
	if not player.Character:FindFirstChild("Humanoid") then return end
	
	player.Character.Humanoid.WalkSpeed = getSprintSpeed(player) 
	
	return true
	
end

local function disengageSprint(player)
	
	if not player then return  end
	if not player.Character then return end
	if not player.Character:FindFirstChild("Humanoid") then return end
	
	player.Character.Humanoid.WalkSpeed = 16
	
	return true
	
end

local function generateDodgeParts(player, cFrameMultiplier)
	
	local characterParts = player.Character:GetChildren()
	local materialTable = {}
	local tempParts = {}

	local tempFolder = Instance.new("Folder", player.Character)
	tempFolder.Name = "DodgeParts"

	for i = 1,#characterParts do
	
		if characterParts[i].ClassName == "Accessory" then

			materialTable[characterParts[i].Name] = {nil, "Accessory", characterParts[i].Name}
			local clone = characterParts[i].Handle:Clone()
			clone.Color = Color3.fromRGB(255,255,255)
			clone.Material = Enum.Material.ForceField
			clone.Name = characterParts[i].Name				
			table.insert(tempParts, clone.Name)
			clone.Transparency = 1
			
			clone.Anchored = true

			clone.CollisionGroupId = 3

			local pWelds = clone:GetChildren()

			for i = 1,#pWelds do
				if pWelds[i].ClassName == "Weld" or pWelds[i].ClassName == "Motor6D" or pWelds[i].ClassName == "WeldConstraint" then
					pWelds[i]:Destroy()
				end
			end

			clone.CFrame = clone.CFrame + cFrameMultiplier

			clone.Parent = tempFolder

		elseif characterParts[i].ClassName == "MeshPart" then

			materialTable[characterParts[i].Name] = {nil, "MeshPart", characterParts[i].Name}
			local clone = characterParts[i]:Clone()
			clone.Color = Color3.fromRGB(255,255,255)
			clone.Material = Enum.Material.ForceField				
			table.insert(tempParts, clone.Name)
			clone.Transparency = 1
			
			clone.Anchored = true

			clone.CollisionGroupId = 3

			local pWelds = clone:GetChildren()

			for i = 1,#pWelds do
				if pWelds[i].ClassName == "Weld" or pWelds[i].ClassName == "Motor6D" or pWelds[i].ClassName == "WeldConstraint" then
					pWelds[i]:Destroy()
				end
			end

			clone.CFrame = clone.CFrame + cFrameMultiplier

			clone.Parent = tempFolder

		elseif characterParts[i].ClassName == "Part" then

			materialTable[characterParts[i].Name] = {nil, "Part", characterParts[i].Name}	
			local clone = characterParts[i]:Clone()
			clone.Color = Color3.fromRGB(255,255,255)
			clone.Material = Enum.Material.ForceField				
			table.insert(tempParts, clone.Name)
			clone.Transparency = 1

			clone.Anchored = true

			clone.CollisionGroupId = 3

			local pWelds = clone:GetChildren()

			for i = 1,#pWelds do
				if pWelds[i].ClassName == "Weld" or pWelds[i].ClassName == "Motor6D" or pWelds[i].ClassName == "WeldConstraint" then
					pWelds[i]:Destroy()
				end
			end

			clone.CFrame = clone.CFrame + cFrameMultiplier

			clone.Parent = tempFolder

		end
	end
	
	local childObjects = tempFolder:GetChildren()
	
	for i = 1,#childObjects do
		tweenObject(.225, childObjects[i], {Transparency = 0})
	end
	
	return {materialTable, tempFolder}
	
end



function module.ExecuteDodge(player, keyCode)
	
	if keyCode ~= "None" then
		
		player.Character.Humanoid.WalkSpeed = 4
		local materialTable
		local tempFolder

		for i = 1, 10, 1 do
			
			tweenObject(.0025, player.Character.HumanoidRootPart, {CFrame = player.Character.HumanoidRootPart.CFrame + (player.Character.Humanoid.MoveDirection)*.75})
			wait(.005)
			
			if i == 2 then
				
				local parts = generateDodgeParts(player, player.Character.Humanoid.MoveDirection*6)
				materialTable = parts[1]
				tempFolder = parts[2]
				
			elseif i == 7 then

				for key, value in pairs(materialTable) do

					tweenObject(.25, tempFolder:FindFirstChild(value[3]), {Transparency = 1})

				end	
				
			end
			
		end		
		
		wait(.1)
		
		for key, value in pairs(materialTable) do
			
			tempFolder:FindFirstChild(value[3]):Destroy()
			
		end
		
		materialTable = {}
				
		wait(.125)
		
		player.Character.Humanoid.WalkSpeed = 16
		
		return
		
	else
	
		player.Character.Humanoid.WalkSpeed = 5
		local materialTable
		local tempFolder
		
		for i = 1, 10, 1 do

			tweenObject(.0025, player.Character.HumanoidRootPart, {CFrame = player.Character.HumanoidRootPart.CFrame + -(player.Character.HumanoidRootPart.CFrame.LookVector)*.75})
			wait(.005)
			
			if i == 2 then
				
				local multiplier = -(player.Character.HumanoidRootPart.CFrame.LookVector)*6
				local parts = generateDodgeParts(player, multiplier)
				materialTable = parts[1]
				tempFolder = parts[2]
				
			elseif i == 7 then
				
				for key, value in pairs(materialTable) do

					tweenObject(.25, tempFolder:FindFirstChild(value[3]), {Transparency = 1})

				end
				
			end
		end		
		
		wait(.1)
		
		for key, value in pairs(materialTable) do

			tempFolder:FindFirstChild(value[3]):Destroy()

		end

		materialTable = {}
		
		wait(.125)

		player.Character.Humanoid.WalkSpeed = 16
		
		return		
	end
	
end

function module.ExecuteRoll(keyCode)

	if keyCode ~= "None" then

		-- roll forwards

	else

		-- roll backwards

	end

end

remote.OnServerInvoke = module.ExecuteDodge
remote2.OnServerInvoke = module.ExecuteRoll

remote3.OnServerEvent:Connect(engageSprint)
remote4.OnServerEvent:Connect(disengageSprint)

return module
