-- Label UI Component

local Label = {}
Label.__index = Label

function Label.new(text, x, y, options)
    local self = setmetatable({}, Label)
    self.text = text or ""
    self.x = x or 0
    self.y = y or 0
    self.width = 0
    self.height = 24
    self.font = love.graphics.getFont()
    self.color = {1, 1, 1, 1}
    self.align = "left" -- left, center, right
    self.visible = true
    self.enabled = true

    -- Options
    if options then
        for k, v in pairs(options) do
            self[k] = v
        end
    end

    self:updateDimensions()
    return self
end

function Label:setText(text)
    self.text = text
    self:updateDimensions()
end

function Label:getText()
    return self.text
end

function Label:setFont(font)
    self.font = font
    self:updateDimensions()
end

function Label:setColor(r, g, b, a)
    self.color = {r, g, b, a or 1}
end

function Label:setAlign(align)
    self.align = align
end

function Label:updateDimensions()
    if self.font then
        self.width = self.font:getWidth(self.text)
        self.height = self.font:getHeight()
    end
end

function Label:draw()
    if not self.visible then return end

    love.graphics.setFont(self.font)
    love.graphics.setColor(self.color)

    local x = self.x
    if self.align == "center" then
        x = self.x - self.width / 2
    elseif self.align == "right" then
        x = self.x - self.width
    end

    love.graphics.print(self.text, x, self.y)
end

function Label:update(dt)
    -- Override for dynamic labels
end

function Label:isPointInside(px, py)
    local x = self.x
    if self.align == "center" then
        x = self.x - self.width / 2
    elseif self.align == "right" then
        x = self.x - self.width
    end
    return px >= x and px <= x + self.width and
           py >= self.y and py <= self.y + self.height
end

return Label
