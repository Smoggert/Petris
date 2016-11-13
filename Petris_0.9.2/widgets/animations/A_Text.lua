A_Text = {}
A_Text.__index = A_Text

function A_Text.new(parent, id, duration, x, y, w, h, text, font)
	local animation = Animation.new(parent,	id,	duration, 	x,	y)
	setmetatable(animation, A_Text)	
	
		animation.font = font or parent.font
		animation.w = assert(w,	"No width was given to element: " .. id)
		animation.h = assert(h,	"No height was given to element: " .. id)
		animation.text = text or id
		
		animation.textW = w-2*parent.margin
		local _, lines = animation.font:getWrap(animation.text, animation.textW)
		animation.textX = x + parent.margin
		animation.textY = y + (h - animation.font:getHeight()*lines) / 2
		
		animation.textColor = {255,0,0,255}
		animation.adjustment = 5
	return animation
end

function A_Text:draw()
	love.graphics.setColor(self.textColor)
	love.graphics.setFont(self.font)
	love.graphics.printf(self.text,self.textX,self.textY,self.textW,"center")
end
--- RED  255-0-0
--- ORANGE 255-69-0
--- YELLOW 	255-165-0
function A_Text:update(dt)
	self.t = self.t + dt
	self.textColor[2] = self.textColor[2] + self.adjustment
	if self.textColor[2] <= 0 or self.textColor[2] >= 165 then
		self.adjustment = self.adjustment*-1
	end	
	if self.t >= self.duration then self.parent:remove(self.id) end
end

function A_Text:isHovered(mouseX,mouseY)
		return Animation.isHovered(self,mouseX,mouseY)
end
	
