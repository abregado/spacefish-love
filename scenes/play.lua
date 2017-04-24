play = {}

play.planets = {}
play.fish = nil
play.zoom = 1
play.orbitlock = false
play.locked_to = nil
play.locked_pos = {x=20,y=20}

function play:enter()
	math.randomseed(os.time())
	
	print("Building World")
	local planets = play.planets
	local sun = Body.new(nil)
	table.insert(planets,sun)
	planets[1].color = {244,191,0}
	planets[1].size = 50
	--planets[3].distance = 30
	--planets[3].speed = 500
	--planets[3].size = 0.25	
	
	local distance = 500
	local maxplanets = 1
	for p = 0, 10 do
		distance = distance + math.random(500,2000)
		local planetshere = math.floor(math.random(math.floor(maxplanets/2),maxplanets))
		local startoff = math.pi*2*math.random()
		local step = math.pi*2/(planetshere+5)
		for pl=0, planetshere do
			
			local newplanet = Body.new(sun,
				distance, --orbital distance
				1+math.random(1,2)/distance*1000, --orbital speed
				startoff+(step*pl), --random starting offset
				4+(4*math.random()), --size
				{171,191,0}, -- color
				true --is real planet
				)
			table.insert(planets,newplanet)
		end
		maxplanets = maxplanets + 1
		if maxplanets > 3 then maxplanets = 3 end
	end
	
	--[[local moons = {}
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
	end]]
	
	print("Finished Building World")
	
	print("building Fish")
	play.fish = Fish.new()
	play.camera = Camera(play.fish.pos.x,play.fish.pos.y,ZOOM_LEVELS[play.zoom])

end
local hue = 0
function play:keypressed(key)

	if key == "1" then
		Logic.addDetail(play.fish,"Purple")
		Fish.render(play.fish)
	elseif key == "2" then
		Logic.addDetail(play.fish,"Electric")
		Fish.render(play.fish)
	elseif key == "3" then
		Logic.mixStyle(play.fish)
		Fish.render(play.fish)
	elseif key == "4" then
		Logic.chooseStyleChange(play.fish,{},1)
		Fish.render(play.fish)
	elseif key == "5" then
		Logic.setAllDetail(play.fish,false)
		Fish.render(play.fish)
	elseif key == "6" then
		Logic.rainbowChange(play.fish)
		Fish.render(play.fish)
	elseif key == "7" then
		Logic.plainChange(play.fish)
		Fish.render(play.fish)
	elseif key == "8" then
		Fish.randomize(play.fish)
		Fish.render(play.fish)
	elseif key == "9" then
		local color = HSV(hue,255,255)
		Logic.colorAll(play.fish,color)
		Fish.render(play.fish)
		hue = hue + 10
		if hue > 255 then hue = hue - 255 end
	elseif key == "0" then
		play.fish.scale = play.fish.scale * FISH_GROWTH_PER_PLANET
	end
end

local pulsepower = 0
local isLocked = false

function play:wheelmoved(x,y)
	if y > 0 then
		play.zoom = play.zoom + 1
		if play.zoom > #ZOOM_LEVELS then play.zoom = #ZOOM_LEVELS end
		play.camera:zoomTo(ZOOM_LEVELS[play.zoom])
	elseif y < 0 and play.zoom > 1 then
		play.zoom = play.zoom - 1
		play.camera:zoomTo(ZOOM_LEVELS[play.zoom])
	end
end

function play:mousepressed(x,y,button)
	--[[if button == 1 then
		local mx,my = play.camera:mousePosition()
		--play.fish:teleport({x=mx,y=my})
		local fvec = Vector(play.fish.pos.x,play.fish.pos.y)
		local mvec = play.fish.lookingVector
		--local mvec = Vector(mx,my)
		local direc =  mvec - fvec
		
		direc = direc:trimmed(0.5)
		play.fish.vector = play.fish.vector + direc
	]]

	if button == 1 then
		local mx,my = play.camera:mousePosition()
		local clicked, distance = Body.clickCheck(play.planets,mx,my,timepoint)
		
		if clicked then
			local x,y = play.fish.pos:unpack()
			local bpos = Body.pos(clicked,timepoint)
			local distanceToFish = VectorL.dist(x,y,bpos.x,bpos.y)
			if distanceToFish < (FISH_REACH*play.fish.scale)+(clicked.size*10) then
				isLocked = Fish.lockToBody(play.fish,clicked)
			end
		end
		pulsepower = 0
	elseif button == 2 then
		if isLocked then
			Fish.detach(play.fish)
			isLocked = false
		end
		--Fish.lockToBody(play.fish,nil)
		--Fish.slowDown(play.fish)
	elseif button == 3 then
		play.zoom = play.zoom + 1
		if play.zoom > #ZOOM_LEVELS then play.zoom = 1 end
		play.camera:zoomTo(ZOOM_LEVELS[play.zoom])
	end
	
end

function play:mousereleased(x,y,button)
	if button == 1 then
		Fish.updateVelocity(play.fish,pulsepower)
		pulsepower = 0
	end
end



function play:draw()
	
	local w,h = assets.background:getWidth(), assets.background:getHeight()
	local ww,wh = lg:getWidth(), lg:getHeight()
	lg.draw(assets.background,ww/2-w,wh/2-h,0,2,2)

	--Draw game world
	play.camera:attach()
	
	--draw locked indicator
	if play.orbitlock then
		lg.setColor(255,0,0)
		lg.line(
			play.fish.pos.x,
			play.fish.pos.y,
			play.fish.pos.x - play.locked_pos.x,
			play.fish.pos.y - play.locked_pos.y
			)
	end
	
	--draw orbit rings
	for i, planet in ipairs(play.planets) do
		if planet.isPlanet == true then
			--[[lg.setBlendMode("alpha")
			local bpos = Body.pos(planet,timepoint)
			local centre = Vector(GLOBAL_CENTREPOINT_X,GLOBAL_CENTREPOINT_Y)
			local bvec = Vector(bpos.x,bpos.y)
			local angle = bvec:angleTo(centre)
			
			local arcLength = math.pi/10
			local arcSegs = 10
			local shadestep = 255/arcSegs
			
			lg.setColor(255,255,255)
			lg.arc("line","open",GLOBAL_CENTREPOINT_X,GLOBAL_CENTREPOINT_Y,planet.distance,angle,angle+0.1,150)
			
			
			--for seg=0,arcSegs do
			--	local shade = 255-(seg*shadestep)
			--	lg.setColor(shade,shade,shade)
			--end]]
			--main planet
			lg.setColor(40,40,40)
			lg.circle("line",GLOBAL_CENTREPOINT_X,GLOBAL_CENTREPOINT_Y,planet.distance,150)
		end
	end
	
	--draw bodies	
	for i, planet in ipairs(play.planets) do
		Body.draw(planet,timepoint)
	end
	
	Fish.draw(play.fish)
	--lg.setColor(255,206,32)
	--lg.circle("line",play.fish.pos.x,play.fish.pos.y,30,3)
	
	play.camera:detach()
	
	--draw UI
	--[[lg.setColor(255,255,255)
	lg.print("playstate is working",0,15)
	local mx,my = play.camera:mousePosition()
	mx,my = math.floor(mx), math.floor(my)
	lg.print(mx..","..my,0,30)
	if play.orbitlock then
		lg.setColor(255,0,0)
		lg.print("movement locked to body",0,45)
	else
		lg.setColor(0,255,0)
		lg.print("movement free",0,45)
	end
	lg.print("Pulse: "..pulsepower,0,60)
	lg.print("Angle: "..ANGLE,0,75)]]
	--lg.setColor(HSV(hue,255,255))
	--lg.print(hue,0,0)
end

function play:update(dt)
	timepoint = timepoint + dt
	if love.mouse.isDown(1) then
		pulsepower = pulsepower + dt*PULSE_RATE
		if pulsepower > MAX_PULSE then pulsepower = MAX_PULSE end
	end
	if love.mouse.isDown(2) and isLocked == false then
		Fish.slowDown(play.fish,dt)
	end
	
	Fish.update(play.fish,play.camera,dt)
	local x,y = play.fish.pos:unpack()
	--local mx,my = love.mouse.getPosition()
	--local mx,my = play.fish.vector:unpack()
	--local w,h = lg.getWidth()/2, lg.getHeight()/2
	--local mx, my = (mx - w), (my - h)
	--mx,my = mx*10 , my*10 
	
	play.camera:lockPosition(x,y, CAMERA_SMOOTHER)
	
	--[[
	local fpos = Vector(play.fish.pos.x,play.fish.pos.y)
	local npos = fpos + play.fish.vector
	local x,y = npos:unpack()
	
	
	if play.orbitlock and play.locked_to then
		local lock_point = Body.pos(play.locked_to,timepoint)
		local bpos = Vector(lock_point.x,lock_point.y)
		play.fish.pos = {
			x= lock_point.x + play.locked_pos.x,
			y= lock_point.y + play.locked_pos.y
			}
		play.fish.vector = bpos - fpos
	else
		play.fish.pos = {x=x,y=y}
	end
	]]
	
end

return play
