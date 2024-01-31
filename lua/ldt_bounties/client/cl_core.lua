-- This function renders the notification
local function ShowNotification(text, autoHideTime)
    if IsValid(LDT_Bounties.NotificationPanel) then return end
    LDT_Bounties.NotificationPanel = vgui.Create( "DPanel" )
    LDT_Bounties.NotificationPanel:SetPos(LDT_Bounties.GetWidth(1919.9), LDT_Bounties.GetHeight(300))
    LDT_Bounties.NotificationPanel:SetSize(LDT_Bounties.GetWidth(300), LDT_Bounties.GetHeight(50) )

    local ActivatedAnim = false
    LDT_Bounties.NotificationPanel.Paint = function(me, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, LDT_Bounties.Config.GreyThird )
        local length = draw.SimpleText(text,"WorkSans30", w*0.04, h*0.475, LDT_Bounties.Config.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        if length > 265 and not ActivatedAnim then 
            ActivatedAnim = true
            LDT_Bounties.NotificationPanel:SetWide(length+LDT_Bounties.GetWidth(35)+w*0.07)
            LDT_Bounties.NotificationPanel:MoveTo(LDT_Bounties.GetWidth(1920-(length+LDT_Bounties.GetWidth(35)+w*0.07)), LDT_Bounties.GetHeight(300), 0.3, 0, -1, function(_,self)
                LDT_Bounties.NotificationPanel:MoveTo(LDT_Bounties.GetWidth(1920), LDT_Bounties.GetHeight(300), 0.3, autoHideTime, -1, function(_,self)
                    self:Remove()
                end)
            end)
        elseif length <= 265 and not ActivatedAnim then
            ActivatedAnim = true
            LDT_Bounties.NotificationPanel:MoveTo(LDT_Bounties.GetWidth(1920-300), LDT_Bounties.GetHeight(300), 0.3, 0, -1, function(_,self)
                LDT_Bounties.NotificationPanel:MoveTo(LDT_Bounties.GetWidth(1920), LDT_Bounties.GetHeight(300), 0.3, autoHideTime, -1, function(_,self)
                    self:Remove()
                end)
            end)
        end
    end

    LDT_Bounties.NotificationPanel.accentBar = vgui.Create( "DPanel",LDT_Bounties.NotificationPanel )
    LDT_Bounties.NotificationPanel.accentBar:Dock(LEFT)
    LDT_Bounties.NotificationPanel.accentBar:SetWide(LDT_Bounties.GetWidth(10))
    LDT_Bounties.NotificationPanel.accentBar.Paint = function(me, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, LDT_Bounties.Config.Blue )
    end
end

-- This function renders the notification
local function ShowActiveBounty(bountyPerson)
    if IsValid(LDT_Bounties.BountyPanel) then return end
    LDT_Bounties.BountyPanel = vgui.Create( "DPanel" )
    LDT_Bounties.BountyPanel:SetPos(LDT_Bounties.GetWidth(0), LDT_Bounties.GetHeight(850))
    LDT_Bounties.BountyPanel:SetSize(LDT_Bounties.GetWidth(300), LDT_Bounties.GetHeight(50) )

    local ActivatedAnim = false
    LDT_Bounties.BountyPanel.Paint = function(me, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, LDT_Bounties.Config.GreyThird )
        local length = draw.SimpleText(LDT_Bounties.GetLanguange("CurrentBountyNotify") .. bountyPerson,"WorkSans30", w*0.04, h*0.475, LDT_Bounties.Config.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        if length > 265 and not ActivatedAnim then 
            ActivatedAnim = true
            LDT_Bounties.BountyPanel:SetWide(length+LDT_Bounties.GetWidth(35)+w*0.07)
            LDT_Bounties.BountyPanel:MoveTo(0, LDT_Bounties.GetHeight(850), 0.3, 0, -1, function(_,self)
            end)
        elseif length <= 265 and not ActivatedAnim then
            ActivatedAnim = true
            LDT_Bounties.BountyPanel:MoveTo(0, LDT_Bounties.GetHeight(850), 0.3, 0, -1, function(_,self)
            end)
        end
    end

    LDT_Bounties.BountyPanel.accentBar = vgui.Create( "DPanel",LDT_Bounties.BountyPanel )
    LDT_Bounties.BountyPanel.accentBar:Dock(RIGHT)
    LDT_Bounties.BountyPanel.accentBar:SetWide(LDT_Bounties.GetWidth(10))
    LDT_Bounties.BountyPanel.accentBar.Paint = function(me, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, LDT_Bounties.Config.Blue )
    end
end

local function RemoveActiveBounty()
    if not IsValid(LDT_Bounties.BountyPanel) then return end
    LDT_Bounties.BountyPanel:MoveTo(-LDT_Bounties.GetWidth(LDT_Bounties.BountyPanel:GetWide()), LDT_Bounties.GetHeight(850), 0.3, 0, -1, function(_,self)
        self:Remove()
    end)
end

-- This function opens the bounties UI
local function OpenBountiesUI()
    if IsValid(LDT_Bounties.bountiesMainPanel) then
        LDT_Bounties.bountiesMainPanel:Remove()
    end

    LDT_Bounties.bountiesMainPanel = vgui.Create( "LDTBountiesFrame" )
    LDT_Bounties.bountiesMainPanel:Center()
    LDT_Bounties.bountiesMainPanel:MakePopup()
    LDT_Bounties.bountiesMainPanel:Show()
end

-- This network message is received when the player wants to open the bounties UI
net.Receive("LDT_Bounties_OpenBountiesUI", function()
    OpenBountiesUI()
end)

-- This network message is received when a new bounty is created
net.Receive("LDT_Bounties_NewBountyPerson", function()
    local ply = net.ReadEntity()
    local amount = net.ReadInt(32)

    if not IsValid(ply) then return end

    local nick = ply:Nick()

    if IsValid(LDT_Bounties.NotificationPanel) then 
        LDT_Bounties.NotificationPanel:Remove()
    end

    ShowActiveBounty(nick)

    if LDT_Bounties.Config.CurrencySymbolLocation and LDT_Bounties.ply ~= ply then
        ShowNotification(string.Replace(LDT_Bounties.GetLanguange("NewBounty"), "VICTIMNICK", nick)..LDT_Bounties.Config.CurrencySymbol..amount.."!", 15)
        return
    elseif LDT_Bounties.ply ~= ply then
        ShowNotification(string.Replace(LDT_Bounties.GetLanguange("NewBounty"), "VICTIMNICK", nick)..amount..LDT_Bounties.Config.CurrencySymbol.."!", 15)
        return
    end

    if LDT_Bounties.Config.CurrencySymbolLocation then
        ShowNotification(LDT_Bounties.GetLanguange("NewBountySelf")..LDT_Bounties.Config.CurrencySymbol..amount.."!", 15)
    else
        ShowNotification(LDT_Bounties.GetLanguange("NewBountySelf")..amount..LDT_Bounties.Config.CurrencySymbol.."!", 15)
    end
end)

-- This network message is received when a bounty is ended without a winner
net.Receive("LDT_Bounties_BountyEndedWithoutWinner", function()
    local ply = net.ReadEntity()
    local amount = net.ReadInt(32)
    local type = net.ReadBool()

    if not IsValid(ply) then return end

    RemoveActiveBounty()

    if IsValid(LDT_Bounties.NotificationPanel) then 
        LDT_Bounties.NotificationPanel:Remove()
    end

    if LDT_Bounties.Config.CurrencySymbolLocation and LDT_Bounties.ply ~= ply or type and LDT_Bounties.Config.CurrencySymbolLocation then
        ShowNotification(string.Replace(LDT_Bounties.GetLanguange("NoBountyWinner"), "PLYNAME", ply:Nick()), 5)
        return
    elseif LDT_Bounties.ply ~= ply or type then
        ShowNotification(string.Replace(LDT_Bounties.GetLanguange("NoBountyWinner"), "PLYNAME", ply:Nick()), 5)
        return
    end

    if LDT_Bounties.Config.CurrencySymbolLocation and LDT_Bounties.Config.RewardForSurviving and not type then
        ShowNotification(LDT_Bounties.GetLanguange("NoBountyWinnerSelf")..LDT_Bounties.Config.CurrencySymbol..amount.."!", 5)
    elseif not type then
        ShowNotification(LDT_Bounties.GetLanguange("NoBountyWinnerSelf")..amount..LDT_Bounties.Config.CurrencySymbol.."!", 5)
    end
end)

-- This network message is received when a bounty is ended with a winner
net.Receive("LDT_Bounties_BountyEndedWithWinner", function()
    local ply = net.ReadEntity()
    local winner = net.ReadEntity()
    local amount = net.ReadInt(32)

    if not IsValid(ply) or not IsValid(winner) then return end

    RemoveActiveBounty()

    if IsValid(LDT_Bounties.NotificationPanel) then 
        LDT_Bounties.NotificationPanel:Remove()
    end

    local text = string.Replace(LDT_Bounties.GetLanguange("BountyWinner"), "VICTIMNICK", ply:Nick())
    text = string.Replace(text, "WINNERNICK", winner:Nick())
    
    if LDT_Bounties.Config.CurrencySymbolLocation and LDT_Bounties.ply ~= ply then
        ShowNotification(text..LDT_Bounties.Config.CurrencySymbol..amount.."!", 5)
        return
    elseif LDT_Bounties.ply ~= ply then
        ShowNotification(text..amount..LDT_Bounties.Config.CurrencySymbol.."!", 5)
        return
    end
end)

-- This network message is received when a the player just connected and there is already a bounty active
net.Receive("LDT_Bounties_CurrentBounty", function()
    local ply = net.ReadEntity()
    local amount = net.ReadInt(32)

    if not IsValid(ply) then return end

    local nick = ply:Nick()

    ShowActiveBounty(nick)

    if LDT_Bounties.Config.CurrencySymbolLocation and LDT_Bounties.ply ~= ply then
        ShowNotification(string.Replace(LDT_Bounties.GetLanguange("BountyExists"), "VICTIMNICK", nick)..LDT_Bounties.Config.CurrencySymbol..amount.."!", 15)
        return
    elseif LDT_Bounties.ply ~= ply then
        ShowNotification(string.Replace(LDT_Bounties.GetLanguange("BountyExists"), "VICTIMNICK", nick)..amount..LDT_Bounties.Config.CurrencySymbol.."!", 15)
        return
    end
end)

-- this hook is used to check if the player is loaded in and then send a network message to the server
function LDT_Bounties.IsPlayerLoadedIn()
	if IsValid( LocalPlayer() ) then
		LDT_Bounties.ply = LocalPlayer()
		
		hook.Remove( "HUDPaint", "LDT_Bounties.IsPlayerLoadedIn" )

        net.Start("LDT_Bounties_PlayerLoadedIn")
        net.SendToServer()
	end
end
hook.Add( "HUDPaint", "LDT_Bounties.IsPlayerLoadedIn", LDT_Bounties.IsPlayerLoadedIn )