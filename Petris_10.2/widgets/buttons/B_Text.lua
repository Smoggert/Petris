B_Text = {}
B_Text.__index = B_Text

function B_Text.new(parent, id, x, y, w, h, text, font)
	local button = Button.new(parent,id,x,y)
	setmetatable(button, B_Text)
	
		button.font = font or parent.font
		button.w = assert(w,	"No width was given to element: " .. id)
		button.h = assert(h,	"No height was given to element: " .. id)
		
		local _, lines = button.font:getWrap(text,w-2*parent.margin)
		button.textX = x+parent.margin
		button.textY = y + (h - button.font:getHeight()*table.getn(lines)) / 2
		
		button.text = love.graphics.newText(parent.font)
		button:refresh(text or id)
		
	return button
end

function B_Text:draw()
	love.graphics.setColor(self.color.active)
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h,15)
	love.graphics.setColor(self.color.line)
	love.graphics.draw(self.text,self.textX,self.textY)
	love.graphics.rectangle("line",self.x,self.y,self.w,self.h,15)
end

function B_Text:update(dt)
	if self.parent.hoveredID == self.id then
		if self.parent.isDown then	self.color.active = self.color.clicked
		else self.color.active = self.color.hovered
		end
	else
		self.color.active = self.color.default
	end
end

function B_Text:refresh(text, letter)
	self.text:clear()
	self.text:addf(text or self.id,self.w-2*self.parent.margin,"center")
end

function B_Text:isHovered(mouseX,mouseY)
	--  x and y inbetween sides of rect
	assert(mouseX,"Mouse X is nil: " .. self.id)
	assert(mouseY,"Mouse Y is nil: " .. self.id)
	return mouseX <= self.x + self.w and mouseX >= self.x and mouseY <= self.y + self.h and mouseY >= self.y
end
	
function B_Text:resetColor()
	Button.resetColor(self)
end
