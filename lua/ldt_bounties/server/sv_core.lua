util.AddNetworkString("LDT_Bounties_NewBountyPerson")
util.AddNetworkString("LDT_Bounties_BountyEndedWithoutWinner")

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