local module = {}

local activeMarkers = {}

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local tweenInfo = TweenInfo.new(0.0075, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0)

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Character = Player.Character or Player.CharacterAdded:Wait()

local UI = PlayerGui:WaitForChild("HUDUI"):WaitForChild("Markers")
local Screen = PlayerGui:WaitForChild("HUDUI"):WaitForChild("Markers").AbsoluteSize
local Sample = UI:WaitForChild("Sample")

local function TweenObject(object, properties)
	
	TweenService:Create(object, tweenInfo, properties):Play()
	
end

function round(num, numDecimalPlaces)
	
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
	
end

local function ClampMarkerToBorder(X, Y, Absolute)
	
	X = Screen.X - X
	Y = Screen.Y - Y

	local DistanceToXBorder = math.min(X, Screen.X - X)
	local DistanceToYBorder = math.min(Y, Screen.Y - Y)

	if DistanceToYBorder < DistanceToXBorder then 
		if Y < (Screen.Y - Y) then
			return math.clamp(X,0,Screen.X - Absolute.X), 0
		else
			return math.clamp(X,0,Screen.X - Absolute.X), Screen.Y - Absolute.Y
		end
	else
		if X < (Screen.X - X) then
			return 0, math.clamp(Y, 0, Screen.Y - Absolute.Y)
		else
			return Screen.X - Absolute.X, math.clamp(Y, 0, Screen.Y - Absolute.Y)
		end
	end
	
end

function module.CalculateMarkerDistance(markerObject)
	
	local originalDistance = (Character:WaitForChild("HumanoidRootPart").Position - markerObject.Position).Magnitude
	return (round(originalDistance/20, 1)).." M"
	
end

function module.CreateMarker(markerObject, config)
	
	if activeMarkers[markerObject.Name] then return end
	
	local Marker = Sample:Clone()
	
	Marker.Parent = UI:WaitForChild("Holder")
	
	Marker.ImageColor3 = config["ImageColor3"]
	Marker.RotateLabel.Arrow.ImageColor3 = config["ImageColor3"]
	Marker.Icon.Image = config["Image"]
	
	Marker.Visible = true
	
	activeMarkers[markerObject.Name] = {Marker, markerObject}
	
end

function module.DeleteMarker(markerName)
	
	if not activeMarkers[markerName] then return end
	
	activeMarkers[markerName][1]:Destroy()
	activeMarkers[markerName] = nil
	
end

function module.RenderMarkers()
	
	for i, tableObject in pairs(activeMarkers) do
		
		local Marker = tableObject[1]
		local MarkerObject = tableObject[2]
		
		local distance = module.CalculateMarkerDistance(MarkerObject)		
		
		local MarkerPosition, MarkerVisible = game.Workspace.CurrentCamera:WorldToScreenPoint(MarkerObject.Position)
		local MarkerRotation = game.Workspace.CurrentCamera.CFrame:Inverse() * MarkerObject.CFrame
		local MarkerAbsolute = Marker.AbsoluteSize

		local MarkerPositionX = MarkerPosition.X - MarkerAbsolute.X/2
		local MarkerPositionY = MarkerPosition.Y - MarkerAbsolute.Y/2

		if MarkerPosition.Z < 0  then
			
			MarkerPositionX,MarkerPositionY = ClampMarkerToBorder(MarkerPositionX, MarkerPositionY, MarkerAbsolute)
			
		else
			
			if MarkerPositionX < 0 then
				
				MarkerPositionX = 0
				
			elseif MarkerPositionX > (Screen.X - MarkerAbsolute.X) then
				
				MarkerPositionX = Screen.X - MarkerAbsolute.X
				
			end
			
			if MarkerPositionY < 0 then
				
				MarkerPositionY = 0
				
			elseif MarkerPositionY > (Screen.Y - MarkerAbsolute.Y) then
				
				MarkerPositionY = Screen.Y - MarkerAbsolute.Y
				
			end
		end
		
		Marker.RotateLabel.Visible = not MarkerVisible
		
		TweenObject(Marker, {Position = UDim2.new(0,MarkerPositionX,0,MarkerPositionY), AnchorPoint = Vector2.new(MarkerPositionX, MarkerPositionY)})
		TweenObject(Marker.RotateLabel, {Rotation = 90 + math.deg(math.atan2(MarkerRotation.Z, MarkerRotation.X))})
		
		Marker:WaitForChild("Distance").Text = distance
		
	end
	
end

local function onCharacterRemoving()
	
	for key, value in next, activeMarkers do
		
		module.DeleteMarker(key)
		
	end
	
end

RunService.RenderStepped:Connect(module.RenderMarkers)

local markerConfig = {
	
	["ImageColor3"] = Color3.fromRGB(255, 255, 255),
	["Image"] = "rbxassetid://0",
	
}

local object = game:GetService("ReplicatedStorage"):WaitForChild("ExampleMarker")

module.CreateMarker(object, markerConfig)

Player.CharacterRemoving:Connect(onCharacterRemoving)

return module
