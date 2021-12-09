local module = {}

local players = game:GetService("Players")

local currentGamemode

local bowHandler = require(script.Parent.BowHandler)
local meleeHandler = require(script.Parent.MeleeHandler)

local classes = {

    ["Archer"] = bowHandler,
    ["Footman"] = meleeHandler,
    ["Armored"] = meleeHandler,

}

local gamemodes = {

    ["Duel"] = true,
    ["FFA1"] = true,
    ["FFA2"] = true,
    ["Skirmish"] = true,
    ["Domination"] = true,
    ["Training"] = true,
    ["Survival"] = true,

}

local gamemodeLives = {

    ["Duel"] = 0,
    ["FFA1"] = 5,
    ["FFA2"] = 10,
    ["Skirmish"] = 35,
    ["Domination"] = 35,
    ["Training"] = 0,
    ["Survival"] = 0,

}

local gamemodeTeamCount = {

    ["Duel"] = {2, 1},
    ["FFA1"] = {6, 1},
    ["FFA2"] = {4, 2},
    ["Skirmish"] = {2, 6},
    ["Domination"] = {2, 6},
    ["Training"] = {5, 1},
    ["Survival"] = {1, 5},   

}

local teamColors = {

    [1] = BrickColor.new("Maroon"),
    [2] = BrickColor.new("Blue"),
    [3] = BrickColor.new("Yellow"),
    [4] = BrickColor.new("Green"),
    [5] = BrickColor.new("Purple"),
    [6] = BrickColor.new("White")

}

local teamNames = {

    [1] = "RED TEAM",
    [2] = "BLUE TEAM",
    [3] = "YELLOW TEAM",
    [4] = "GREEN TEAM",
    [5] = "PURPLE TEAM",
    [6] = "WHITE TEAM",

}

function module.CreateTeams(gamemode)

    if not gamemodeTeamCount[gamemode] then return end

    for i = 1,#get:GetService("Teams") do
        
        game:GetService("Teams")[i]:Destroy()

    end

    for i = 1,#gamemodeTeamCount[gamemode][1] do
        
        local team = Instance.new("Team", game:GetService("Teams"))
        team.TeamColor = teamColors[i]
        team.Name = teamNames[i]

    end

    local spectatorTeam = Instance.new("Team", game:GetService("Teams"))
    spectatorTeam.TeamColor = BrickColor.new("Really black")
    spectatorTeam.Name = "Spectators"

end

function module.CountPlayersOnTeam(teamColor)

    local count = 0

    for i = 1,#players do
        
        if players[i].TeamColor == teamColor then
            count = count + 1
        end

    end

    return count

end

function module.AssignPlayerTeam(player, partyData, gamemode)

    if partyData then
        
        for i = 1,#partyData do 

            for i = 1,#players do
                
                if players[i].Name == partyData[i] and players[i].TeamName ~= "Spectators" then
                    
                    local playerCount = module.CountPlayersOnTeam(players[i].TeamColor)
                    if playerCount < gamemodeTeamCount[gamemode][2] then
                        player.TeamColor = players[i].TeamColor
                    end

                end

            end

        end

    else

        -- assign to a random team

    end

end

function module.EstablishGamemodeData(gamemode)

    module.CreateTeams(gamemode)

    local folder = Instance.new("Folder", game:GetService("ReplicatedStorage"))
    folder.Name = "GamemodeData"

    local stringGamemode = Instance.new("StringValue", folder)
    stringGamemode.Name = "Gamemode"
    stringGamemode.Value = gamemode

    local teamFolder = Instance.new("Folder", folder)
    teamFolder.Name = "TeamData"

    local teams = game:GetService("Teams"):GetChildren()

    for i = 1,#teams do
        
        local teamSpecificFolder = Instance.new("Folder", teamFolder)
        teamSpecificFolder.Name = "TeamData"..teams[i].Name

        local teamLives = Instance.new("IntegerValue", teamSpecificFolder)
        teamLives.Name = "TeamLives"
        teamLives.Value = gamemodeLives[gamemode]

        if gamemode == "Domination" then
            
            local teamCaptureData = Instance.new("IntegerValue", teamSpecificFolder)
            teamCaptureData.Name = "TeamCapture"
            teamCaptureData.Value = 0

        end

    end

    if gamemode == "Domination" then
            
        local captureControllerA = Instance.new("ObjectValue", folder)
        captureControllerA.Name = "CaptureAController"
        captureControllerA.Value = nil

        local captureDataA = Instance.new("IntegerValue", folder)
        captureDataA.Name = "CaptureAControl"
        captureDataA.Value = 0

        local captureControllerB = Instance.new("ObjectValue", folder)
        captureControllerB.Name = "CaptureBController"
        captureControllerB.Value = nil

        local captureDataB = Instance.new("IntegerValue", folder)
        captureDataB.Name = "CaptureBControl"
        captureDataB.Value = 0

        local captureControllerC = Instance.new("ObjectValue", folder)
        captureControllerC.Name = "CaptureCController"
        captureControllerC.Value = nil

        local captureDataC = Instance.new("IntegerValue", folder)
        captureDataC.Name = "CaptureCControl"
        captureDataC.Value = 0

    end

    repeat
        wait(1)
    until 
    #players == gamemodeTeamCount[1]*gamemodeTeamCount[2]

    for i = 1,#players do
        
        players.CharacterAdded:Connect(module.CharacterAdded)
        players.CharacterRemoving:Connect(module.CharacterRemoving)

    end

    -- duel; players on 2 teams; round reset on death
    -- ffa1; all players on 6 teams; with limited lives
    -- ffa2; all players on 4 teams; with limited lives
    -- skirmish; all playes on 2 teams; with limited lives
    -- domination; all players on 2 teams; with limited lives and capture data
    -- training; all players on independent teams; with infinite lives
    -- survival; all players on a single team

end

function module.CharacterAdded(character)

end

function module.CharacterRemoving(character)

    local player = players:GetPlayerFromCharacter(character)
    local teamName = player.teamName

    local gamemode = game:GetService("ReplicatedStorage"):WaitForChild("GamemodeData"):WaitForChild("Gamemode").Value

    if gamemode == "FFA1" or gamemode == "FFA2" or gamemode == "Skirmish" or gamemode == "Domination" then
        
        local teamLives = game:GetService("ReplicatedStorage"):WaitForChild("GamemodeData"):WaitForChild("TeamData"):WaitForChild("TeamData"..teamName):WaitForChild("TeamLives")

        if teamLives.Value - 1 > 0 then
            teamLives.Value = teamLives.Value - 1
        else
            player.TeamColor = BrickColor.new("Really black")
            -- team is out of lives, prevent respawn.
            -- check if team is the last other team standing, if so, condition win.
        end

    elseif gamemode == "Training" then
        return

    elseif gamemode == "Survival" then
        player.TeamColor = BrickColor.new("Really black")

        -- wait until round is over, then reset

    elseif gamemode == "Duel" then
        -- check if enough rounds have been won for an overall victory
        -- if not, update the round count

    end

end

function module.OnPlayerJoined(player)

    local joinData = player:GetJoinData()

    if not joinData then player:Disconnect() return end
    if not joinData[1] then player:Disconnect() return end
    if not joinData[2] then player:Disconnect() return end

    if currentGamemode == nil then

        if not gamemodes[joinData[1]] == true then player:Disconnect() return end

        currentGamemode = joinData[1]
        module.EstablishGamemodeData(joinData[1])
    end

    if not classes[joinData[2]] then player:Disconnect() return end

    classes[joinData[2]]:Init(player)

    player.CharacterAdded:Connect(module.CharacterAdded)
    player.CharacterRemoving:Connect(module.CharacterRemoving)

end

return module
