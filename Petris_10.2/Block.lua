Block = {}
Block.__index = Block

Block.typeParts = {
	[1] = { 
				[1] = 	{	-1,-1,
							0,-1,
							0,0,
							-1,0,
							center = {-0.5,-0.5}
							},
						
				[2] =	{	0,-1,
							1,-1,
							1,0,
							0,0,
							center = {0.5,-0.5}},
						
				[3] =	{	-1,0,
							0,0,
							0,1,
							-1,1,
							center = {-0.5,0.5}	},
						
				[4] =	{	0,0,
							1,0,
							1,1,
							0,1,
							center = {0.5,0.5}	},
				center = {0,0}	},				
	[2] = { 	
				[1] = 	{	0,-1,
							1,-1,
							1,0,
							0,0,	
							center = {0.5,-0.5}},
						
				[2] =	{	-1,0,
							0,0,
							0,1,
							-1,1,	
							center = {-0.5,0.5}},
						
				[3] =	{	0,0,
							1,0,
							1,1,
							0,1,	
							center = {0.5,0.5}},
						
				[4] =	{	1,0,
							2,0,
							2,1,
							1,1	,	
							center = {1.5,0.5}},
				center = {0.5,0.5}	},
	[3] = { 
				[1] = 	{	-1,-1,
							0,-1,
							0,0,
							-1,0,	
							center = {-0.5,-0.5}},
						
				[2] =	{	-1,0,
							0,0,
							0,1,
							-1,1,	
							center = {-0.5,0.5}},
						
				[3] =	{	0,0,
							1,0,
							1,1,
							0,1,	
							center = {0.5,0.5}},
						
				[4] =	{	1,0,
							2,0,
							2,1,
							1,1	,	
							center = {1.5,0.5}},
				center = {0.5,0.5}	},
	[4] = { 
				[1] = 	{	1,-1,
							2,-1,
							2,0,
							1,0	,	
							center = {1.5,-0.5}},
						
				[2] =	{	-1,0,
							0,0,
							0,1,
							-1,1,	
							center = {-0.5,0.5}},
						
				[3] =	{	0,0,
							1,0,
							1,1,
							0,1,	
							center = {0.5,0.5}},
						
				[4] =	{	1,0,
							2,0,
							2,1,
							1,1	,	
							center = {1.5,0.5}},
				center = {0.5,0.5}	},			
	[5] = { 
				[1] = 	{	-1,-1,
							0,-1,
							0,0,
							-1,0,	
							center = {-0.5,-0.5}},
						
				[2] =	{	0,-1,
							1,-1,
							1,0,
							0,0	,	
							center = {0.5,-0.5}},
						
				[3] =	{	0,0,
							1,0,
							1,1,
							0,1	,	
							center = {0.5,0.5}},
						
				[4] =	{	1,0,
							2,0,
							2,1,
							1,1	,	
							center = {1.5,0.5}},
				center = {0.5,0.5}	},				
	[6] = { 
				[1] =	{	0,-1,
							1,-1,
							1,0,
							0,0	,	
							center = {0.5,-0.5}},
							
				[2] = 	{	1,-1,
							2,-1,
							2,0,
							1,0	,	
							center = {1.5,-0.5}},
						
				[3] =	{	-1,0,
							0,0,
							0,1,
							-1,1,	
							center = {-0.5,0.5}},
						
				[4] =	{	0,0,
							1,0,
							1,1,
							0,1,	
							center = {0.5,0.5}},
				center = {0.5,0.5}	},			
	[7] = { 
				[1] = 	{	-2,0,
							-1,0,
							-1,1,
							-2,1,	
							center = {-1.5,0.5}},
				[2] = 	{	-1,0,
							0,0,
							0,1,
							-1,1,	
							center = {-0.5,0.5}},
				[3] = 	{	0,0,
							1,0,
							1,1,
							0,1	,	
							center = {0.5,0.5}},
				[4] = 	{	1,0,
							2,0,
							2,1,
							1,1	,	
							center = {1.5,0.5}},	
				center = {0,0}	},	
				
	[8] = { 
				[1] = 	{	-1,-2,
							-1,-1,
							-2,-1,
							-2,-2,	
							center = {-1.5,-1.5}},
				[2] = 	{	-1,-1,
							0,-1,
							0,0,
							-1,0,	
							center = {-0.5,-0.5}},
				[3] = 	{	0,1,
							1,1,
							1,0,
							0,0,	
							center = {0.5,0.5}},
				[4] = 	{	2,1,
							2,2,
							1,2,
							1,1,	
							center = {1.5,1.5}},	
				center = {0,0}	},
	n = 7
				}
	Block.typeParts.squareBlock = Block.typeParts[1]
	Block.typeParts.tBlock = Block.typeParts[2]
	Block.typeParts.leftLBlock = Block.typeParts[3]
	Block.typeParts.rightLBlock = Block.typeParts[4]
	Block.typeParts.leftZBlock = Block.typeParts[5]
	Block.typeParts.rightZBlock = Block.typeParts[6]
	Block.typeParts.longBlock = Block.typeParts[7]
	Block.typeParts.diaBlock = Block.typeParts[8]

							
							
function Block.new(typeName, rotation, gameSettings)
	local block = {
					typeName = assert(typeName,	"No block-type name or integer was given to new block. "),
					rotation = assert(rotation,	"No rotation value was given for block: " .. typeName),
					gameSettings = assert(gameSettings,"No settings were passed down for block: " .. typeName),
					parts = {}   						-- Every block consists of: 4 parts (4 corners, 1 center)
														-- 							1 block-center for rotation and rendering
	}
	setmetatable(block, Block)
	block.parts.center = {
							[1] = 	( block.typeParts[block.typeName].center[1] + gameSettings.spawnX ) * gameSettings.size,
							[2] =	( block.typeParts[block.typeName].center[2] + gameSettings.spawnY ) * gameSettings.size
						}
	for i=1,4,1 do
		block.parts[i] = {}
		for j=1,7,2 do
			block.parts[i][j] = 	( block.typeParts[block.typeName][i][j] + gameSettings.spawnX 	 ) * gameSettings.size
			block.parts[i][j+1] = 	( block.typeParts[block.typeName][i][j+1] + gameSettings.spawnY	 ) * gameSettings.size
		end	
		block.parts[i].center = {
							[1] = 	( block.typeParts[block.typeName][i].center[1] + gameSettings.spawnX ) * gameSettings.size,
							[2] =	( block.typeParts[block.typeName][i].center[2] + gameSettings.spawnY ) * gameSettings.size
						}
	end
	while rotation > 0 do
		block:rotate()
		rotation = rotation - 1
	end
		
	return block
end

function Block.newDummy(typeName, rotation, drawX, drawY, size)
	local block = Block.new(typeName, rotation, {spawnX = drawX, spawnY = drawY, size = size, shapes = { n = 0}, fieldWidth = 1000, fieldHeight = 1000})
	return block	
end

function Block.newRandom(gameSettings)
	local rotation = love.math.random(0,3)
	local blockType = love.math.random(1,Block.typeParts.n)
	local block = Block.new(blockType, rotation, gameSettings)
	return block
end

function Block.newDummyRandom(drawX, drawY, size)
	local rotation = love.math.random(0,3)
	local blockType = love.math.random(1,Block.typeParts.n)
	local block = Block.new(blockType, rotation, {spawnX = drawX, spawnY = drawY, size = size, shapes = { n = 0}, fieldWidth = 1000, fieldHeight = 1000})
	return block
end

function Block:checkCollision(blockPart)
	if self.gameSettings.shapes.n == 0 then
		return false
	end
	for i=1,self.gameSettings.shapes.n,1 do
		if self.gameSettings.shapes[i].center[1] == blockPart.center[1] and self.gameSettings.shapes[i].center[2] == blockPart.center[2] then
			return true
		end
	end
	return false
end

function Block:translate(dx,dy,ghost)
	local temp = {}
	temp.center = self.parts.center
	for i=1,4,1 do
		temp[i] = { center = {}}
		temp[i].center[1] = self.parts[i].center[1] + dx*self.gameSettings.size 
		temp[i].center[2] = self.parts[i].center[2] + dy*self.gameSettings.size
		for j=1,7,2 do
			temp[i][j] = self.parts[i][j] + dx*self.gameSettings.size
			temp[i][j+1] = self.parts[i][j+1] + dy*self.gameSettings.size
			if temp[i][j] > self.gameSettings.fieldWidth * self.gameSettings.size or temp[i][j] < 0 or temp[i][j+1] > self.gameSettings.fieldHeight * self.gameSettings.size then
				if not ghost then return false end
			end
		end
		if self:checkCollision(temp[i]) then
			if not ghost then return false end
		end
	end
	self.parts = temp
	self.parts.center[1] = self.parts.center[1] + dx*self.gameSettings.size
	self.parts.center[2] = self.parts.center[2] + dy*self.gameSettings.size
	return true
end

function Block:rotate(direction)
	local d = -1
	if direction == "clockwise" then
		d = 1
	end
	local temp = { }
	temp.center = self.parts.center
		for i=1,4,1 do
			temp[i] = {center = {}}
			temp[i].center[1] =  -d*(self.parts[i].center[2] - self.parts.center[2]) 	+ self.parts.center[1] 
			temp[i].center[2] =  d *(self.parts[i].center[1] - self.parts.center[1])	+ self.parts.center[2]
				
			for j=1,7,2 do
				temp[i][j]  	= -d*	(	self.parts[i][j+1] - 	self.parts.center[2]) 	+ self.parts.center[1] 
				temp[i][j+1] 	= d*	(   self.parts[i][j] - 		self.parts.center[1]) 	+ self.parts.center[2]
				if temp[i][j] > self.gameSettings.fieldWidth * self.gameSettings.size or temp[i][j] < 0 or temp[i][j+1] > self.gameSettings.fieldHeight * self.gameSettings.size then
					return false
				end
			end
			if self:checkCollision(temp[i]) then
				return false
			end			
		end
		self.parts = temp
		return true
end

function Block:pushDown()
	while self:translate(0,1) do	end
	return true
end

function Block:draw()
	for i=1,4,1 do
		love.graphics.setColor(175+i*20,10+i*10,55,220)
		love.graphics.polygon("fill",self.parts[i])
	end
	love.graphics.setColor(0,0,0,255)
	for i=1,4,1 do
		love.graphics.setLineWidth(4)
		love.graphics.polygon("line",self.parts[i])
	end
	love.graphics.setLineWidth(2)
end
