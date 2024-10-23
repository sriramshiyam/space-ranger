player = {}

player.bullets = {}
player.shoot_laser_timer = 0.0

player.linear_velocity = 380

player.grid = anim8.newGrid(64, 64, sprites.player:getWidth(), sprites.player:getHeight())

player.direction = create_vector()
player.position = create_vector()

player.position.x = virtual_width / 2 - player.grid.frameWidth / 2
player.position.y = virtual_height - player.grid.frameHeight

player.animation = {}

player.animation.anim1 = anim8.newAnimation(player.grid('1-2', 1), 0.1)
player.animation.anim2 = anim8.newAnimation(player.grid('1-2', 2), 0.1)


function player:update(dt)
    self.current_anim = self.animation.anim1
    self.linear_velocity = 380

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
        self.fire_bullet(self)
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

    for i = #self.bullets, 1, -1 do
        local is_removed = self.bullets[i]:update(dt)
        if is_removed then
            table.remove(self.bullets, i)
        end
    end
end

function player:draw()
    self.current_anim:draw(sprites.player, self.position.x, self.position.y)
    for i = 1, #self.bullets do
        self.bullets[i]:draw()
    end
end

function player:fire_bullet()
    local bullet = copy_table(bullet, true)
    bullet.direction.y = -1
    bullet.linear_velocity = 900
    bullet.position.x = self.position.x + self.grid.frameWidth / 2 - sprites.bullet:getWidth() / 2
    bullet.position.y = self.position.y - sprites.bullet:getHeight()
    math.randomseed(os.time())
    bullet.drift_direciton = math.random(-1, 1)
    table.insert(self.bullets, bullet)
end
