-- made by kamalsarasq

-- // VARIABLES //
local remotes = game.ReplicatedStorage:WaitForChild("ContactDeveloperRemotes")

-- // MODULES //
-- local TrimTextToFit = require(script.FitText)

-- // MESSAGE HOLDER //
local MessageHolder = {}
MessageHolder.__index = MessageHolder

-- // CONSTRUCTOR //
function MessageHolder.new(Key, _Content, Parent, ContentFrame)
	local NewMessageHolder = {}
	setmetatable(NewMessageHolder, MessageHolder)
	
	NewMessageHolder.Key = Key
	
	NewMessageHolder.Content = _Content
	NewMessageHolder.Template = game:GetService("ReplicatedStorage")
								:WaitForChild("ContactDeveloperRemotes")
								:WaitForChild("Template")
								:Clone()
	NewMessageHolder.Template.Parent = Parent
	NewMessageHolder.Template.Name = Key
	
	MessageHolder.OpenButton = NewMessageHolder.Template.Hitbox
	NewMessageHolder.TemplateR = NewMessageHolder.Template.DeveloperMessage
	NewMessageHolder.TemplateU = NewMessageHolder.Template.PlayerMessage
	
	NewMessageHolder.DeveloperReplyPrefix = "<b>Developer Reply: </b> \n"
	NewMessageHolder.UserReplyPrefix = '<font color="#FFFFFF" size="18"><b>Your Message: </b></font>'
	
	NewMessageHolder.ContentFrame = ContentFrame
	NewMessageHolder.LabelsPath = ContentFrame.Frame.ScrollingFrame.ScrollingFrame
	NewMessageHolder.DeveloperReply = NewMessageHolder.LabelsPath.DeveloperReply
	NewMessageHolder.UserReply = NewMessageHolder.LabelsPath.UserMessage
	
	NewMessageHolder:AddText()
	NewMessageHolder:Connect()
	
	return NewMessageHolder
end

-- // THIS FUNCTION WAS REMOVED //
function MessageHolder:TrimText(TextLabel)
	-- this was removed
	-- return TrimTextToFit.TrimTextToFit(self.Content.DeveloperReply, self.DeveloperReply, self.DeveloperReply.AbsoluteSize), TrimTextToFit.TrimTextToFit(self.Content.UserReply, self.UserReply, self.UserReply.AbsoluteSize)
end

-- // FUNCTION TO ADD TEXT //
function MessageHolder:AddText()
	self.TemplateR.Text = self.DeveloperReplyPrefix .. self.Content.DeveloperReply
	self.TemplateU.Text = self.Content.UserReply
end

-- // FUNCTION TO CONNECT WHEN A OPEN BUTTON IS PRESSED SO WE CAN OPEN THE LINKED FRAME//
function MessageHolder:Connect()
	self.OpenButton.Activated:Connect(function()
		self:Open()
	end)
end

-- // FUNCTION TO OPEN THE CONTENT FRAME AND FILLING THE CONTENT //
function MessageHolder:Open()
	self.DeveloperReply.Text = self.DeveloperReplyPrefix .. self.Content.DeveloperReply
	self.UserReply.Text = self.UserReplyPrefix .. self.Content.UserReply
	self.ContentFrame:Open()
	
	local success = remotes.SetRead:InvokeServer(self.Key)
	if not success then error("Failed to set DataStore!") end
end

-- // FUNCTION TO REMOVE THE MESSAGE HOLDER //
function MessageHolder:DeleteSelf()
	self.ContentFrame:Close()
	self.Template:Destroy()
end

return MessageHolder
