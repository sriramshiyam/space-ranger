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

    if self.position.y + player.bullet_sprite:getHeight() < 0 then
        return true
    end

    return false
end

function bullet:draw()
    love.graphics.draw(player.bullet_sprite, self.position.x, self.position.y)
end
