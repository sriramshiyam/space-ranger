particles = {}

particles.enemy_destroyed = {
    particle = love.graphics.newParticleSystem(love.graphics.newImage("resource/image/enemy_particle.png")),
}

function particles.enemy_destroyed:load()
    self.particle:setParticleLifetime(0.7, 1.5)
    self.particle:setSpeed(300, 400)
    self.particle:setSpread(2 * math.pi)
    self.particle:setSizes(1.0, 0.9, 0.7, 0.4, 0.2, 0.5)
    self.particle:setLinearDamping(1, 1.25)
    self.particle:setParticleLifetime(1, 1.5)
end

function particles.enemy_destroyed:update(dt)
    self.particle:update(dt)
end

function particles.enemy_destroyed:draw()
    love.graphics.draw(self.particle)
end
