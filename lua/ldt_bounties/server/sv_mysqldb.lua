if LDT_Bounties.Config.DatabaseMode ~= "mysqloo" then return end
local MySQLOO = require("mysqloo")

-- Creates the DB connection
LDT_Bounties.DB_BOUNTIES = mysqloo.connect(LDT_Bounties.Config.DatabaseConfig.host, LDT_Bounties.Config.DatabaseConfig.user, LDT_Bounties.Config.DatabaseConfig.password, LDT_Bounties.Config.DatabaseConfig.database, LDT_Bounties.Config.DatabaseConfig.port)

-- Connects to the DB
function LDT_Bounties.ConnectToDatabase()
	LDT_Bounties.DB_BOUNTIES:setAutoReconnect(true)
	
	print("[BOUNTIES] Connecting to Database!")
	LDT_Bounties.DB_BOUNTIES.onConnected = function()
		print("[BOUNTIES] Database Connection Successful!")
	end
	LDT_Bounties.DB_BOUNTIES.onConnectionFailed = function(db,msg)
		print("[BOUNTIES] Database Connection failed!")
		print(msg)
	end

	LDT_Bounties.DB_BOUNTIES:connect()
end


-- Creates all the necessary tables
function LDT_Bounties.CreateDBTables()
    local query = LDT_Bounties.DB_BOUNTIES:query([[
		CREATE TABLE IF NOT EXISTS `LDT_Bounties_PlayerStats` (
			`ID` int unsigned PRIMARY KEY AUTO_INCREMENT,
			`SteamID` varchar(30) NOT NULL UNIQUE,
			`ClaimedBounties` int unsigned NOT NULL,
            `SurvivedBounties` int unsigned NOT NULL
		);
    ]])
		
	query.onSuccess = function()
		print("[BOUNTIES] Successfully created MySQL tables.")
	end
	query:start()
end

function LDT_Bounties.UpdateClaimedBounties(ply) 
	local steamID = ply:SteamID64()

	local query = LDT_Bounties.DB_BOUNTIES:query("Select * from `LDT_Bounties_PlayerStats` where `SteamID` = '"..steamID.."';")
	query.onSuccess = function( q, data )
		local query1 = nil
		if #data > 0 then 
			query1 = LDT_Bounties.DB_BOUNTIES:query("Update `LDT_Bounties_PlayerStats` set `ClaimedBounties` = `ClaimedBounties` + 1 where `SteamID` = '"..steamID.."';")
			
		else
			query1 = LDT_Bounties.DB_BOUNTIES:query("Insert into `LDT_Bounties_PlayerStats` (`SteamID`, `ClaimedBounties`, `SurvivedBounties`) values ('"..steamID.."', 1, 0);")
		end

		query1.onSuccess = function()
			print("[BOUNTIES] Successfully updated ClaimedBounties for "..ply:Nick()..".")
		end
		query1:start()
    end

    query:start()
end

function LDT_Bounties.UpdateSurvivedBounties(ply) 
	local steamID = ply:SteamID64()

	local query = LDT_Bounties.DB_BOUNTIES:query("Select * from `LDT_Bounties_PlayerStats` where `SteamID` = '"..steamID.."';")
	query.onSuccess = function( q, data )
		local query1 = nil
		if #data > 0 then 
			query1 = LDT_Bounties.DB_BOUNTIES:query("Update `LDT_Bounties_PlayerStats` set `SurvivedBounties` = `SurvivedBounties` + 1 where `SteamID` = '"..steamID.."';")
			
		else
			query1 = LDT_Bounties.DB_BOUNTIES:query("Insert into `LDT_Bounties_PlayerStats` (`SteamID`, `ClaimedBounties`, `SurvivedBounties`) values ('"..steamID.."', 0, 1);")
		end

		query1.onSuccess = function()
			print("[BOUNTIES] Successfully updated Survived Bounties for "..ply:Nick()..".")
		end
		query1:start()
    end
    query:start()
end

function LDT_Bounties.GetSurvivedBountiesLeaderboard(callback)
	local query = LDT_Bounties.DB_BOUNTIES:query("Select * from `LDT_Bounties_PlayerStats` where `SurvivedBounties` > 0 order by `SurvivedBounties` desc limit 10;")
	query.onSuccess = function( q, data )
		callback(data)
	end
	query:start()
end

function LDT_Bounties.GetClaimedBountiesLeaderboard(callback)
	local query = LDT_Bounties.DB_BOUNTIES:query("Select * from `LDT_Bounties_PlayerStats` where `ClaimedBounties` > 0 order by `ClaimedBounties` desc limit 10;")
	query.onSuccess = function( q, data )
		callback(data)
	end
	query:start()
end