play = {}

play.planets = {}
play.fish = nil
play.zoom = 1

function play:enter()
	print("Building World")
	local planets = play.planets
	local sun = Body.new(nil)
	table.insert(planets,sun)
	planets[1].color = {244,191,0}
	planets[1].size = 8
	--planets[3].distance = 30
	--planets[3].speed = 500
	--planets[3].size = 0.25	
	
	local distance = 100
	for p = 0, 25 do
		distance = distance + math.random(150,250)
		local newplanet = Body.new(sun,
			distance, --orbital distance
			20+math.random(1,10), --orbital speed
			math.pi*2*math.random(), --random starting offset
			1+(2*math.random()), --size
			{171,191,0} --color
			)
		table.insert(planets,newplanet)
	end
	
	local moons = {}
	for i, planet in ipairs(planets) do
		if i > 1 then
			local distance = 3+(planet.size*10)
			for m=0, math.random(1,10) do
				distance = distance + math.random(10,25)
				local newmoon = Body.new(planet,
					distance, --orbital distance
					150+math.random(1,200), --orbital speed
					math.pi*2*math.random(), --random starting offset
					0.25, --size
					{125,73,194} -- color
					)
				table.insert(moons,newmoon)
			end
		end
	end
	
	for i, moon in ipairs(moons) do
		table.insert(planets, moon)
	end
	
	print("Finished Building World")
	
	print("building Fish")
	play.fish = Fish.new()
	play.camera = Camera(play.fish.pos.x,play.fish.pos.y,ZOOM_LEVELS[play.zoom])

end

function play:mousepressed(x,y,button)
	if button == 1 then
	local mx,my = play.camera:mousePosition()
	play.fish:teleport({x=mx,y=my})
	elseif button == 3 then
		play.zoom = play.zoom + 1
		if play.zoom > #ZOOM_LEVELS then play.zoom = 1 end
		play.camera:zoomTo(ZOOM_LEVELS[play.zoom])
	end
	
end



function play:draw()
	--Draw game world
	play.camera:attach()
	
	--draw orbit rings
	for i, planet in ipairs(play.planets) do
		if planet.parent == play.planets[1] then
			--main planet
			lg.setColor(40,40,40)
			lg.circle("line",GLOBAL_CENTREPOINT_X,GLOBAL_CENTREPOINT_Y,planet.distance,150)
		end
	end
	
	--draw bodies	
	for i, planet in ipairs(play.planets) do
		Body.draw(planet,timepoint)
	end
	
	lg.setColor(255,206,32)
	lg.circle("line",play.fish.pos.x,play.fish.pos.y,30,3)
	
	play.camera:detach()
	
	--draw UI
	lg.setColor(255,255,255)
	lg.print("playstate is working",0,15)
	local mx,my = play.camera:mousePosition()
	mx,my = math.floor(mx), math.floor(my)
	lg.print(mx..","..my,0,30)
end

function play:update(dt)
	timepoint = timepoint + dt
	
	local mx,my = play.camera:mousePosition()
	
	play.camera:lockPosition(play.fish.pos.x,play.fish.pos.y, Camera.smooth.damped(0.3))
end

return play
