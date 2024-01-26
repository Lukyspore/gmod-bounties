-- Returns the currently active language
function LDT_Bounties.GetLanguange(id)
    return LDT_Bounties.Language[LDT_Bounties.Config.Language][id]
end