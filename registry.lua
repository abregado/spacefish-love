--GLOBAL VARIABLES

Body = require("body")
Camera = require("lib.hump.camera")
Gamestate = require("lib.hump.gamestate")
VectorL = require("lib.hump.vector-light")
Vector = require("lib.hump.vector")
Tween = require("lib.tween.tween")
Fish = require("fish")
Logic = require("eat-logic")

--API pointers
lg = love.graphics

--Timing
timepoint = 0

--Scenes
scenes = {}
scenes.play = require("scenes.play")

--constants
BODY_SPEED_MODIFIER = 100
GLOBAL_CENTREPOINT_X = lg.getWidth()/2
GLOBAL_CENTREPOINT_Y = lg.getHeight()/2
ZOOM_LEVELS = {0.25,0.5,1,2}
CAMERA_SMOOTHER = Camera.smooth.damped(100)
FISH_SWIM_IMPULSE = 10
FISH_MAX_SPEED = 300


--assets
assets = {}
assets.planet_layers = {}
assets.planet_layers[1] = {
	lg.newImage("assets/P_Background_1_Earth.png"),
	lg.newImage("assets/P_Background_2_Barren.png"),
	lg.newImage("assets/P_Background_3_Mars.png"),
	lg.newImage("assets/P_Background_4_Swamp.png"),
	lg.newImage("assets/P_Background_5_Broken1.png"),
	lg.newImage("assets/P_Background_5_Broken2.png"),
	lg.newImage("assets/P_Background_6_Purple.png")
	}

assets.planet_layers[2] = {
	lg.newImage("assets/P_Detail_1_City.png"),
	lg.newImage("assets/P_Detail_2_Vulcano.png"),
	lg.newImage("assets/P_Detail_1_Corruption.png"),
	lg.newImage("assets/P_Detail_3_Corruption.png"),
	lg.newImage("assets/P_Detail_4_Electric.png")
	}

assets.planet_layers[3] = {
	lg.newImage("assets/P_Top1_1_Clouds.png"),
	lg.newImage("assets/P_Top1_2_Clouds.png"),
	lg.newImage("assets/P_Top1_3_Rainbow.png")
	}

assets.planet_layers[4] = {
	lg.newImage("assets/P_Top2_1_Asteroids.png"),
	lg.newImage("assets/P_Top2_1_Corruption.png"),
	lg.newImage("assets/P_Top2_2_Satelites.png"),
	lg.newImage("assets/P_Top2_2_Butterflies.png")
	}



assets.monster = {}
assets.monster.body = {}
assets.monster.head = {}
assets.monster.eyes = {}
assets.monster.mouth = {}
assets.monster.arms = {}
assets.monster.legs = {}
assets.monster.tail = {}
assets.monster.cap = {}

function newPartType(name1,name2,part)
	--TODO: generate the filesnames based on a single string
	local layers = {
		"assets/M_"..name1.."_Background.png",
		"assets/M_"..name1.."_Outline.png",
		"assets/M_"..name1.."_Color.png",
		"assets/M_"..name1.."_Detail_"..name2..".png"
		}
	local part_type = {}
	for i, layer in ipairs(layers) do
		table.insert(part_type,lg.newImage(layer))
	end
	part_type.detail = name2
	table.insert(assets.monster[part],part_type)
end

newPartType("Body_1_Crab","Purple","body")

newPartType("Head_1_Crab","Purple","head")
	
newPartType("Arm_1_Crab","Purple","arms")
newPartType("Arm_1_Crab","Electric","arms")
	
newPartType("Mouth_1_Crab","Electric","mouth")
newPartType("Mouth_2_Butterfly","Electric","mouth")
	
newPartType("Leg_1_Crab","Purple","legs")
newPartType("Leg_1_Crab","Electric","legs")
newPartType("Leg_2_Butterfly","Purple","legs")
	
newPartType("Cap_1_Crab","Purple","cap")
	
newPartType("Tail_1_Crab","Purple","tail")
newPartType("Tail_2_Flesh","Purple","tail")
	
newPartType("Eyes_1_Crab","Purple","eyes")

part_offsets = {
	body = {x=0,y=0},
	head = {x=550,y=0},
	eyes = {x=550,y=0},
	mouth = {x=550+210,y=0},
	arms = {x=504,y=-512},
	legs = {x=-210,y=-512},
	tail = {x=-370-256,y=0},
	cap = {x=-370-512,y=0}	
	}



colors = {
	outline = {125,125,125}
	}
