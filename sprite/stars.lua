stars = {}
stars.list = {}
stars.grid = anim8.newGrid(4, 8, sprites.star:getWidth(), sprites.star:getHeight())
stars.anim = anim8.newAnimation(stars.grid('1-2', 1), 0.1)
stars.stars_spawn_timer = 0.0
stars.data = { { x = 706, y = -1, alpha = 1.6, linear_velocity = 130 }, { x = 796, y = 10, alpha = 0.6, linear_velocity = 131 }, { x = 913, y = 22, alpha = 0.6, linear_velocity = 57 }, { x = 259, y = 2, alpha = 1.6, linear_velocity = 138 }, { x = 29, y = 14, alpha = 0.6, linear_velocity = 122 }, { x = 595, y = -22, alpha = 0.6, linear_velocity = 118 }, { x = 202, y = 29, alpha = 0.6, linear_velocity = 51 }, { x = 608, y = -14, alpha = 0.6, linear_velocity = 147 }, { x = 710, y = 29, alpha = 0.6, linear_velocity = 122 }, { x = 364, y = 38, alpha = 0.6, linear_velocity = 130 }, { x = 901, y = 16, alpha = 0.6, linear_velocity = 135 }, { x = 519, y = 28, alpha = 0.6, linear_velocity = 91 }, { x = 542, y = -19, alpha = 0.6, linear_velocity = 81 }, { x = 931, y = -18, alpha = 1.6, linear_velocity = 98 }, { x = 563, y = 16, alpha = 0.6, linear_velocity = 71 }, { x = 141, y = -10, alpha = 0.6, linear_velocity = 77 }, { x = 65, y = -18, alpha = 0.6, linear_velocity = 84 }, { x = 850, y = -12, alpha = 0.6, linear_velocity = 87 }, { x = 273, y = -12, alpha = 0.6, linear_velocity = 81 }, { x = 810, y = -20, alpha = 0.6, linear_velocity = 150 }, { x = 96, y = 4, alpha = 0.6, linear_velocity = 64 }, { x = 639, y = 26, alpha = 0.6, linear_velocity = 149 }, { x = 585, y = 28, alpha = 0.6, linear_velocity = 65 }, { x = 211, y = 16, alpha = 0.6, linear_velocity = 117 }, { x = 242, y = -7, alpha = 0.6, linear_velocity = 149 }, { x = 416, y = -16, alpha = 0.6, linear_velocity = 149 }, { x = 266, y = -10, alpha = 0.6, linear_velocity = 97 }, { x = 270, y = 35, alpha = 0.6, linear_velocity = 103 }, { x = 618, y = 1, alpha = 0.6, linear_velocity = 112 }, { x = 925, y = 39, alpha = 0.6, linear_velocity = 81 } }
stars.index = 1
stars.scale = 40

star = {}
star.direction = create_vector()
star.position = create_vector()
star.linear_velocity = 0.0
star.alpha = 1

function stars:load()
    for i = 1, 20 do
        for _ = 1, 10 do
            local star = copy_table(star, false)

            star.direction.x = 0
            star.direction.y = 1
            star.linear_velocity = self.data[self.index].linear_velocity
            star.alpha = self.data[self.index].alpha

            star.position.x = self.data[self.index].x
            star.position.y = self.data[self.index].y + i * 115
            table.insert(self.list, star)
            self.index = self.index + 1
            if self.index > #self.data then
                self.index = 1
                shuffle_table(self.data)
            end
        end
    end
end

function stars:update(dt)
    self.stars_spawn_timer = self.stars_spawn_timer - dt
    if self.scale > 2.0 then
        self.scale = self.scale - dt * 15
    elseif self.scale < 2.0 then
        self.scale = 2.0
    end

    if self.stars_spawn_timer <= 0.0 then
        self.stars_spawn_timer = 1.0 / self.scale

        math.randomseed(os.time())

        for _ = 1, 10 do
            local star = copy_table(star, false)

            star.direction.x = 0
            star.direction.y = 1
            star.linear_velocity = self.data[self.index].linear_velocity
            star.alpha = self.data[self.index].alpha

            star.position.x = self.data[self.index].x
            star.position.y = self.data[self.index].y
            table.insert(self.list, star)
            self.index = self.index + 1
            if self.index > #self.data then
                self.index = 1
                shuffle_table(self.data)
            end
        end
    end

    for i = #self.list, 1, -1 do
        self.list[i].position = self.list[i].position +
        (self.list[i].direction * self.list[i].linear_velocity * dt * self.scale)
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
        self.anim:draw(sprites.star, self.list[i].position.x, self.list[i].position.y, 0, 1, self.scale)
    end
    love.graphics.setColor(r, g, b, a)
end
