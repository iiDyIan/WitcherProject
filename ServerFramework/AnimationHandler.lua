local module = {}

local playerAnimTables = {}

function module.GenerateAnimations(sendModule, humanoid)
	
	local animationSets = script:GetChildren()
	
	local animTable = {}
	
	for i = 1,#animationSets do
		
		animTable[animationSets[i].Name] = {}
		local animationsInSet = animationSets[i]:GetChildren()
		
		for k = 1,#animationsInSet do
			
			local animation = humanoid:LoadAnimation(animationsInSet[k])

			animTable[animationSets[i].Name][animationsInSet[k].Name] = animation
			
		end
	end
	
	playerAnimTables[humanoid.Parent.Name] = animTable
	
	return animTable
end

function module.IsAnimationPlaying(sendmodule, humanoid, animationSet, animationName)
	
	if not playerAnimTables[humanoid.Parent.Name] then return "Error playing animation; Player is not a valid member of playerAnimTables." end
	if not playerAnimTables[humanoid.Parent.Name][animationSet] then return "Error playing animation; animationSet is not a valid member of playerAnimTables." end
	if not playerAnimTables[humanoid.Parent.Name][animationSet][animationName] then return "Error playing animation; animationName is not a valid member of playerAnimTables." end

	return playerAnimTables[humanoid.Parent.Name][animationSet][animationName].IsPlaying
end

function module.PlayAnimation(sendModule, humanoid, animationSet, animationName)
	
	if not playerAnimTables[humanoid.Parent.Name] then return "Error playing animation; Player is not a valid member of playerAnimTables." end
	if not playerAnimTables[humanoid.Parent.Name][animationSet] then return "Error playing animation; animationSet is not a valid member of playerAnimTables." end
	if not playerAnimTables[humanoid.Parent.Name][animationSet][animationName] then return "Error playing animation; animationName is not a valid member of playerAnimTables." end
	
	playerAnimTables[humanoid.Parent.Name][animationSet][animationName]:Play()
	
	return playerAnimTables[humanoid.Parent.Name][animationSet][animationName]
	
end

function module.PlayWaitAnimation(sendModule, humanoid, animationSet, animationName)
	
	if not playerAnimTables[humanoid.Parent.Name] then return "Error playing animation; Player is not a valid member of playerAnimTables." end
	if not playerAnimTables[humanoid.Parent.Name][animationSet] then return "Error playing animation; animationSet is not a valid member of playerAnimTables." end
	if not playerAnimTables[humanoid.Parent.Name][animationSet][animationName] then return "Error playing animation; animationName is not a valid member of playerAnimTables." end

	playerAnimTables[humanoid.Parent.Name][animationSet][animationName]:Play()
	
	wait(playerAnimTables[humanoid.Parent.Name][animationSet][animationName].Length)
	
	return playerAnimTables[humanoid.Parent.Name][animationSet][animationName]
	
end

function module.StopAnimation(sendModule, humanoid, animationSet, animationName)
	
	if not playerAnimTables[humanoid.Parent.Name] then return "Error playing animation; Player is not a valid member of playerAnimTables." end
	if not playerAnimTables[humanoid.Parent.Name][animationSet] then return "Error playing animation; animationSet is not a valid member of playerAnimTables." end
	if not playerAnimTables[humanoid.Parent.Name][animationSet][animationName] then return "Error playing animation; animationName is not a valid member of playerAnimTables." end
	
	playerAnimTables[humanoid.Parent.Name][animationSet][animationName]:Stop()
	
	return playerAnimTables[humanoid.Parent.Name][animationSet][animationName]
	
end

return module
