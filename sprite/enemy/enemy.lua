enemy = {}
enemy.wave = 0
enemy.fleet = 0

enemy.shoot_laser_timer = 2.0
enemy.health = 0
enemy.is_attacked = false
enemy.attacked_effect_timer = 0.400
enemy.shoot_laser_count = 0

enemy.linear_velocity = 0.0
enemy.rotational_velocity = 0
enemy.rotation_lap_no = 0.0

enemy.direction = create_vector()
enemy.position = create_vector()
enemy.width = sprites.enemy1:getWidth()
enemy.height = sprites.enemy1:getHeight()
enemy.origin = { x = enemy.width / 2, y = enemy.height / 2 }

enemy.position.x = virtual_width / 2
enemy.position.y = virtual_height / 2
enemy.rotation_offset = -90.0
enemy.rotation = enemy.rotation_offset
enemy.scale = 0.0
enemy.delay = 0.0
enemy.is_removed = false
enemy.despawn = false
enemy.scale_timer = 0.0

enemy.shake_direction = create_vector()
enemy.shake_scale = 1

function enemy:update(dt)
    if self.is_removed then
        return
    end

    if self.wave == 3 then
        self:wave3_update(dt)
    end

    if self.delay > 0.0 then
        self.delay = self.delay - dt
        return
    end

    if self.scale_timer < 1.0 then
        self.scale = 1 * self.scale_timer / 1.0
        self.scale_timer = self.scale_timer + dt
    end

    if self.position.x > 0 and self.position.x < virtual_width then
        self.shoot_laser_timer = self.shoot_laser_timer - dt
    end

    if self.wave ~= 3 and self.shoot_laser_timer <= 0.0 then
        self:fire_bullet()
        sounds.enemy_laser:play()
        self.shoot_laser_timer = 2.0
    end

    if self.wave == 1 then
        self:wave1_update(dt)
    elseif self.wave == 2 then
        self:wave2_update(dt)
    end

    if self.is_attacked then
        self:handle_attacked_state(dt)
    end
end

function enemy:draw()
    if self.is_attacked then
        love.graphics.setShader(shaders.enemy_attacked)
    end
    if self.wave == 1 then
        self:wave1_draw()
    elseif self.wave == 2 then
        self:wave2_draw()
    elseif self.wave == 3 then
        self:wave3_draw()
    end
    if self.is_attacked then
        love.graphics.setShader()
    end
end

function enemy:fire_bullet()
    self.shoot_laser_count = self.shoot_laser_count + 1
    local bullet = copy_table(enemy_bullet, true)
    bullet.direction = player.position - self.position

    normalize_vector(bullet.direction)

    bullet.linear_velocity = 150
    bullet.position = self.position
    bullet.shake_direction = rotate_vector(bullet.direction, 90)

    table.insert(game_manager.enemy_bullets, bullet)
end

function enemy:handle_attacked_state(dt)
    self.attacked_effect_timer = self.attacked_effect_timer - dt

    local white = math.abs(self.attacked_effect_timer / 0.400)
    shaders.enemy_attacked:send("white", white)

    if self.attacked_effect_timer < 0.0 then
        self.attacked_effect_timer = 0.400
        self.is_attacked = false
    end
end

function enemy:wave1_update(dt)
    self.rotation = self.rotation + (self.rotation_lap_no == 0 and 1 or -1) * (dt * self.rotational_velocity)

    local x_offset = 50
    local x_origin = virtual_width / 2
    local x_length = virtual_width - x_offset - x_origin

    local y_offset = 50
    local y_length = (virtual_height / 2 - y_offset) / 2
    local y_origin = y_offset + y_length + (y_length * self.rotation_lap_no * 2)

    local cosine = math.cos(math.rad(self.rotation))
    local sine = -math.sin(math.rad(self.rotation))

    self.position.x = x_origin + cosine * x_length
    self.position.y = y_origin + sine * y_length

    self.shake_direction = rotate_vector({ x = cosine, y = sine }, 180)
    self.position = self.position + self.shake_direction * self.shake_scale * 1.55
    self.shake_scale = self.shake_scale * -1

    if self.rotation_lap_no == 0 and self.rotation >= (360.0 + self.rotation_offset) then
        self.rotation_lap_no = self.rotation_lap_no + 1
        self.rotation_offset = -270
        self.rotation = self.rotation_offset
    elseif self.rotation_lap_no == 1 and self.rotation <= (-360.0 + self.rotation_offset) then
        self.rotation_lap_no = self.rotation_lap_no - 1
        self.rotation_offset = -90
        self.rotation = self.rotation_offset
    end
end

function enemy:wave2_update(dt)
    if (self.position.x > virtual_width + 100 and self.direction.x > 0.0) or
        (self.position.x < -100 and self.direction.x < 0.0) then
        self.direction.x = -self.direction.x
        if self.position.y > (50 + (virtual_height - 100) / 5 * 4 + 100) then
            self.is_removed = true
        end
    end

    self.shake_direction = create_vector()
    self.shake_direction.x = 0
    self.shake_direction.y = 1
    self.position = self.position + self.shake_direction * self.shake_scale * 1.55
    self.shake_scale = self.shake_scale * -1

    self.position = self.position + self.direction * self.linear_velocity * dt
end

function enemy:wave3_update(dt)
    self.rotation = self.rotation + (dt * self.rotational_velocity)

    self.position.x = game_manager.enemy_boss.position.x + math.cos(math.rad(self.rotation)) * game_manager.orbit_radius
    self.position.y = game_manager.enemy_boss.position.y + math.sin(math.rad(self.rotation)) * game_manager.orbit_radius

    if game_manager.enemy_boss.is_moving then
        self.shoot_laser_count = 0
    end

    if not game_manager.enemy_boss.is_moving and
        game_manager.enemy_boss.shoot_laser_count == 1 and
        self.shoot_laser_count == 0 then
        self:fire_bullet()
        sounds.enemy_laser:play()
    end
end

function enemy:wave1_draw()
    love.graphics.draw(self.sprite, self.position.x, self.position.y,
        math.rad((self.rotation_lap_no == 0 and 0 or -180) + -self.rotation), self.scale, nil,
        self.origin.x,
        self.origin.y)
end

function enemy:wave2_draw()
    love.graphics.draw(self.sprite, self.position.x, self.position.y, 0,
        (self.direction.x < 0 and self.fleet == 1 and -1 or 1) * self.scale, nil,
        self.origin.x,
        self.origin.y)
end

function enemy:wave3_draw()
    love.graphics.draw(self.sprite, self.position.x, self.position.y,
        0, 1, nil, self.origin.x, self.origin.y)
end
