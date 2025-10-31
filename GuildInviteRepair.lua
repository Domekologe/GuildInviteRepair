-- GuildInviteRepair - by Domekologe
-- This addon restores Guild Invite functionality and add Player Menu to invite players

local function DoGuildInvite(name)
	C_GuildInfo.Invite(name)
end

RepairGuildInvite = function()
	CommunitiesFrame.InviteButton:SetScript("OnClick", function()
		StaticPopup_Show("ADD_GUILDMEMBER")
	end)
end

-- Init
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event, arg1)
    RepairGuildInvite()
end)

-- Character Menu
local function AddGuildInviteButton(ownerRegion, rootDescription, contextData)
    -- contextData often has a unit token ("target", "player", "party1", etc.) or a name
    local unit = contextData and contextData.unit

    -- Only show for valid player units
    if unit and UnitIsPlayer(unit) and UnitIsFriend("player", unit) then
        -- Optional: don't show for yourself
        if UnitIsUnit(unit, "player") then return end

        -- Add a divider and our button at the end of the menu
        rootDescription:CreateDivider()
        rootDescription:CreateButton("Invite to Guild", function()
            local name = UnitName(unit)
            if name then
                -- Prefer modern API if available; fall back to legacy
                if C_GuildInfo and C_GuildInfo.CanGuildInvite and C_GuildInfo.CanGuildInvite() then
                    DoGuildInvite(name)
                else
                    -- Classic often allows direct GuildInvite(name) if you have permission
                    DoGuildInvite(name)
                end
                print(L.INVITETEXT .. name)
            else
                print(L.INVITE_ERROR1)
            end
        end)
    end
end

Menu.ModifyMenu("MENU_UNIT_TARGET", AddGuildInviteButton)

-- Right-click on player names in various places:
Menu.ModifyMenu("MENU_UNIT_PLAYER", AddGuildInviteButton) -- generic player entries
Menu.ModifyMenu("MENU_UNIT_PARTY",  AddGuildInviteButton) -- party members
Menu.ModifyMenu("MENU_UNIT_RAID",   AddGuildInviteButton) -- raid members
Menu.ModifyMenu("MENU_UNIT_FRIEND", AddGuildInviteButton) -- friends list, etc.
Menu.ModifyMenu("MENU_CHAT_ROSTER", AddGuildInviteButton)
Menu.ModifyMenu("MENU_CHAT_PLAYER_NAME", AddGuildInviteButton)