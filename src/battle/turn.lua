-- Turn Manager
-- Manages turn order and combat flow

local Turn = {}
Turn.__index = Turn

-- Turn states
Turn.PREPARING = "preparing"
Turn.PLAYER_TURN = "player"
Turn.ENEMY_TURN = "enemy"
Turn.ACTION = "action"
Turn.VICTORY = "victory"
Turn.DEFEAT = "defeat"

function Turn.new()
    local self = setmetatable({}, Turn)
    self.state = Turn.PREPARING
    self.turnNumber = 1
    self.currentUnitIndex = 1
    self.units = {}
    return self
end

-- Set units for battle
function Turn:setUnits(units)
    self.units = units
    self:sortBySpeed()
    self.currentUnitIndex = 1
    self.state = Turn.PLAYER_TURN
end

-- Sort units by speed (highest first)
function Turn:sortBySpeed()
    table.sort(self.units, function(a, b)
        return a.speed > b.speed
    end)
end

-- Get current unit
function Turn:getCurrentUnit()
    return self.units[self.currentUnitIndex]
end

-- Advance to next unit
function Turn:nextUnit()
    -- Skip dead or inactive units
    repeat
        self.currentUnitIndex = self.currentUnitIndex + 1

        if self.currentUnitIndex > #self.units then
            self.currentUnitIndex = 1
            self.turnNumber = self.turnNumber + 1
        end
    until self:getCurrentUnit():isAlive() or not self:hasAliveUnits()

    -- Check for victory/defeat
    self:checkBattleEnd()
end

-- Check if battle should end
function Turn:checkBattleEnd()
    local playerAlive = false
    local enemyAlive = false

    for _, unit in ipairs(self.units) do
        if unit.unitType == "hero" and unit:isAlive() then
            playerAlive = true
        elseif unit.unitType == "enemy" and unit:isAlive() then
            enemyAlive = true
        end
    end

    if not enemyAlive then
        self.state = Turn.VICTORY
    elseif not playerAlive then
        self.state = Turn.DEFEAT
    end
end

-- Check if any units are alive
function Turn:hasAliveUnits()
    for _, unit in ipairs(self.units) do
        if unit:isAlive() then return true end
    end
    return false
end

-- Check if battle is over
function Turn:isBattleOver()
    return self.state == Turn.VICTORY or self.state == Turn.DEFEAT
end

-- Get current state
function Turn:getState()
    return self.state
end

-- Set state
function Turn:setState(state)
    self.state = state
end

-- Get turn number
function Turn:getTurnNumber()
    return self.turnNumber
end

-- Get all units
function Turn:getUnits()
    return self.units
end

-- Get heroes
function Turn:getHeroes()
    local heroes = {}
    for _, unit in ipairs(self.units) do
        if unit.unitType == "hero" then
            table.insert(heroes, unit)
        end
    end
    return heroes
end

-- Get enemies
function Turn:getEnemies()
    local enemies = {}
    for _, unit in ipairs(self.units) do
        if unit.unitType == "enemy" then
            table.insert(enemies, unit)
        end
    end
    return enemies
end

-- Get alive heroes
function Turn:getAliveHeroes()
    local heroes = {}
    for _, unit in ipairs(self.units) do
        if unit.unitType == "hero" and unit:isAlive() then
            table.insert(heroes, unit)
        end
    end
    return heroes
end

-- Get alive enemies
function Turn:getAliveEnemies()
    local enemies = {}
    for _, unit in ipairs(self.units) do
        if unit.unitType == "enemy" and unit:isAlive() then
            table.insert(enemies, unit)
        end
    end
    return enemies
end

return Turn
