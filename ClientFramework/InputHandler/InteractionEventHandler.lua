local module = {}

local collectionService = game:GetService("CollectionService")
local runService = game:GetService("RunService")
local userinputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")

local player = game.Players.LocalPlayer
local character = player.Character or player.CharactedAdded:wait()

local ui = player:WaitForChild("PlayerGui"):WaitForChild("HUDUI")

local interactableTag = "Interactable"

local interactables = collectionService:GetTagged("Interactable")

local function tweenObject(length,object,properties)

	local tInfo = TweenInfo.new(length,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,0,false,0)
	local tween = tweenService:Create(object,tInfo,properties):Play()

end

function module.getInteractable()

	local applicableInteractables = {}

	for i = 1,#interactables do
				
		if (character.HumanoidRootPart.Position - interactables[i].Position).magnitude > 10 then
						
		elseif interactables[i].CanShow.Value == true then
			table.insert(applicableInteractables, interactables[i])
		end
	end

	local closestInteractionMagnitude = 10
	local closestInteraction

	if applicableInteractables[1] then
		for i = 1, #applicableInteractables do
			
			if (character.HumanoidRootPart.Position - applicableInteractables[i].Position).magnitude < closestInteractionMagnitude then
				
				closestInteraction = applicableInteractables[i]

			end
		end
		
	end

	return closestInteraction

end

function module.Heartbeat()

	local closestInteraction = module.getInteractable()
		
	if closestInteraction then
				
		if not ui then return end
		if not ui:FindFirstChild("Interaction") then return end
				
		ui:WaitForChild("Interaction").Visible = true
		ui:WaitForChild("Interaction"):WaitForChild("ImageLabel"):WaitForChild("PromptText").Text = closestInteraction.Prompt.Value
		ui:WaitForChild("Interaction"):WaitForChild("ImageLabel"):WaitForChild("PromptText"):WaitForChild("TextBack").Text = closestInteraction.PromptBack.Value
		
	else
		
		if not ui then return end
		if not ui:FindFirstChild("Interaction") then return end

		ui:WaitForChild("Interaction").Visible = false
		
	end

end

local heartbeatConnection = runService.Heartbeat:Connect(module.Heartbeat)

function module.OnCharacterDeath()

	heartbeatConnection:Disconnect()

end

function module.onInputBegan()

	local closestInteraction = module.getInteractable()

	if closestInteraction then

		local count = 0

		repeat

			wait(.01)
			count = count + 5
			
			if not ui then return end
			if not ui:FindFirstChild("Interaction") then return end
			
			tweenObject(.01, ui:WaitForChild("Interaction"):WaitForChild("ImageLabel"):WaitForChild("Frame"):WaitForChild("MoveFrame"), {Size = UDim2.new(count/closestInteraction.Count.Value, 2, 1, 2)})
			
		until
		count >= closestInteraction.Count.Value or not userinputService:IsKeyDown(closestInteraction.KeyCode.Value)

		if count >= closestInteraction.Count.Value then
			closestInteraction.TriggerEvent:FireServer()
		else
			
			if not ui then return end
			if not ui:FindFirstChild("Interaction") then return end
			
			tweenObject(.2, ui:WaitForChild("Interaction"):WaitForChild("ImageLabel"):WaitForChild("Frame"):WaitForChild("MoveFrame"), {Size = UDim2.new(0, 2, 1, 2)})
			return
		end
		
		if not ui then return end
		if not ui:FindFirstChild("Interaction") then return end
		
		tweenObject(.2, ui:WaitForChild("Interaction"):WaitForChild("ImageLabel"):WaitForChild("Frame"):WaitForChild("MoveFrame"), {Size = UDim2.new(0, 2, 1, 2)})

	end

end

userinputService.InputBegan:Connect(module.onInputBegan)

return module
