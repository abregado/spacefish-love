local fish = {}

function fish.new()
	local f = {}
	--properties
	f.pos = {x=0,y=0}
	f.parts = {
		body = 1,
		head = 1,
		eyes = 1,
		mouth = 1,
		arms = 0,
		legs = 0,
		tail = 1,
		cap = 0		
		}
	f.detail = {
		body = true,
		head = false,
		eyes = false,
		mouth = false,
		arms = false,
		legs = false,
		tail = false,
		cap = false		
		}
	f.color = {255,0,0}
	--methods
	f.move = fish.move
	f.teleport = fish.teleport
	return f
end

function fish.move(self,vector)
	self.pos.x = self.pos.x + vector.x 
	self.pos.y = self.pos.y + vector.y 
end

function fish.teleport(self,pos)
	self.pos = pos
end

function fish.drawPart(self,part)
	local poff = part_offsets[part]
	
	if self.parts[part] > 0 then
		--draw background
		lg.setBlendMode("alpha")
		lg.setColor(255,255,255)
		local background = assets.monster[part][self.parts[part]][1]
		local ox,oy = background:getWidth()/2, background:getHeight()/2
		lg.draw(background,self.pos.x + poff.x,self.pos.y + poff.y,0,1,1,ox,oy)
		
		if self.color then
			--draw color layer (2)
			local colorlayer = assets.monster[part][self.parts[part]][3]
			lg.setBlendMode("add")
			lg.setColor(self.color)
			lg.draw(colorlayer,self.pos.x + poff.x,self.pos.y + poff.y,0,1,1,ox,oy)
		end
		
		lg.setBlendMode("alpha")
		local outline = assets.monster[part][self.parts[part]][2]
		lg.setColor(colors.outline)
		lg.draw(outline,self.pos.x + poff.x,self.pos.y + poff.y,0,1,1,ox,oy)
		
		if self.detail[part] then
			--draw detail layer (4)
			local detail = assets.monster[part][self.parts[part]][4]
			lg.setColor(125,125,125)
			lg.draw(detail,self.pos.x + poff.x,self.pos.y + poff.y,0,1,1,ox,oy)
		
		end
	end
end

function fish.draw(self)
	
	--draw tailcap
	fish.drawPart(self,"tail")
	--draw arms
	--draw legs
	--draw body
	fish.drawPart(self,"body")
	--draw head
	fish.drawPart(self,"head")
	--draw mouth
	fish.drawPart(self,"mouth")
	--draw eyes
	fish.drawPart(self,"eyes")

	
	
	
end

return fish
