-- Room Class
-- Represents a single room in a dungeon floor

local Room = {}
Room.__index = Room

-- Room types
Room.TYPE_NORMAL = "normal"      -- Regular combat
Room.TYPE_ELITE = "elite"        -- Elite enemy
Room.TYPE_TREASURE = "treasure"  -- Loot room
Room.TYPE_SHOP = "shop"          -- Merchant
Room.TYPE_ALTAR = "altar"        -- Heal/buff
Room.TYPE_EVENT = "event"        -- Random event
Room.TYPE_STAIRS = "stairs"      -- Stairs to next level
Room.TYPE_BOSS = "boss"          -- Boss room

function Room.new(x, y, width, height, roomType)
    local self = setmetatable({}, Room)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.roomType = roomType or Room.TYPE_NORMAL
    self.visited = false
    self.cleared = false
    self.enemies = {}
    self.items = {}
    self.exits = {} -- Directions: "north", "south", "east", "west"
    return self
end

-- Get room center
function Room:getCenter()
    return {
        x = self.x + math.floor(self.width / 2),
        y = self.y + math.floor(self.height / 2)
    }
end

-- Get room bounds
function Room:getBounds()
    return {
        x = self.x,
        y = self.y,
        width = self.width,
        height = self.height
    }
end

-- Check if point is inside room
function Room:contains(x, y)
    return x >= self.x and x < self.x + self.width and
           y >= self.y and y < self.y + self.height
end

-- Check if position is on room edge
function Room:isOnEdge(x, y)
    return x == self.x or x == self.x + self.width - 1 or
           y == self.y or y == self.y + self.height - 1
end

-- Add enemy to room
function Room:addEnemy(enemy)
    table.insert(self.enemies, enemy)
end

-- Remove enemy from room
function Room:removeEnemy(enemy)
    for i, e in ipairs(self.enemies) do
        if e == enemy then
            table.remove(self.enemies, i)
            return true
        end
    end
    return false
end

-- Get enemies in room
function Room:getEnemies()
    return self.enemies
end

-- Check if room has enemies
function Room:hasEnemies()
    return #self.enemies > 0
end

-- Clear all enemies
function Room:clearEnemies()
    self.enemies = {}
    self.cleared = true
end

-- Add exit direction
function Room:addExit(direction)
    if not self:hasExit(direction) then
        table.insert(self.exits, direction)
    end
end

-- Check if room has exit in direction
function Room:hasExit(direction)
    for _, exit in ipairs(self.exits) do
        if exit == direction then return true end
    end
    return false
end

-- Get all exits
function Room:getExits()
    return self.exits
end

-- Set room as visited
function Room:setVisited(visited)
    self.visited = visited
end

-- Check if visited
function Room:isVisited()
    return self.visited
end

-- Check if cleared
function Room:isCleared()
    return self.cleared or not self:hasEnemies()
end

-- Get random position in room
function Room:getRandomPosition()
    local x = math.random(self.x + 1, self.x + self.width - 2)
    local y = math.random(self.y + 1, self.y + self.height - 2)
    return x, y
end

-- Get room type name
function Room:getTypeName()
    return self.roomType
end

return Room
