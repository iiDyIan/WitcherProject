local module = {}

local function deleteChildren(parentObject, exclusionEntries)
	
	local applicableChildren = parentObject:GetChildren()
	
	for i = 1,#applicableChildren do
		
		if not exclusionEntries[applicableChildren[i].Name] then
			
			applicableChildren[i]:Destroy()
			
		end
		
	end
	
end

local function generateCloneObjects(initialParentObject, finalParentObject, exclusionEntries)
	
	local applicableChildren = initialParentObject:GetChildren()
	
	for i = 1,#applicableChildren do
		
		if not exclusionEntries[applicableChildren[i].Name] then
			
			local clonedObject = applicableChildren[i]:Clone()
			clonedObject.Parent = finalParentObject
			
		end
	end
	
end

local function setObjectProperties(setObject, propertiesFolder, exclusionEntries)
	
	local applicableProperties = propertiesFolder:GetChildren()
	
	for i = 1,#applicableProperties do
		
		if not exclusionEntries[applicableProperties[i].Name] then
			
			if setObject[applicableProperties[i].Name] then
				
				setObject[applicableProperties[i].Name] = applicableProperties[i].Value
				
			end
			
		end
		
	end
	
end

function module:Load(terrainRegion)
	
	game:GetService("ReplicatedStorage"):WaitForChild("EncryptedFunctions"):WaitForChild("DisplayLoadingUI"):FireAllClients()
	
	wait(1.25)
	
	assert(typeof(terrainRegion) == "Instance" and terrainRegion:IsA("TerrainRegion"),
		"Load method for TerrainSaveLoad API requires a TerrainRegion object as an argument"
	)
	
	local xPos = -math.floor(terrainRegion.SizeInCells.X * 0.5)
	local yPos = -math.floor(terrainRegion.SizeInCells.Y * 0.5)
	local zPos = -math.floor(terrainRegion.SizeInCells.Z * 0.5)
	local pos = Vector3int16.new(xPos, yPos, zPos)
	
	local waterProps = terrainRegion:FindFirstChild("WaterProperties")
	if (waterProps) then
		local function LoadProperty(name)
			local obj = waterProps:FindFirstChild(name)
			if (not obj) then return end
			xpcall(function()
				game.Workspace.Terrain[obj.Name] = obj.Value
			end, function(err)
				warn("Failed to set property: " .. tostring(err))
			end)
		end
		LoadProperty("WaterColor")
		LoadProperty("WaterReflectance")
		LoadProperty("WaterTransparency")
		LoadProperty("WaterWaveSize")
		LoadProperty("WaterWaveSpeed")
	end
		
	game.Workspace.Terrain:PasteRegion(terrainRegion, pos, true)
	
	local terrainMaterials = terrainRegion:FindFirstChild("MaterialData"):GetChildren()

	for i = 1,#terrainMaterials do

		game.Workspace.Terrain:SetMaterialColor(terrainMaterials[i].Name, terrainMaterials[i].Value)
		
	end
	
	deleteChildren(workspace, 
		{
			["Terrain"] = 1,
			["Camera"] = 1,

		}
	)
	generateCloneObjects(terrainRegion.Parent:WaitForChild("Workspace"), workspace, {})

	local players = game:GetService("Players"):GetChildren()

	for i = 1,#players do

		players[i]:RequestStreamAroundAsync(workspace.SpawnLocation.Position)

		players[i]:LoadCharacter()

	end
	
	setObjectProperties(game:GetService("Lighting"), terrainRegion.Parent:WaitForChild("Lighting"):WaitForChild("LightingProperties"), {})
	deleteChildren(game:GetService("Lighting"), {})
	generateCloneObjects(terrainRegion.Parent:WaitForChild("Lighting"), game:GetService("Lighting"), {})

	local audioHandler = terrainRegion.Parent:WaitForChild("AudioHandler"):Clone()
	audioHandler.Parent = game:GetService("StarterGui")
	
end

return module
