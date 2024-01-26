util.AddNetworkString("LDT_Bounties_NewBountyPerson")
util.AddNetworkString("LDT_Bounties_BountyEndedWithoutWinner")
util.AddNetworkString("LDT_Bounties_BountyEndedWithWinner")
util.AddNetworkString("LDT_Bounties_PlayerLoadedIn")
util.AddNetworkString("LDT_Bounties_CurrentBounty")
util.AddNetworkString("LDT_Bounties_OpenBountiesUI")


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

net.Receive("LDT_Bounties_PlayerLoadedIn", function(len, ply)
    if not IsValid(ply) or LDT_Bounties.BountyPerson == nil then return end

    net.Start("LDT_Bounties_CurrentBounty")
        net.WriteEntity(LDT_Bounties.BountyPerson)
        net.WriteInt(LDT_Bounties.BountyAmount, 32)
    net.Send(ply)
end)

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
    
        LDT_Bounties.BountyPerson = ply
        LDT_Bounties.BountyAmount = math.random(LDT_Bounties.Config.BountyMinimum, LDT_Bounties.Config.BountyMaximum)
    
        net.Start("LDT_Bounties_NewBountyPerson")
            net.WriteEntity(LDT_Bounties.BountyPerson)
            net.WriteInt(LDT_Bounties.BountyAmount, 32)
        net.Broadcast()
    end )
end)

hook.Add("PH_RoundEnd", "LDT_Bounties.RoundEnded",function()
    timer.Remove("LDT_Bounties.NewBountyTimer")

    if LDT_Bounties.BountyPerson ~= nil and LDT_Bounties.BountyAmount ~= nil then
        net.Start("LDT_Bounties_BountyEndedWithoutWinner")
            net.WriteEntity(LDT_Bounties.BountyPerson)
            net.WriteInt(LDT_Bounties.BountyAmount, 32)
        net.Broadcast()

        RewardPlayer(LDT_Bounties.BountyPerson)
    end
    
    LDT_Bounties.BountyPerson = nil
    LDT_Bounties.BountyAmount = nil
end)

hook.Add( "PH_OnPropKilled", "LDT_Bounties.PlayerKilled", function( victim, attacker )
    if not IsValid(victim) or not IsValid(attacker) then return end
    if not victim:IsPlayer() or not attacker:IsPlayer() then return end
    if victim == attacker then return end
    if victim:Team() == attacker:Team() then return end
    if LDT_Bounties.BountyPerson == nil or LDT_Bounties.BountyPerson ~= victim then return end

    net.Start("LDT_Bounties_BountyEndedWithWinner")
        net.WriteEntity(victim)
        net.WriteEntity(attacker)
        net.WriteInt(LDT_Bounties.BountyAmount, 32)
    net.Broadcast()

    RewardPlayer(attacker)

    LDT_Bounties.BountyPerson = nil
    LDT_Bounties.BountyAmount = nil
end )

hook.Add( "PlayerDisconnected", "LDT_Bounties.PlayerDisconnected", function(ply)
    if LDT_Bounties.BountyPerson == nil then return end
    if LDT_Bounties.BountyPerson ~= ply then return end

    net.Start("LDT_Bounties_BountyEndedWithoutWinner")
        net.WriteEntity(LDT_Bounties.BountyPerson)
        net.WriteInt(LDT_Bounties.BountyAmount, 32)
    net.Broadcast()

    LDT_Bounties.BountyPerson = nil
    LDT_Bounties.BountyAmount = nil
end )

-- This sends the open command to the player
hook.Add("PlayerSay", "LDT_Bounties.OpenBountiesUI", function( ply, text )
    if string.lower(text) != string.lower(LDT_Bounties.Config.MenuCommand) then return end
    
    net.Start("LDT_Bounties_OpenBountiesUI")
    net.Send(ply)
end)