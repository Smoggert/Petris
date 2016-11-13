ButtonManager = {}
ButtonManager.__index = ButtonManager

function ButtonManager.new()
	local buttonManager = {
							buttons = { n = 0 },
							events = { hovered = {}, clicked = {}, dragged = {} },
							mouseX = 0,
							mouseY = 0,
							isDown = false,
							clicked = false,
							hoveredID = nil,
							clickedOnID = nil,
							font = love.graphics.newFont(18),
							margin = 0
	}
	setmetatable(buttonManager, ButtonManager)
	--- LOAD ALL WIDGETS
	
	local mainFolder = "/widgets"
	local folders = love.filesystem.getDirectoryItems(mainFolder)
	for k,folder in pairs(folders) do
		if love.filesystem.isDirectory(mainFolder .. '/' .. folder) then
			local files = love.filesystem.getDirectoryItems(mainFolder .. '/' .. folder)
				for l,file in pairs(files) do
					local fileName = string.match(file,"(%a_%a+)") or string.match(file,"(%a+)")
					require(("widgets.%s.%s"):format(folder,fileName))
				end
		end

	end
	return buttonManager
end

function ButtonManager:newButton(button)
	self.buttons.n = self.buttons.n + 1
	self.buttons[self.buttons.n] = button
end


function ButtonManager:addEvent(id, fctn, state)
	if state == "hovered" then
		self.events.hovered[id] = fctn
	elseif state == "dragged" then
		self.events.dragged[id] = fctn
	else
		self.events.clicked[id] = fctn
	end
end

function ButtonManager:moveToTop(id)
	for i,v in ipairs(self.buttons) do
		if v.id == id then
			table.remove(self.buttons, i)
			table.insert(self.buttons, v)
			break
		end
	end
end

function ButtonManager:moveToBottom(id)
	for i,v in ipairs(self.buttons) do
		if v.id == id then
			table.remove(self.buttons, i)
			table.insert(self.buttons, 1, v)
			break
		end
	end
end

function ButtonManager:remove(id)
	for i,v in ipairs(self.buttons) do
		if v.id == id then
			table.remove(self.buttons,i)
			self.buttons.n = self.buttons.n - 1
			break
		end
	end
end

function ButtonManager:removeEvent(id, state)
	if state == "hovered" then
		self.events.hovered[id] = nil
	elseif state == "dragged" then
		self.events.dragged[id] = nil
	else
		self.events.clicked[id] = nil
	end
end

function ButtonManager:isHovered(hX,hY)
	for i = self.buttons.n, 1 , -1 do 
		if self.buttons[i]:isHovered(hX,hY) then
			self.hoveredID =  self.buttons[i].id
			return true
		end		
	end 
	self.hoveredID = nil
	return false
end

function ButtonManager:setClickedOnID()

	for i = self.buttons.n, 1 , -1 do 
		if self.buttons[i]:isHovered(self.mouseX,self.mouseY) then
			self.clickedOnID =  self.buttons[i].id
			break
		else
			self.clickedOnID = nil
		end
	end 
	
end

function ButtonManager:getButton(id)
	for i,v in ipairs(self.buttons) do
		if v.id == id then return v end
	end
	return error("No button with id:" .. id)
end

function ButtonManager:update(dt,mX,mY,isDown)
	if not self.isDown and isDown then self:setClickedOnID() end
	self.clicked = self.isDown and not isDown
	self.dragged = self.isDown and isDown
	if self.dragged then
			if self.events.dragged[self.clickedOnID] then self.events.dragged[self.clickedOnID](mX - self.mouseX, mY - self.mouseY) end
	end	
	if self:isHovered(mX,mY) then
		if self.clicked and self.hoveredID == self.clickedOnID then
			if self.events.clicked[self.hoveredID] then self.events.clicked[self.hoveredID](self) end
		elseif not isDown then
			if self.events.hovered[self.hoveredID] then self.events.hovered[self.hoveredID](self) end
		end
	end
	
	self.mouseX, self.mouseY, self.isDown = mX, mY, isDown
	
	for i = self.buttons.n, 1 , -1 do
		self.buttons[i]:update(dt)
	end

end

function ButtonManager:draw()
	for i = 1, self.buttons.n , 1 do 
		self.buttons[i]:draw()
	end 
end

