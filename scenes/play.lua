play = {}

play.planets = {}

function play:enter()
	print("Building World")
	local planets = play.planets
	local sun = Body.new(nil)
	table.insert(planets,sun)
	planets[1].color = {0,125,65}
	planets[1].size = 8
	--planets[3].distance = 30
	--planets[3].speed = 500
	--planets[3].size = 0.25	
	
	local distance = 100
	for p = 0, 25 do
		distance = distance + math.random(30,50)
		local newplanet = Body.new(sun,
			distance, --orbital distance
			20+math.random(1,10), --orbital speed
			math.pi*2*math.random(), --random starting offset
			1+(2*math.random()), --size
			{0,255,0} --color
			)
		table.insert(planets,newplanet)
	end
	
	local moons = {}
	for i, planet in ipairs(planets) do
		if i > 1 then
			local distance = 3+(planet.size*10)
			for m=0, math.random(1,10) do
				distance = distance + math.random(3,4)
				local newmoon = Body.new(planet,
					distance, --orbital distance
					150+math.random(1,200), --orbital speed
					math.pi*2*math.random(), --random starting offset
					0.25, --size
					{200,200,200} -- color
					)
				table.insert(moons,newmoon)
			end
		end
	end
	
	for i, moon in ipairs(moons) do
		table.insert(planets, moon)
	end
	
	print("Finished Building World")
end

function play:draw()
	lg.print("playstate is working",0,15)
	
	
	for i, planet in ipairs(play.planets) do
		local pos = Body.pos(planet,timepoint)
		lg.setColor(planet.color)
		lg.circle("fill",pos.x,pos.y,10*planet.size,30)
	end
end

function play:update(dt)
	timepoint = timepoint + dt
end

return play
