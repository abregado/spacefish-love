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
    end return (r+m)*255,(g+m)*255,(b+m)*255
end

function logic.changeStyle(fish,part,style)
	--if no sytle given then select style 1
	fish.parts[part].style = style or 1
end


function logic.chooseStyleChange(fish,parts,style)
	local parts = parts or {"body","head","eyes","mouth","arms","legs","tail","cap"}
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
				break
			end
		end
	end
	
	if #parts > 0 then
		local choice = math.random(1,#parts)
		logic.changeStyle(fish,parts[choice],style)
	else
		print("couldnt find a valid part for style change")
	end
end


function logic.mixStyle(fish)
	local parts = {"body","head","eyes","mouth","arms","legs","tail","cap"}
	for i, part in ipairs(parts) do
		local style = math.random(1,#assets.monster[part])
		logic.changeStyle(fish,part,style)
	end
end

function logic.changeColor(fish,part,color)
	--if no color given then nil the color
	fish.parts[part].color = color or nil
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
		logic.changeColor(fish,part,color)
		hue = hue + 32
	end
	
end

function logic.changeOutline(fish,color)
	fish.color = color or nil
	--if no color then nil
end

function logic.addCorruption(fish)

end

function logic.addElectric(fish)

end


function logic.consumeBody(body,fish)
	
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
