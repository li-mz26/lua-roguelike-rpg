-- UI Manager
-- Manages all UI elements and input handling

local Manager = {}
Manager.__index = Manager

function Manager.new()
    local self = setmetatable({}, Manager)
    self.screens = {}
    self.currentScreen = nil
    self.mouseX = 0
    self.mouseY = 0
    return self
end

function Manager:addScreen(name, screen)
    self.screens[name] = screen
    return screen
end

function Manager:removeScreen(name)
    self.screens[name] = nil
end

function Manager:setScreen(name)
    local screen = self.screens[name]
    if screen then
        -- Hide current screen
        if self.currentScreen and self.currentScreen.onHide then
            self.currentScreen:onHide()
        end

        self.currentScreen = screen

        -- Show new screen
        if self.currentScreen.onShow then
            self.currentScreen:onShow()
        end
    end
end

function Manager:getScreen(name)
    return self.screens[name]
end

function Manager:getCurrentScreen()
    return self.currentScreen
end

function Manager:update(dt)
    self.mouseX, self.mouseY = love.mouse.getPosition()

    if self.currentScreen and self.currentScreen.update then
        self.currentScreen:update(dt, self.mouseX, self.mouseY)
    end
end

function Manager:draw()
    if self.currentScreen and self.currentScreen.draw then
        self.currentScreen:draw()
    end
end

function Manager:keyPressed(key)
    if self.currentScreen and self.currentScreen.keyPressed then
        self.currentScreen:keyPressed(key)
    end
end

function Manager:keyReleased(key)
    if self.currentScreen and self.currentScreen.keyReleased then
        self.currentScreen:keyReleased(key)
    end
end

function Manager:mousePressed(x, y, button)
    if self.currentScreen and self.currentScreen.mousePressed then
        return self.currentScreen:mousePressed(x, y, button)
    end
    return false
end

function Manager:mouseReleased(x, y, button)
    if self.currentScreen and self.currentScreen.mouseReleased then
        self.currentScreen:mouseReleased(x, y, button)
    end
end

function Manager:textInput(text)
    if self.currentScreen and self.currentScreen.textInput then
        self.currentScreen:textInput(text)
    end
end

return Manager
