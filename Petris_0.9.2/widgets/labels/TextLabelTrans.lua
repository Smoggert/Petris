TextLabelTrans = {}
TextLabelTrans.__index = TextLabelTrans

function TextLabelTrans.new(parent, id, x, y, w, h, text)
	local button = Button.new(parent,id,x,y)
	setmetatable(button, TextLabelTrans)
	
		button.w = assert(w,	"No width was given to button: " .. id)
		button.h = assert(h,	"No height was given to button: " .. id)
		button.text = text or id
		
		button.textW = w-2*parent.margin
		local _, lines = parent.font:getWrap(button.text,button.textW)
		button.textX = x + parent.margin
		button.textY = y + parent.margin
		return button
end

function TextLabelTrans:draw()
	love.graphics.setColor(self.color.default)
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h,5)
	love.graphics.setColor(self.color.line)
	love.graphics.setFont(self.parent.font)
	love.graphics.printf(self.text,self.textX,self.textY,self.textW,"center")
end

function TextLabelTrans:update(dt)
end

function TextLabelTrans:refresh(text)
	self.text = text
end

function TextLabelTrans:isHovered(mouseX,mouseY)
	return false
end
	
