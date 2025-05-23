-- made by kamalsarasq

-- // SERVICES //
local HttpService = game:GetService("HttpService")

-- // WebhookRequest //
local WebhookRequest = {}
WebhookRequest.__index = WebhookRequest

-- // REQUEST CONSTRUCTOR //
function WebhookRequest.new(WebookUrl, HttpType, Data)
	local NewRequest = {}
	setmetatable(NewRequest, WebhookRequest)
	
	NewRequest.WebhookUrl = WebookUrl
	NewRequest.HttpType = HttpType
	NewRequest.Data = Data
	
	return NewRequest
end

-- // FUNCTION TO SEND REQUEST //
function WebhookRequest:SendRequest()
	local JsonData = HttpService:JSONEncode(self.Data)
	
	local success, response = pcall(function()
		return HttpService:PostAsync(self.WebhookUrl, JsonData, self.HttpType)
	end)
	
	if not success then error(response) return false end
	
	return true
end

return WebhookRequest
