require("registry")

function love.load()
	Gamestate.registerEvents()
    Gamestate.switch(scenes.play)
end

function love.draw()
	lg.setColor(255,255,255)
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 0, 0)
end

function love.update(dt)

end

function love.mousepressed(x,y,button)
end

--[[
fish rotates toward mouse when unlocked
fish rotates toward planet when locked
slow rotation
clicking adds movment in direction that you are facing
right clicking moves speed toward tangental orbital velocity


two canvas, one fades in

sun and background placed in world

]]
