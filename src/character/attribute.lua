-- Attribute System
-- Handles character attributes and stats

local Attribute = {}
Attribute.__index = Attribute

-- Attribute types
Attribute.STR = "str"   -- Strength: HP, physical damage
Attribute.AGI = "agi"  -- Agility: Attack speed, dodge, crit
Attribute.INT = "int"  -- Intelligence: MP, magic damage

-- Derived stat multipliers
Attribute.MULTIPLIERS = {
    hpPerStr = 10,
    mpPerInt = 15,
    attackPerStr = 2,
    attackPerAgi = 1.5,
    dodgePerAgi = 0.01,
    critRatePerAgi = 0.01,
    attackSpeedPerAgi = 0.05,
    magicDamagePerInt = 2,
    magicResistPerInt = 0.5
}

function Attribute.new(base)
    local self = setmetatable({}, Attribute)
    self.base = base or {}
    -- Base values
    self.base.str = self.base.str or 10
    self.base.agi = self.base.agi or 10
    self.base.int = self.base.int or 10

    -- Current derived stats
    self.current = {}
    self:recalculate()

    return self
end

function Attribute:setBase(attrType, value)
    self.base[attrType] = value
    self:recalculate()
end

function Attribute:getBase(attrType)
    return self.base[attrType] or 0
end

function Attribute:addBase(attrType, amount)
    self.base[attrType] = (self.base[attrType] or 0) + amount
    self:recalculate()
end

-- Recalculate all derived stats from base attributes
function Attribute:recalculate()
    local str = self.base.str or 0
    local agi = self.base.agi or 0
    local int = self.base.int or 0

    -- HP
    self.current.maxHp = 50 + str * Attribute.MULTIPLIERS.hpPerStr
    if not self.current.hp then
        self.current.hp = self.current.maxHp
    else
        self.current.hp = math.min(self.current.hp, self.current.maxHp)
    end

    -- MP
    self.current.maxMp = 20 + int * Attribute.MULTIPLIERS.mpPerInt
    if not self.current.mp then
        self.current.mp = self.current.maxMp
    else
        self.current.mp = math.min(self.current.mp, self.current.maxMp)
    end

    -- Attack
    self.current.attack = 5 + str * Attribute.MULTIPLIERS.attackPerStr +
                          agi * Attribute.MULTIPLIERS.attackPerAgi

    -- Defense (base)
    self.current.defense = 2 + str * 0.3

    -- Magic Resist
    self.current.magicResist = int * Attribute.MULTIPLIERS.magicResistPerInt

    -- Magic Attack
    self.current.magicAttack = int * Attribute.MULTIPLIERS.magicDamagePerInt

    -- Attack Speed
    self.current.attackSpeed = 1.0 + agi * Attribute.MULTIPLIERS.attackSpeedPerAgi

    -- Crit Rate
    self.current.critRate = 0.05 + agi * Attribute.MULTIPLIERS.critRatePerAgi

    -- Crit Damage
    self.current.critDamage = 1.5

    -- Dodge
    self.current.dodge = agi * Attribute.MULTIPLIERS.dodgePerAgi

    -- Speed
    self.current.speed = 100 + agi * 2

    -- Clamp values
    self.current.critRate = math.min(self.current.critRate, 0.75)
    self.current.dodge = math.min(self.current.dodge, 0.5)
end

-- Get current stat value
function Attribute:get(statName)
    return self.current[statName] or 0
end

-- Set current stat value (for temp modifications)
function Attribute:set(statName, value)
    self.current[statName] = value
end

-- Modify current HP (returns actual amount modified)
function Attribute:modifyHp(amount)
    local oldHp = self.current.hp
    self.current.hp = math.max(0, math.min(self.current.maxHp, self.current.hp + amount))
    return self.current.hp - oldHp
end

-- Modify current MP
function Attribute:modifyMp(amount)
    local oldMp = self.current.mp
    self.current.mp = math.max(0, math.min(self.current.maxMp, self.current.mp + amount))
    return self.current.mp - oldMp
end

-- Check if can afford MP cost
function Attribute:canAfford(mpCost)
    return self.current.mp >= mpCost
end

-- Consume MP
function Attribute:consumeMp(amount)
    if self:canAfford(amount) then
        self.current.mp = self.current.mp - amount
        return true
    end
    return false
end

-- Get all attributes as table
function Attribute:getAll()
    return {
        base = self.base,
        current = self.current
    }
end

-- Heal to full
function Attribute:healFull()
    self.current.hp = self.current.maxHp
    self.current.mp = self.current.maxMp
end

return Attribute
