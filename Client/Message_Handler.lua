-- made by kamalsarasq

-- // MESSAGE HANDLER //
local MessageHandler = {}
MessageHandler.__index = MessageHandler

-- // CONSTRUCTOR //
function MessageHandler.new(SumbitButton: TextButton, ClearButton: TextButton, TextBox: TextButton, RemoteFunction: RemoteFunction, StatusFrame, Address)
	local NewMessageHandler = {}
	setmetatable(NewMessageHandler, MessageHandler)
	
	NewMessageHandler.SumbitButton = SumbitButton -- sumbit button
	NewMessageHandler.ClearButton = ClearButton -- clear button
	NewMessageHandler.TextBox = TextBox -- TextBox
	NewMessageHandler.StatusFrame = StatusFrame -- linked StatusFrame
	NewMessageHandler.LinkedRemote = RemoteFunction -- linked RemoteFunction
	if Address then NewMessageHandler.Address = {ReplyID = Address.ReplyID or nil, TargetUserID = Address.TargetUserID or nil, SenderName = Address.SenderName or nil} or "Zuckerburg" end
	
	NewMessageHandler.ConfirmationText = "Waiting for confirmation..."
	NewMessageHandler.ErrorText = "this will just take a moment."
	NewMessageHandler.SuccessText = 'Your message was <font color="#28A745" size="34"><b>successfully sent!</b></font>'
	NewMessageHandler.FailedText = 'Your message was <font color="#FF3B3B" size="34"><b>FAILED</b></font> to send!'
	
	NewMessageHandler.StatusMessageL = StatusFrame.Frame:FindFirstChild("ScrollingFrame", true)
		                                                :FindFirstChild("Message", true)

	NewMessageHandler.ErrorMessageL = NewMessageHandler.StatusMessageL:FindFirstChild("ErrorMessage", true)
	
	-- // CONNECTING TO BUTTONS //
	NewMessageHandler:ConnectToClear()
	NewMessageHandler:ConnectToSumbit()
	
	return NewMessageHandler
end

-- // FUNCTION TO CLEAR TEXT //
function MessageHandler:Clear()
	self.TextBox.Text = ""
end

-- // FUNCTION TO CONNECT TO CLEAR //
function MessageHandler:ConnectToClear()
	self.ClearButton.Activated:Connect(function()
		self:Clear()
	end)
end

-- // FUNCTION TO CHANGE TEXT TO SUCCESS TEXT //
function MessageHandler:SuccessScreen()
	self.ErrorMessageL.Visible = false
	self.StatusMessageL.Text = self.SuccessText
end

-- // FUNCTION TO CHANGE TEXT TO FAILED TEXT //
function MessageHandler:FailedScreen(ErrorMessage)
	self.ErrorMessageL.Visible = true
	self.StatusMessageL.Text = self.FailedText
	self.ErrorMessageL.Text = ErrorMessage or ""
end

-- // FUNCTION TO SUMBIT THE TEXTBOX MESSAGE //
function MessageHandler:Sumbit()
	
	warn(self.Address)
	self.StatusMessageL.Text = self.ConfirmationText
	self.ErrorMessageL.Text = self.ErrorText
	
	self.StatusFrame:Open()
	
	local Texts = nil
	if self.Address then
		Texts = {TargetUserID = self.Address.TargetUserID.Text, ReplyID = self.Address.ReplyID.Text}
	end
	
	-- local RequestClarificationFailed = self.LinkedRemote:InvokeServer(self.TextBox.Text, self.Address)
	local RequestClarificationFailed = self.LinkedRemote:InvokeServer(self.TextBox.Text, Texts)
	
	if RequestClarificationFailed then
		self:FailedScreen(RequestClarificationFailed)
		return
	end
	
	self.StatusFrame:Open()
	self:Clear()
	
	self:SuccessScreen()
end

-- // FUNCTION TO CONNECT TO SUMBIT BUTTON //
function MessageHandler:ConnectToSumbit()
	self.SumbitButton.Activated:Connect(function()
		self:Sumbit()
	end)
end

return MessageHandler
