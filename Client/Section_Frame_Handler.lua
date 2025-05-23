-- made by kamalsarasq

-- local Paths = require(script.Parent.Parent.Paths)

-- // TWEEN CREATOR //
local Tween = require(script.Tween)

-- // SECTION FRAME //
local SectionFrame = {}
SectionFrame.__index = SectionFrame

-- // CONSTRUCTOR //
function SectionFrame.new(frame: Frame, OpenButton: TextButton, ExitButton: TextButton, TweenPositions, Holder)
	local newsectionframe = {}
	setmetatable(newsectionframe, SectionFrame)
	
	newsectionframe.Frame = frame -- linked frame
	newsectionframe.IsVisible = newsectionframe.Frame.Visible
	newsectionframe.StartPosition = TweenPositions[1]
	newsectionframe.EndPosition = TweenPositions[2]
	newsectionframe.OpenButton = OpenButton
	newsectionframe.ExitButton = ExitButton
	
	-- // CONNECTING TO BUTTONS //
	newsectionframe:ConnectToOpen()
	newsectionframe:ConnectToExit()
	
	--newsectionframe.Tweener = Tween.new(newsectionframe.Frame, newsectionframe.StartPosition, newsectionframe.EndPosition)
	return newsectionframe
end

-- // FUNCTION TO OPEN THE SECTION FRAME //
function SectionFrame:Open()
	self.Frame.Visible = true
	local EntryTween = Tween.new(self.Frame, self.StartPosition, self.EndPosition)
	-- returning and playing the tween
	return EntryTween:Entry()
end

-- // FUNCTION TO CLOSE THE SECTION FRAME //
function SectionFrame:Close()
	local ExitTween = Tween.new(self.Frame, self.StartPosition, self.EndPosition)
	local ExitApply = ExitTween:Exit() -- playing the exit tween
	ExitApply.Completed:Wait()
	self.Frame.Visible = false
	return ExitApply
end

-- // FUNCTION TO CONNECT THE BUTTON TO OPEN //
function SectionFrame:ConnectToOpen()
	if not self.OpenButton then return end
	
	self.OpenButton.Activated:Connect(function()
		self:Open()
	end)
end

-- // FUNTION TO CONNECT THE BUTTON TO EXIT //
function SectionFrame:ConnectToExit()
	if not self.ExitButton then return end
	
	self.ExitButton.Activated:Connect(function()
		self:Close()
	end)
end

return SectionFrame
