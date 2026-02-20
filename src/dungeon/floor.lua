-- Floor Class
-- Represents a single dungeon floor

local Room = require("src.dungeon.room")
local Tile = require("src.dungeon.tile")

local Floor = {}
Floor.__index = Floor

function Floor.new(floorNumber, width, height)
    local self = setmetatable({}, Floor)
    self.floorNumber = floorNumber
    self.width = width or 40
    self.height = height or 30
    self.rooms = {}
    self.tiles = {}
    self.currentRoom = nil

    -- Generate the floor
    self:generate()

    return self
end

-- Generate floor with rooms
function Floor:generate()
    -- Initialize tiles with walls
    for y = 1, self.height do
        self.tiles[y] = {}
        for x = 1, self.width do
            self.tiles[y][x] = Tile.WALL
        end
    end

    -- Generate rooms
    self:generateRooms()

    -- Connect rooms with corridors
    self:generateCorridors()

    -- Set starting room
    if #self.rooms > 0 then
        self.currentRoom = self.rooms[1]
        self.currentRoom:setVisited(true)
    end
end

-- Generate rooms
function Floor:generateRooms()
    local numRooms = math.random(5, 8)

    for i = 1, numRooms do
        local roomWidth = math.random(5, 10)
        local roomHeight = math.random(5, 8)
        local x = math.random(2, self.width - roomWidth - 2)
        local y = math.random(2, self.height - roomHeight - 2)

        -- Check overlap with existing rooms
        local overlaps = false
        for _, room in ipairs(self.rooms) do
            if x < room.x + room.width + 1 and x + roomWidth + 1 > room.x and
               y < room.y + room.height + 1 and y + roomHeight + 1 > room.y then
                overlaps = true
                break
            end
        end

        if not overlaps then
            local roomType = self:getRoomType(i, numRooms)
            local room = Room.new(x, y, roomWidth, roomHeight, roomType)
            table.insert(self.rooms, room)

            -- Carve room
            self:carveRoom(room)
        end
    end
end

-- Determine room type based on position
function Floor:getRoomType(index, total)
    if index == 1 then
        return Room.TYPE_NORMAL -- Starting room
    elseif index == total then
        return Room.TYPE_STAIRS -- Exit room
    else
        local rand = math.random()
        if rand < 0.1 then
            return Room.TYPE_TREASURE
        elseif rand < 0.2 then
            return Room.TYPE_ALTAR
        else
            return Room.TYPE_NORMAL
        end
    end
end

-- Carve room into tiles
function Floor:carveRoom(room)
    for y = room.y, room.y + room.height - 1 do
        for x = room.x, room.x + room.width - 1 do
            self.tiles[y][x] = Tile.FLOOR
        end
    end
end

-- Generate corridors between rooms
function Floor:generateCorridors()
    for i = 1, #self.rooms - 1 do
        local room1 = self.rooms[i]
        local room2 = self.rooms[i + 1]

        local center1 = room1:getCenter()
        local center2 = room2:getCenter()

        -- Simple L-shaped corridor
        if math.random() < 0.5 then
            self:carveHorizontalTunnel(center1.x, center2.x, center1.y)
            self:carveVerticalTunnel(center1.y, center2.y, center2.x)
        else
            self:carveVerticalTunnel(center1.y, center2.y, center1.x)
            self:carveHorizontalTunnel(center1.x, center2.x, center2.y)
        end

        -- Connect rooms
        room1:addExit("east")
        room2:addExit("west")
    end
end

-- Carve horizontal tunnel
function Floor:carveHorizontalTunnel(x1, x2, y)
    local minX = math.min(x1, x2)
    local maxX = math.max(x1, x2)
    for x = minX, maxX do
        if y >= 1 and y <= self.height and x >= 1 and x <= self.width then
            self.tiles[y][x] = Tile.FLOOR
        end
    end
end

-- Carve vertical tunnel
function Floor:carveVerticalTunnel(y1, y2, x)
    local minY = math.min(y1, y2)
    local maxY = math.max(y1, y2)
    for y = minY, maxY do
        if y >= 1 and y <= self.height and x >= 1 and x <= self.width then
            self.tiles[y][x] = Tile.FLOOR
        end
    end
end

-- Get tile at position
function Floor:getTile(x, y)
    if x < 1 or x > self.width or y < 1 or y > self.height then
        return Tile.WALL
    end
    return self.tiles[y][x]
end

-- Set tile at position
function Floor:setTile(x, y, tileType)
    if x >= 1 and x <= self.width and y >= 1 and y <= self.height then
        self.tiles[y][x] = tileType
    end
end

-- Check if position is walkable
function Floor:isWalkable(x, y)
    return Tile.isWalkable(self:getTile(x, y))
end

-- Get room at position
function Floor:getRoomAt(x, y)
    for _, room in ipairs(self.rooms) do
        if room:contains(x, y) then
            return room
        end
    end
    return nil
end

-- Get all rooms
function Floor:getRooms()
    return self.rooms
end

-- Get current room
function Floor:getCurrentRoom()
    return self.currentRoom
end

-- Set current room
function Floor:setCurrentRoom(room)
    self.currentRoom = room
    room:setVisited(true)
end

-- Check if position is in current room
function Floor:isInCurrentRoom(x, y)
    if self.currentRoom then
        return self.currentRoom:contains(x, y)
    end
    return false
end

-- Get stairs position
function Floor:getStairsPosition()
    local lastRoom = self.rooms[#self.rooms]
    if lastRoom and lastRoom:getTypeName() == Room.TYPE_STAIRS then
        return lastRoom:getCenter()
    end
    return nil
end

return Floor
