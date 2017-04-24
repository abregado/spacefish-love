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
ZOOM_LEVELS = {0.02,0.04,0.05,0.06,0.07,0.08,0.09,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,1.2,1.4,1.6,1.8,2}
CAMERA_SMOOTHER = Camera.smooth.damped(100)
FISH_SWIM_IMPULSE = 100
FISH_MAX_SPEED = 60
FISH_REACH = 800
FISH_GROWTH_PER_PLANET = 1.025
BRAKE_CONSTANT = 200
PULSE_DEADZONE = 0.1
PULSE_RATE = 8
MAX_PULSE = 32

--DEBUG
ANGLE = 0


--assets
assets = {}
assets.planet_layers = {}
assets.planet_layers[1] = {
	{image = lg.newImage("assets/P_Top2_1_Asteroids.png")},
	{image = lg.newImage("assets/P_Background_2_Barren.png"), callback = function(fish) Logic.planet.barren(fish) end},
	{image = lg.newImage("assets/P_Background_1_Earth.png"), callback = function(fish) Logic.planet.earth(fish) end},
	{image = lg.newImage("assets/P_Background_3_Mars.png"), callback = function(fish) Logic.planet.mars(fish) end},
	{image = lg.newImage("assets/P_Background_4_Swamp.png"), callback = function(fish) Logic.planet.swamp(fish) end},
	{image = lg.newImage("assets/P_Background_5_Broken1.png"), callback = function(fish) Logic.planet.broken(fish) end},
	{image = lg.newImage("assets/P_Background_5_Broken2.png"), callback = function(fish) Logic.planet.broken(fish) end},
	{image = lg.newImage("assets/P_Background_6_Purple.png"), callback = function(fish) Logic.planet.purple(fish) end},
	{image = lg.newImage("assets/P_Background_7_Eye.png"), callback = function(fish) Logic.planet.eye(fish) end},
	{image = lg.newImage("assets/P_Background_8_Forge.png"), callback = function(fish) Logic.planet.forge(fish) end},
	{image = lg.newImage("assets/P_Background_8_Metal.png"), callback = function(fish) Logic.planet.metal(fish) end}
	}

assets.planet_layers[2] = {
	{image = lg.newImage("assets/P_Detail_2_Vulcano.png"), callback = function(fish) Logic.planet.vulcano(fish) end},
	{image = lg.newImage("assets/P_Detail_1_Corruption.png"), callback = function(fish) Logic.planet.corruption(fish) end},
	{image = lg.newImage("assets/P_Detail_3_Corruption.png"), callback = function(fish) Logic.planet.corruption(fish) end},
	{image = lg.newImage("assets/P_Detail_4_Electric.png"), callback = function(fish) Logic.planet.electric(fish) end},
	{image = lg.newImage("assets/P_Detail_5_Metal.png"), callback = function(fish) Logic.planet.metal(fish) end}
	}

assets.planet_layers[3] = {
	{image = lg.newImage("assets/P_Top1_1_Clouds.png"), callback = function(fish) Logic.planet.clouds(fish) end},
	{image = lg.newImage("assets/P_Top1_2_Clouds.png"), callback = function(fish) Logic.planet.clouds(fish) end},
	{image = lg.newImage("assets/P_Top1_3_Rainbow.png"), callback = function(fish) Logic.rainbowChange(fish) end},
	{image = lg.newImage("assets/P_Top1_5_Shield.png"), callback = function(fish) Logic.planet.shield(fish) end},
	{image = lg.newImage("assets/P_Top1_4_Smog.png"), callback = function(fish) Logic.planet.smog(fish) end}
	}

assets.planet_layers[4] = {
	{image = lg.newImage("assets/P_Top2_1_Corruption.png"), callback = function(fish) Logic.planet.corruption(fish) end},
	{image = lg.newImage("assets/P_Top2_2_Butterflies.png"), callback = function(fish) Logic.planet.butterfly(fish) end},
	{image = lg.newImage("assets/P_Top2_5_Express.png"), callback = function(fish) Logic.planet.express(fish) end}
	}

assets.sun = lg.newImage("assets/sun.png")
assets.background = lg.newImage("assets/space_background.png")

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
newPartType("Body_2_Turtle","Purple","body")

newPartType("Head_1_Crab","Purple","head")
newPartType("Head_2_Skull","Purple","head")
	
newPartType("Arm_1_Crab","Purple","arms")
newPartType("Arm_1_Crab","Electric","arms")
newPartType("Arm_2_Tentacles","Electric","arms")
	
newPartType("Mouth_1_Crab","Electric","mouth")
newPartType("Mouth_2_Butterfly","Electric","mouth")
newPartType("Mouth_3_Tentacles","Electric","mouth")
	
newPartType("Leg_1_Crab","Purple","legs")
newPartType("Leg_1_Crab","Electric","legs")
newPartType("Leg_3_Tentacles","Electric","legs")
newPartType("Leg_2_Butterfly","Purple","legs")
	
newPartType("Cap_1_Crab","Purple","cap")
newPartType("Cap_2_Flesh","Purple","cap")
	
newPartType("Tail_1_Crab","Purple","tail")
newPartType("Tail_2_Flesh","Purple","tail")
	
newPartType("Eyes_1_Crab","Purple","eyes")
newPartType("Eyes_2_Single","Purple","eyes")
newPartType("Eyes_3_Wierd","Purple","eyes")

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
