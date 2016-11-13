B_UnderLinedText = {}
B_UnderLinedText.__index = B_UnderLinedText

function B_UnderLinedText.new(parent, id, x, y, w, h, text, font)
	local button = B_Text.new(parent, id, x, y, w, h, text, font)
	setmetatable(button, B_UnderLinedText)
		button:refresh(text or id)
		
	return button
end

function B_UnderLinedText:draw()
	B_Text.draw(self)
	love.graphics.line(self.underlineX,self.underlineY,self.underlineX + self.underlineL,self.underlineY)
end

function B_UnderLinedText:update(dt)
	if self.parent.hoveredID == self.id then
		if self.parent.isDown then	self.color.active = self.color.clicked
		else self.color.active = self.color.hovered
		end
	else
		self.color.active = self.color.default
	end
end

function B_UnderLinedText:refresh(text, letter)
	local _, lines = self.font:getWrap(text,self.w-2*self.parent.margin)
	
	B_Text.refresh(self, text)
	local mString = ''
	if letter then
		 mString = '(%a+)' .. letter 
	end
	self.underlineX = self.x + (self.w - self.font:getWidth(text)) /2 + self.font:getWidth(string.match(text, mString)) or 0
	self.underlineY = self.textY + 	self.font:getBaseline() + 3
	self.underlineL = self.font:getWidth(letter or string.match(text,'(%a)')) - 1
end

function B_UnderLinedText:isHovered(mouseX,mouseY)
	return B_Text.isHovered(self, mouseX,mouseY)
end
	
function B_UnderLinedText:resetColor()
	B_Text.resetColor(self)
end
