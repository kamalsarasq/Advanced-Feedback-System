-- made by kamalsarasq

-- // SERVICES //
local DataStoreService = game:GetService("DataStoreService")

-- // DATASTORE //
local CooldownsDataStore = DataStoreService:GetDataStore("Cooldowns")

-- // MODULE //
local module = {}

-- // FUNCTION TO SET DATA //
function module:SetData(Player: Player, Data: number)
	return pcall(function()
		CooldownsDataStore:SetAsync(Player.UserId, Data)
	end)
end

-- // FUNCTION TO GET DATA //
function module:GetData(Player: Player, Data: number)
	return pcall(function()
		return CooldownsDataStore:GetAsync(Player.UserId)
	end)
end

-- // FUNCTION TO COMPARE TICK //
function module:CompareTick(Player: Player, CooldownTime: number): boolean
	local success, DataOrError = self:GetData(Player)
	if not success then
		return false
	end
	
	if DataOrError == nil then
		return true
	end
	
	local TimeDifference = os.time() - (DataOrError)
	if TimeDifference > CooldownTime then
		return true
	end
	
	return false

end

-- // FCUNTION TO SET COOLDOWN //
function module:SetCooldown(Player: Player): boolean	
	local success, err = self:SetData(Player, os.time())
	if success then return true end
	return false
end

return module
