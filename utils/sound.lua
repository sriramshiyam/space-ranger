sounds = {}
sounds.player_laser = love.audio.newSource("resource/audio/player_bullet.wav", "static")
sounds.game_music = love.audio.newSource("resource/audio/music-1.xm", "stream")
sounds.enemy_laser = love.audio.newSource("resource/audio/enemy_bullet.wav", "static")
sounds.player_attacked = love.audio.newSource("resource/audio/player_attacked.wav", "static")
sounds.enemy_explode = love.audio.newSource("resource/audio/enemy_explode.wav", "static")
sounds.enemy_attacked = love.audio.newSource("resource/audio/enemy_attacked.wav", "static")
sounds.enemy_boss_laser = love.audio.newSource("resource/audio/enemy_boss_bullet.wav", "static")


sounds.player_laser:setVolume(0.7)
sounds.enemy_laser:setVolume(0.7)
sounds.player_attacked:setVolume(0.6)
sounds.enemy_explode:setVolume(0.6)
sounds.enemy_attacked:setVolume(0.6)
sounds.enemy_boss_laser:setVolume(0.5)
sounds.game_music:setLooping(true)
sounds.game_music:play()
