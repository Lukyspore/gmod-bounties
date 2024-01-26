util.AddNetworkString("LDT_Bounties_NewBountyPerson")
util.AddNetworkString("LDT_Bounties_BountyEndedWithoutWinner")
util.AddNetworkString("LDT_Bounties_BountyEndedWithWinner")

-- Reward players using the correct reward framework
local function RewardPlayer(ply, achievement)
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

hook.Add("PH_RoundStart", "LDT_Bounties.RoundStarted", function()
    LDT_Bounties.BountyPerson = nil
    LDT_Bounties.BountyAmount = nil

    local plys = team.GetPlayers(2)
    if LDT_Bounties.Config.MinimumPlayers > #plys then return end

    local ply = plys[math.random(#plys)]

    LDT_Bounties.BountyPerson = ply
    LDT_Bounties.BountyAmount = math.random(LDT_Bounties.Config.BountyMinimum, LDT_Bounties.Config.BountyMaximum)

    net.Start("LDT_Bounties_NewBountyPerson")
        net.WriteEntity(LDT_Bounties.BountyPerson)
        net.WriteInt(LDT_Bounties.BountyAmount, 32)
    net.Broadcast()
end)

hook.Add("PH_RoundEnd", "LDT_Bounties.RoundStarted",function()
    LDT_Bounties.BountyPerson = nil
    LDT_Bounties.BountyAmount = nil

    net.Start("LDT_Bounties_BountyEndedWithoutWinner")
    net.Broadcast()
end)

hook.Add( "PlayerDeath", "LDT_Bounties.PlayerKilled", function( victim, inflictor, attacker )
    if not IsValid(victim) or not IsValid(attacker) then return end
    if not victim:IsPlayer() or not attacker:IsPlayer() then return end
    if victim == attacker then return end
    if victim:Team() == attacker:Team() then return end

    if LDT_Bounties.BountyPerson == victim then
        net.Start("LDT_Bounties_BountyEndedWithWinner")
            net.WriteEntity(victim)
            net.WriteEntity(attacker)
            net.WriteInt(LDT_Bounties.BountyAmount, 32)
        net.Broadcast()

        LDT_Bounties.BountyPerson = nil
        LDT_Bounties.BountyAmount = nil
    end
end )