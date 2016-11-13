A_TetrisBlock = {}
A_TetrisBlock.__index = A_TetrisBlock

function A_TetrisBlock.new(parent, id, duration, block)
	local animation = Animation.new(parent,id, duration ,block.parts.center[1],block.parts.center[2])
	setmetatable(animation, A_TetrisBlock)	
	animation.block	 = assert(block,"No block value was passed down to animation")		
	return animation
end

function A_TetrisBlock:draw()
	self.block:draw()
end

function A_TetrisBlock:update(dt)
	self.t = self.t + dt
	self.block:translate(0,dt*self.duration,true)
	if self.t >= self.duration then self.parent:remove(self.id) end
end
	
function A_TetrisBlock:isHovered(mouseX,mouseY)
	return Animation.isHovered(self,mouseX,mouseY)
end