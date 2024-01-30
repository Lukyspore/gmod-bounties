LDT_Bounties = LDT_Bounties or {}
LDT_Bounties.Config = LDT_Bounties.Config or {}

LDT_Bounties.Config.Language = "en" -- Currently there are en, pl, fr, da, tr and de translations available.

LDT_Bounties.Config.MenuCommand = "!bounties" -- This is the command to open the menu.

LDT_Bounties.Config.MinimumPlayers = 1 -- This is the minimum amount of players required to start a bounty.

LDT_Bounties.Config.BountyChance = 100 -- This is the chance of a bounty being started when new round starts. 100 = 100% chance, 50 = 50%, etc.

LDT_Bounties.Config.RewardForSurviving = true -- This is whether or not you get a reward for surviving the round when having a bounty on you.
LDT_Bounties.Config.RewardFramework = "PS1" -- This is the reward framework. You can choose between PS1, PS2, ZPN.
LDT_Bounties.Config.CurrencySymbol = " Points" -- This is the name of the currency. This only works when using the PS1, PS2 or ZPN reward framework.
LDT_Bounties.Config.CurrencySymbolLocation = false -- This is the location of the currency symbol. True = Before the amount, false = After the amount.
LDT_Bounties.Config.ZPNMultiplier = 1 -- This is the multiplier for the ZPN currency. This changes the amount of ZPN you get from voting.

LDT_Bounties.Config.BountyMinimum = 10 -- This is the minimum amount of money you can set a bounty to.
LDT_Bounties.Config.BountyMaximum = 100 -- This is the maximum amount of money you can set a bounty to.

-- These are the colors for every element of the UI. Feel free to change them to your liking.
LDT_Bounties.Config.Red = Color(255, 63, 5)
LDT_Bounties.Config.White = Color(255,255,255)
LDT_Bounties.Config.WhiteHighlight = Color(200,200,200,255)
LDT_Bounties.Config.Grey = Color(47, 54, 64)
LDT_Bounties.Config.GreySecond = Color(53, 59, 72)
LDT_Bounties.Config.GreyThird = Color(53, 59, 72,100)
LDT_Bounties.Config.Blue = Color(0, 151, 230)

LDT_Bounties.Config.Gold = Color(251, 197, 49,255)
LDT_Bounties.Config.Silver = Color(127, 143, 166,255)
LDT_Bounties.Config.Bronze = Color(240, 147, 43,255)