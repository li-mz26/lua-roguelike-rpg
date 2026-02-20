-- Isometric Projection
-- Converts between grid and screen coordinates

local Isometric = {}
Isometric.__index = Isometric

-- Tile dimensions
Isometric.TILE_WIDTH = 32
Isometric.TILE_HEIGHT = 16

function Isometric.new(tileWidth, tileHeight)
    local self = setmetatable({}, Isometric)
    self.tileWidth = tileWidth or Isometric.TILE_WIDTH
    self.tileHeight = tileHeight or Isometric.TILE_HEIGHT
    self.originX = 0
    self.originY = 0
    return self
end

-- Set origin (screen position for grid 0,0)
function Isometric:setOrigin(x, y)
    self.originX = x
    self.originY = y
end

-- Convert grid coordinates to screen coordinates
function Isometric:gridToScreen(gridX, gridY)
    local screenX = self.originX + (gridX - gridY) * (self.tileWidth / 2)
    local screenY = self.originY + (gridX + gridY) * (self.tileHeight / 2)
    return screenX, screenY
end

-- Convert screen coordinates to grid coordinates
function Isometric:screenToGrid(screenX, screenY)
    local x = screenX - self.originX
    local y = screenY - self.originY

    local gridX = (x / (self.tileWidth / 2) + y / (self.tileHeight / 2)) / 2
    local gridY = (y / (self.tileHeight / 2) - x / (self.tileWidth / 2)) / 2

    return math.floor(gridX), math.floor(gridY)
end

-- Get tile dimensions
function Isometric:getTileDimensions()
    return self.tileWidth, self.tileHeight
end

-- Set tile dimensions
function Isometric:setTileDimensions(width, height)
    self.tileWidth = width
    self.tileHeight = height
end

return Isometric
