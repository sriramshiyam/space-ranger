bullet = {}
bullet.linear_velocity = 0.0
bullet.position = create_vector()
bullet.direction = create_vector()
bullet.drift_direciton = 0.0
bullet.drift_timer = 0.0

function bullet:update(dt)
    if self.is_destroyed then
        return true
    end
    self.position = self.position +
        (self.direction * self.linear_velocity * dt)

    self.drift_timer = self.drift_timer + dt

    if self.drift_timer > 0.200 then
        self.drift_timer = 0.0
        self.position.x = self.position.x + self.drift_direciton * 8.5
    end

    local enemy_lists = { game_manager.enemies, game_manager.orbit_enemies }

    for j = 1, #enemy_lists do
        local list = enemy_lists[j]
        for i = 1, #list do
            if list[i].scale_timer >= 1.0 and calculate_distance(self.position, list[i].position) <= 30 then
                list[i].health = list[i].health - 1
                if list[i].health == 0 then
                    list[i].is_removed = true
                    particles.enemy_destroyed.particle:setPosition(list[i].position.x,
                        list[i].position.y)
                    local blast = copy_table(blast, false)
                    blast:init()
                    blast.position.x = list[i].position.x
                    blast.position.y = list[i].position.y
                    table.insert(game_manager.blasts, blast)
                    particles.enemy_destroyed.particle:emit(30)
                    sounds.enemy_explode:stop()
                    sounds.enemy_explode:play()
                else
                    list[i].is_attacked = true
                    sounds.enemy_attacked:stop()
                    sounds.enemy_attacked:play()
                end
                return true
            end
        end
    end

    -- print(game_manager.enemy_boss.delay_timer)
    if game_manager.wave_no == 3 and not game_manager.enemy_boss.is_removed and not game_manager.enemy_boss.is_moving and game_manager.enemy_boss.delay_timer >= 3.0 and calculate_distance(self.position, game_manager.enemy_boss.position) <= 40 then
        game_manager.enemy_boss.health = game_manager.enemy_boss.health - 1
        if game_manager.enemy_boss.health == 0 then
            game_manager.enemy_boss.is_removed = true
            particles.enemy_destroyed.particle:setPosition(game_manager.enemy_boss.position.x,
                game_manager.enemy_boss.position.y)
            local blast = copy_table(blast, false)
            blast:init()
            blast.position.x = game_manager.enemy_boss.position.x
            blast.position.y = game_manager.enemy_boss.position.y
            blast.scale = 1.5
            table.insert(game_manager.blasts, blast)
            particles.enemy_destroyed.particle:emit(100)
            sounds.enemy_explode:stop()
            sounds.enemy_explode:play()
        else
            game_manager.enemy_boss.is_attacked = true
            sounds.enemy_attacked:stop()
            sounds.enemy_attacked:play()
        end
        return true
    end

    return (self.position.y + sprites.bullet:getHeight() < 0 or
        self.position.x + sprites.bullet:getWidth() < 0 or
        self.position.y > virtual_height or
        self.position.x > virtual_width)
end

function bullet:draw(sprite)
    love.graphics.draw(sprite, self.position.x, self.position.y)
end
