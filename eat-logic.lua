local logic = {}

function HSV(h, s, v)
    if s <= 0 then return v,v,v end
    h, s, v = h/256*6, s/255, v/255
    local c = v*s
    local x = (1-math.abs((h%2)-1))*c
    local m,r,g,b = (v-c), 0,0,0
    if h < 1     then r,g,b = c,x,0
    elseif h < 2 then r,g,b = x,c,0
    elseif h < 3 then r,g,b = 0,c,x
    elseif h < 4 then r,g,b = 0,x,c
    elseif h < 5 then r,g,b = x,0,c
    else              r,g,b = c,0,x
    end return {(r+m)*255,(g+m)*255,(b+m)*255}
end

function logic.changeStyle(fish,part,style)
	--if no sytle given then select style 1
	fish.parts[part].style = style or 1
	print(part.." changed to style "..(style or 1))
end

function logic.setDetail(fish,part,hasDetail)
	--if no setting given then remove detail
	fish.detail[part] = hasDetail or false
	print(part.." detail changed to "..(tostring(style) or "false"))
end

function logic.setAllDetail(fish,hasDetail)
	local parts = {"body","head","eyes","mouth","arms","legs","tail","cap"}
	for partname, part in ipairs(parts) do
		logic.setDetail(fish,partname,hasDetail)
	end
end

function logic.chooseStyleChange(fish,parts,style)
	local parts = parts or {"body","head","eyes","mouth","arms","legs","tail","cap"}
	local style = style or 1 
	if #parts == 0 then parts = {"body","head","eyes","mouth","arms","legs","tail","cap"} end
	
	
	--remove parts which are already this style
	local removals = 0
	for i, part in ipairs(parts) do
		if fish.parts[part].style == style then
			removals = removals + 1
		end
	end
	while removals > 0 do
		for i, part in ipairs(parts) do
			if fish.parts[part].style == style then
				table.remove(parts,i)
				removals = removals - 1
				break
			end
		end
	end
	
	--remove parts which dont have this style
	removals = 0
	for i, part in ipairs(parts) do
		if assets.monster[part][style] then
			--style exists so do nothing
		else
			removals = removals + 1
		end
	end
	while removals > 0 do
		for i, part in ipairs(parts) do
			if assets.monster[part][style] then
				--style exists so do nothing
			else
				table.remove(parts,i)
				removals = removals - 1
				break
			end
		end
	end
	
	
	if #parts > 0 then
		local choice = math.random(1,#parts)
		logic.changeStyle(fish,parts[choice],style)
		return parts[choice]
	else
		print("couldnt find a valid part for style change")
		return nil
	end
end


function logic.mixStyle(fish)
	local parts = {"body","head","eyes","mouth","arms","legs","tail","cap"}
	for i, part in ipairs(parts) do
		local style = math.random(1,#assets.monster[part])
		logic.changeStyle(fish,partname,style)
	end
	
end

function logic.changeColor(fish,part,color)
	--if no color given then nil the color
	fish.parts[part].color = color or nil
	print(part.." changed color to "..(tostring(color) or "nil"))
end

function logic.colorAll(fish,color)
	if color == nil then local color = nil end
	print("Coloring all parts")
	for partname, part in pairs(fish.parts) do
		logic.changeColor(fish,partname,color)
	end
end

function logic.chooseColorChange(fish,parts,color)
	local parts = parts or {"body","head","eyes","mouth","arms","legs","tail","cap"}
	if #parts == 0 then parts = {"body","head","eyes","mouth","arms","legs","tail","cap"} end
	
	--remove parts which are alrady this color
	local removals = 0
	for i, part in ipairs(parts) do
		if fish.parts[part].color == color then
			removals = removals + 1
		end
	end
	while removals > 0 do
		for i, part in ipairs(parts) do
			if fish.parts[part].color == color then
				table.remove(parts,i)
				removals = removals - 1
				break
			end
		end
	end
	
	if #parts > 0 then
		local choice = math.random(1,#parts)
		logic.changeStyle(fish,parts[choice],style)
	else
		print("couldnt find a valid part for color change")
	end
end

function logic.rainbowChange(fish)
	local parts = {"body","head","eyes","mouth","arms","legs","tail","cap"}
	
	local hue = math.random(0,255)
	for i, part in ipairs(parts) do
		local color = HSV(hue,255,255)
		print(color[1],color[2],color[3])
		logic.changeColor(fish,part,color)
		hue = hue + 32
		if hue > 255 then hue = hue - 255 end
	end
	
end

function logic.plainChange(fish)
	local parts = {"body","head","eyes","mouth","arms","legs","tail","cap"}
	
	for i, part in ipairs(parts) do
		logic.changeColor(fish,part,nil)
	end
	
end

function logic.changeOutline(fish,color)
	fish.color = color or nil
	--if no color then nil
end

function logic.addDetail(fish,detailType)
	local parts = {{"body"},{"head"},{"eyes"},{"mouth"},{"arms"},{"legs"},{"tail"},{"cap"}}
	local detailType = detailType or "Purple"
	--local detailType = "Electric"
	
	--remove parts which have already got details (and thus cannot get detailed again)
	local removals = 0
	for i, part in ipairs(parts) do
		if fish.detail[part[1]] == true then
			--set the part to be removed
			part[2] = true
			--print(part[1].." is already detailed, deleting")
			removals = removals + 1
		else
			part[2] = false
			--print(part[1].." is can be detailed")
		end
	end
	
	while removals > 0 do
		for i, part in ipairs(parts) do
			if part[2] then
				table.remove(parts,i)
				removals = removals -1
				break
			end
		end
	end
	--print("addDetail parts remain after stage 1: "..#parts)
	
	--of the remaining parts, find those which have a corruptable option
	removals = 0
	for i, part in ipairs(parts) do
		local style = fish.parts[part[1]].style
		if assets.monster[part[1]][style].detail == detailType then
			--its corruptable, leave it
			--print(part[1].." can become "..detailType)
			part[2] = false
		else
			part[2] = true
			removals = removals + 1
			--print(part[1].." cannot become "..detailType..", deleting")
		end
	end
	
	while removals > 0 do
		for i, part in ipairs(parts) do
			if part[2] == true then
				table.remove(parts,i)
				removals = removals -1
				break
			end
		end
	end
	--print("addDetail parts remain after stage 2: "..#parts)
	
	if #parts > 0 then
		local choice = math.random(1,#parts)
		logic.setDetail(fish,parts[choice][1],true)
		return parts[choice][1]
	else
		print("couldnt find a valid part for detailing")
		return nil
	end
	
end

function logic.consumeBody(body,fish)
	for layer, variant in ipairs(body.layers) do
		local callback = assets.planet_layers[layer][variant.variant].callback or nil
		if callback then
			callback(fish)
			Fish.render(fish)
			--variant.eaten = true
		end
	end
end

logic.planet = {}

function logic.planet.earth(fish)
	print("Earth planet eaten")
	logic.chooseStyleChange(fish,{},1)
end

function logic.planet.barren(fish)
	print("Barren planet eaten")
	logic.plainChange(fish)
end

function logic.planet.mars(fish)
	print("Mars planet eaten")
	local hue = 295
	logic.colorAll(fish,HSV(hue/360*255,255,255))
end

function logic.planet.swamp(fish)
	print("Swamp planet eaten")
	local hue = 295
	logic.colorAll(fish,HSV(hue/360*255,255,255))
end

function logic.planet.purple(fish)
	print("Purple planet eaten")
	local hue = 295
	logic.colorAll(fish,HSV(hue/360*255,255,255))
end

function logic.planet.vulcano(fish)
	print("Vulcano planet eaten")
	local hue = 94
	logic.colorAll(fish,HSV(hue/360*255,255,255))
end

function logic.planet.broken(fish)
	print("Broken planet eaten")
	logic.changeStyle(fish,"tail",2)
	logic.changeStyle(fish,"cap",2)
end

function logic.planet.corruption(fish)
	print("Corrupt planet eaten")
	local result = logic.addDetail(fish,"Purple")
	if result then
		print("Corrupted "..result)
	else
		--nothing to corrupt so check if we can change some parts
		if fish.parts.legs.style == 2 and fish.detail.legs == false then
			logic.changeStyle(fish,"legs",1)
			logic.setDetail(fish,"legs",true)
		elseif fish.parts.arms.style == 2 and fish.detail.arms == false then
			logic.changeStyle(fish,"arms",1)
			logic.setDetail(fish,"arms",true)
		end
	end
end

function logic.planet.electric(fish)
	print("Electric planet eaten")
	local result = logic.addDetail(fish,"Electric")
	if result then
		print("Electrified "..result)
	else
		--nothing to corrupt so check if we can change some parts
		if fish.parts.legs.style == 1 and fish.detail.legs == false then
			logic.changeStyle(fish,"legs",2)
			logic.setDetail(fish,"legs",true)
			print("Swapped legs from NonCorrupt Crab to Electric Crab")
		elseif fish.parts.arms.style == 1 and fish.detail.arms == false then
			logic.changeStyle(fish,"arms",2)
			logic.setDetail(fish,"arms",true)
			print("Swapped mouth from NonCorrupt Crab to Electric Crab")
		else
			local hue = 213
			local color = HSV(hue/360*255,255,255)
			logic.chooseColorChange(fish,{},color)
		end
	end
end

function logic.planet.clouds(fish)
	logic.chooseColorChange(fish,{},{255,255,255})
end

function logic.planet.butterly(fish)
	print("Butterfly planet eaten")
	if fish.parts.mouth.style == 2 and not fish.parts.legs.style == 3 then
		logic.changeStyle(fish,"legs",3)
		logic.setDetail(fish,"legs",false)
	elseif not fish.parts.mouth.style == 2 then
		logic.changeStyle(fish,"mouth",2)
		logic.setDetail(fish,"mouth",false)		
	end
	
end

return logic


--[[

P_Background_1_Earth - Changes random body part to CRAB
P_Background_2_Barren - Hides color layer
P_Background_3_Mars - Changes the color to and the outline to orange
P_Background_4_Swamp - Changes the color to and the outline to green
P_Background_5_Broken1 - Changes tail or tail cap to FLESH
P_Background_5_Broken2 - Changes tail or tail cap to FLESH
P_Background_6_Purple - Changes the color to and the outline to purple
P_Detail_1_City - 
P_Detail_2_Vulcano - Changes the outline color to yellow
P_Detail_3_Corruption - Adds PURPLE detail to the random body part. If the is no body part that can be affected, change the color to purple
P_Detail_4_Electric - Adds ELECTRIC to random body part. If the is no body part that can be affected, change the outline to light blue
P_Top1_1_Clouds - Change outline color to white
P_Top1_2_Clouds - 
P_Top1_3_Rainbow - Color each body part with a random color
P_Top2_1_Asteroids - Add a tail segment
P_Top2_1_Corruption - Add a tail segment AND Adds PURPLE detail to the random body part. If the is no body part that can be affected, change the color to purple
P_Top2_2_Butterflies - Chainges legs or mouth to BUTTERFLY
P_Top2_2_Satelites -
]]
