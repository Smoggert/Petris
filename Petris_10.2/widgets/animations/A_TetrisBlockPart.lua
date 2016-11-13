A_TetrisBlockPart = {}
A_TetrisBlockPart.__index = A_TetrisBlockPart

function A_TetrisBlockPart.new(parent, id, duration, coords)
	local animation = Animation.new(parent,id, duration,coords.center[1],coords.center[2])
	setmetatable(animation, A_TetrisBlockPart)	
	
	animation.coords = {	coords[1],coords[2],
							coords[3],coords[4],
							coords[5],coords[6],
							coords[7],coords[8],
							center = coords.center					
						}
	animation.color = {255,60*love.math.random(0,4),15,125}
	
	return animation
end

function A_TetrisBlockPart.spreadCoords(coords, dt)
	local c = coords
	for i=1,7,2 do
		c[i] = (c[i] - c.center[1])*(1+dt) + c.center[1]
		c[i+1]=(c[i+1] - c.center[2])*(1+dt) + c.center[2]
	end
	return c
end

function A_TetrisBlockPart:draw()
	love.graphics.setColor(self.color)
	local lw = love.graphics.getLineWidth()
	love.graphics.setLineWidth( 30 )
	love.graphics.polygon("line",self.coords)
	love.graphics.setLineWidth(lw)
end

function A_TetrisBlockPart:update(dt)
	self.t = self.t + dt
	self.color[4] = math.max(0,self.color[4]-dt*100)
	self.coords = self.spreadCoords(self.coords, dt)
	if self.t >= self.duration then self.parent:remove(self.id) end
end
	
function A_TetrisBlockPart:isHovered(mouseX,mouseY)
	return Animation.isHovered(self,mouseX,mouseY)
end