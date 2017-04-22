local fish = {}

function fish.new()
	local f = {}
	--properties
	f.pos = {x=0,y=0}
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

return fish
