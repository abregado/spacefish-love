local body = {}

function body.new(parent,distance,speed,offset,size,color,isPlanet)
	local b = {}
	b.parent = parent
	b.distance = distance or 100
	b.speed = speed or 10
	b.offset = offset or 0
	b.size = size or 1
	b.color = color or {255,255,255}
	b.isPlanet = isPlanet or false
	if b.size < 1 then
		b.layers = {
			{variant = 2, eaten = false}
			}
	else
		b.layers = {}
		b.layers[1] = {variant = 1, eaten = false}
		--b.layers[1] = {variant = math.random(1,#assets.planet_layers[1]), eaten = false}
		b.layers[2] = {variant = math.random(0,#assets.planet_layers[2]), eaten = false}
		--b.layers[3] = {variant = math.random(0,#assets.planet_layers[3]), eaten = false}
		--b.layers[4] = {variant = math.random(0,#assets.planet_layers[4]), eaten = false}
	end
	return b
end

function body.pos(self,timepoint)
	if self.parent then
		local centerpos = body.pos(self.parent,timepoint)
		local rotation = self.offset + (timepoint*self.speed/BODY_SPEED_MODIFIER)
		local x = centerpos.x + (self.distance * math.cos(rotation))
		local y = centerpos.y + (self.distance * math.sin(rotation))
		return {x=x,y=y}
	else
		return {x=GLOBAL_CENTREPOINT_X,y=GLOBAL_CENTREPOINT_Y}
	end
end

function body.draw(self,timepoint)
	--TODO: planet surfaces rotate to face the galactic centre
	local pos = body.pos(self,timepoint)
	lg.setColor(self.color)
	lg.circle("fill",pos.x,pos.y,10*self.size,30)

	if self.parent then
		local diameter = self.size*10
		local ratio = diameter/128
		
		lg.setColor(255,255,255)
		for i, layer in ipairs(self.layers) do
			if layer.variant > 0 and layer.eaten == false then
				local image = assets.planet_layers[i][layer.variant].image
				lg.draw(image,pos.x,pos.y,1,ratio,ratio,image:getWidth()/2,image:getHeight()/2)
			end
		end
		
	end
end

function body.findNearest(bodies,pos,timepoint)
	local nearest = {body=nil,pos={x=0,y=0},dist=300}
	for i, planet in ipairs(bodies) do
		if planet.isPlanet then
			local p_pos = body.pos(planet,timepoint)
			local dist = VectorL.dist(p_pos.x,p_pos.y,pos.x,pos.y)
			if dist < nearest.dist then
				nearest.body = planet
				nearest.dist = dist
				nearest.pos = p_pos
			end
		end
	end
	return nearest.body, {x=pos.x - nearest.pos.x, y=pos.y- nearest.pos.y}
end

return body

