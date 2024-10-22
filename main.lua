virtualHeight = 1000
virtualWidth = 1000

local canvas

canvasOffsetX = 0
canvasOffsetY = 0

function draw_canvas()
    local windowWidth, windowHeight = love.graphics.getDimensions()

    local scale = math.min(windowWidth / virtualWidth, windowHeight / virtualHeight)

    canvasOffsetX = (windowWidth - virtualWidth * scale) / 2
    canvasOffsetY = (windowHeight - virtualHeight * scale) / 2

    love.graphics.draw(canvas, canvasOffsetX, canvasOffsetY, 0, scale, scale)
end

anim8 = require "lib.anim8"
require("utils.table")
require("utils.vector")
require("utils.sound")
require("sprite.bullet")
require("sprite.player")

function love.load()
    love.window.setTitle("Space Shooter")
    love.window.setMode(800, 600, { resizable = true, vsync = 0, minwidth = 400, minheight = 3 })
    love.window.maximize()

    canvas = love.graphics.newCanvas(virtualWidth, virtualHeight)
end

function love.update(dt)
    player:update(dt)
    -- require("debug_lib.lovebird").update()
end

function love.draw()
    love.graphics.clear(0.13, 0.13, 0.13, 1)
    love.graphics.setCanvas(canvas)
    love.graphics.clear(0, 0, 0, 1)
    player:draw()
    love.graphics.setCanvas()
    draw_canvas()
end
