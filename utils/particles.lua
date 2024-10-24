particles = {}

particles.enemy_destroyed = love.graphics.newParticleSystem(love.graphics.newImage("resource/image/enemy_particle.png"))
particles.enemy_destroyed:setParticleLifetime(0.7, 1.5)
particles.enemy_destroyed:setSpeed(300, 400)
particles.enemy_destroyed:setSpread(2 * math.pi)
particles.enemy_destroyed:setSizes(1.0, 0.9, 0.7, 0.4, 0.2, 0.5)
