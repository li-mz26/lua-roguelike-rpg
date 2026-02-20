-- Unit Class
-- Combat unit (hero or enemy)

local Entity = require("src.entity.entity")

local Unit = {}
Unit.__index = Unit
setmetatable(Unit, {__index = Entity})

function Unit.new(unitType, data)
    local self = setmetatable({}, Unit)
    Entity.new(self, data.id, data.name)

    self.unitType = unitType -- "hero" or "enemy"
    self.data = data
    self.color = data.color or {1, 1, 1}

    -- Grid position
    self.gridX = 0
    self.gridY = 0

    -- Stats (copy from data)
    self.hp = data.attributes and data.attributes.hp or 50
    self.maxHp = data.attributes and data.attributes.maxHp or 50
    self.mp = data.attributes and data.attributes.mp or 20
    self.maxMp = data.attributes and data.attributes.maxMp or 20
    self.attack = data.attributes and data.attributes.attack or 10
    self.defense = data.attributes and data.attributes.defense or 2
    self.magicResist = data.attributes and data.attributes.magicResist or 1
    self.speed = data.attributes and data.attributes.speed or 100
    self.critRate = data.attributes and data.attributes.critRate or 0.1
    self.critDamage = data.attributes and data.attributes.critDamage or 1.5
    self.dodge = data.attributes and data.attributes.dodge or 0.05
    self.attackSpeed = data.attributes and data.attributes.attackSpeed or 1.0

    -- Combat state
    self.alive = true
    self.active = true
    self.canAct = true

    -- Turn order
    self.actionGauge = 0

    return self
end

-- Set grid position
function Unit:setGridPosition(x, y)
    self.gridX = x
    self.gridY = y
end

-- Get grid position
function Unit:getGridPosition()
    return self.gridX, self.gridY
end

-- Take damage
function Unit:takeDamage(amount)
    -- Apply defense
    local damage = math.max(1, amount - self.defense)

    -- Check dodge
    if math.random() < self.dodge then
        return 0, true -- Dodged
    end

    self.hp = math.max(0, self.hp - damage)

    if self.hp <= 0 then
        self.alive = false
    end

    return damage, false
end

-- Heal
function Unit:heal(amount)
    local oldHp = self.hp
    self.hp = math.min(self.maxHp, self.hp + amount)
    return self.hp - oldHp
end

-- Restore MP
function Unit:restoreMp(amount)
    local oldMp = self.mp
    self.mp = math.min(self.maxMp, self.mp + amount)
    return self.mp - oldMp
end

-- Use MP
function Unit:useMp(amount)
    if self.mp >= amount then
        self.mp = self.mp - amount
        return true
    end
    return false
end

-- Check if alive
function Unit:isAlive()
    return self.alive
end

-- Check if can act
function Unit:canAct()
    return self.alive and self.canAct
end

-- Revive
function Unit:revive(fullHealth)
    self.alive = true
    if fullHealth then
        self.hp = self.maxHp
        self.mp = self.maxMp
    else
        self.hp = math.floor(self.maxHp * 0.5)
    end
end

-- Get HP percentage
function Unit:getHpPercent()
    return self.maxHp > 0 and self.hp / self.maxHp or 0
end

-- Get MP percentage
function Unit:getMpPercent()
    return self.maxMp > 0 and self.mp / self.maxMp or 0
end

-- Calculate attack damage
function Unit:calculateDamage()
    local damage = self.attack

    -- Critical hit
    if math.random() < self.critRate then
        damage = damage * self.critDamage
    end

    return math.floor(damage)
end

-- Reset for new turn
function Unit:resetTurn()
    self.canAct = true
end

-- Skip turn
function Unit:skipTurn()
    self.canAct = false
end

return Unit
