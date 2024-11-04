anim8 = require("lib.anim8")
require("utils.table")
require("utils.vector")
require("utils.sound")
require("utils.shaders")
require("utils.particles")
require("utils.menu")
require("sprite.sprites")
require("sprite.player.bullet")
require("sprite.player.player")
require("sprite.enemy.enemy_bullet")
require("sprite.enemy.enemy")
require("sprite.enemy.enemy_boss")
require("sprite.stars")

game_manager = {}
game_manager.enemies = {}
game_manager.enemy_bullets = {}
game_manager.enemy_boss = {}
game_manager.orbit_enemies = {}
game_manager.orbit_radius = 0.0
game_manager.wave1 = {}
game_manager.wave_no = 0
game_manager.state = "menu"

function draw_health_bar(x, y, width, height, border_width, health, total_health, ratio)
    local rectangles = {
        { x = x,                        y = y,                         width = width,        height = border_width },
        { x = x,                        y = y + border_width,          width = border_width, height = height - border_width * 2 },
        { x = x + width - border_width, y = y + border_width,          width = border_width, height = height - border_width * 2 },
        { x = x,                        y = y + height - border_width, width = width,        height = border_width } }

    local _, _, _, a = love.graphics.getColor()
    love.graphics.setColor(0.92, 0.91, 0.91, a)

    for i = 1, #rectangles do
        love.graphics.rectangle("fill", rectangles[i].x, rectangles[i].y, rectangles[i].width, rectangles[i].height)
    end

    if (health / total_health) <= (ratio) then
        love.graphics.setColor(0.93, 0.19, 0.19, a)
    else
        love.graphics.setColor(0.15, 0.81, 0.51, a)
    end

    width = (width - border_width * 2) * (health / total_health)

    love.graphics.rectangle("fill", x + border_width, y + border_width, width,
        height - border_width * 2)

    love.graphics.setColor(1, 1, 1, a)
end

function game_manager.wave1:init()
    for i = 1, 10 do
        game_manager.enemies[i] = copy_table(enemy, false)
        game_manager.enemies[i].delay = 0.600 * i
        game_manager.enemies[i].shoot_laser_timer = game_manager.enemies[i].shoot_laser_timer + 0.600 * i
        game_manager.enemies[i].wave = 1

        if i <= 5 then
            game_manager.enemies[i].health = 1
            game_manager.enemies[i].total_health = 1
            game_manager.enemies[i].sprite = sprites.enemy1
            game_manager.enemies[i].rotational_velocity = 40
            game_manager.enemies[i].width = sprites.enemy1:getWidth()
            game_manager.enemies[i].height = sprites.enemy1:getHeight()
            game_manager.enemies[i].origin.x = game_manager.enemies[i].width / 2
            game_manager.enemies[i].origin.y = game_manager.enemies[i].height / 2
            game_manager.enemies[i].fleet = 1
        else
            game_manager.enemies[i].health = 2
            game_manager.enemies[i].total_health = 2
            game_manager.enemies[i].delay = game_manager.enemies[i].delay + 3.0
            game_manager.enemies[i].sprite = sprites.enemy2
            game_manager.enemies[i].rotational_velocity = 50
            game_manager.enemies[i].width = sprites.enemy2:getWidth()
            game_manager.enemies[i].height = sprites.enemy2:getHeight()
            game_manager.enemies[i].origin.x = game_manager.enemies[i].width / 2
            game_manager.enemies[i].origin.y = game_manager.enemies[i].height / 2
            game_manager.enemies[i].fleet = 2
        end
    end
    game_manager.wave_no = 1
end

function game_manager.wave1:update(dt)
    if #game_manager.enemies == 0 then
        game_manager.current_wave = game_manager.wave2
        game_manager.current_wave:init()
    end
end

function game_manager.wave1:draw()

end

game_manager.wave2 = {}

function game_manager.wave2:init()
    local y_offset = (virtual_height - 100) / 5
    local destination = create_vector()
    destination.y = y_offset

    for i = 1, 10 do
        game_manager.enemies[i] = copy_table(enemy, false)
        game_manager.enemies[i].delay = 0.600 * i
        game_manager.enemies[i].shoot_laser_timer = game_manager.enemies[i].shoot_laser_timer + 0.600 * i
        game_manager.enemies[i].wave = 2
        game_manager.enemies[i].health = 1
        game_manager.enemies[i].total_health = 1

        if i <= 5 then
            game_manager.enemies[i].sprite = sprites.enemy3
            game_manager.enemies[i].linear_velocity = 250
            game_manager.enemies[i].position.x = -sprites.enemy3:getWidth() / 2
            game_manager.enemies[i].position.y = 50
            destination.x = virtual_width + sprites.enemy3:getWidth() / 2
            game_manager.enemies[i].direction = destination - game_manager.enemies[i].position
            game_manager.enemies[i].width = sprites.enemy3:getWidth()
            game_manager.enemies[i].height = sprites.enemy3:getHeight()
            game_manager.enemies[i].origin.x = game_manager.enemies[i].width / 2
            game_manager.enemies[i].origin.y = game_manager.enemies[i].height / 2
            game_manager.enemies[i].fleet = 1
        else
            game_manager.enemies[i].delay = game_manager.enemies[i].delay + 6.0
            game_manager.enemies[i].sprite = sprites.enemy4
            game_manager.enemies[i].linear_velocity = 300
            game_manager.enemies[i].position.x = virtual_width + sprites.enemy4:getWidth() / 2
            game_manager.enemies[i].position.y = 50
            destination.x = -sprites.enemy4:getWidth() / 2
            game_manager.enemies[i].direction = destination - game_manager.enemies[i].position
            game_manager.enemies[i].width = sprites.enemy4:getWidth()
            game_manager.enemies[i].height = sprites.enemy4:getHeight()
            game_manager.enemies[i].origin.x = game_manager.enemies[i].width / 2
            game_manager.enemies[i].origin.y = game_manager.enemies[i].height / 2
            game_manager.enemies[i].fleet = 2
        end
        normalize_vector(game_manager.enemies[i].direction)
    end
    game_manager.wave_no = 2
    stars.scale = 40
end

function game_manager.wave2:update(dt)
    for i = #game_manager.enemies, 1, -1 do
        if game_manager.enemies[i].position.y + game_manager.enemies[i].origin.y > virtual_height + 100 then
            table.remove(game_manager.enemies, i)
        end
    end

    if #game_manager.enemies == 0 then
        game_manager.current_wave = game_manager.wave3
        game_manager.current_wave:init()
    end
end

function game_manager.wave2:draw()

end

game_manager.wave3 = { alpha_timer = 0.0 }

function game_manager.wave3:init()
    game_manager.enemy_boss = copy_table(enemy_boss, false)
    game_manager.enemy_boss.linear_velocity = 350
    game_manager.orbit_radius = enemy_boss.width + 50
    game_manager.enemy_boss.health = 10
    game_manager.enemy_boss.total_health = 10

    local enemy_boss_diameter = game_manager.orbit_radius * 2

    local axis_length = virtual_width / 2 - (enemy_boss_diameter / 2 + 25)

    for i = 1, 12 do
        local degree = 90 - (i - 1) * 30
        game_manager.enemy_boss.positions[i] = create_vector()
        game_manager.enemy_boss.positions[i].x = virtual_width / 2 + math.cos(math.rad(degree)) * axis_length
        game_manager.enemy_boss.positions[i].y = virtual_height / 2 + -math.sin(math.rad(degree)) * axis_length
    end

    shuffle_table(game_manager.enemy_boss.positions)

    for i = 1, 8 do
        game_manager.orbit_enemies[i] = copy_table(enemy, false)
        game_manager.orbit_enemies[i].wave = 3
        game_manager.orbit_enemies[i].delay = 3.0

        game_manager.orbit_enemies[i].health = 2
        game_manager.orbit_enemies[i].total_health = 2
        game_manager.orbit_enemies[i].sprite = sprites.orbit_enemy
        game_manager.orbit_enemies[i].rotation = (i - 1) * 45
        game_manager.orbit_enemies[i].rotational_velocity = 200
        game_manager.orbit_enemies[i].width = sprites.orbit_enemy:getWidth()
        game_manager.orbit_enemies[i].height = sprites.orbit_enemy:getHeight()
        game_manager.orbit_enemies[i].origin.x = game_manager.orbit_enemies[i].width / 2
        game_manager.orbit_enemies[i].origin.y = game_manager.orbit_enemies[i].height / 2
        game_manager.orbit_enemies[i].fleet = 1
    end
    game_manager.wave_no = 3
    stars.scale = 40
end

function game_manager.wave3:update(dt)
    if game_manager.current_wave.alpha_timer < 1.5 then
        game_manager.current_wave.alpha_timer = game_manager.current_wave.alpha_timer + dt
    end

    if not game_manager.enemy_boss.is_removed then
        game_manager.enemy_boss:update(dt)
    end

    for i = 1, #game_manager.orbit_enemies do
        game_manager.orbit_enemies[i]:update(dt)
    end

    for i = #game_manager.orbit_enemies, 1, -1 do
        if game_manager.orbit_enemies[i].is_removed then
            table.remove(game_manager.orbit_enemies, i)
        end
    end
end

function game_manager.wave3:draw()
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(r, g, b, game_manager.current_wave.alpha_timer / 1.5)

    game_manager.enemy_boss:draw()

    if not game_manager.enemy_boss.is_removed then
        draw_health_bar(game_manager.enemy_boss.position.x - game_manager.enemy_boss.origin.x,
            game_manager.enemy_boss.position.y - game_manager.enemy_boss.origin.y - 25, game_manager.enemy_boss.width, 20,
            5,
            game_manager.enemy_boss.health, game_manager.enemy_boss.total_health, 30 / 100)
    end

    for i = 1, #game_manager.orbit_enemies do
        game_manager.orbit_enemies[i]:draw()
    end
    love.graphics.setColor(r, g, b, a)
end

game_manager.current_wave = game_manager.wave1

function game_manager:load()
    love.mouse.setVisible(false)
    menu:init()
    game_manager.current_wave:init()
    particles.enemy_destroyed:load()
    stars:load()
end

function game_manager:update(dt)
    stars:update(dt)
    if self.state == "menu" then
        menu:update(dt)
    elseif self.state == "game" then
        player:update(dt)

        for i = #self.enemy_bullets, 1, -1 do
            local is_removed = self.enemy_bullets[i]:update(dt)
            if is_removed then
                table.remove(self.enemy_bullets, i)
            end
        end
        particles.enemy_destroyed:update(dt)

        if stars.scale ~= 2.0 then
            return
        end

        for i = 1, #self.enemies do
            self.enemies[i]:update(dt)
        end

        for i = #self.enemies, 1, -1 do
            if self.enemies[i].is_removed then
                table.remove(self.enemies, i)
            end
        end

        self.current_wave:update(dt)
    end
end

function game_manager:draw()
    stars:draw()
    if self.state == "menu" then
        menu:draw()
    elseif self.state == "game" then
        player:draw()

        for i = 1, #self.enemies do
            self.enemies[i]:draw()
        end
        for i = 1, #self.enemy_bullets do
            self.enemy_bullets[i]:draw(sprites.enemy_bullet)
        end
        self.current_wave:draw()
        particles.enemy_destroyed:draw()
    end
end

function game_manager:keypressed(key)
    if self.state == "menu" then
        menu:keypressed(key)
    end
end
