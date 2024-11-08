text_dialog = {}
text_dialog.font = love.graphics.newFont("resource/fonts/arcadeclassic.ttf", 50)
text_dialog.font_height = menu.font:getHeight()

text_dialog.character = {
    grid = anim8.newGrid(58, 58, sprites.support_char:getWidth(), sprites.support_char:getHeight()),
    position = create_vector(),
    linear_velocity = 300
}

text_dialog.character.anim = anim8.newAnimation(text_dialog.character.grid('1-4', 1), 0.2)
text_dialog.character.origin = {
    x = text_dialog.character.grid.frameWidth / 2,
    y = text_dialog.character.grid
        .frameHeight / 2
}


function text_dialog:init()
    self.character.position.x = -self.character.grid.frameWidth
    self.character.position.y = virtual_height - self.character.grid.frameHeight - 100
    self:init_dialog({ "CAPTAIN", "WE\tDETECTED\tSOME\tENEMY\tSCOUTS", "BETTER\tDESTROY\tTHEM" })
end

function text_dialog:update(dt)
    if self.dialog_finished then
        if self.alphabet_timer < 0.1 then
            self.alphabet_timer = self.alphabet_timer + dt
            return
        end
        if self.character.position.x > -self.character.grid.frameWidth then
            self.character.position.x = self.character.position.x - self.character.linear_velocity * dt
        else
            self.active = false
        end
        return
    end

    if self.alphabet_timer >= 0.0 then
        self.character.anim:update(dt)
    else
        self.character.anim:gotoFrame(1)
    end

    if self.character.position.x < self.character.grid.frameWidth + 20 then
        self.character.position.x = self.character.position.x + self.character.linear_velocity * dt
    else
        self.alphabet_timer = self.alphabet_timer + dt

        if self.alphabet_timer > 0.1 then
            if self.alphabet_index > #self.lines[self.line_number] then
                self.alphabet_timer = -0.6
                self.alphabet_index = 1
                self.line_number = self.line_number + 1
                sounds.dialog:pause()

                if self.line_number > #self.lines then
                    self.dialog_finished = true
                    sounds.dialog:stop()
                end
                return
            end

            self.alphabet_timer = 0.0
            self.display_text = string.sub(self.lines[self.line_number], 1, self.alphabet_index)
            self.alphabet_index = self.alphabet_index + 1
            sounds.dialog:play()
        end
    end
end

function text_dialog:draw()
    self.character.anim:draw(sprites.support_char, self.character.position.x, self.character.position.y, 0, 1, nil,
        self.character.origin.x,
        self.character.origin.y)
    if self.character.position.x > self.character.grid.frameWidth + 20 then
        love.graphics.print(self.display_text, self.character.position.x + self.character.grid.frameWidth,
            self.character.position.y - self.character.grid.frameHeight / 2)
    end
end

function text_dialog:init_dialog(text_list)
    self.active = true
    self.alphabet_timer = 0.0
    self.alphabet_index = 1
    self.lines = text_list
    self.line_number = 1
    self.display_text = ""
    self.dialog_finished = false
end
