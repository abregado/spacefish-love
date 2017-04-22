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
