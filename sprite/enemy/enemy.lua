enemy = {}

enemy.bullets = {}
enemy.shoot_laser_timer = 2.0

enemy.linear_velocity = 380
enemy.rotational_velocity = 35
enemy.rotation_lap_no = 0.0

enemy.direction = create_vector()
enemy.position = create_vector()
enemy.width = sprites.enemy:getWidth()
enemy.height = sprites.enemy:getHeight()
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

    self.shoot_laser_timer = self.shoot_laser_timer - dt

    if self.delay > 0.0 then
        self.delay = self.delay - dt
        return
    end

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

    self.position = self.position + self.shake_direction * self.shake_scale * 1.2
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

    if self.scale_timer < 1.0 then
        self.scale = 1 * self.scale_timer / 1.0
        self.scale_timer = self.scale_timer + dt
    end

    if self.shoot_laser_timer <= 0.0 then
        self:fire_bullet()
        sounds.enemy_laser:play()
        self.shoot_laser_timer = 2.0
    end
end

function enemy:draw()
    love.graphics.draw(sprites.enemy, self.position.x, self.position.y,
        math.rad((self.rotation_lap_no == 0 and 0 or -180) + -self.rotation), self.scale, nil,
        self.origin.x,
        self.origin.y)
end

function enemy:fire_bullet()
    local bullet = copy_table(enemy_bullet, true)
    bullet.direction = player.position - self.position

    normalize_vector(bullet.direction)

    bullet.linear_velocity = self.linear_velocity - 225
    bullet.position = self.position
    bullet.shake_direction = rotate_vector(bullet.direction, 90)

    table.insert(enemy_bullets, bullet)
end
