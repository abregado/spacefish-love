local fish = {}

function fish.new()
	local f = {}
	--properties
	f.pos = Vector(-100,-100)
	f.parts = {
		body = {style=1,color=nil,outline=nil},
		head = {style=1,color=nil,outline=nil},
		eyes = {style=1,color=nil,outline=nil},
		mouth = {style=1,color=nil,outline=nil},
		arms = {style=1,color=nil,outline=nil},
		legs = {style=1,color=nil,outline=nil},
		tail = {style=1,color=nil,outline=nil},
		cap = {style=1,color=nil,outline=nil}		
		}
	f.detail = {
		body = false,
		head = false,
		eyes = false,
		mouth = false,
		arms = false,
		legs = false,
		tail = false,
		cap = false		
		}
	f.canvas = lg.newCanvas(2048*2,2048*2)
	f.nextcanvas = nil
	f.fade = 0
	f.color = {255,255,255}
	f.scale = 0.15
	f.vector = Vector(0,0)
	f.lookingVector = Vector(1,0)
	f.wantedVector = Vector(0,1)
	f.locked = {
		body = nil,
		dx = 0,
		dy = 0
		}
	--methods
	f.move = fish.move
	f.teleport = fish.teleport
	fish.render(f)
	return f
end

function fish.randomize(self)
	self.parts.arms.style = math.random(1,#assets.monster.arms)
	self.parts.body.style = math.random(1,#assets.monster.body)
	self.parts.eyes.style = math.random(1,#assets.monster.eyes)
	self.parts.legs.style = math.random(1,#assets.monster.legs)
	self.parts.tail.style = math.random(1,#assets.monster.tail)
	self.parts.mouth.style = math.random(1,#assets.monster.mouth)
	self.parts.cap.style = self.parts.tail.style
	for i, part in pairs(self.detail) do
		if math.random(1,6) >= 5 then
			self.detail[i] = true
		else
			self.detail[i] = false
		end
	end
	for i, part in pairs(self.parts) do
		if math.random(1,10) > 3 then
			part.color = {math.random(0,255),math.random(0,255),math.random(0,255)}
		else
			part.color = nil
		end
	end
	
	if math.random(1,10) > 3 then
		self.color = {math.random(90,155),math.random(90,155),math.random(90,155)}
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

function fish.drawPartInPlace(self,part,flip)
	local fixedoff = 2048
	local poff = {x= part_offsets[part].x + fixedoff, y = part_offsets[part].y  + fixedoff}
	if flip then
		poff = {x= part_offsets[part].x + fixedoff , y= part_offsets[part].y * -1  + fixedoff}	
	end
	
	local vflip = 1
	local hflip = 1 
	if flip then vflip = -1  end
	
	--print(part.." checking "..self.parts[part].style)
	
	if self.parts[part].style > 0 then
		--draw background
		lg.setBlendMode("alpha")
		lg.setColor(255,255,255)
		local background = assets.monster[part][self.parts[part].style][1]
		local ox,oy = background:getWidth()/2, background:getHeight()/2
		lg.draw(background,poff.x,poff.y,0,hflip,vflip,ox,oy)
		
		if self.parts[part].color then
			--draw color layer (2)
			local colorlayer = assets.monster[part][self.parts[part].style][3]
			lg.setBlendMode("add")
			lg.setColor(self.parts[part].color)
			lg.draw(colorlayer,poff.x,poff.y,0,hflip,vflip,ox,oy)
			lg.draw(colorlayer,poff.x,poff.y,0,hflip,vflip,ox,oy)
		end
		
		lg.setBlendMode("alpha")
		local outline = assets.monster[part][self.parts[part].style][2]
		if self.color then
			lg.setColor(self.color)
		else
			lg.setColor(colors.outline)
		end
		lg.draw(outline,poff.x,poff.y,0,hflip,vflip,ox,oy)
		
		if self.detail[part] then
			--draw detail layer (4)
			lg.setBlendMode("alpha")
			local detail = assets.monster[part][self.parts[part].style][4]
			lg.setColor(255,255,255)
			lg.draw(detail,poff.x,poff.y,0,hflip,vflip,ox,oy)
		
		end
	end
end

function fish.render(self)
	self.nextcanvas = lg.newCanvas(2048*2,2048*2)
	lg.setCanvas(self.nextcanvas)

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
	self.fade = 0
	
end

function fish.draw(self)
	--[[local pos = Vector(self.pos.x,self.pos.y)
	local norm = pos - self.vector]]
	
	local x,y = self.pos:unpack()
	local rot = self.lookingVector:angleTo(Vector(0,0))
	local step = self.pos + self.vector*30
	local nx,ny = step:unpack()
	
	
	lg.setColor(255,255,255,300-self.fade)
	lg.draw(self.canvas,x,y,rot,self.scale,self.scale,self.canvas:getWidth()/2,self.canvas:getHeight()/2)
	if self.nextcanvas then
		lg.setColor(255,255,255,self.fade)
		lg.draw(self.nextcanvas,x,y,rot,self.scale,self.scale,self.canvas:getWidth()/2,self.canvas:getHeight()/2)
	end
	--lg.setColor(255,0,0)
	--lg.line(self.pos.x,self.pos.y,nx,ny)
end

function fish.update(fish,camera,dt)
	local mx,my = camera:mousePosition()
	local FADE_CONST = 100
	if fish.nextcanvas then
		if fish.fade < 255 then
			--fade in more
			fish.fade = fish.fade + (FADE_CONST*dt)
			fish.fade = fish.fade + (FADE_CONST*dt)
		else
			--swap canvas
			fish.canvas = fish.nextcanvas
			fish.nextcanvas = nil
			fish.fade = 0
		end
	end
	
	--local fpos = Vector(fish.pos.x,fish.pos.y)
	fish.wantedVector = Vector(mx-fish.pos.x,my-fish.pos.y):normalized()	

	--CANT GET THIS MESS WORKING
	--[[local ROTSPEED = 30
	local angle = fish.wantedVector:angleTo(fish.lookingVector)
	local l_angle = Vector(0,0):angleTo(fish.lookingVector)
	local w_angle = Vector(0,0):angleTo(fish.wantedVector)
	local clockwise = l_angle - w_angle
	local anticlockwise = w_angle - l_angle
	if math.abs(clockwise) < math.abs(anticlockwise) then 
		angle = clockwise
	else
		angle = anticlockwise
	end
	--fish.lookingVector = fish.lookingVector + (fish.wantedVector/100*ROTSPEED)
	--fish.lookingVector:normalized()]]
	
	fish.lookingVector = fish.wantedVector
	if fish.locked.body then
		local bpos = Body.pos(fish.locked.body,timepoint)
		fish.lookingVector = Vector(bpos.x,bpos.y) - fish.pos
		fish.pos = Vector(bpos.x+fish.locked.dx,bpos.y+fish.locked.dy)
	else
		fish.pos = fish.pos + fish.vector
	end
end

function fish.updateVelocity(fish,power)
	

	--[[if power < PULSE_DEADZONE or fish.locked.body then
		--do nothing
		print("added no speed")
	else]]	
		fish.vector = fish.vector + (fish.lookingVector*power/100*FISH_SWIM_IMPULSE)
		fish.vector = fish.vector:trimmed(FISH_MAX_SPEED)
		--print("added more speed")
	--end
end

function fish.lockToBody(fish,body)
	if fish.locked.body then
		if fish.locked.body == body then
			Logic.consumeBody(body,fish)
		end
		--[[print("unlocked from body")
		fish.vector = Vector(0,0)
		fish.locked.body = nil]]
		return true
	else
		print("locked to body")
		fish.locked.body = body
		local x,y = fish.pos:unpack()
		local bpos = Body.pos(body,timepoint)
		local dx,dy = x - bpos.x, y - bpos.y
		fish.locked.dx, fish.locked.dy = dx,dy
		fish.vector = Vector(0,0)
		return true
	end
end

function fish.detach(fish)
	if fish.locked.body then
		print("unlocked from body")
		fish.vector = Vector(0,0)
		fish.locked.body = nil
		return false
	end
end

function fish.slowDown(fish,dt)
	--print("Slowing Down")
	local percentslowed = 100 - (BRAKE_CONSTANT * dt)
	
	fish.vector = fish.vector * percentslowed / 100
end

return fish
