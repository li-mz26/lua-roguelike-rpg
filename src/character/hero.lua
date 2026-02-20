-- Hero Class
-- Player controllable character

local Attribute = require("src.character.attribute")

local Hero = {}
Hero.__index = Hero

function Hero.new(heroData)
    local self = setmetatable({}, Hero)

    -- Data reference
    self.data = heroData

    -- Identity
    self.id = heroData.id
    self.name = heroData.name
    self.nameEn = heroData.nameEn
    self.type = heroData.type
    self.description = heroData.description or ""
    self.color = heroData.color or {1, 1, 1}

    -- Position (grid coordinates)
    self.gridX = 0
    self.gridY = 0
    self.pixelX = 0
    self.pixelY = 0

    -- Attributes
    self.attributes = Attribute.new(heroData.attributes)

    -- Status
    self.alive = true
    self.active = true -- Can act in battle

    -- Skills
    self.skills = heroData.skills or {}

    -- Equipment (placeholder)
    self.equipment = heroData.equipment or {}

    -- Level and experience
    self.level = 1
    self.exp = 0
    self.expToNextLevel = 100

    -- Combat state
    self.lastAttackTime = 0
    self.actionPoints = 100

    return self
end

-- Get display name
function Hero:getName()
    return self.name
end

-- Get hero type
function Hero:getType()
    return self.type
end

-- Set position on grid
function Hero:setGridPosition(x, y)
    self.gridX = x
    self.gridY = y
end

-- Get grid position
function Hero:getGridPosition()
    return self.gridX, self.gridY
end

-- Get grid position as table
function Hero:getPosition()
    return {x = self.gridX, y = self.gridY}
end

-- Set pixel position (for smooth movement)
function Hero:setPixelPosition(x, y)
    self.pixelX = x
    self.pixelY = y
end

-- Take damage
function Hero:takeDamage(amount)
    local hp = self.attributes:get("hp")
    local actualDamage = math.max(1, amount) -- Minimum 1 damage
    self.attributes:modifyHp(-actualDamage)

    if self.attributes:get("hp") <= 0 then
        self.alive = false
    end

    return actualDamage
end

-- Heal
function Hero:heal(amount)
    return self.attributes:modifyHp(amount)
end

-- Restore MP
function Hero:restoreMp(amount)
    return self.attributes:modifyMp(amount)
end

-- Check if alive
function Hero:isAlive()
    return self.alive
end

-- Check if can act
function Hero:canAct()
    return self.alive and self.active
end

-- Revive
function Hero:revive(fullHealth)
    self.alive = true
    if fullHealth then
        self.attributes:healFull()
    else
        self.attributes:modifyHp(self.attributes:get("maxHp") * 0.5)
    end
end

-- Add experience
function Hero:addExperience(amount)
    self.exp = self.exp + amount

    -- Check level up
    while self.exp >= self.expToNextLevel do
        self:levelUp()
    end
end

-- Level up
function Hero:levelUp()
    self.level = self.level + 1
    self.exp = self.exp - self.expToNextLevel
    self.expToNextLevel = math.floor(self.expToNextLevel * 1.5)

    -- Increase base stats
    self.attributes:addBase("str", 2)
    self.attributes:addBase("agi", 2)
    self.attributes:addBase("int", 2)
end

-- Use skill
function Hero:useSkill(skillId)
    -- Skill system placeholder
    return true
end

-- Get HP percentage
function Hero:getHpPercent()
    local hp = self.attributes:get("hp")
    local maxHp = self.attributes:get("maxHp")
    if maxHp <= 0 then return 0 end
    return hp / maxHp
end

-- Get MP percentage
function Hero:getMpPercent()
    local mp = self.attributes:get("mp")
    local maxMp = self.attributes:get("maxMp")
    if maxMp <= 0 then return 0 end
    return mp / maxMp
end

-- Get attribute value
function Hero:getAttribute(name)
    return self.attributes:get(name)
end

-- Clone hero (for creating instances from data)
function Hero.clone(heroData)
    return Hero.new(heroData)
end

return Hero
