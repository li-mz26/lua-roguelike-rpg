-- Panel UI Component

local Panel = {}
Panel.__index = Panel

function Panel.new(x, y, width, height, options)
    local self = setmetatable({}, Panel)
    self.x = x or 0
    self.y = y or 0
    self.width = width or 200
    self.height = height or 150
    self.visible = true
    self.enabled = true

    -- Colors
    self.bgColor = {0.1, 0.1, 0.15, 0.9}
    self.borderColor = {0.3, 0.3, 0.4, 1}

    -- Children
    self.children = {}

    -- Options
    if options then
        for k, v in pairs(options) do
            self[k] = v
        end
    end

    return self
end

function Panel:add(child)
    table.insert(self.children, child)
    return child
end

function Panel:remove(child)
    for i, c in ipairs(self.children) do
        if c == child then
            table.remove(self.children, i)
            return true
        end
    end
    return false
end

function Panel:clear()
    self.children = {}
end

function Panel:setPosition(x, y)
    self.x = x
    self.y = y
end

function Panel:setSize(width, height)
    self.width = width
    self.height = height
end

function Panel:setVisible(visible)
    self.visible = visible
end

function Panel:isVisible()
    return self.visible
end

function Panel:update(dt, mouseX, mouseY)
    if not self.visible then return end

    for _, child in ipairs(self.children) do
        if child.update then
            child:update(dt, mouseX, mouseY)
        end
    end
end

function Panel:draw()
    if not self.visible then return end

    -- Background
    love.graphics.setColor(self.bgColor)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    -- Border
    love.graphics.setColor(self.borderColor)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

    -- Children
    for _, child in ipairs(self.children) do
        if child.draw then
            child:draw()
        end
    end
end

function Panel:mousePressed(x, y, button)
    if not self.visible or not self.enabled then return false end

    for _, child in ipairs(self.children) do
        if child.mousePressed and child:mousePressed(x, y, button) then
            return true
        end
    end
    return false
end

function Panel:mouseReleased(x, y, button)
    if not self.visible or not self.enabled then return end

    for _, child in ipairs(self.children) do
        if child.mouseReleased then
            child:mouseReleased(x, y, button)
        end
    end
end

function Panel:isPointInside(px, py)
    return px >= self.x and px <= self.x + self.width and
           py >= self.y and py <= self.y + self.height
end

return Panel
