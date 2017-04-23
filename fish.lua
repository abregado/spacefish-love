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
		arms = 1,
		legs = 1,
		tail = 1,
		cap = 1		
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
	f.canvas = lg.newCanvas(2048*2,2048*2)
	f.color = {255,255,255}
	f.scale = 0.15
	--methods
	f.move = fish.move
	f.teleport = fish.teleport
	fish.render(f)
	return f
end

function fish.randomize(self)
	self.parts.arms = math.random(1,#assets.monster.arms)
	self.parts.legs = math.random(1,#assets.monster.legs)
	self.parts.tail = math.random(1,#assets.monster.tail)
	self.parts.cap = 1
	for i, part in pairs(self.detail) do
		if math.random(1,6) >= 5 then
			self.detail[i] = true
		else
			self.detail[i] = false
		end
	end
	if math.random(1,10) > 3 then
		self.color = {math.random(0,255),math.random(0,255),math.random(0,255)}
	else
		self.color = nil
	end
	fish.render(self)
end

function fish.move(self,vector)
	self.pos.x = self.pos.x + vector.x 
	self.pos.y = self.pos.y + vector.y 
end

function fish.teleport(self,pos)
	self.pos = pos
end

function fish.drawPart(self,part,flip)
	local poff = {x= part_offsets[part].x, y = part_offsets[part].y }
	if flip then
		poff = {x= part_offsets[part].x , y= part_offsets[part].y * -1 }	
	end
	
	local vflip = 1 
	local hflip = 1 
	if flip then vflip = -1  end
	
	if self.parts[part] > 0 then
		--draw background
		lg.setBlendMode("alpha")
		lg.setColor(255,255,255)
		local background = assets.monster[part][self.parts[part]][1]
		local ox,oy = background:getWidth()/2, background:getHeight()/2
		lg.draw(background,self.pos.x + poff.x,self.pos.y + poff.y,0,hflip,vflip,ox,oy)
		
		if self.color then
			--draw color layer (2)
			local colorlayer = assets.monster[part][self.parts[part]][3]
			lg.setBlendMode("add")
			lg.setColor(self.color)
			lg.draw(colorlayer,self.pos.x + poff.x,self.pos.y + poff.y,0,hflip,vflip,ox,oy)
			lg.draw(colorlayer,self.pos.x + poff.x,self.pos.y + poff.y,0,hflip,vflip,ox,oy)
		end
		
		lg.setBlendMode("alpha")
		local outline = assets.monster[part][self.parts[part]][2]
		lg.setColor(colors.outline)
		lg.draw(outline,self.pos.x + poff.x,self.pos.y + poff.y,0,hflip,vflip,ox,oy)
		
		if self.detail[part] == true then
			--draw detail layer (4)
			lg.setBlendMode("alpha")
			local detail = assets.monster[part][self.parts[part]][4]
			lg.setColor(255,255,255)
			lg.draw(detail,self.pos.x + poff.x,self.pos.y + poff.y,0,hflip,vflip,ox,oy)
		
		end
	end
end

function fish.drawPartInPlace(self,part,flip)
	local fixedoff = 2048
	local poff = {x= part_offsets[part].x + fixedoff, y = part_offsets[part].y  + fixedoff}
	if flip then
		poff = {x= part_offsets[part].x + fixedoff , y= part_offsets[part].y * -1  + fixedoff}	
	end
	
	local vflip = 1 
	local hflip = 1 
	if flip then vflip = -1  end
	
	if self.parts[part] > 0 then
		--draw background
		lg.setBlendMode("alpha")
		lg.setColor(255,255,255)
		local background = assets.monster[part][self.parts[part]][1]
		local ox,oy = background:getWidth()/2, background:getHeight()/2
		lg.draw(background,poff.x,poff.y,0,hflip,vflip,ox,oy)
		
		if self.color then
			--draw color layer (2)
			local colorlayer = assets.monster[part][self.parts[part]][3]
			lg.setBlendMode("add")
			lg.setColor(self.color)
			lg.draw(colorlayer,poff.x,poff.y,0,hflip,vflip,ox,oy)
			lg.draw(colorlayer,poff.x,poff.y,0,hflip,vflip,ox,oy)
		end
		
		lg.setBlendMode("alpha")
		local outline = assets.monster[part][self.parts[part]][2]
		lg.setColor(colors.outline)
		lg.draw(outline,poff.x,poff.y,0,hflip,vflip,ox,oy)
		
		if self.detail[part] then
			--draw detail layer (4)
			local detail = assets.monster[part][self.parts[part]][4]
			lg.setColor(125,125,125)
			lg.draw(detail,poff.x,poff.y,0,hflip,vflip,ox,oy)
		
		end
	end
end

function fish.render(self)
	lg.setCanvas(self.canvas)
	lg.clear()

	--draw tailsegments
	fish.drawPartInPlace(self,"tail")
	--draw tailcap
	fish.drawPartInPlace(self,"cap")
	--draw arms
	fish.drawPartInPlace(self,"arms")
	fish.drawPartInPlace(self,"arms",true)
	--draw legs
	fish.drawPartInPlace(self,"legs")
	fish.drawPartInPlace(self,"legs",true)
	--draw body
	fish.drawPartInPlace(self,"body")
	--draw head
	fish.drawPartInPlace(self,"head")
	--draw mouth
	fish.drawPartInPlace(self,"mouth")
	--draw eyes
	fish.drawPartInPlace(self,"eyes")

	lg.setCanvas()
	
end

function fish.draw(self)
	lg.draw(self.canvas,self.pos.x,self.pos.y,0,self.scale,self.scale,self.canvas:getWidth()/2,self.canvas:getHeight()/2)
	
end

return fish
