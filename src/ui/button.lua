-- Button UI Component

local Button = {}
Button.__index = Button

function Button.new(text, x, y, width, height, options)
    local self = setmetatable({}, Button)
    self.text = text or "Button"
    self.x = x or 0
    self.y = y or 0
    self.width = width or 120
    self.height = height or 40
    self.visible = true
    self.enabled = true
    self.hovered = false
    self.pressed = false
    self.clicked = false

    -- Colors
    self.bgColor = {0.2, 0.2, 0.3, 1}
    self.hoverColor = {0.3, 0.3, 0.4, 1}
    self.pressColor = {0.15, 0.15, 0.25, 1}
    self.disabledColor = {0.15, 0.15, 0.15, 1}
    self.borderColor = {0.4, 0.4, 0.5, 1}
    self.textColor = {1, 1, 1, 1}
    self.hoverTextColor = {1, 1, 0.8, 1}

    -- Callback
    self.onClick = nil
    self.onHover = nil

    -- Options
    if options then
        for k, v in pairs(options) do
            self[k] = v
        end
    end

    -- Font
    self.font = love.graphics.getFont()
    self.textOffsetX = self.width / 2
    self.textOffsetY = self.height / 2 - self.font:getHeight() / 2

    return self
end

function Button:setText(text)
    self.text = text
end

function Button:getText()
    return self.text
end

function Button:setPosition(x, y)
    self.x = x
    self.y = y
end

function Button:setSize(width, height)
    self.width = width
    self.height = height
    self.textOffsetX = self.width / 2
    self.textOffsetY = self.height / 2 - self.font:getHeight() / 2
end

function Button:setCallback(callback)
    self.onClick = callback
end

function Button:isPointInside(px, py)
    return px >= self.x and px <= self.x + self.width and
           py >= self.y and py <= self.y + self.height
end

function Button:update(dt, mouseX, mouseY)
    if not self.visible or not self.enabled then
        self.hovered = false
        return
    end

    local wasHovered = self.hovered
    self.hovered = self:isPointInside(mouseX, mouseY)

    if self.hovered and not wasHovered and self.onHover then
        self.onHover(self)
    end
end

function Button:mousePressed(x, y, button)
    if not self.visible or not self.enabled then return false end

    if self:isPointInside(x, y) and button == 1 then
        self.pressed = true
        return true
    end
    return false
end

function Button:mouseReleased(x, y, button)
    if not self.visible or not self.enabled then
        self.pressed = false
        return
    end

    if self.pressed and button == 1 then
        self.pressed = false
        if self:isPointInside(x, y) and self.onClick then
            self.onClick(self)
            self.clicked = true
        end
    end
end

function Button:draw()
    if not self.visible then return end

    local bgColor = self.bgColor
    if not self.enabled then
        bgColor = self.disabledColor
    elseif self.pressed then
        bgColor = self.pressColor
    elseif self.hovered then
        bgColor = self.hoverColor
    end

    -- Background
    love.graphics.setColor(bgColor)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    -- Border
    love.graphics.setColor(self.borderColor)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

    -- Text
    local textColor = self.textColor
    if self.hovered and self.enabled then
        textColor = self.hoverTextColor
    end
    love.graphics.setFont(self.font)
    love.graphics.setColor(textColor)
    love.graphics.print(self.text, self.x + self.textOffsetX - self.font:getWidth(self.text) / 2,
                        self.y + self.textOffsetY)
end

return Button
