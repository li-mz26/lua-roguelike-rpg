-- Battle Manager
-- Manages combat between heroes and enemies

local Unit = require("src.entity.unit")
local Turn = require("src.battle.turn")

local Battle = {}
Battle.__index = Battle

-- Battle states
Battle.NOT_STARTED = "not_started"
Battle.IN_PROGRESS = "in_progress"
Battle.VICTORY = "victory"
Battle.DEFEAT = "defeat"

function Battle.new()
    local self = setmetatable({}, Battle)
    self.state = Battle.NOT_STARTED
    self.turnManager = nil
    self.currentAction = nil
    self.actionLog = {}
    return self
end

-- Start battle with heroes and enemies
function Battle:start(heroes, enemies)
    -- Create unit instances
    local units = {}

    -- Add heroes
    for _, hero in ipairs(heroes) do
        local unit = Unit.new("hero", {
            id = hero.id,
            name = hero.name,
            color = hero.color,
            attributes = {
                hp = hero.attributes:get("hp"),
                maxHp = hero.attributes:get("maxHp"),
                mp = hero.attributes:get("mp"),
                maxMp = hero.attributes:get("maxMp"),
                attack = hero.attributes:get("attack"),
                defense = hero.attributes:get("defense"),
                magicResist = hero.attributes:get("magicResist"),
                speed = hero.attributes:get("speed"),
                critRate = hero.attributes:get("critRate"),
                critDamage = hero.attributes:get("critDamage"),
                dodge = hero.attributes:get("dodge")
            }
        })
        unit.hero = hero -- Reference to hero object
        table.insert(units, unit)
    end

    -- Add enemies
    for _, enemy in ipairs(enemies) do
        local unit = Unit.new("enemy", {
            id = enemy.id,
            name = enemy.name,
            color = enemy.color,
            attributes = {
                hp = enemy.attributes.hp,
                maxHp = enemy.attributes.maxHp,
                mp = enemy.attributes.mp,
                maxMp = enemy.attributes.maxMp,
                attack = enemy.attributes.attack,
                defense = enemy.attributes.defense,
                magicResist = enemy.attributes.magicResist,
                speed = enemy.attributes.speed,
                critRate = enemy.attributes.critRate,
                critDamage = enemy.attributes.critDamage,
                dodge = enemy.attributes.dodge
            }
        })
        unit.enemyData = enemy -- Reference to enemy data
        table.insert(units, unit)
    end

    -- Initialize turn manager
    self.turnManager = Turn.new()
    self.turnManager:setUnits(units)
    self.state = Battle.IN_PROGRESS

    return self.turnManager:getCurrentUnit()
end

-- Get current unit
function Battle:getCurrentUnit()
    if self.turnManager then
        return self.turnManager:getCurrentUnit()
    end
    return nil
end

-- Execute attack action
function Battle:attack(attacker, target)
    if not attacker:canAct() then return nil end

    local damage, dodged = attacker:calculateDamage(), false
    local actualDamage, wasDodged = target:takeDamage(damage)
    wasDodged = wasDodged or (actualDamage == 0)

    -- Log action
    table.insert(self.actionLog, {
        type = "attack",
        attacker = attacker.name,
        target = target.name,
        damage = actualDamage,
        dodged = wasDodged,
        critical = damage > attacker.attack
    })

    attacker:skipTurn()
    return {damage = actualDamage, dodged = wasDodged}
end

-- End current turn
function Battle:endTurn()
    if self.turnManager then
        self.turnManager:nextUnit()
        self:checkBattleEnd()
    end
end

-- Check if battle ended
function Battle:checkBattleEnd()
    if self.turnManager:isBattleOver() then
        if self.turnManager:getState() == Turn.VICTORY then
            self.state = Battle.VICTORY
        elseif self.turnManager:getState() == Turn.DEFEAT then
            self.state = Battle.DEFEAT
        end
    end
end

-- Get battle state
function Battle:getState()
    return self.state
end

-- Check if battle is over
function Battle:isOver()
    return self.state == Battle.VICTORY or self.state == Battle.DEFEAT
end

-- Get turn manager
function Battle:getTurnManager()
    return self.turnManager
end

-- Get heroes
function Battle:getHeroes()
    if self.turnManager then
        return self.turnManager:getHeroes()
    end
    return {}
end

-- Get enemies
function Battle:getEnemies()
    if self.turnManager then
        return self.turnManager:getEnemies()
    end
    return {}
end

-- Get alive heroes
function Battle:getAliveHeroes()
    if self.turnManager then
        return self.turnManager:getAliveHeroes()
    end
    return {}
end

-- Get alive enemies
function Battle:getAliveEnemies()
    if self.turnManager then
        return self.turnManager:getAliveEnemies()
    end
    return {}
end

-- Get action log
function Battle:getActionLog()
    return self.actionLog
end

-- Clear action log
function Battle:clearLog()
    self.actionLog = {}
end

-- Reset battle
function Battle:reset()
    self.state = Battle.NOT_STARTED
    self.turnManager = nil
    self.actionLog = {}
end

return Battle
