virtual_height = 1000
virtual_width = 1000

local canvas

canvasOffsetX = 0
canvasOffsetY = 0

anim8 = require("lib.anim8")
require("utils.table")
require("utils.vector")
require("utils.sound")
require("utils.shaders")
require("utils.particles")
require("sprite.sprites")
require("sprite.player.bullet")
require("sprite.player.player")
require("sprite.enemy.enemy_bullet")
require("sprite.enemy.enemy")

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
    enemies = {}
    enemy_bullets = {}
    enemies[1] = copy_table(enemy, false)
    enemies[2] = copy_table(enemy, false)
    enemies[3] = copy_table(enemy, false)

    for i = 1, 3 do
        enemies[i].delay = 0.500 * i
        enemies[i].shoot_laser_timer = enemies[i].shoot_laser_timer + 0.500 * i
    end

    canvas = love.graphics.newCanvas(virtual_width, virtual_height)
end

function love.update(dt)
    player:update(dt)
    for i = 1, #enemies do
        enemies[i]:update(dt)
    end
    for i = #enemies, 1, -1 do
        if enemies[i].is_removed then
            table.remove(enemies, i)
        end
    end
    particles.enemy_destroyed:update(dt)

    for i = #enemy_bullets, 1, -1 do
        local is_removed = enemy_bullets[i]:update(dt)
        if is_removed then
            table.remove(enemy_bullets, i)
        end
    end
    -- require("debug_lib.lovebird").update()
end

function love.draw()
    love.graphics.clear(0.13, 0.13, 0.13, 1)
    love.graphics.setCanvas(canvas)
    love.graphics.clear(0, 0, 0, 1)
    player:draw()
    for i = 1, #enemies do
        enemies[i]:draw()
    end
    for i = 1, #enemy_bullets do
        enemy_bullets[i]:draw(sprites.enemy_bullet)
    end
    love.graphics.draw(particles.enemy_destroyed)
    love.graphics.setCanvas()
    draw_canvas()
end
