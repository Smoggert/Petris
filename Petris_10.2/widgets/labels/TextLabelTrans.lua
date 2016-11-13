TextLabelTrans = {}
TextLabelTrans.__index = TextLabelTrans

function TextLabelTrans.new(parent, id, x, y, w, h, text)
	local textLabel = Button.new(parent,id,x,y)
	setmetatable(textLabel, TextLabelTrans)	
		textLabel.w = assert(w,	"No width was given to textLabel element: " .. id)
		textLabel.h = assert(h,	"No height was given to textLabel element: " .. id)
		textLabel.text = love.graphics.newText(parent.font)
		textLabel.text:addf(text or id,w-2*parent.margin,"center")
	return textLabel
end

function TextLabelTrans:draw()
		love.graphics.setColor(self.color.default)
		love.graphics.rectangle("fill",self.x,self.y,self.w,self.h,5)
		love.graphics.setColor(self.color.line)
		love.graphics.draw(self.text,self.x+self.parent.margin,self.y+self.parent.margin)
end

function TextLabelTrans:update(dt)
end

function TextLabelTrans:refresh(text)
	self.text:clear()
	self.text:addf(text or self.id,self.w-2*self.parent.margin,"center")
end

function TextLabelTrans:isHovered(mouseX,mouseY)
	return false
end
	
