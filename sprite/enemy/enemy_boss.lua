enemy_boss = {}

enemy_boss.position = create_vector()
enemy_boss.direction = create_vector()
enemy_boss.is_removed = false
enemy_boss.health = 0
enemy_boss.total_health = 0
enemy_boss.shoot_laser_count = 3
enemy_boss.shoot_laser_timer = 0.0
enemy_boss.attacked_effect_timer = 0.400
enemy_boss.linear_velocity = 0.0
enemy_boss.is_moving = true
enemy_boss.is_attacked = false

enemy_boss.sprite = sprites.enemy_boss
enemy_boss.width = sprites.enemy_boss:getWidth()
enemy_boss.height = sprites.enemy_boss:getHeight()
enemy_boss.origin = { x = enemy_boss.width / 2, y = enemy_boss.height / 2 }

enemy_boss.position.x = virtual_width / 2
enemy_boss.position.y = virtual_height / 2
enemy_boss.delay_timer = 0.0
enemy_boss.positions = {}
enemy_boss.current_position = 1

function enemy_boss:update(dt)
    if self.is_moving then
        self:move(dt)
    end
    self.delay_timer = self.delay_timer + dt

    if self.delay_timer < 1.5 then
        return
    end

    if self.shoot_laser_count < 4 then
        self:fire_bullets(dt)
    else
        self.is_moving = true
    end

    if self.is_attacked then
        self:handle_attacked_state(dt)
    end
end

function enemy_boss:draw()
    if self.is_removed then
        return
    end
    if self.is_attacked then
        love.graphics.setShader(shaders.enemy_attacked)
    end
    love.graphics.draw(self.sprite, self.position.x, self.position.y, 0, 1, nil, self.origin.x, self.origin.y)
    if self.is_attacked then
        love.graphics.setShader()
    end
end

function enemy_boss:fire_bullets(dt)
    self.shoot_laser_timer = self.shoot_laser_timer - dt

    if self.shoot_laser_timer <= 0.0 then
        self.shoot_laser_timer = 0.500
        self.shoot_laser_count = self.shoot_laser_count + 1

        if self.shoot_laser_count < 4 then
            for i = 0, 360, 30 do
                local bullet = copy_table(enemy_bullet, false)
                bullet.direction.x = math.cos(math.rad(i))
                bullet.direction.y = math.sin(math.rad(i))

                bullet.linear_velocity = 200
                bullet.position = self.position
                bullet.shake_direction.x = 0
                bullet.shake_direction.y = 0

                table.insert(game_manager.enemy_bullets, bullet)
            end
            sounds.enemy_boss_laser:play()
        end
    end
end

function enemy_boss:move(dt)
    local direction = self.positions[self.current_position] - self.position
    normalize_vector(direction)
    -- print(direction.x, direction.y)
    self.position = self.position + direction * self.linear_velocity * dt
    -- local coord = "position" ..
    --     " x:" ..
    --     tostring(self.position.x) ..
    --     " y:" ..
    --     tostring(self.position.y) ..
    --     " dest" ..
    --     " x:" ..
    --     tostring(self.positions[self.current_position].x) .. " y:" .. tostring(self.positions[self.current_position].y)
    -- print(coord)

    if calculate_distance(self.positions[self.current_position], self.position) < 5.0 then
        self.is_moving = false
        self.shoot_laser_count = 0
        self.shoot_laser_timer = 0.0
        self.current_position = self.current_position + 1
        if self.current_position > #self.positions then
            self.current_position = 1
            shuffle_table(self.positions)
        end
    end
end

function enemy_boss:handle_attacked_state(dt)
    self.attacked_effect_timer = self.attacked_effect_timer - dt

    local white = math.abs(self.attacked_effect_timer / 0.400)
    shaders.enemy_attacked:send("white", white)

    if self.attacked_effect_timer < 0.0 then
        self.attacked_effect_timer = 0.400
        self.is_attacked = false
    end
end

function draw_health_bar(x, y, width, height, border_width, health, total_health, ratio)
    local rectangles = {
        { x = x,                        y = y,                         width = width,        height = border_width },
        { x = x,                        y = y + border_width,          width = border_width, height = height - border_width * 2 },
        { x = x + width - border_width, y = y + border_width,          width = border_width, height = height - border_width * 2 },
        { x = x,                        y = y + height - border_width, width = width,        height = border_width } }

    love.graphics.setColor(0.92, 0.91, 0.91, 1)

    for i = 1, #rectangles do
        love.graphics.rectangle("fill", rectangles[i].x, rectangles[i].y, rectangles[i].width, rectangles[i].height)
    end

    if (self.health / self.total_health) < (ratio) then
        love.graphics.setColor(0.93, 0.19, 0.19, 1)
    else
        love.graphics.setColor(0.15, 0.81, 0.51, 1)
    end

    width = (width - border_width * 2) * (health / total_health)

    love.graphics.rectangle("fill", x + border_width, y + border_width, width,
        height - border_width * 2)

    love.graphics.setColor(1, 1, 1, 1)
end
