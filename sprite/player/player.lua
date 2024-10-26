player = {}

player.bullets = {}
player.shoot_laser_timer = 0.0

player.linear_velocity = 380

player.grid = anim8.newGrid(64, 64, sprites.player:getWidth(), sprites.player:getHeight())

player.direction = create_vector()
player.position = create_vector()

player.position.x = virtual_width / 2
player.position.y = virtual_height - player.grid.frameHeight
player.origin = { x = player.grid.frameWidth / 2, y = player.grid.frameHeight / 2 }


player.animation = {}

player.animation.anim1 = anim8.newAnimation(player.grid('1-2', 1), 0.1)
player.animation.anim2 = anim8.newAnimation(player.grid('1-2', 2), 0.1)

player.is_attacked = false
player.attacked_effect_timer = 0.300
player.attacked_effect_direction = -1
player.attacked_effect_count = 0

function player:update(dt)
    self.current_anim = self.animation.anim1

    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        self.direction.x = 1.0
    elseif love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        self.direction.x = -1.0
    end

    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        self.direction.y = 1.0
    elseif love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        self.direction.y = -1.0
        self.current_anim = self.animation.anim2
        self.linear_velocity = 500
    end

    if love.keyboard.isDown("space") and self.shoot_laser_timer == 0.0 then
        self:fire_bullet()
        sounds.player_laser:play()
        self.shoot_laser_timer = self.shoot_laser_timer + dt
    elseif self.shoot_laser_timer ~= 0.0 then
        self.shoot_laser_timer = self.shoot_laser_timer + dt
        if self.shoot_laser_timer > 0.300 then
            self.shoot_laser_timer = 0.0
        end
    end

    self.position = self.position + (self.direction * self.linear_velocity * dt)

    self.current_anim:update(dt)

    self.direction.x = 0
    self.direction.y = 0

    if self.is_attacked then
        self:handle_attacked_state(dt)
    end

    for i = #self.bullets, 1, -1 do
        local is_removed = self.bullets[i]:update(dt)
        if is_removed then
            table.remove(self.bullets, i)
        end
    end

    for i = 1, #game_manager.enemies do
        if game_manager.enemies[i].scale_timer >= 1.0 and calculate_distance(self.position, game_manager.enemies[i].position) <= 30 then
            game_manager.enemies[i].is_removed = true
            particles.enemy_destroyed.particle:setPosition(game_manager.enemies[i].position.x,
                game_manager.enemies[i].position.y)
            particles.enemy_destroyed.particle:emit(30)
            sounds.enemy_explode:stop()
            sounds.enemy_explode:play()
            self.is_attacked = true
        end
    end
end

function player:draw()
    if self.is_attacked then
        love.graphics.setShader(shaders.player_attacked)
    end
    self.current_anim:draw(sprites.player, self.position.x, self.position.y, 0, 1, nil, self.origin.x, self.origin.y)
    if self.is_attacked then
        love.graphics.setShader()
    end
    for i = 1, #self.bullets do
        self.bullets[i]:draw(sprites.bullet)
    end
end

function player:fire_bullet()
    local bullet = copy_table(bullet, true)
    bullet.direction.y = -1
    bullet.linear_velocity = 900
    bullet.position.x = self.position.x - sprites.bullet:getWidth() / 2
    bullet.position.y = self.position.y - self.origin.y - sprites.bullet:getHeight()
    math.randomseed(os.time())
    bullet.drift_direciton = math.random(-1, 1)
    table.insert(self.bullets, bullet)
end

function player:handle_attacked_state(dt)
    self.attacked_effect_timer = self.attacked_effect_timer + (self.attacked_effect_direction) * dt

    local red = math.abs(self.attacked_effect_timer / 0.300)
    shaders.player_attacked:send("red", red)

    if self.attacked_effect_count < 2 then
        if self.attacked_effect_timer >= 0.300 then
            self.attacked_effect_direction = -1
            self.attacked_effect_timer = 0.299
            self.attacked_effect_count = self.attacked_effect_count + 1
        elseif self.attacked_effect_timer <= -0.300 then
            self.attacked_effect_direction = 1
            self.attacked_effect_timer = -0.299
            self.attacked_effect_count = self.attacked_effect_count + 1
        end
    else
        if self.attacked_effect_timer >= 0.0 then
            self.is_attacked = false
            player.attacked_effect_timer = 0.300
            player.attacked_effect_direction = -1
            player.attacked_effect_count = 0
        end
    end
end
