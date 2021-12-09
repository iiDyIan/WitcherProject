local module = {}

local players = game:GetService("Players")

local currentGamemode

local bowHandler = require(script.Parent.BowHandler)
local meleeHandler = require(script.Parent.MeleeHandler)

local survivalData = require(script.SurvivalData)

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

function module.CloseGame()

end

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

        local teamCountDict = {}

        for i = 1,#game:GetService("Teams") do
            teamCountDict[game:GetService("Teams").Name] = {module.CountPlayersOnTeam(game:GetService("Teams")[i].TeamColor), game:GetService("Teams")[i]}
        end

        for key, value in next,  teamCountDict do

            if key ~= "Spectators" then
                if value[1] < gamemodeTeamCount[gamemode][2] then
                    player.TeamColor = value[2].TeamCOlor
                    return
                end
            end
        end 
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

    elseif gamemode == "Duel" then

        local roundFolder = Instance.new("Folder", folder)
        roundFolder.Name = "RoundData"

        local currentRound = Instance.new("IntegerValue", roundFolder)
        currentRound.Name = "CurrentRound"
        currentRound.Value = 1

        local round1 = Instance.new("StringValue", roundFolder)
        round1.Name = "Round1"

        local round2 = Instance.new("StringValue", roundFolder)
        round2.Name = "Round2"

        local round3 = Instance.new("StringValue", roundFolder)
        round3.Name = "Round3"

        local round4 = Instance.new("StringValue", roundFolder)
        round4.Name = "Round4"

        local round5 = Instance.new("StringValue", roundFolder)
        round5.Name = "Round5"

    elseif gamemode == "Survival" then

        local currentRound = Instance.new("IntegerValue", folder)
        currentRound.Name = "CurrentRound"
        currentRound.Value = 1

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

function module.InitializeSurvivalMode()

    local currentRound = game:GerService("ReplicatedStorage"):waitForChild("Gamemode"):WaitForChild("CurrentRound")

    for i = 1, 50 do

        survivalData:ClearLevel(i)

        survivalData:LoadLevel(i):Wait()

    end

    module.CloseGame()

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
            return
        else
            player.TeamColor = BrickColor.new("Really black")

            local teamCount
            local emptyTeamCount
            local teamStats = game:GetService("ReplicatedStorage"):WaitForChild("Gamemode"):WaitForChild("TeamData"):GetChildren()

            for i = 1,#teamStats do

                if string.gsub(teamStats[i].Name, "TeamData", "") ~= "Spectators" then

                    teamCount = teamCount + 1
                    if teamStats[i].TeamLives.Value <= 0 then

                        emptyTeamCount = emptyTeamCount + 1

                    end

                end

            end

            if (teamCount-1) == emptyTeamCount then
                module.CloseGame()
                return

            end
            
            return
        end

    elseif gamemode == "Training" then
        return

    elseif gamemode == "Survival" then

        player.TeamColor = BrickColor.new("Really black")

        local currentRound = game:GetService("ReplicatedStorage"):WaitForChild("Gamemode"):WaitForChild("CurrentRound").Value

        repeat
            wait(1)
        until
        currentRound ~= game:GetService("ReplicatedStorage"):WaitForChild("Gamemode"):WaitForChild("CurrentRound").Value

        player.TeamColor = BrickColor.new("Maroon")
            

    elseif gamemode == "Duel" then

        local redTeamCount
        local blueTeamCount

        local rounds = game:GetService("ReplicatedStorage"):WaitForChild("GamemodeData"):WaitForChild("RoundData"):GetChildren()

        for i = 1,#rounds do

            if rounds[i].Name ~= "CurrentRound" then

                if rounds[i].Value == "RED TEAM" then
                    redTeamCount = redTeamCount + 1
                elseif rounds[i].Value == "BLUE TEAM" then
                    blueTeamCOunt = blueTeamCount +1
                end

            end

        end

        if blueTeamCount >= 3 then
            module.CloseGame()
            return
        elseif redTeamCount >= 3 then
            module.CloseGame()
            return
        end

        local roundData = game:GetService("ReplicatedStorage"):WaitForChild("GamemodeData"):WaitForChild("RoundData")

        roundData:WaitForChild("CurrentRound").Value = roundData:WaitForChild("CurrentRound").Value + 1
        

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
