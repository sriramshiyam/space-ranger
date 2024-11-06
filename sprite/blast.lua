blast = {}

blast.position = create_vector()
blast.anim_timer = 0.0
blast.is_removed = false
blast.scale = 1

function blast:init()
    self.grid = anim8.newGrid(64, 64, sprites.blast:getWidth(), sprites.blast:getHeight())
    self.anim = anim8.newAnimation(self.grid('1-4', 1), 0.12)
    self.origin = { x = self.grid.frameWidth / 2, y = self.grid.frameHeight / 2 }
end

function blast:update(dt)
    self.anim_timer = self.anim_timer + dt

    if self.anim_timer >= 0.12 * 4 then
        self.is_removed = true
        return
    end

    self.anim:update(dt)
end

function blast:draw()
    self.anim:draw(sprites.blast, self.position.x, self.position.y, 0, self.scale, nil, self.origin.x, self.origin.y)
end
