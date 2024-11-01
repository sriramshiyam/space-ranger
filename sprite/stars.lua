stars = {}
stars.list = {}
stars.grid = anim8.newGrid(4, 8, sprites.star:getWidth(), sprites.star:getHeight())
stars.anim = anim8.newAnimation(stars.grid('1-2', 1), 0.1)
stars.stars_spawn_timer = 0.0

star = {}
star.direction = create_vector()
star.position = create_vector()
star.linear_velocity = 0.0
star.scale = 1
star.alpha = 1
star.is_calculating = false

function stars:load()
    for i = 1, 20 do
        for _ = 1, 10 do
            local star = copy_table(star, false)

            star.direction.x = 0
            star.direction.y = 1
            star.linear_velocity = math.random(50, 150)
            star.alpha = math.random(0.6, 0.7)

            star.position.x = math.random(self.grid.frameWidth + 10, virtual_width - (self.grid.frameWidth + 10))
            star.position.y = math.random(-25, 40) + i * 115
            table.insert(self.list, star)
        end
    end
end

function stars:update(dt)
    self.stars_spawn_timer = self.stars_spawn_timer - dt

    if self.stars_spawn_timer <= 0.0 then
        self.stars_spawn_timer = 1.0

        math.randomseed(os.time())

        for _ = 1, 10 do
            local star = copy_table(star, false)

            star.direction.x = 0
            star.direction.y = 1
            star.linear_velocity = math.random(50, 150)
            star.alpha = math.random(0.6, 0.7)

            star.position.x = math.random(self.grid.frameWidth + 10, virtual_width - (self.grid.frameWidth + 10))
            star.position.y = math.random(-25, 40)
            table.insert(self.list, star)
        end
    end

    for i = #self.list, 1, -1 do
        self.list[i].position = self.list[i].position + (self.list[i].direction * self.list[i].linear_velocity * dt)
        if self.list[i].position.y > virtual_height then
            table.remove(self.list, i)
        end
    end

    self.anim:update(dt)
end

function stars:draw()
    local r, g, b, a = love.graphics.getColor()
    for i = 1, #self.list do
        love.graphics.setColor(r, g, b, self.list[i].alpha)
        self.anim:draw(sprites.star, self.list[i].position.x, self.list[i].position.y, 0, 1, self.list[i].scale)
    end
    love.graphics.setColor(r, g, b, a)
end
