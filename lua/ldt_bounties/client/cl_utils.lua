LDT_Bounties.Config.Scrw, LDT_Bounties.Config.Scrh = ScrW(), ScrH()

-- This functio returns size values for 1080p monitor
function LDT_Bounties.GetHeight(num)
    return (LDT_Bounties.Config.Scrh * (num / 1080))
end

-- This functio returns size values for 1920 width monitor
function LDT_Bounties.GetWidth(num)
    return (LDT_Bounties.Config.Scrw * (num / 1920))
end

-- Create fonts with correct size
local fontSize = {20, 24, 26, 30, 40, 50}
local fontSizeBold = {30, 36, 40}
local function CreateFonts()
	for k,v in ipairs(fontSize) do 
		surface.CreateFont("WorkSans"..v, {font = "Work Sans Regular",    size = LDT_Bounties.GetWidth(v),     weight = 500,	antialias = true})
	end

    for k,v in ipairs(fontSizeBold) do 
		surface.CreateFont("WorkSans"..v.."-Bold", {font = "Work Sans Bold",    size = LDT_Bounties.GetWidth(v),     weight = 500})
	end
end
CreateFonts()

-- On screen size changed change font size
hook.Add( "OnScreenSizeChanged", "LDT_Bounties.OnScreenSizeChanged_ChnageFont", function()
    LDT_Bounties.Config.Scrw, LDT_Bounties.Config.Scrh = ScrW(), ScrH()
    CreateFonts()
end)