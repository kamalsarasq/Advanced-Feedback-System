-- made by kamalsarasq

--[[ more funtions will be added to this module later]]

-- // SERVICES //
local LocalizationService = game:GetService("LocalizationService")

local PlayerInfo = {}
PlayerInfo.__index = PlayerInfo

-- // FUNCTION TO GET ACCOUNT AGE //
--[[function PlayerInfo:GetAccountAge(player: Player): number
	return player.AccountAge -- this function is completly useless so it will be removed
end]]

-- // FUNCTION TO GET PLAYER REGION //
function PlayerInfo:GetPlayerRegion(player: Player): string?
	local success, result = pcall(function()
		return LocalizationService:GetCountryRegionForPlayerAsync(player)
	end)

	if success then
		return result
	else
		return nil
	end
end

return PlayerInfo
