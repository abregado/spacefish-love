local body = {}

function body.new(parent,distance,speed,offset,size,color)
	local b = {}
	b.parent = parent
	b.distance = distance or 100
	b.speed = speed or 10
	b.offset = offset or 0
	b.size = size or 1
	b.color = color or {255,255,255}
	
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

return body

