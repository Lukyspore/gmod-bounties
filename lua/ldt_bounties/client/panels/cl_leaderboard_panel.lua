local PANEL = {}
local this

-- Setup default properties of this panel
function PANEL:Init()
    this = self
    self:Dock(FILL)
    self:DockMargin(LDT_Bounties.GetWidth(5), LDT_Bounties.GetHeight(10), LDT_Bounties.GetWidth(5), 0)
end

-- Set the leaderboard type. And send a net message to the server to get the leaderboard.
-- 1 = Claimed bounties, 2 = Survived bounties
function PANEL:SetLeaderboard(netString, leaderboardType)
    self.leaderboardType = leaderboardType
    net.Start(netString)
    net.SendToServer()
end

-- Create the scroll body that will hold the websites.
function PANEL:CreateBody()
    self.scroll = self:Add("DScrollPanel")
    self.scroll:Dock(FILL)
    self.scroll:DockMargin(0, 0, 0, LDT_Bounties.GetHeight(10))
    local sbar = self.scroll:GetVBar()
    function sbar:Paint(w, h)
    end
    function sbar.btnUp:Paint(w, h)
    end
    function sbar.btnDown:Paint(w, h)
    end
    function sbar.btnGrip:Paint(w, h)
        draw.RoundedBox(8, w*0.5, 0, w * .4, h, LDT_Bounties.Config.Blue)
    end
end

-- Fill the leaderboard with the data from the server.
function PANEL:FillLeaderboards()
    self.topPlayers = {}
    if #self.playersLeaderboard == 0 then
        self.scroll:Remove()
        self.noServerData = self:Add("DScrollPanel")
        self.noServerData:Dock(FILL)
        self.noServerData:DockMargin(0,0,0,0)
        self.noServerData.Paint = function(me,w,h)
            if self.leaderboardType == 1 then
                draw.SimpleText(LDT_Bounties.GetLanguange("NoClaimedBountiesText"),"WorkSans50-Bold",w*.5,h*.5, LDT_Bounties.Config.White,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            elseif self.leaderboardType == 2 then
                draw.SimpleText(LDT_Bounties.GetLanguange("NoSurvivedBountiesText"),"WorkSans50-Bold",w*.5,h*.5, LDT_Bounties.Config.White,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            end
        end
    else
        for k, v in ipairs(self.playersLeaderboard) do
            self.topPlayers[k] = self.scroll:Add("DPanel")
            self.topPlayers[k]:Dock(TOP)
            self.topPlayers[k]:SetTall(LDT_Bounties.GetHeight(70))
            self.topPlayers[k]:DockMargin(LDT_Bounties.GetWidth(10),0,LDT_Bounties.GetWidth(10),LDT_Bounties.GetHeight(15))
            self.topPlayers[k].Paint = function(me,w,h)
                draw.RoundedBox( 5, 0, 0, w, h, LDT_Bounties.Config.GreySecond )
                if k < 4 then 
                    if self.leaderboardType == 1 then
                        draw.SimpleText(LDT_Bounties.GetLanguange("ClaimedBountiesText")..v.Count,"WorkSans30",w*.96,h*.46,LDT_Bounties.Config.White,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
                    elseif self.leaderboardType == 2 then
                        draw.SimpleText(LDT_Bounties.GetLanguange("SurvivedBountiesText")..v.Count,"WorkSans30",w*.96,h*.46,LDT_Bounties.Config.White,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
                    end
                    draw.SimpleText(k,"WorkSans36-Bold",w*.01,h*.46,LDT_Bounties.Config.WhiteHighlight,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
                    steamworks.RequestPlayerInfo( v.SteamID, function( steamName )
                        draw.SimpleText(steamName,"WorkSans50-Bold",w*.04,h*.46,LDT_Bounties.Config.White,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
                    end )
                else 
                    if self.leaderboardType == 1 then
                        draw.SimpleText(LDT_Bounties.GetLanguange("ClaimedBountiesText")..v.Count,"WorkSans30",w*.96,h*.5,LDT_Bounties.Config.White,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
                    elseif self.leaderboardType == 2 then
                        draw.SimpleText(LDT_Bounties.GetLanguange("SurvivedBountiesText")..v.Count,"WorkSans30",w*.96,h*.5,LDT_Bounties.Config.White,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
                    end

                    draw.SimpleText(k,"WorkSans36-Bold",w*.01,h*.5,LDT_Bounties.Config.WhiteHighlight,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
                    steamworks.RequestPlayerInfo( v.SteamID, function( steamName )
                        draw.SimpleText(steamName,"WorkSans50-Bold",w*.04,h*.5,LDT_Bounties.Config.White,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
                    end )
                end

                if k == 1 then
                    draw.RoundedBox( 5, 0, h*.92, w, h*.08, LDT_Bounties.Config.Gold )
                elseif k==2 then
                    draw.RoundedBox( 5, 0, h*.92, w, h*.08, LDT_Bounties.Config.Silver )
                elseif k==3 then
                    draw.RoundedBox( 5, 0, h*.92, w, h*.08, LDT_Bounties.Config.Bronze )
                end
            end 
        end
    end
end

-- Change the defualt paint.
function PANEL:Paint(w, h)
end

-- Receive the data from the server. And create the body.
net.Receive("LDT_Bounties_PanelLeaderboardsResponse", function()
    local tableCount = net.ReadUInt(4)
    this.playersLeaderboard = {}

    for i = 1, tableCount do
        local steamID = net.ReadString()
        local count = net.ReadUInt(16)
        table.insert(this.playersLeaderboard, {SteamID = steamID, Count = count})
    end

    this:CreateBody()
    this:FillLeaderboards()
end)

vgui.Register("LDTLeaderboardPanel", PANEL, "DPanel")