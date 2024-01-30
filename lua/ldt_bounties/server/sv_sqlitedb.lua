if LDT_Bounties.Config.DatabaseMode ~= "sqlite" then return end

-- Creates all the necessary tables
function LDT_Bounties.CreateDBTables()
    sql.Query("CREATE TABLE IF NOT EXISTS LDT_Bounties_PlayerStats (ID INTEGER PRIMARY KEY, SteamID TEXT NOT NULL, ClaimedBounties INT NOT NULL, SurvivedBounties INT NOT NULL);")
end

function LDT_Bounties.UpdateClaimedBounties(ply) 
	local steamID = ply:SteamID64()

    local data = sql.Query("Select * from `LDT_Bounties_PlayerStats` where `SteamID` = '"..steamID.."';")

    if data == nil then
        sql.Query("Insert into `LDT_Bounties_PlayerStats` (`SteamID`, `ClaimedBounties`, `SurvivedBounties`) values ('"..steamID.."', 1, 0);")
    elseif data then
        sql.Query("Update `LDT_Bounties_PlayerStats` set `ClaimedBounties` = `ClaimedBounties` + 1 where `SteamID` = '"..steamID.."';")
    end

    print("[BOUNTIES] Successfully updated ClaimedBounties for "..ply:Nick()..".")
end

function LDT_Bounties.UpdateSurvivedBounties(ply) 
	local steamID = ply:SteamID64()

    local data = sql.Query("Select * from `LDT_Bounties_PlayerStats` where `SteamID` = '"..steamID.."';")

    if data == nil then
        sql.Query("Insert into `LDT_Bounties_PlayerStats` (`SteamID`, `ClaimedBounties`, `SurvivedBounties`) values ('"..steamID.."', 0, 1);")
    elseif data then
        sql.Query("Update `LDT_Bounties_PlayerStats` set `SurvivedBounties` = `SurvivedBounties` + 1 where `SteamID` = '"..steamID.."';")
    end

    print("[BOUNTIES] Successfully updated Survived Bounties for "..ply:Nick()..".")
end

function LDT_Bounties.GetSurvivedBountiesLeaderboard(callback)
	local data = sql.Query("Select * from `LDT_Bounties_PlayerStats` where `SurvivedBounties` > 0 order by `SurvivedBounties` desc limit 10;")

    if data == nil then
        callback({})
    elseif data then
        callback(data)
    end
end

function LDT_Bounties.GetClaimedBountiesLeaderboard(callback)
	local data = sql.Query("Select * from `LDT_Bounties_PlayerStats` where `ClaimedBounties` > 0 order by `ClaimedBounties` desc limit 10;")

    if data == nil then
        callback({})
    elseif data then
        callback(data)
    end
end