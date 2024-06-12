import("CoreLibs/timer")

local gfx <const> = playdate.graphics
local spriteTransition = nil
class("SceneManager").extends()

function SceneManager:drawTransition()
	local rectangleWidth = 0
	spriteTransition = gfx.sprite.new()
	local imageTransition = gfx.image.new(400, 240)
	gfx.pushContext(imageTransition)
	gfx.setImageDrawMode(gfx.kDrawModeInverted)
	gfx.drawTextAligned("Loading . . . ", 200, 120, kTextAlignment.center)
	gfx.drawRect(0, 0, rectangleWidth, 240)
	gfx.popContext()
	spriteTransition:setImage(imageTransition)
	spriteTransition:moveTo(200, 120)
	spriteTransition:add()
end

function SceneManager:switchScene(scene, withLoading)
	self:cleanupScene()
	if withLoading then
		self:drawTransition()
	end

	local delay = withLoading and 500 or 1

	playdate.timer.performAfterDelay(delay, function()
		self.scene = scene
		self:loadNewScene()
		if withLoading and spriteTransition ~= nil then
			spriteTransition:remove()
		end
	end)
end

function SceneManager:loadNewScene()
	self.scene = self.scene()
end

function SceneManager:cleanupScene()
	gfx.sprite.removeAll()
	self.scene = nil
	gfx.clear(gfx.kColorBlack)
	gfx.setDrawOffset(0, 0)
end
