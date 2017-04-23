--GLOBAL VARIABLES

Body = require("body")
Camera = require("lib.hump.camera")
Gamestate = require("lib.hump.gamestate")
Vector = require("lib.hump.vector-light")
Tween = require("lib.tween.tween")
Fish = require("fish")

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
CAMERA_SMOOTHER = Camera.smooth.damped(1)


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
	lg.newImage("assets/P_Detail_1_Corruption.png")
	}

assets.planet_layers[3] = {
	lg.newImage("assets/P_Top1_1_Clouds.png"),
	lg.newImage("assets/P_Top1_2_Clouds.png")
	}

assets.planet_layers[4] = {
	lg.newImage("assets/P_Top2_1_Asteroids.png"),
	lg.newImage("assets/P_Top2_1_Corruption.png"),
	lg.newImage("assets/P_Top2_2_Satelites.png")
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

function newPartType(part,layers)
	--TODO: generate the filesnames based on a single string
	local part_type = {}
	for i, layer in ipairs(layers) do
		table.insert(part_type,lg.newImage(layer))
	end
	table.insert(assets.monster[part],part_type)
end

newPartType("body",{
	"assets/M_Body_1_Crab_Background.png",
	"assets/M_Body_1_Crab_Outline.png",
	"assets/M_Body_1_Crab_Color.png",
	"assets/M_Body_1_Crab_Detail.png"
	})

newPartType("head",{
	"assets/M_Head_1_Template_Background.png",
	"assets/M_Head_1_Template_Background.png",
	"assets/M_Head_1_Template_Background.png",
	"assets/M_Head_1_Template_Background.png"
	})
	
newPartType("arms",{
	"assets/M_Arm_1_Template_Background.png",
	"assets/M_Arm_1_Template_Background.png",
	"assets/M_Arm_1_Template_Background.png",
	"assets/M_Arm_1_Template_Background.png"
	})
	
newPartType("mouth",{
	"assets/M_Mouth_1_Template_Background.png",
	"assets/M_Mouth_1_Template_Background.png",
	"assets/M_Mouth_1_Template_Background.png",
	"assets/M_Mouth_1_Template_Background.png"
	})
	
newPartType("legs",{
	"assets/M_Leg_1_Template_Background.png",
	"assets/M_Leg_1_Template_Background.png",
	"assets/M_Leg_1_Template_Background.png",
	"assets/M_Leg_1_Template_Background.png"
	})
	
newPartType("cap",{
	"assets/M_Cap_1_Template_Background.png",
	"assets/M_Cap_1_Template_Background.png",
	"assets/M_Cap_1_Template_Background.png",
	"assets/M_Cap_1_Template_Background.png"
	})
	
newPartType("tail",{
	"assets/M_Tail_1_Template_Background.png",
	"assets/M_Tail_1_Template_Background.png",
	"assets/M_Tail_1_Template_Background.png",
	"assets/M_Tail_1_Template_Background.png"
	})
	
newPartType("eyes",{
	"assets/M_Eyes_1_Template_Background.png",
	"assets/M_Eyes_1_Template_Background.png",
	"assets/M_Eyes_1_Template_Background.png",
	"assets/M_Eyes_1_Template_Background.png"
	})

part_offsets = {
	body = {x=0,y=0},
	head = {x=512,y=0},
	eyes = {x=512,y=0},
	mouth = {x=732,y=0},
	arms = {x=0,y=0},
	legs = {x=0,y=0},
	tail = {x=-512,y=0},
	cap = {x=0,y=0}	
	}

colors = {
	outline = {255,255,255}
	}
