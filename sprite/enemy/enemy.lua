enemy = {}

enemy.bullets = {}
enemy.shoot_laser_timer = 0.0

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
enemy.delay = 0.200
enemy.is_removed = false
enemy.despawn = false

enemy.scale_timer = 0.0

function enemy:update(dt)
    if self.is_removed then
        return
    end

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

    self.position.x = x_origin + math.cos(math.rad(self.rotation)) * x_length
    self.position.y = y_origin + -math.sin(math.rad(self.rotation)) * y_length

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
end

function enemy:draw()
    love.graphics.draw(sprites.enemy, self.position.x, self.position.y,
        math.rad((self.rotation_lap_no == 0 and 0 or -180) + -self.rotation), self.scale, nil,
        self.origin.x,
        self.origin.y)
end
