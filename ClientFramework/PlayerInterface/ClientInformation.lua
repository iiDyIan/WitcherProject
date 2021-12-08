local PingTimes = require(game:GetService("ReplicatedStorage"):WaitForChild("ServerStatistics"):WaitForChild("PingTimes"))

local runService = game:GetService("RunService")
local player = game.Players.LocalPlayer

local pingEvent = game:GetService("ReplicatedStorage"):WaitForChild("ServerStatistics"):WaitForChild("MeasurePing")

local ui = player:WaitForChild("PlayerGui"):WaitForChild("HUDUI"):WaitForChild("Frame"):WaitForChild("Information")

local module = {}

local function onRenderStepped(step)
	
	if not ui then return end
	if not ui:FindFirstChild("TextLabel1") then return end
	if not ui:FindFirstChild("TextLabel1"):FindFirstChild("TextLabel") then return end
	
	ui:FindFirstChild("TextLabel1").Text = math.round(1/step).." FPS"
	ui:FindFirstChild("TextLabel1"):FindFirstChild("TextLabel").Text = math.round(1/step).." FPS"
	
end

local function updatePing(ping)
	
	if not ui then return end
	if not ui:FindFirstChild("TextLabel2") then return end
	if not ui:FindFirstChild("TextLabel2"):FindFirstChild("TextLabel") then return end
	
	local numPing = tonumber(string.format("%0.2f", ping))
	
	if numPing > 135 and numPing < 255 then
		ui:FindFirstChild("TextLabel2").TextColor3 = Color3.fromRGB(255, 250, 102)
	elseif numPing > 255 then
		ui:FindFirstChild("TextLabel2").TextColor3 = Color3.fromRGB(255, 89, 89)
	else
		ui:FindFirstChild("TextLabel2").TextColor3 = Color3.fromRGB(255, 255, 255)
	end
	
	ui:FindFirstChild("TextLabel2").Text = string.format("%0.2f", ping).." MS"
	ui:FindFirstChild("TextLabel2"):FindFirstChild("TextLabel").Text = string.format("%0.2f", ping).." MS"
	
end

pingEvent.OnClientEvent:Connect(updatePing)
runService.RenderStepped:Connect(onRenderStepped)

local regionInformation = game:GetService("ReplicatedStorage"):WaitForChild("ServerStatistics"):WaitForChild("ServerRegionInformation").Value

if not ui then return end
if not ui:FindFirstChild("TextLabel2") then return end

ui:FindFirstChild("TextLabel3").Text = regionInformation
ui:FindFirstChild("TextLabel3"):FindFirstChild("TextLabel").Text = regionInformation

return module
