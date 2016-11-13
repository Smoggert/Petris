A_Hex = {}
A_Hex.__index = A_Hex

--- HELPER FUNCTIONS
function A_Hex.calculateCoords(x,y,radius, rotation)
	local c = {			[1] = x, [2] = -radius + y,
						[3] = math.cos(math.pi / 6)*radius + x, [4] = -math.sin(math.pi / 6)*radius + y,
						[5] = math.cos(math.pi / 6)*radius + x, [6] = math.sin(math.pi / 6)*radius + y,
						[7] = x, [8] = radius + y,
						[9] = -math.cos(math.pi / 6)*radius + x, [10] = math.sin(math.pi / 6)*radius + y,
						[11] = -math.cos(math.pi / 6)*radius + x, [12] = -math.sin(math.pi / 6)*radius + y
	}
	A_Hex.rotate(c, x, y,rotation)
	return c	
end

function A_Hex.rotate(coords,x , y, rotation)
	local cosRotDel, sinRotDel = math.cos(rotation), math.sin(rotation)
	for i=1,11,2 do
			local xNew, yNew = (coords[i]-x)*cosRotDel - (coords[i+1]-y)*sinRotDel , (coords[i+1]-y)*cosRotDel + (coords[i]-x)*sinRotDel
			coords[i] = xNew + x
			coords[i+1] = yNew + y
	end
end
--- // HELPER FUNCTIONS

function A_Hex.new(parent, id, duration, x, y, radius, rotation)
	local animation = Animation.new(parent,id, duration,x,y)
	setmetatable(animation, A_Hex)	
	animation.radius = assert(radius,	"No radius was given to element: " .. id)
	animation.rotation = rotation or 0
	animation.coords = animation.calculateCoords(x,y,radius, animation.rotation)
	animation.color = {255,215,15,125}
	return animation
end

function A_Hex:draw()
	love.graphics.setColor(self.color)
	local lw = love.graphics.getLineWidth()
	love.graphics.setLineWidth( 30 )
	love.graphics.polygon("line",self.coords)
	love.graphics.setLineWidth(lw)
end

function A_Hex:update(dt)
	self.t = self.t + dt
	self.color[4] = self.color[4]-dt*100
	self.radius = self.radius *(1+self.t/self.duration/4)
	self.coords = self.calculateCoords(self.x,self.y,self.radius, self.rotation)
	if self.t >= self.duration then print("On hit Animation should be dead now"); self.parent:remove(self.id) end
end
	
function A_Hex:isHovered(mouseX,mouseY)
	return Animation.isHovered(self,mouseX,mouseY)
end