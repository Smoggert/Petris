B = {}
B.__index = B

function B.new(parent, id, x, y)
	local button = {
					parent = assert(parent,	"No parent was given to element: " .. id),
					id = assert(id,	"No id-value was given to element: ... yeh go figure you didn't give an id so what am I supposed to write here" ),
					x = assert(x,	"No x-value was given to element: " .. id),
					y = assert(y,	"No y-value was given to element: " .. id),
					
	}
	setmetatable(button, B)
	button:resetColor()
	return button
end

function B:draw()
	-- draw function
end

function B:update()
	if self.parent.hoveredID == self.id then
		if self.parent.isDown then	self.color.active = self.color.clicked
		else self.color.active = self.color.hovered
		end
	else
		self.color.active = self.color.default
	end
end

function B:isHovered(mouseX,mouseY)
	-- hitbox logic
end

function B:resetColor()
	self.color = { 	hovered = {235,165,61,255}, 
					default = {75,75,75,255},
					clicked = {0,0,0},
					line = {255,255,255,255},
					active = {75,75,75,255}
					}
end

Button = B
