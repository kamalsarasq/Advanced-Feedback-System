-- made by kamalsarasq

-- // SERVICES //
local TweenService = game:GetService("TweenService")
-- local Paths = require(script.Parent.Parent.Paths)

-- // TWEEN //
local Tween = {}
Tween.__index = Tween

-- // TWEENER TYPE //
type Tweener = {
	Frame: Frame,
	StartPosition: UDim2,
	EndPosition: UDim2,
	TweenInfo: TweenInfo
}

-- // FUNCTION TO TWEEN TO TARGET //
local function TweenToTarget(Tweener: Tweener, TargetPosition: UDim2, StartPosition: UDim2)
	Tweener.Frame.Position = StartPosition
	local TweenCreation = TweenService:Create(Tweener.Frame, Tweener.TweenInfo, {Position = TargetPosition})
	TweenCreation:Play()
	return TweenCreation -- returning tween creation for further modifications
end

-- // CONSTRUCTOR //
function Tween.new(SectionFrame: Frame, StartPosition: UDim2, EndPosition: UDim2)
	local NewTween = {}
	setmetatable(NewTween, Tween)
	
	NewTween.Frame = SectionFrame
	NewTween.StartPosition = StartPosition
	NewTween.EndPosition = EndPosition
	NewTween.Duration = 0.3
	NewTween.TweenInfo = TweenInfo.new(NewTween.Duration, Enum.EasingStyle.Quad)
	
	return NewTween
end

-- // FUNCTION TO MANAGE ENTRY TWEEN //
function Tween:Entry()
	return TweenToTarget(self, self.StartPosition, self.EndPosition)
end

-- // FUNCTION TO MANAGE EXIT TWEEN //
function Tween:Exit()
	return TweenToTarget(self, self.EndPosition, self.StartPosition)
end

return Tween
