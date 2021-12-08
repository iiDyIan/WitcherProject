local module = {}

local player = game.Players.LocalPlayer
local playerGUI = player:WaitForChild("PlayerGui")

local Loading = playerGUI:WaitForChild("Loading"):WaitForChild("LocalScript")

local spriteSheets = require(script.SpriteSheets)

local sprite1 = spriteSheets[1]
local sprite2 = spriteSheets[2]

local TweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(.75, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0)

local usedStrings = {}

local possibleStrings = {
	
	"Initializing client-side modules",
	"Loading workspace",
	"Pre-loading assets",
	"Setting up animations",
	"Establishing lighting",
	"Communicating with server",
	"Loading user data",
	
}

local function checkForString(inputString)
	
	for i = 1,#usedStrings do
		if inputString == usedStrings[i] then
			return inputString
		end
	end
	
	return
	
end

local function getDisplayString()
	
	local randIndex = math.random(#possibleStrings)
			
	if checkForString(possibleStrings[randIndex]) then
		repeat
			randIndex = math.random(#possibleStrings)
		until	
		not checkForString(possibleStrings[randIndex]) or #usedStrings >= #possibleStrings
		
		if #usedStrings >= #possibleStrings then
			return
		end
		
		table.insert(usedStrings, possibleStrings[randIndex])
		return possibleStrings[randIndex]
		
	else
		
		table.insert(usedStrings, possibleStrings[randIndex])
		return possibleStrings[randIndex]
		
	end
	
end

local function tweenObject(object, properties)
	
	TweenService:Create(object, tweenInfo, properties):Play()
	
end

local stringSequence = 1
local currentString

local function updateText()
	
	if Loading.Parent.Frame.Frame.Frame.TextLabel.Transparency == 1 then
		tweenObject(Loading.Parent.Frame.Frame.Frame.TextLabel, {TextTransparency = 0.2})
		tweenObject(Loading.Parent.Frame.Frame.Frame.TextLabel.TextLabel, {TextTransparency = 0.5})
	end
	
	local mainString
	
	if stringSequence == 1 then
		mainString = getDisplayString()
		currentString = mainString
	else
		mainString = currentString
	end
	
	if mainString == nil then 
		Loading.Parent.Frame.Frame.Frame.TextLabel.Text = ""
		Loading.Parent.Frame.Frame.Frame.TextLabel.TextLabel.Text = ""
		return 
	end
	
	if stringSequence < 4 then
		stringSequence = stringSequence + 1
	else
		stringSequence = 1
	end
	
	if stringSequence == 2 then
		mainString = mainString.."."
	elseif stringSequence == 3 then
		mainString = mainString.."."
	elseif stringSequence == 4 then
		mainString = mainString.."."
	end
	
	currentString = mainString
	
	Loading.Parent.Frame.Frame.Frame.TextLabel.Text = currentString
	Loading.Parent.Frame.Frame.Frame.TextLabel.TextLabel.Text = currentString
	
end

local currentSprite = 0

function module.PreloadVideo()
	
	local assets = {}
	
	for i = 1,#sprite1 do
		table.insert(assets, "rbxassetid://"..sprite1[i])		
	end
	
	game:GetService("ContentProvider"):PreloadAsync(assets, nil)
	
end

local cycle = 1

function module.PlayVideo()
	
	while true do
		
		wait(.05)
		
		if currentSprite < #sprite1 then
			currentSprite = currentSprite + 1
		else
			currentSprite = 1
			cycle = cycle + 1
		end
		
		if (currentSprite % 2) == 0 and cycle >= 3 and cycle < 5 then
			
			updateText()
			
		elseif cycle >= 5 then
			
			tweenObject(Loading.Parent.Frame.Frame.Frame.TextLabel, {TextTransparency = 01})
			tweenObject(Loading.Parent.Frame.Frame.Frame.TextLabel.TextLabel, {TextTransparency = 01})
			
			tweenObject(Loading.Parent.Frame.Frame.ImageLabel, {ImageTransparency = 01})
			tweenObject(Loading.Parent.Frame.Frame.Frame, {BackgroundTransparency = 01})
			tweenObject(Loading.Parent.Frame.Frame.Frame.Frame, {BackgroundTransparency = 01})
			
			tweenObject(Loading.Parent.Frame.Frame.Frame.ImageLabel, {BackgroundTransparency = 01})
			
			tweenObject(Loading.Parent.Frame.Frame.ImageLabel.Frame1, {BackgroundTransparency = 01})
			tweenObject(Loading.Parent.Frame.Frame.ImageLabel.Frame2, {BackgroundTransparency = 01})
			
			wait(1)
			
			tweenObject(Loading.Parent.Frame2, {BackgroundTransparency = 01})
			
			wait(1)
			
			Loading.Parent.Enabled = false
			
			return
			
		end
		
		if cycle == 2 then
			tweenObject(Loading.Parent.Frame.Frame.ImageLabel, {ImageTransparency = 0})
			tweenObject(Loading.Parent.Frame.Frame.Frame, {BackgroundTransparency = 0})
			tweenObject(Loading.Parent.Frame.Frame.Frame.Frame, {BackgroundTransparency = 0})
		end

		local image = "rbxassetid://"..sprite1[currentSprite]
		Loading.Parent.Frame.Frame.ImageLabel.Image = image
		
	end
	
end

module.PreloadVideo()

module.PlayVideo()

return module
