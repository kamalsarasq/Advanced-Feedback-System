-- made by kamalsarasq

-- // SERVICES //
local DataStoreService = game:GetService("DataStoreService")

-- // DATASTORE //
local MessagesStore = DataStoreService:GetDataStore("NewDataStore")

-- // MESSAGES //
local Messages = {}

-- // FUNCTION TO GET DATASTORE //
function Messages:Get(player: Player): (boolean, { [string]: any } | string)
	return pcall(function()
		return MessagesStore:GetAsync(player.UserId or player) or {}
	end)
end

-- // FUNCTION TO SET DATASTORE //
function Messages:Set(player: Player, data: { [string]: any }): (boolean, string?)
	return pcall(function()
		MessagesStore:SetAsync(player.UserId or player, data)
	end)
end

-- // FUNCTION TO ADD PLAYER MESSAGE TO DATASTORE //
function Messages:Add(player: Player, id: string, messageText: string): (boolean, string?)
	local ok, result = self:Get(player)
	if not ok then
		return false, result
	end
	
	if result == nil then
		local success, err = self:Set(player, {})
		if not success then return false end
	end
	
	result[id] = {
		Mess  = messageText,
		Reply = false,
		Read  = false,
	}
	
	return self:Set(player, result)
end

-- // FUNCTION TO SET A REPLY TO PLAYER'S MESSAGE //
function Messages:Reply(player: Player, id: string, replyText: string): (boolean, string?)
	local ok, data = self:Get(player)
	if not ok then
		return false, data
	end
	
	if not data[id] then
		return false, "Message ID not found"
	end
	
	data[id].Reply = replyText
	data[id].Read = false
	return self:Set(player, data)
end

-- // FUNCTION TO SET REPLY AS READ //
function Messages:SetRead(Player: Player, ReplyID: string)
	local success, dataOrError = self:Get(Player)
	if not success then return false end
	
	if dataOrError[ReplyID] then
		
		dataOrError[ReplyID].Read = true
		
		local success, errmessage = self:Set(Player, dataOrError) -- setting the message as read
		if not success then return false end
		
		return true
	end
	
	return false
end

return Messages
