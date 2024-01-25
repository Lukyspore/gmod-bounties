local function AddFile(strPath,Include)
	local files, folders = file.Find(strPath.."*","LUA")
    
	for k,v in ipairs(files or {}) do
		if Include then
			include(strPath..v)
		else
			AddCSLuaFile(strPath..v)
		end
	end

	for k,v in ipairs(folders or {}) do 
		AddFile(strPath..v.."/",Include)
	end
end

local function LoadFiles()
	if SERVER then
		AddCSLuaFile("ldt_bounties/sh_config.lua")
		include("ldt_bounties/sh_config.lua")
        include("ldt_bounties/sv_mysql.lua")

        AddFile("ldt_bounties/server/", true)

		AddFile("ldt_bounties/shared/", true)
		AddFile("ldt_bounties/shared/", false)
		AddFile("ldt_bounties/client/", false)

	elseif CLIENT then
		include("ldt_bounties/sh_config.lua")
		
		AddFile("ldt_bounties/shared/", true)
		AddFile("ldt_bounties/client/", true)
	end
end

LoadFiles()