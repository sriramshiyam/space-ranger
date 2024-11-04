menu = {}
menu.font = love.graphics.newFont("resource/fonts/arcadeclassic.ttf", 50)
menu.font_height = menu.font:getHeight()
menu.positions = {}
menu.arrow1_position = create_vector()
menu.arrow2_position = create_vector()
menu.active_option = 1

function menu:init()
    love.graphics.setFont(self.font)
    self.positions[1] = {
        width = self.font:getWidth("START GAME"),
        x = virtual_width / 2 - self.font:getWidth("START GAME") / 2,
        y = virtual_height / 2,
        action = function()
            stars.scale = 40
            game_manager.state = "game"
        end
    }
    self.positions[2] = {
        width = self.font:getWidth("SETTINGS"),
        x = virtual_width / 2 - self.font:getWidth("SETTINGS") / 2,
        y = virtual_height / 2 + self.font_height * 1.5,
        action = function()
        end
    }
    self.positions[3] = {
        width = self.font:getWidth("CREDITS"),
        x = virtual_width / 2 - self.font:getWidth("CREDITS") / 2,
        y = virtual_height / 2 + self.font_height * 3,
        action = function()
        end
    }
    self.positions[4] = {
        width = self.font:getWidth("EXIT"),
        x = virtual_width / 2 - self.font:getWidth("EXIT") / 2,
        y = virtual_height / 2 + self.font_height * 4.5,
        action = function()
            love.event.quit()
        end
    }

    local menu_height = self.positions[#self.positions].y - self.positions[1].y

    for k, v in pairs(self.positions) do
        v.y = v.y - menu_height / 2
    end

    self:update_arrow_position()
end

function menu:update(dt)
end

function menu:update_arrow(up)
    if up and self.active_option > 1 then
        self.active_option = self.active_option - 1
        self:update_arrow_position()
    elseif not up and self.active_option < #self.positions then
        self.active_option = self.active_option + 1
        self:update_arrow_position()
    end
end

function menu:draw()
    love.graphics.print("START GAME", self.positions[1].x, self.positions[1].y)
    love.graphics.print("SETTINGS", self.positions[2].x, self.positions[2].y)
    love.graphics.print("CREDITS", self.positions[3].x, self.positions[3].y)
    love.graphics.print("EXIT", self.positions[4].x, self.positions[4].y)
    love.graphics.draw(sprites.menu_arrow1, self.arrow1_position.x, self.arrow1_position.y)
    love.graphics.draw(sprites.menu_arrow2, self.arrow2_position.x, self.arrow2_position.y)
end

function menu:update_arrow_position()
    self.arrow1_position.x = self.positions[self.active_option].x - sprites.menu_arrow1:getWidth() - self.font_height / 2
    self.arrow1_position.y = self.positions[self.active_option].y + self.font_height / 2 -
        sprites.menu_arrow1:getHeight() / 2

    self.arrow2_position.x = self.positions[self.active_option].x + self.positions[self.active_option].width +
        self.font_height / 2
    self.arrow2_position.y = self.positions[self.active_option].y + self.font_height / 2 -
        sprites.menu_arrow1:getHeight() / 2
    sounds.menu_active:play()
end

function menu:keypressed(key)
    if key == "up" then
        self:update_arrow(true)
    elseif key == "down" then
        self:update_arrow(false)
    elseif key == "return" then
        self.positions[self.active_option].action()
        sounds.menu_select:play()
    end
end
