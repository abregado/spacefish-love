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
TODOS
slow rotation
right clicking moves speed toward tangental orbital velocity

better orbit rings


]]
