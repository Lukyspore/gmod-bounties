if LDT_Bounties.Config.DatabaseMode ~= "mysqloo" then return end
local MySQLOO = require("mysqloo")

-- Creates the DB connection
LDT_Bounties.DB_BOUNTIES = mysqloo.connect(LDT_Bounties.Config.DatabaseConfig.host, LDT_Bounties.Config.DatabaseConfig.user, LDT_Bounties.Config.DatabaseConfig.password, LDT_Bounties.Config.DatabaseConfig.database, LDT_Bounties.Config.DatabaseConfig.port)

-- Connects to the DB
function LDT_Bounties.ConnectToDatabase()
	LDT_Bounties.DB_BOUNTIES:setAutoReconnect(true)
	LDT_Bounties.DB_BOUNTIES:setMultiStatements(true)
	
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
    local query = LDT_Bounties.DB_BOUNTIES:query([[]])
		
	query.onSuccess = function()
		print("[BOUNTIES] Successfully created MySQL tables.")
	end
	query:start()
end