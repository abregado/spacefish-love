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
	lg.newImage("assets/P_Background_2_Barren.png")
	}

assets.planet_layers[2] = {
	lg.newImage("assets/P_Detail_1_City.png"),
	lg.newImage("assets/P_Detail_2_Vulcano.png")
	}

assets.planet_layers[3] = {
	lg.newImage("assets/P_Top1_1_Clouds.png"),
	lg.newImage("assets/P_Top1_2_Clouds.png")
	}

assets.planet_layers[4] = {
	lg.newImage("assets/P_Top2_1_Asteroids.png"),
	lg.newImage("assets/P_Top2_2_Satelites.png")
	}
