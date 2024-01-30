-- Returns the currently active language
function LDT_Bounties.GetLanguange(id)
    return LDT_Bounties.Language[LDT_Bounties.Config.Language][id]
end

-- Returns the correct User Group
function LDT_Bounties.GetPlayerGroup(ply)
    if SG then
        return ply:GetSecondaryUserGroup() or ply:GetUserGroup()
    else
        return ply:GetUserGroup()
    end
end
