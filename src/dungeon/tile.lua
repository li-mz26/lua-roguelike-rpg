-- Tile Types for Dungeon

local Tile = {}
Tile.__index = Tile

-- Tile types
Tile.FLOOR = 0
Tile.WALL = 1
Tile.DOOR = 2
Tile.STAIRS = 3
Tile.TRAP = 4
Tile.WATER = 5

-- Tile properties
Tile.properties = {
    [Tile.FLOOR] = {
        name = "floor",
        walkable = true,
        transparent = true,
        color = {0.3, 0.3, 0.35}
    },
    [Tile.WALL] = {
        name = "wall",
        walkable = false,
        transparent = false,
        color = {0.15, 0.15, 0.2}
    },
    [Tile.DOOR] = {
        name = "door",
        walkable = true,
        transparent = true,
        color = {0.4, 0.25, 0.15}
    },
    [Tile.STAIRS] = {
        name = "stairs",
        walkable = true,
        transparent = true,
        color = {0.6, 0.6, 0.5}
    },
    [Tile.TRAP] = {
        name = "trap",
        walkable = true,
        transparent = true,
        color = {0.5, 0.3, 0.3}
    },
    [Tile.WATER] = {
        name = "water",
        walkable = false,
        transparent = true,
        color = {0.2, 0.3, 0.5}
    }
}

-- Get tile property
function Tile.getProperty(tileType)
    return Tile.properties[tileType] or Tile.properties[Tile.FLOOR]
end

-- Check if tile is walkable
function Tile.isWalkable(tileType)
    local prop = Tile.getProperty(tileType)
    return prop.walkable
end

-- Check if tile is transparent (for visibility)
function Tile.isTransparent(tileType)
    local prop = Tile.getProperty(tileType)
    return prop.transparent
end

-- Get tile color
function Tile.getColor(tileType)
    local prop = Tile.getProperty(tileType)
    return prop.color
end

-- Get tile name
function Tile.getName(tileType)
    local prop = Tile.getProperty(tileType)
    return prop.name
end

return Tile
