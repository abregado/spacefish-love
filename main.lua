require("registry")

function love.load()
	--local modes = love.window.getFullscreenModes()
	--love.window.setMode(modes[1].width,modes[1].height)
	--love.window.setFullscreen(true)
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
