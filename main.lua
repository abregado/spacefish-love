require("registry")

function love.load()
	Gamestate.registerEvents()
    Gamestate.switch(scenes.play)
end

function love.draw()
	love.graphics.print("Love is working")
end

function love.update(dt)

end

function love.mousepressed(x,y,button)
	print("mouseclicked "..button)
end
