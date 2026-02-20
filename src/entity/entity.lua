-- Entity Base Class
-- Base class for all game entities (characters, enemies, items)

local Entity = {}
Entity.__index = Entity

function Entity.new(id, name)
    local self = setmetatable({}, Entity)
    self.id = id or ""
    self.name = name or "Entity"
    self.x = 0
    self.y = 0
    self.visible = true
    self.active = true
    return self
end

function Entity:setPosition(x, y)
    self.x = x
    self.y = y
end

function Entity:getPosition()
    return self.x, self.y
end

function Entity:setVisible(visible)
    self.visible = visible
end

function Entity:isVisible()
    return self.visible
end

function Entity:setActive(active)
    self.active = active
end

function Entity:isActive()
    return self.active
end

function Entity:update(dt)
    -- Override in subclasses
end

function Entity:draw()
    -- Override in subclasses
end

function Entity:destroy()
    self.active = false
    self.visible = false
end

return Entity
