util.AddNetworkString("LDT_Bounties_NewBountyPerson")
util.AddNetworkString("LDT_Bounties_BountyEndedWithoutWinner")
util.AddNetworkString("LDT_Bounties_BountyEndedWithWinner")
util.AddNetworkString("LDT_Bounties_PlayerLoadedIn")
util.AddNetworkString("LDT_Bounties_CurrentBounty")
util.AddNetworkString("LDT_Bounties_OpenBountiesUI")
util.AddNetworkString("LDT_Bounties_OpenClaimed")
util.AddNetworkString("LDT_Bounties_OpenSurvived")
util.AddNetworkString("LDT_Bounties_PanelLeaderboardsResponse")


-- Reward players using the correct reward framework
local function RewardPlayer(ply)
    if LDT_Bounties.Config.RewardFramework == "NS" then
        ply:getChar():giveMoney(LDT_Bounties.BountyAmount)
    elseif LDT_Bounties.Config.RewardFramework == "ZPN" then
        zpn.Candy.AddPoints(ply, LDT_Bounties.BountyAmount * LDT_Bounties.Config.ZPNMultiplier)
    elseif LDT_Bounties.Config.RewardFramework == "PS1" then
        ply:PS_GivePoints(LDT_Bounties.BountyAmount)
    elseif LDT_Bounties.Config.RewardFramework == "PS2" then
        ply:PS2_AddStandardPoints(LDT_Bounties.BountyAmount)
    end
end

-- Sets the bounty on a player with the given amount
local function SetBounty(ply, amount)
    LDT_Bounties.BountyPerson = ply
    LDT_Bounties.BountyAmount = amount

    net.Start("LDT_Bounties_NewBountyPerson")
        net.WriteEntity(LDT_Bounties.BountyPerson)
        net.WriteInt(LDT_Bounties.BountyAmount, 32)
    net.Broadcast()
end

-- This network message is received when a player loads in and asks for the current bounty
net.Receive("LDT_Bounties_PlayerLoadedIn", function(len, ply)
    if not IsValid(ply) or LDT_Bounties.BountyPerson == nil then return end

    net.Start("LDT_Bounties_CurrentBounty")
        net.WriteEntity(LDT_Bounties.BountyPerson)
        net.WriteInt(LDT_Bounties.BountyAmount, 32)
    net.Send(ply)
end)


-- This network message is received when a player opens the claimed bounties leaderboard. The server has to get the data from the DB first and then send it back
net.Receive("LDT_Bounties_OpenClaimed", function(len, ply)
    LDT_Bounties.GetClaimedBountiesLeaderboard(function(data)
        net.Start("LDT_Bounties_PanelLeaderboardsResponse")
            net.WriteUInt(#data, 4)
            for k, v in ipairs(data) do
                net.WriteString(v.SteamID)
                net.WriteUInt(v.ClaimedBounties, 16)
            end
        net.Send(ply)
    end)
end)

-- This network message is received when a player opens the survived bounties leaderboard. The server has to get the data from the DB first and then send it back
net.Receive("LDT_Bounties_OpenSurvived", function(len, ply)
    LDT_Bounties.GetSurvivedBountiesLeaderboard(function(data)
        net.Start("LDT_Bounties_PanelLeaderboardsResponse")
            net.WriteUInt(#data, 4)
            for k, v in ipairs(data) do
                net.WriteString(v.SteamID)
                net.WriteUInt(v.SurvivedBounties, 16)
            end
        net.Send(ply)
    end)
end)

-- This hook is called when a round starts. It will check if a bounty should be set and then set it
hook.Add("PH_RoundStart", "LDT_Bounties.RoundStarted", function()
    LDT_Bounties.BountyPerson = nil
    LDT_Bounties.BountyAmount = nil
    
    local randChance = math.random(0, 100)
    if randChance > LDT_Bounties.Config.BountyChance then return end

    timer.Create( "LDT_Bounties.NewBountyTimer", 10, 1, function() 
        timer.Remove("LDT_Bounties.NewBountyTimer")
    
        local plys = team.GetPlayers(2)
        if LDT_Bounties.Config.MinimumPlayers > #plys then return end
    
        local ply = plys[math.random(#plys)]
        local amount = math.random(LDT_Bounties.Config.BountyMinimum, LDT_Bounties.Config.BountyMaximum)
    
        SetBounty(ply, amount)
    end )
end)

-- This hook is called when a round ends. It will check if the reward should be given to the player who survived
hook.Add("PH_RoundEnd", "LDT_Bounties.RoundEnded",function()
    timer.Remove("LDT_Bounties.NewBountyTimer")

    if LDT_Bounties.BountyPerson ~= nil and LDT_Bounties.BountyAmount ~= nil and LDT_Bounties.Config.RewardForSurviving then
        LDT_Bounties.UpdateSurvivedBounties(LDT_Bounties.BountyPerson)

        net.Start("LDT_Bounties_BountyEndedWithoutWinner")
            net.WriteEntity(LDT_Bounties.BountyPerson)
            net.WriteInt(LDT_Bounties.BountyAmount, 32)
            net.WriteBool(false)
        net.Broadcast()

        --RewardPlayer(LDT_Bounties.BountyPerson)
    end
    
    LDT_Bounties.BountyPerson = nil
    LDT_Bounties.BountyAmount = nil
end)

hook.Add( "PlayerDeath", "GlobalDeathMessage", function( victim, inflictor, attacker )
    if victim ~= attacker then return end
    if LDT_Bounties.BountyPerson == nil then return end
    if LDT_Bounties.BountyPerson ~= victim then return end

    net.Start("LDT_Bounties_BountyEndedWithoutWinner")
        net.WriteEntity(LDT_Bounties.BountyPerson)
        net.WriteInt(LDT_Bounties.BountyAmount, 32)
        net.WriteBool(true)
    net.Broadcast()

    LDT_Bounties.BountyPerson = nil
    LDT_Bounties.BountyAmount = nil
end )

-- This hook is called when a player is killed. It will check if the player who was killed was the bounty and if so, give the reward to the killer
hook.Add( "PH_OnPropKilled", "LDT_Bounties.PlayerKilled", function( victim, attacker )
    if not IsValid(victim) or not IsValid(attacker) then return end
    if not victim:IsPlayer() or not attacker:IsPlayer() then return end
    if victim == attacker then return end
    if victim:Team() == attacker:Team() then return end
    if LDT_Bounties.BountyPerson == nil or LDT_Bounties.BountyPerson ~= victim then return end

    LDT_Bounties.UpdateClaimedBounties(attacker)

    net.Start("LDT_Bounties_BountyEndedWithWinner")
        net.WriteEntity(victim)
        net.WriteEntity(attacker)
        net.WriteInt(LDT_Bounties.BountyAmount, 32)
    net.Broadcast()

    --RewardPlayer(attacker)

    LDT_Bounties.BountyPerson = nil
    LDT_Bounties.BountyAmount = nil
end )

-- This hook is called when a player disconnects. It will check if the player who disconnected was the bounty and if so, end the bounty
hook.Add( "PlayerDisconnected", "LDT_Bounties.PlayerDisconnected", function(ply)
    if LDT_Bounties.BountyPerson == nil then return end
    if LDT_Bounties.BountyPerson ~= ply then return end

    net.Start("LDT_Bounties_BountyEndedWithoutWinner")
        net.WriteEntity(LDT_Bounties.BountyPerson)
        net.WriteInt(LDT_Bounties.BountyAmount, 32)
        net.WriteBool(true)
    net.Broadcast()

    LDT_Bounties.BountyPerson = nil
    LDT_Bounties.BountyAmount = nil
end )

-- Connects the server to the DB
hook.Add("InitPostEntity", "LDT_Bounties.ServerLoaded", function()
    if LDT_Bounties.Config.DatabaseMode == "mysqloo" then
        LDT_Bounties.ConnectToDatabase()
    end

    LDT_Bounties.CreateDBTables()
end)

-- This sends the open command to the player
hook.Add("PlayerSay", "LDT_Bounties.OpenBountiesUI", function( ply, text )
    local lowerText = string.lower(text)
    if lowerText != string.lower(LDT_Bounties.Config.MenuCommand) then return end
    
    net.Start("LDT_Bounties_OpenBountiesUI")
    net.Send(ply)
end)