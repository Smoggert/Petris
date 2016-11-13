B_Triangle = {}
B_Triangle.__index = B_Triangle

function B_Triangle.new(parent, id, x, y, w, h, direction)
	local button = Button.new(parent,id,x,y)
	setmetatable(button, B_Triangle)
		button.w = assert(w,	"No width was given to button: " .. id)
		button.h = assert(h,	"No height was given to button: " .. id)
		button.direction = direction or "up"
		button.coords = button:setCoords()
	return button
end

function B_Triangle:draw()
	love.graphics.setColor(self.color.active)
	love.graphics.polygon("fill",self.coords)
	love.graphics.setColor(self.color.line)
	love.graphics.polygon("line",self.coords)
end

function B_Triangle:update()
	if self.parent.hoveredID == self.id then
		if self.parent.isDown then	self.color.active = self.color.clicked
		else self.color.active = self.color.hovered
		end
	else
		self.color.active = self.color.default
	end
end

function B_Triangle:isHovered(mouseX,mouseY)
	if self.direction == "down" then
		if mouseX >= self.x and mouseX <= self.x + self.w /2 and mouseY >= self.y and mouseY <= self.y + 2*self.h / self.w * (mouseX-self.x) then
			return true
		elseif mouseX >= self.x + self.w/2 and mouseX <= self.x + self.w and mouseY >= self.y and mouseY <= self.y + 2*self.h - 2*self.h / self.w * (mouseX-self.x) then
			return true
		end
	else
		if mouseX >= self.x and mouseX <= self.x + self.w /2 and mouseY >= self.y + self.h - 2*self.h / self.w * (mouseX-self.x) and mouseY <= self.y + self.h then
			return true
		elseif mouseX >= self.x + self.w/2 and mouseX <= self.x + self.w and mouseY >= self.y - self.h + 2*self.h / self.w * (mouseX-self.x) and mouseY <= self.y + self.h then
			return true
		end
	end
		return false
end

function B_Triangle:setCoords()
	if self.direction == "down" then
		return { 	self.x, self.y,
					self.x + self.w, self.y,
					self.x + self.w/2, self.y + self.h
					}
	--elseif self.direction == "right" then
	--	return { 	self.x, self.y,
	--				self.x + self.w, self.y + self.h/2,
	--				self.x , self.y + self.h
	--				}
	--elseif self.direction == "left" then
	--	return { 	self.x, self.y + self.h/2,
	--				self.x + self.w, self.y ,
	--				self.x + self.w, self.y + self.h
	--				}
	else
		return { 	self.x + self.w/2, self.y,
					self.x , self.y + self.h,
					self.x + self.w, self.y + self.h
					}
	end
end
	
