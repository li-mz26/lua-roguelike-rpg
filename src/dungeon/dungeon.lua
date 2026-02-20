-- Dungeon Manager
-- Manages dungeon floors and overall dungeon state

local Floor = require("src.dungeon.floor")

local Dungeon = {}
Dungeon.__index = Dungeon

-- Dungeon states
Dungeon.EXPLORING = "exploring"
Dungeon.COMBAT = "combat"
Dungeon.EVENT = "event"
Dungeon.VICTORY = "victory"

function Dungeon.new(maxFloors)
    local self = setmetatable({}, Dungeon)
    self.currentFloorNumber = 1
    self.maxFloors = maxFloors or 3
    self.floors = {}
    self.currentFloor = nil
    self.state = Dungeon.EXPLORING

    -- Generate first floor
    self:generateFloor(1)

    return self
end

-- Generate a floor
function Dungeon:generateFloor(floorNumber)
    local floor = Floor.new(floorNumber)
    self.floors[floorNumber] = floor
    self.currentFloor = floor
    self.currentFloorNumber = floorNumber
    return floor
end

-- Get current floor
function Dungeon:getCurrentFloor()
    return self.currentFloor
end

-- Get current floor number
function Dungeon:getFloorNumber()
    return self.currentFloorNumber
end

-- Get max floors
function Dungeon:getMaxFloors()
    return self.maxFloors
end

-- Go to next floor
function Dungeon:nextFloor()
    if self.currentFloorNumber < self.maxFloors then
        self:generateFloor(self.currentFloorNumber + 1)
        return true
    end
    return false
end

-- Check if can go to next floor
function Dungeon:canGoNextFloor()
    local stairs = self.currentFloor:getStairsPosition()
    return stairs ~= nil
end

-- Get dungeon state
function Dungeon:getState()
    return self.state
end

-- Set dungeon state
function Dungeon:setState(state)
    self.state = state
end

-- Check if dungeon is complete (all floors cleared)
function Dungeon:isComplete()
    return self.currentFloorNumber >= self.maxFloors
end

-- Get all floors
function Dungeon:getFloors()
    return self.floors
end

return Dungeon
