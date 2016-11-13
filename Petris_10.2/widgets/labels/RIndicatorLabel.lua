RIndicator = {}
RIndicator.__index = RIndicator

function RIndicator.new(parent, id, x, y, w, h, value, max)
	local button = Button.new(parent,id,x,y)
		button.w = assert(w,	"No width was given to button: " .. id)
		button.h = assert(h,	"No height was given to button: " .. id)
		button.value = assert(h,	"No value was given to button: " .. id)
		button.max = assert(h,	"No max was given to button: " .. id)
	setmetatable(button, RIndicator)	
	return button
end

function RIndicator:draw()
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
	love.graphics.setColor(self.color.default)
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
	love.graphics.setColor(self.color.line)
	love.graphics.setLineWidth(4)
	love.graphics.rectangle("line",self.x,self.y,self.w,self.h)
	love.graphics.setLineWidth(2)
end

function RIndicator:update()
	if self.parent.hoveredID == self.id then
		if self.parent.isDown then	self.color.active = self.color.clicked
		else self.color.active = self.color.hovered
		end
	else
		self.color.active = self.color.default
	end
end

function RIndicator:refresh(value, max)
	button.value = value
	button.max = max or button.max
end

function RIndicator:isHovered(mouseX,mouseY)
	--  x and y inbetween sides of rect
	return mouseX <= self.x + self.w and mouseX >= self.x and mouseY <= self.y + self.h and mouseY >= self.y
end
	
