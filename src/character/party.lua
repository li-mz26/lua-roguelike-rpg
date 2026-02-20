-- Party System
-- Manages the player's party of heroes

local Hero = require("src.character.hero")

local Party = {}
Party.__index = Party

-- Max party size
Party.MAX_SIZE = 4

function Party.new()
    local self = setmetatable({}, Party)
    self.heroes = {}
    self.leaderIndex = 1 -- Index of party leader
    self.gold = 0
    return self
end

-- Add hero to party
function Party:addHero(hero)
    if #self.heroes >= Party.MAX_SIZE then
        return false, "Party is full"
    end

    table.insert(self.heroes, hero)
    return true
end

-- Remove hero from party
function Party:removeHero(index)
    if index < 1 or index > #self.heroes then
        return false, "Invalid index"
    end

    local removed = table.remove(self.heroes, index)

    -- Adjust leader index if needed
    if self.leaderIndex > #self.heroes then
        self.leaderIndex = 1
    end

    return true, removed
end

-- Get hero by index
function Party:getHero(index)
    return self.heroes[index]
end

-- Get hero by id
function Party:getHeroById(id)
    for _, hero in ipairs(self.heroes) do
        if hero.id == id then
            return hero
        end
    end
    return nil
end

-- Get all heroes
function Party:getAllHeroes()
    return self.heroes
end

-- Get party size
function Party:getSize()
    return #self.heroes
end

-- Get max party size
function Party:getMaxSize()
    return Party.MAX_SIZE
end

-- Check if party is empty
function Party:isEmpty()
    return #self.heroes == 0
end

-- Check if party is full
function Party:isFull()
    return #self.heroes >= Party.MAX_SIZE
end

-- Get leader
function Party:getLeader()
    return self.heroes[self.leaderIndex]
end

-- Set leader
function Party:setLeader(index)
    if index >= 1 and index <= #self.heroes then
        self.leaderIndex = index
        return true
    end
    return false
end

-- Get alive heroes
function Party:getAliveHeroes()
    local alive = {}
    for _, hero in ipairs(self.heroes) do
        if hero:isAlive() then
            table.insert(alive, hero)
        end
    end
    return alive
end

-- Get hero count
function Party:getCount()
    return #self.heroes
end

-- Check if any hero is alive
function Party:hasAliveHero()
    for _, hero in ipairs(self.heroes) do
        if hero:isAlive() then
            return true
        end
    end
    return false
end

-- Add gold
function Party:addGold(amount)
    self.gold = self.gold + amount
end

-- Spend gold
function Party:spendGold(amount)
    if self.gold >= amount then
        self.gold = self.gold - amount
        return true
    end
    return false
end

-- Get gold
function Party:getGold()
    return self.gold
end

-- Heal all heroes
function Party:healAll()
    for _, hero in ipairs(self.heroes) do
        hero:heal(hero.attributes:get("maxHp"))
    end
end

-- Revive all dead heroes (with reduced health)
function Party:reviveAll()
    for _, hero in ipairs(self.heroes) do
        if not hero:isAlive() then
            hero:revive(false)
        end
    end
end

-- Clear party
function Party:clear()
    self.heroes = {}
    self.leaderIndex = 1
end

return Party
