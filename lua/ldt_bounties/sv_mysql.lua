-- Which database mode to use.
-- Available modes: mysqloo, sqlite
LDT_Bounties.Config.DatabaseMode = "sqlite"

-- If mysqloo is enabled above, the login info for the MySQL server.
-- The tables will be created automatically.
LDT_Bounties.Config.DatabaseConfig = {
	host = "hostname",
	user = "username",
	password = "password",
	database = "dbname",
	port = 3306,
}