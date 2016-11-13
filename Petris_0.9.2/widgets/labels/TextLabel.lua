TextLabel = {}
TextLabel.__index = TextLabel

function TextLabel.new(parent, id, x, y, w, h, text)
	local button = Button.new(parent,id,x,y)
	setmetatable(button, TextLabel)
	
		button.w = assert(w,	"No width was given to button: " .. id)
		button.h = assert(h,	"No height was given to button: " .. id)
		button.text = text or id
		
		button.textW = w-2*parent.margin
		local _, lines = parent.font:getWrap(button.text,button.textW)
		button.textX = x + parent.margin
		button.textY = y + (h - parent.font:getHeight()*lines) / 2
		return button
end

function TextLabel:draw()
	love.graphics.setColor(self.color.hovered)
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h,5)
	love.graphics.setColor(self.color.line)
	love.graphics.setFont(self.parent.font)
	love.graphics.printf(self.text,self.textX,self.textY,self.textW,"center")
	love.graphics.rectangle("line",self.x,self.y,self.w,self.h,5)
end

function TextLabel:update(dt)
end

function TextLabel:refresh(text)
	self.text = text
end

function TextLabel:isHovered(mouseX,mouseY)
	--  x and y inbetween sides of rect
	return mouseX <= self.x + self.w and mouseX >= self.x and mouseY <= self.y + self.h and mouseY >= self.y
end
	
