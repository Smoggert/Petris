TextLabel = {}
TextLabel.__index = TextLabel

function TextLabel.new(parent, id, x, y, w, h, text)
	local button = Button.new(parent,id,x,y)
		button.w = assert(w,	"No width was given to button: " .. id)
		button.h = assert(h,	"No height was given to button: " .. id)
		button.text = love.graphics.newText(parent.font)
		button.text:addf(text or id,w-2*parent.margin,"center")
	setmetatable(button, TextLabel)	
		local _, lines = parent.font:getWrap(text,w-2*parent.margin)
		button.textX, button.textY = x+parent.margin, y+h/2-parent.font:getHeight()*table.getn(lines)/2
	return button
end

function TextLabel:draw()
	love.graphics.setColor(self.color.hovered)
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h,5)
	love.graphics.setColor(self.color.line)
	love.graphics.draw(self.text,self.textX,self.textY)
	love.graphics.rectangle("line",self.x,self.y,self.w,self.h,5)
end

function TextLabel:update(dt)
end

function TextLabel:refresh(text)
	self.text:clear()
	self.text:addf(text or self.id,self.w-2*self.parent.margin,"center")
end

function TextLabel:isHovered(mouseX,mouseY)
	--  x and y inbetween sides of rect
	return mouseX <= self.x + self.w and mouseX >= self.x and mouseY <= self.y + self.h and mouseY >= self.y
end
	
