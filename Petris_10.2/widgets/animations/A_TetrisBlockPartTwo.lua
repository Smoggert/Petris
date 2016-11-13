A_TetrisBlockPartTwo = {}
A_TetrisBlockPartTwo.__index = A_TetrisBlockPartTwo

function A_TetrisBlockPartTwo.new(parent, id, duration, coords)
	local animation = Animation.new(parent,id, duration,coords.center[1],coords.center[2])
	setmetatable(animation, A_TetrisBlockPartTwo)	
	
	animation.xMin = math.min(coords[1],coords[5])
	animation.xMax = math.max(coords[1],coords[5])
	animation.yMin = math.min(coords[2],coords[6])
	animation.yMax = math.max(coords[2],coords[6])
	print(animation.xMin,animation.yMin,"---",animation.xMax,animation.yMax)
	
	animation.color = {255,60*love.math.random(0,4),15,125}
	animation.coords = {	animation.xMin,animation.yMin,
							animation.xMax,animation.yMin,
							animation.xMax,animation.yMax,
							animation.xMin,animation.yMax						
						}
	animation.triangles = animation:getTriangles()
	return animation
end

function A_TetrisBlockPartTwo:getTriangles()
	local t = { n = 0 }
	local randX	= love.math.random(self.xMin,self.xMax)
	local randY = love.math.random(self.yMin,self.yMax)
		for i=2,8,2 do
			t[i/2] = {	self.coords[i-1]	, self.coords[i],
						randX			, 	self.coords[i],
						randX			, 	randY,
						self.coords[i-1]	, randY,
						center = { (self.coords[i-1] + randX)/2, (self.coords[i] + randY)/2}
						}
			for j=1,7,2 do
			end
			t.n = t.n + 1			
		end
	return t
end

function A_TetrisBlockPartTwo.spreadCoords(coords, dt)
	
	for j=1,coords.n,1 do
	for i=1,7,2 do
		coords[j][i] = (coords[j][i] - coords[j].center[1])*(1+dt) + coords[j].center[1]
		coords[j][i+1]=(coords[j][i+1] - coords[j].center[2])*(1+dt) + coords[j].center[2]
	end
	end
end

function A_TetrisBlockPartTwo:draw()
	love.graphics.setColor(self.color)
	local lw = love.graphics.getLineWidth()
	love.graphics.setLineWidth( 2 )
	for i=self.triangles.n,1,-1 do
		love.graphics.polygon("fill",self.triangles[i])
	end
	love.graphics.setLineWidth(lw)
end

function A_TetrisBlockPartTwo:update(dt)
	self.t = self.t + dt
	self.color[4] = math.max(0,self.color[4]-dt*100)
	self.spreadCoords(self.triangles, dt)
	if self.t >= self.duration then self.parent:remove(self.id) end
end
	
function A_TetrisBlockPartTwo:isHovered(mouseX,mouseY)
	return Animation.isHovered(self,mouseX,mouseY)
end