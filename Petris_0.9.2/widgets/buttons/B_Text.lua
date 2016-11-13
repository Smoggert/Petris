B_Text = {}
B_Text.__index = B_Text

function B_Text.new(parent, id, x, y, w, h, text, font)
	local button = Button.new(parent,id,x,y)
	setmetatable(button, B_Text)
	
		button.font = font or parent.font
		button.w = assert(w,	"No width was given to element: " .. id)
		button.h = assert(h,	"No height was given to element: " .. id)			
		button.text = text or id
		
		button.textW = w-2*parent.margin
		local _, lines = button.font:getWrap(button.text,w-2*parent.margin)
		button.textX = x + parent.margin
		button.textY = y + (h - button.font:getHeight()*lines) / 2

		
	return button
end

function B_Text:draw()
	love.graphics.setColor(self.color.active)
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h,15)
	love.graphics.setColor(self.color.line)
		love.graphics.setFont(self.parent.font)
	love.graphics.printf(self.text,self.textX,self.textY,self.textW,"center")
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
	self.text = text
end

function B_Text:isHovered(mouseX,mouseY)
	--  x and y inbetween sides of rect
	return mouseX <= self.x + self.w and mouseX >= self.x and mouseY <= self.y + self.h and mouseY >= self.y
end
	
function B_Text:resetColor()
	Button.resetColor(self)
end
