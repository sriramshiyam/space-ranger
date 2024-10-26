game_manager = {}
game_manager.enemies = {}
game_manager.enemy_bullets = {}

game_manager.wave1 = {}

function game_manager.wave1:init()
    for i = 1, 10 do
        game_manager.enemies[i] = copy_table(enemy, false)
        game_manager.enemies[i].delay = 0.600 * i
        game_manager.enemies[i].shoot_laser_timer = game_manager.enemies[i].shoot_laser_timer + 0.600 * i
        game_manager.enemies[i].wave = 1

        if i <= 5 then
            game_manager.enemies[i].health = 1
            game_manager.enemies[i].sprite = sprites.enemy1
            game_manager.enemies[i].rotational_velocity = 40
            game_manager.enemies[i].width = sprites.enemy1:getWidth()
            game_manager.enemies[i].height = sprites.enemy1:getHeight()
            game_manager.enemies[i].origin.x = game_manager.enemies[i].width / 2
            game_manager.enemies[i].origin.y = game_manager.enemies[i].height / 2
            game_manager.enemies[i].fleet = 1
        else
            game_manager.enemies[i].health = 2
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
end

function game_manager.wave2:update(dt)
    for i = #game_manager.enemies, 1, -1 do
        if game_manager.enemies[i].position.y + game_manager.enemies[i].origin.y > virtual_height + 100 then
            table.remove(game_manager.enemies, i)
        end
    end
end

function game_manager.wave2:draw()

end

game_manager.wave3 = {}

function game_manager.wave3:init()
end

function game_manager.wave3:update(dt)
end

function game_manager.wave3:draw()

end

game_manager.current_wave = game_manager.wave1

function game_manager:load()
    game_manager.current_wave:init()
    particles.enemy_destroyed:load()
end

function game_manager:update(dt)
    for i = 1, #self.enemies do
        self.enemies[i]:update(dt)
    end

    for i = #self.enemies, 1, -1 do
        if self.enemies[i].is_removed then
            table.remove(self.enemies, i)
        end
    end

    player:update(dt)
    game_manager.current_wave:update(dt)
    particles.enemy_destroyed:update(dt)

    for i = #self.enemy_bullets, 1, -1 do
        local is_removed = self.enemy_bullets[i]:update(dt)
        if is_removed then
            table.remove(self.enemy_bullets, i)
        end
    end
end

function game_manager:draw()
    player:draw()
    for i = 1, #self.enemies do
        self.enemies[i]:draw()
    end
    for i = 1, #self.enemy_bullets do
        self.enemy_bullets[i]:draw(sprites.enemy_bullet)
    end
    game_manager.current_wave:draw()
    particles.enemy_destroyed:draw()
end
