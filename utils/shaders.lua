shaders = {}
shaders.player_attacked = love.graphics.newShader(love.filesystem.read("resource/shaders/player_attacked.fx"))
shaders.enemy_attacked = love.graphics.newShader(love.filesystem.read("resource/shaders/enemy_attacked.fx"))
