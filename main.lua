virtual_height = 1000
virtual_width = 1000

local canvas

canvasOffsetX = 0
canvasOffsetY = 0


require("utils.game_manager")

function draw_canvas()
    local windowWidth, windowHeight = love.graphics.getDimensions()

    local scale = math.min(windowWidth / virtual_width, windowHeight / virtual_height)

    canvasOffsetX = (windowWidth - virtual_width * scale) / 2
    canvasOffsetY = (windowHeight - virtual_height * scale) / 2

    love.graphics.draw(canvas, canvasOffsetX, canvasOffsetY, 0, scale, scale)
end

function love.load()
    love.window.setTitle("Space Shooter")
    love.window.setMode(800, 600, { resizable = true, vsync = 0, minwidth = 400, minheight = 3 })
    love.window.maximize()
    game_manager:load()
    canvas = love.graphics.newCanvas(virtual_width, virtual_height)
end

function love.update(dt)
    game_manager:update(dt)
    -- require("debug_lib.lovebird").update()
end

function love.draw()
    love.graphics.clear(0.13, 0.13, 0.13, 1)
    love.graphics.setCanvas(canvas)
    love.graphics.clear(0, 0, 0, 1)
    game_manager:draw()
    love.graphics.setCanvas()
    draw_canvas()
end

function love.keypressed(key)
    game_manager:keypressed(key)
end
