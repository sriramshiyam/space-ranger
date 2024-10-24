enemy_bullet = {}
enemy_bullet.linear_velocity = 0.0
enemy_bullet.position = create_vector()
enemy_bullet.direction = create_vector()
enemy_bullet.shake_direction = create_vector()
enemy_bullet.shake_scale = 1
enemy_bullet.origin = { x = sprites.enemy_bullet:getWidth() / 2, y = sprites.enemy_bullet:getHeight() / 2 }


function enemy_bullet:update(dt)
    self.position = self.position +
        (self.direction * self.linear_velocity * dt)

    self.position = self.position + self.shake_direction * self.shake_scale * 2.25
    self.shake_scale = self.shake_scale * -1

    if calculate_distance(self.position, player.position) <= 40 then
        sounds.player_attacked:stop()
        sounds.player_attacked:play()
        player.is_attacked = true;
        player.red_effect_timer = 0.300
        player.red_effect_direction = -1
        player.red_effect_count = 0
        return true
    end

    return (self.position.y + sprites.enemy_bullet:getHeight() < 0 or
        self.position.x + sprites.enemy_bullet:getWidth() < 0 or
        self.position.y > virtual_height or
        self.position.x > virtual_width)
end

function enemy_bullet:draw(sprite)
    love.graphics.draw(sprite, self.position.x, self.position.y)
end
