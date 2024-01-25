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
            LDT_Bounties.NotificationPanel:SetWide(length+35+w*0.07)
            LDT_Bounties.NotificationPanel:MoveTo(LDT_Bounties.GetWidth(1920-(length+35+w*0.07)), LDT_Bounties.GetHeight(300), 0.3, 0, -1, function(_,self)
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

net.Receive("LDT_Bounties_NewBountyPerson", function()
    local ply = net.ReadEntity()
    local amount = net.ReadInt(32)

    if not IsValid(ply) then return end

    if LDT_Bounties.Config.CurrencySymbolLocation and LDT_Bounties.ply ~= ply then
        ShowNotification("New bounty on "..ply:Nick().." for "..LDT_Bounties.Config.CurrencySymbol..amount.."!", 15)
        return
    elseif LDT_Bounties.ply ~= ply then
        ShowNotification("New bounty on "..ply:Nick().." for "..amount..LDT_Bounties.Config.CurrencySymbol.."!", 15)
        return
    end

    if LDT_Bounties.Config.CurrencySymbolLocation then
        ShowNotification("A new bounty has been placed on you for "..LDT_Bounties.Config.CurrencySymbol..amount.."!", 15)
    else
        ShowNotification("A new bounty has been placed on you for "..amount..LDT_Bounties.Config.CurrencySymbol.."!", 15)
    end
end)

net.Receive("LDT_Bounties_BountyEndedWithoutWinner", function()
    local ply = net.ReadEntity()
    local amount = net.ReadInt(32)

    if not IsValid(ply) then return end

    if IsValid(LDT_Bounties.NotificationPanel) then 
        LDT_Bounties.NotificationPanel:Remove()
    end

    if LDT_Bounties.Config.CurrencySymbolLocation and LDT_Bounties.ply ~= ply then
        ShowNotification("The bounty on "..ply:Nick().." has ended without a winner!", 5)
        return
    elseif LDT_Bounties.ply ~= ply then
        ShowNotification("The bounty on "..ply:Nick().." has ended without a winner!", 5)
        return
    end

    if LDT_Bounties.Config.CurrencySymbolLocation then
        ShowNotification("The bounty on you has ended and you have won "..LDT_Bounties.Config.CurrencySymbol..amount.."!", 5)
    else
        ShowNotification("The bounty on you has ended and you have won "..amount..LDT_Bounties.Config.CurrencySymbol.."!", 5)
    end
end)

function LDT_Bounties.IsPlayerLoadedIn()
	if IsValid( LocalPlayer() ) then
		LDT_Bounties.ply = LocalPlayer()
		
		hook.Remove( "HUDPaint", "LDT_Bounties.IsPlayerLoadedIn" )
	end
end
hook.Add( "HUDPaint", "LDT_Bounties.IsPlayerLoadedIn", LDT_Bounties.IsPlayerLoadedIn )