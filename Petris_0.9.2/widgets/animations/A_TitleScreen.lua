require 'Block'

A_TitleScreen = {}
A_TitleScreen.__index = A_TitleScreen

function A_TitleScreen.new(parent, id, duration, x , y, size, gameWidth, blockSize)
	local animation = Animation.new(parent, id , duration, x, y)
	setmetatable(animation, A_TitleScreen)	
	
	animation.title	 = {	---- P - 10 pcs
							{x,y,				x+size,y,			x+size,y+size,		x,y+size},
							{x,y+size,			x+size,y+size,		x+size,y+2*size,	x,y+2*size},
							{x,y+2*size,		x+size,y+2*size,	x+size,y+3*size,	x,y+3*size},
							{x,y+3*size,		x+size,y+3*size,	x+size,y+4*size,	x,y+4*size},
							{x,y+4*size,		x+size,y+4*size,	x+size,y+5*size,	x,y+5*size},
							
							{x+size,y,			x+2*size,y,			x+2*size,y+size,	x+size,y+size},
							{x+size,y+2*size,	x+2*size,y+2*size,	x+2*size,y+3*size,	x+size,y+3*size},
							
							{x+2*size,y,		x+3*size,y,			x+3*size,y+size,	x+2*size,y+size},
							{x+2*size,y+size,	x+3*size,y+size,	x+3*size,y+2*size,	x+2*size,y+2*size},
							{x+2*size,y+2*size,	x+3*size,y+2*size,	x+3*size,y+3*size,	x+2*size,y+3*size}, 
							---- E - 11 pcs
							{x+4*size,y,		x+5*size,y,			x+5*size,y+size,	x+4*size,y+size},
							{x+4*size,y+size,	x+5*size,y+size,	x+5*size,y+2*size,	x+4*size,y+2*size},
							{x+4*size,y+2*size,	x+5*size,y+2*size,	x+5*size,y+3*size,	x+4*size,y+3*size},
							{x+4*size,y+3*size,	x+5*size,y+3*size,	x+5*size,y+4*size,	x+4*size,y+4*size},
							{x+4*size,y+4*size,	x+5*size,y+4*size,	x+5*size,y+5*size,	x+4*size,y+5*size},
							
							{x+5*size,y,		x+6*size,y,			x+6*size,y+size,	x+5*size,y+size},
							{x+5*size,y+2*size,	x+6*size,y+2*size,	x+6*size,y+3*size,	x+5*size,y+3*size},
							{x+5*size,y+4*size,	x+6*size,y+4*size,	x+6*size,y+5*size,	x+5*size,y+5*size},
							
							{x+6*size,y,		x+7*size,y,			x+7*size,y+size,	x+6*size,y+size},
							{x+6*size,y+2*size,	x+7*size,y+2*size,	x+7*size,y+3*size,	x+6*size,y+3*size},
							{x+6*size,y+4*size,	x+7*size,y+4*size,	x+7*size,y+5*size,	x+6*size,y+5*size},
							---- T -  7 pcs
							{x+8*size,y,		x+9*size,y,			x+9*size,y+size,	x+8*size,y+size},
							
							{x+9*size,y,		x+10*size,y,		x+10*size,y+size,	x+9*size,y+size},
							{x+9*size,y+size,	x+10*size,y+size,	x+10*size,y+2*size,	x+9*size,y+2*size},
							{x+9*size,y+2*size,	x+10*size,y+2*size,	x+10*size,y+3*size,	x+9*size,y+3*size},
							{x+9*size,y+3*size,	x+10*size,y+3*size,	x+10*size,y+4*size,	x+9*size,y+4*size},
							{x+9*size,y+4*size,	x+10*size,y+4*size,	x+10*size,y+5*size,	x+9*size,y+5*size},
							
							{x+10*size,y,		x+11*size,y,		x+11*size,y+size,	x+10*size,y+size},
							---- R - 12 pcs
							{x+12*size,y,		x+13*size,y,		x+13*size,y+size,	x+12*size,y+size},
							{x+12*size,y+size,	x+13*size,y+size,	x+13*size,y+2*size,	x+12*size,y+2*size},
							{x+12*size,y+2*size,x+13*size,y+2*size,	x+13*size,y+3*size,	x+12*size,y+3*size},
							{x+12*size,y+3*size,x+13*size,y+3*size,	x+13*size,y+4*size,	x+12*size,y+4*size},
							{x+12*size,y+4*size,x+13*size,y+4*size,	x+13*size,y+5*size,	x+12*size,y+5*size},
							
							{x+13*size,y,		x+14*size,y,		x+14*size,y+size,	x+13*size,y+size},
							{x+13*size,y+2*size,x+14*size,y+2*size,	x+14*size,y+3*size,	x+13*size,y+3*size},
							
							{x+14*size,y,		x+15*size,y,		x+15*size,y+size,	x+14*size,y+size},
							{x+14*size,y+size,	x+15*size,y+size,	x+15*size,y+2*size,	x+14*size,y+2*size},
							{x+14*size,y+2*size,x+15*size,y+2*size,	x+15*size,y+3*size,	x+14*size,y+3*size},
						{x+13.5*size,y+3*size,	x+14.5*size,y+3*size,	x+14.5*size,y+4*size,	x+13.5*size,y+4*size},
							{x+14*size,y+4*size,x+15*size,y+4*size,	x+15*size,y+5*size,	x+14*size,y+5*size},
							---- I - 5 pcs 
							{x+16*size,y,		x+17*size,y,		x+17*size,y+size,	x+16*size,y+size},
							{x+16*size,y+size,	x+17*size,y+size,	x+17*size,y+2*size,	x+16*size,y+2*size},
							{x+16*size,y+2*size,x+17*size,y+2*size,	x+17*size,y+3*size,	x+16*size,y+3*size},
							{x+16*size,y+3*size,x+17*size,y+3*size,	x+17*size,y+4*size,	x+16*size,y+4*size},
							{x+16*size,y+4*size,x+17*size,y+4*size,	x+17*size,y+5*size,	x+16*size,y+5*size},
							---- S - 11 pcs
							{x+18*size,y,		x+19*size,y,		x+19*size,y+size,	x+18*size,y+size},
							{x+18*size,y+size,	x+19*size,y+size,	x+19*size,y+2*size,	x+18*size,y+2*size},
							{x+18*size,y+2*size,x+19*size,y+2*size,	x+19*size,y+3*size,	x+18*size,y+3*size},
							{x+18*size,y+4*size,x+19*size,y+4*size,	x+19*size,y+5*size,	x+18*size,y+5*size},
							
							{x+19*size,y,		x+20*size,y,		x+20*size,y+size,	x+19*size,y+size},
							{x+19*size,y+2*size,x+20*size,y+2*size,	x+20*size,y+3*size,	x+19*size,y+3*size},
							{x+19*size,y+4*size,x+20*size,y+4*size,	x+20*size,y+5*size,	x+19*size,y+5*size},
							
							{x+20*size,y,		x+21*size,y,		x+21*size,y+size,	x+20*size,y+size},
							{x+20*size,y+2*size,x+21*size,y+2*size,	x+21*size,y+3*size,	x+20*size,y+3*size},
							{x+20*size,y+3*size,x+21*size,y+3*size,	x+21*size,y+4*size,	x+20*size,y+4*size},
							{x+20*size,y+4*size,x+21*size,y+4*size,	x+21*size,y+5*size,	x+20*size,y+5*size},
							n = 56
							}
	animation.color = animation:setColor()
	animation.w = assert(gameWidth, ("Enter a window width for element: %s"):format(id))
	animation.blockSize = assert(blockSize, ("Enter a blockSize for element: %s"):format(id))
	return animation
end

function A_TitleScreen:draw()
	for i=1,self.title.n,1 do
		love.graphics.setColor(self.color[i])
		love.graphics.polygon("fill",self.title[i])
		love.graphics.setLineWidth(4)
		love.graphics.setColor({0,0,0,255})
		love.graphics.polygon("line",self.title[i])
		love.graphics.setLineWidth(2)
	end
end

function A_TitleScreen:setColor()
	local c = {}
	for i=1,self.title.n,1 do
		c[i] = {155+love.math.random(1,5)*20,10+love.math.random(1,5)*10,55,220}
	end
	return c
end
function A_TitleScreen:update(dt)
	self.t = self.t + dt
	if self.t > 0.5 then
		local rand = love.math.random(1,10)
		if  rand > 7 then
			local id = "fallingblock"
			self.parent:newButton(A_TetrisBlock.new(self.parent,id,10,Block.newDummyRandom((love.math.random(3,self.w/self.blockSize)-2),-2,self.blockSize)))
			self.parent:moveToTop(self.id)
			self.t = 0
		end
	end
	--if self.t >= self.duration then self.parent:remove(self.id) end
end
	
function A_TitleScreen:isHovered(mouseX,mouseY)
		return Animation.isHovered(self,mouseX,mouseY)
end