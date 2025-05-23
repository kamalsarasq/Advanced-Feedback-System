-- made by kamalsarasq

-- // REMOTES //
local Remotes = game.ReplicatedStorage.ContactDeveloperRemotes

-- // HTTP INFORMATION //
local webhookUrl = "webhook url goes here"

-- // MODULES HOLDER //
local modules = {}

-- // REQUIRING AND PUTTING THE MODULES IN THE TABLE //
for _, module in pairs(script:GetChildren()) do
	if module:IsA("ModuleScript") then
		modules[module.Name] = require(module)
	end
end

-- // ADMINS LIST //
local Admins = {
	7626737208
}

-- // FUNCTION TO CHECK IF THE PLAYER IS AN ADMIN //
local function IsAdmin(Player: Player)
	return table.find(Admins, Player.UserId)
end

-- // FUNCTION TO CREATE THE STRUCTURE FOR THE WEBHOOK MESSAGE //
local function CreateMessageStructure(Player: Player, Message: string, ReplyID: string, BotName: string)	
	return {
		["content"] = nil,
		["embeds"] = {{
			["title"] = "New Message from Player",
			["color"] = 0x3498db,
			["fields"] = {
				{["name"] = "Reply ID [IMPORTANT]", ["value"] = ReplyID, ["inline"] = true},
				{["name"] = "Username", ["value"] = Player.Name, ["inline"] = true},
				{["name"] = "Display Name", ["value"] = Player.DisplayName, ["inline"] = true},
				{["name"] = "User ID", ["value"] = tostring(Player.UserId), ["inline"] = true},
				{["name"] = "Account Age", ["value"] = tostring(Player.AccountAge) .. " days", ["inline"] = true},
				{["name"] = "Region", ["value"] = modules["Information"]:GetPlayerRegion(Player), ["inline"] = true},
				{["name"] = "Tick", ["value"] = tostring(tick()), ["inline"] = true}
			},
			["description"] = "💬 **Message:**\n" .. Message,
			["footer"] = {
				["text"] = "🕒 Game Time: " .. os.date("%H:%M:%S UTC")
			},
			["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
		}},
		["username"] = BotName or "Zuckerburg",
	}
end

-- // FUNCTION TO ADD PLAYER MESSAGE TO DATA STORE //
local function AddToDataStore(Player: Player, Message: string): string
	local ComposedID = modules["IDgen"].new():ComposeID("#", 7, 4)
	
	local AddedToDataStore = modules["DataStore"]:Add(Player, ComposedID, Message)
	if not AddedToDataStore then return false end
	
	return ComposedID
end

-- // FUNCTION TO VERIFY THE MESSAGE //
local function CheckIfEligible(Player: Player, Message: string): boolean
	-- checking if player is on cooldown
	local Cooldown = modules["Cooldown"]:CompareTick(Player, 15)
	if not Cooldown then return "Player is on cooldown." end -- returing the error message to client
	
	-- checking if the string has enough characters
	local HasEnoughCharacters = string.len(Message) >= 50
	if not HasEnoughCharacters then return "Message must be longer than 50 characters!" end -- returing the error message to client

	-- adding player to cooldown
	local SetCooldown = modules["Cooldown"]:SetCooldown(Player)
	if not SetCooldown then return "Failed adding player to cooldown!" end -- returing the error message to client
	
	-- adding message to data store
	local AddedToDataStore = AddToDataStore(Player, Message)
	if not AddToDataStore then return "Failed adding player message to DataStore!" end -- returing the error message to client
	
	-- creating structured data for the webhook
	local StructuredData = CreateMessageStructure(Player, Message, AddedToDataStore)
	
	-- sending message to the webhook
	local Request = modules["MakeHttp"].new(webhookUrl, Enum.HttpContentType.ApplicationJson,  StructuredData)
	local MessageSent = Request:SendRequest()
	if not MessageSent then return "The message was failed to send" end -- returing the error message to client
	
	return false
end

local function ProcessReply(Player: Player, Message: string, Address)
	local IsAdmin = IsAdmin(Player)
	if not IsAdmin then return "Not admin, Request rejected." end -- returing the error message to client
	
	local ReplyDataStoreSet = modules["DataStore"]:Reply(Address.TargetUserID, Address.ReplyID, Message)
	if not ReplyDataStoreSet then return "Falied to set reply!" end -- returing the error message to client
end

local function OnMessageSumbit(Player, Message)
	return CheckIfEligible(Player, Message)
end

--[[Remotes.SumbitMessage.OnServerInvoke = function(Player, Message)
	local IsEligible = CheckIfEligible(Player, Message)
	return IsEligible
end]]

local function OnReplySumbit(Player, Message, Address)
	return ProcessReply(Player, Message, Address)
end

--[[Remotes.SumbitReply.OnServerInvoke = function(Player: Player, Message: string, Address)
	warn("making a reply")
	local ReplyMade = ProcessReply(Player, Message, Address)
	warn("reply clarification was made")
	return ReplyMade
end]]

-- // CONNECTING TO WHEN A MESSAGE IS SUMBITED//
Remotes.SumbitMessage.OnServerInvoke = OnMessageSumbit

-- // CONNECTING TO WHEN A REPLY IS SUMBITED //
Remotes.SumbitReply.OnServerInvoke = OnReplySumbit

-- // FUNCTION TO SEND BACK THE DATA STORED MESSAGES TO CLIENT //
Remotes.GetMessageData.OnServerInvoke = function(Player)
	return modules["DataStore"]:Get(Player)
end

-- // FUNCTION TO SET THE MESSAGE AS READ IN DATA STORE WHEN CLIENT REQUESTS FOR //
Remotes.SetRead.OnServerInvoke = function(Player, ReplyID)
	return modules["DataStore"]:SetRead(Player, ReplyID)
end
