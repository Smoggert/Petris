A = {}
A.__index = A

function A.new(parent, id, duration, x, y)
	local animation = {
					parent = assert(parent,	"No parent was given to element: " .. id),
					id = assert(id,	"No id-value was given to element: ... yeh go figure u didn't give an id so what am I supposed to write here" ),
					duration = assert(duration,	"No duration was given to element: " .. id),
					x = assert(x,	"No x-value was given to element: " .. id),
					y = assert(y,	"No y-value was given to element: " .. id),
					t = 0
	}	
	setmetatable(animation, A)	
	return animation
end

function A:draw()
	-- draw function
end

function A:update(dt)
	self.t = self.t + dt
	if self.t >= self.duration then self.parent:remove(self.id) end
end

function A:isHovered(mouseX,mouseY)
	return false
end

Animation = A
	
