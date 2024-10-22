sounds = {}
sounds.player_laser = love.audio.newSource("resource/audio/player_bullet.wav", "static")
sounds.game_music = love.audio.newSource("resource/audio/music-1.xm", "stream")

sounds.game_music:play()
