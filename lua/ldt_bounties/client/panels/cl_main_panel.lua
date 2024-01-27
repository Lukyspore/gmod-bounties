local PANEL = {}

local xicon = Material("ldt_bounties/x.png", "noclamp smooth")
local moneyBagIcon = Material("ldt_bounties/moneybag.png", "noclamp smooth")
local gun = Material("ldt_bounties/gun.png", "noclamp smooth")
local notesMedical = Material("ldt_bounties/notesmedical.png", "noclamp smooth")

-- Setup default properties of this panel
function PANEL:Init()
    self:SetDraggable(false)
    self:SetTitle("")
    self:DockPadding(0, 0, 0, 0)
    self:ShowCloseButton(false)
    self:SetSize( LDT_Bounties.GetWidth(900), LDT_Bounties.GetHeight(500) )

    self.BountiesCategory = ""

    self:SideBar()
    self:TopBar()
    self:CloseButton()
end

function PANEL:TopBar() 
    if IsValid(self.topBar) then self.topBar:Remove() end

    local sidebarWidth = self.sidebar:GetWide()
    self.topbar = self:Add("DPanel")
    self.topbar:Dock(TOP)
    self.topbar:SetTall(LDT_Bounties.GetHeight(50))
    self.topbar.Paint = function(me,w,h)
        draw.SimpleText(self.BountiesCategory, "WorkSans36-Bold", w * 0 + LDT_Bounties.GetWidth(10), h * .5, LDT_Bounties.Config.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
end

-- Create the close button
function PANEL:CloseButton()
    if IsValid(self.closeBtn) then self.closeBtn:Remove() end
    
    self.closeBtn = self.topbar:Add("DImageButton")
    self.closeBtn:Dock(RIGHT)
    self.closeBtn:SetWide(LDT_Bounties.GetWidth(18))
    self.closeBtn:DockMargin(0, LDT_Bounties.GetHeight(16), LDT_Bounties.GetWidth(10), LDT_Bounties.GetHeight(16))
    self.closeBtn.DoClick = function()
        self:Remove()
    end
    self.closeBtn.Paint = function(me, w, h)
        surface.SetMaterial( xicon )
        surface.SetDrawColor( LDT_Bounties.Config.Red )
        surface.DrawTexturedRect( 0, h * 0.5 - LDT_Bounties.GetHeight(18)/2, LDT_Bounties.GetWidth(18), LDT_Bounties.GetHeight(18) )
    end
end

function PANEL:OpenLeaderboardPage(netMessageString, leaderboardType)
    if IsValid(self.leaderboardsPage) then
        self.leaderboardsPage:Remove()
    end

    self.leaderboardsPage = self:Add("LDTLeaderboardPanel")
    self.leaderboardsPage:SetLeaderboard(netMessageString, leaderboardType)
end

-- Creates the sidebar
function PANEL:SideBar()
    if IsValid(self.sidebar) then self.sidebar:Remove() end

    self.sidebar = self:Add("DPanel")
    self.sidebar.maxWidth = 0
    self.sidebar:Dock(LEFT)
    self.sidebar:SetWide(LDT_Bounties.GetWidth(65))
    self.sidebar:DockPadding(0, 0, 0, 0)
    self.sidebar:DockMargin(0, 0, 0, 0)
    self.sidebar.Paint = function(me,w,h)
        draw.RoundedBoxEx( 8, 0, 0, w, h, LDT_Bounties.Config.Blue, true, false, true, false )

        if self.sidebar:IsHovered() or self.sidebar:IsChildHovered() then
            self.sidebar:SetWide(Lerp(0.1, self.sidebar:GetWide(), self.sidebar.maxWidth))
        else
            self.sidebar:SetWide(Lerp(0.1, self.sidebar:GetWide(), LDT_Bounties.GetWidth(65)))
        end
    end
    
    self.moneyBagIcon = self.sidebar:Add("DImage")
    self.moneyBagIcon:Dock(TOP)
    self.moneyBagIcon:SetTall(LDT_Bounties.GetHeight(36))
    self.moneyBagIcon:DockMargin(0, LDT_Bounties.GetHeight(15), 0, LDT_Bounties.GetHeight(15))
    self.moneyBagIcon.Paint = function(me,w,h)
        surface.SetMaterial( moneyBagIcon )
        surface.SetDrawColor( LDT_Bounties.Config.White )
        surface.DrawTexturedRect( w * 0.5 - LDT_Bounties.GetWidth(36)/2, 0, LDT_Bounties.GetWidth(36), LDT_Bounties.GetHeight(36) )
    end
        
    self.divider = self.sidebar:Add("DPanel")
    self.divider:Dock(TOP)
    self.divider:SetTall(LDT_Bounties.GetHeight(2))
    self.divider:DockMargin(0, LDT_Bounties.GetHeight(5), 0, 0)
    self.divider.Paint = function(me,w,h)
        draw.RoundedBox( 8, w * 0.1, 0, w * 0.8, h, LDT_Bounties.Config.Grey )
    end

    local selectedIcon = 1
    local longestString = 0
    local stringWidth = 0
    
    self.sidebarItems = {}
    surface.SetFont( "WorkSans30" )

    self:OpenLeaderboardPage("LDT_Bounties_OpenClaimed",1)
    self.BountiesCategory = LDT_Bounties.GetLanguange("ClaimedCategoryName")

    self.sidebarItems[1] = self.sidebar:Add("DImageButton")
    self.sidebarItems[1]:Dock(TOP)
    self.sidebarItems[1]:SetText("")
    self.sidebarItems[1]:SetTall(LDT_Achievements.GetHeight(28))
    self.sidebarItems[1]:DockMargin(0, LDT_Achievements.GetHeight(15), 0, LDT_Achievements.GetHeight(5))
    self.sidebarItems[1].Paint = function(me,w,h)
        surface.SetMaterial( gun )
        surface.SetDrawColor( LDT_Achievements.Config.White )

        if self.sidebarItems[1]:IsHovered() and selectedIcon ~= 1 then
            surface.SetDrawColor( LDT_Achievements.Config.WhiteHighlight )
        end
        if selectedIcon == 1 then
            surface.SetDrawColor( LDT_Achievements.Config.Grey )
        end
        surface.DrawTexturedRect( LDT_Achievements.GetWidth(65)/2 - LDT_Achievements.GetWidth(28)/2, 0, LDT_Achievements.GetWidth(28), LDT_Achievements.GetHeight(28) )
        
        if self.sidebar:IsHovered() or self.sidebar:IsChildHovered() then
            draw.SimpleText(LDT_Bounties.GetLanguange("ClaimedIcon"), "WorkSans30", LDT_Achievements.GetWidth(65)/2 +LDT_Achievements.GetWidth(28)/2 + LDT_Achievements.GetWidth(5), h * .5, LDT_Achievements.Config.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end
    self.sidebarItems[1].DoClick = function()
        selectedIcon = 1

        self:OpenLeaderboardPage("LDT_Bounties_OpenClaimed",1)
        self.BountiesCategory = LDT_Bounties.GetLanguange("ClaimedCategoryName")
    end

    stringWidth = surface.GetTextSize( LDT_Bounties.GetLanguange("ClaimedIcon") )
    if stringWidth > longestString then
        longestString = stringWidth
    end

    self.sidebarItems[2] = self.sidebar:Add("DImageButton")
    self.sidebarItems[2]:Dock(TOP)
    self.sidebarItems[2]:SetText("")
    self.sidebarItems[2]:SetTall(LDT_Achievements.GetHeight(28))
    self.sidebarItems[2]:DockMargin(0, LDT_Achievements.GetHeight(15), 0, LDT_Achievements.GetHeight(5))
    self.sidebarItems[2].Paint = function(me,w,h)
        surface.SetMaterial( notesMedical )
        surface.SetDrawColor( LDT_Achievements.Config.White )

        if self.sidebarItems[2]:IsHovered() and selectedIcon ~= 2 then
            surface.SetDrawColor( LDT_Achievements.Config.WhiteHighlight )
        end
        if selectedIcon == 2 then
            surface.SetDrawColor( LDT_Achievements.Config.Grey )
        end
        surface.DrawTexturedRect( LDT_Achievements.GetWidth(65)/2 - LDT_Achievements.GetWidth(28)/2, 0, LDT_Achievements.GetWidth(28), LDT_Achievements.GetHeight(28) )
        
        if self.sidebar:IsHovered() or self.sidebar:IsChildHovered() then
            draw.SimpleText(LDT_Bounties.GetLanguange("SurvivedIcon"), "WorkSans30", LDT_Achievements.GetWidth(65)/2 +LDT_Achievements.GetWidth(28)/2 + LDT_Achievements.GetWidth(5), h * .5, LDT_Achievements.Config.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end
    self.sidebarItems[2].DoClick = function()
        selectedIcon = 2

        self:OpenLeaderboardPage("LDT_Bounties_OpenSurvived",2)
        self.BountiesCategory = LDT_Bounties.GetLanguange("SurvivedCategoryName")
    end

    stringWidth = surface.GetTextSize( LDT_Bounties.GetLanguange("SurvivedIcon") )
    if stringWidth > longestString then
        longestString = stringWidth
    end

    self.sidebar.maxWidth = longestString + LDT_Bounties.GetWidth(65) + LDT_Bounties.GetWidth(28) + LDT_Bounties.GetWidth(10)
end

-- Change the defualt paint.
function PANEL:Paint(w, h)
    draw.RoundedBox( 8, 0, 0, w, h, LDT_Bounties.Config.Grey )
end

vgui.Register("LDTBountiesFrame", PANEL, "DFrame")