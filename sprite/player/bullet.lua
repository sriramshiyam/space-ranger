bullet = {}
bullet.linear_velocity = 0.0
bullet.position = create_vector()
bullet.direction = create_vector()
bullet.drift_direciton = 0.0
bullet.drift_timer = 0.0

function bullet:update(dt)
    self.position = self.position +
        (self.direction * self.linear_velocity * dt)

    self.drift_timer = self.drift_timer + dt

    if self.drift_timer > 0.200 then
        self.drift_timer = 0.0
        self.position.x = self.position.x + self.drift_direciton * 8.5
    end

    return (self.position.y + sprites.bullet:getHeight() < 0 or
        self.position.x + sprites.bullet:getWidth() < 0 or
        self.position.y > virtual_height or
        self.position.x > virtual_width)
end

function bullet:draw(sprite)
    love.graphics.draw(sprites.bullet, self.position.x, self.position.y)
end