-- Enemies Data Configuration

local Enemies = {}

-- Enemy types
Enemies.TYPE_NORMAL = "normal"
Enemies.TYPE_ELITE = "elite"
Enemies.TYPE_BOSS = "boss"

-- Enemy definitions
Enemies.list = {
    -- Goblin - Basic enemy
    goblin = {
        id = "goblin",
        name = "哥布林",
        nameEn = "Goblin",
        type = Enemies.TYPE_NORMAL,
        difficulty = 1,
        color = {0.3, 0.8, 0.3},
        attributes = {
            hp = 30,
            maxHp = 30,
            mp = 10,
            maxMp = 10,
            attack = 8,
            defense = 2,
            magicResist = 1,
            attackSpeed = 1.0,
            critRate = 0.05,
            critDamage = 1.5,
            dodge = 0.1,
            speed = 80
        },
        ai = "basic",
        expReward = 10,
        goldReward = 5
    },

    -- Orc - Stronger enemy
    orc = {
        id = "orc",
        name = "兽人",
        nameEn = "Orc",
        type = Enemies.TYPE_NORMAL,
        difficulty = 2,
        color = {0.4, 0.6, 0.3},
        attributes = {
            hp = 60,
            maxHp = 60,
            mp = 20,
            maxMp = 20,
            attack = 15,
            defense = 5,
            magicResist = 3,
            attackSpeed = 0.8,
            critRate = 0.1,
            critDamage = 1.5,
            dodge = 0.05,
            speed = 70
        },
        ai = "basic",
        expReward = 20,
        goldReward = 12
    },

    -- Skeleton - Elite enemy
    skeleton = {
        id = "skeleton",
        name = "骷髅战士",
        nameEn = "Skeleton",
        type = Enemies.TYPE_ELITE,
        difficulty = 3,
        color = {0.9, 0.9, 0.8},
        attributes = {
            hp = 80,
            maxHp = 80,
            mp = 25,
            maxMp = 25,
            attack = 20,
            defense = 8,
            magicResist = 5,
            attackSpeed = 1.1,
            critRate = 0.15,
            critDamage = 1.6,
            dodge = 0.1,
            speed = 85
        },
        ai = "aggressive",
        expReward = 40,
        goldReward = 25
    },

    -- Dungeon Boss - Slime King
    slime_king = {
        id = "slime_king",
        name = "史莱姆王",
        nameEn = "Slime King",
        type = Enemies.TYPE_BOSS,
        difficulty = 5,
        color = {0.6, 0.2, 0.8},
        attributes = {
            hp = 200,
            maxHp = 200,
            mp = 50,
            maxMp = 50,
            attack = 25,
            defense = 10,
            magicResist = 8,
            attackSpeed = 0.7,
            critRate = 0.1,
            critDamage = 1.5,
            dodge = 0.15,
            speed = 60
        },
        ai = "boss",
        expReward = 100,
        goldReward = 50,
        skills = {"slimy_touch"}
    }
}

-- Get enemy by id
function Enemies.get(id)
    return Enemies.list[id]
end

-- Get enemies by type
function Enemies.getByType(enemyType)
    local result = {}
    for id, enemy in pairs(Enemies.list) do
        if enemy.type == enemyType then
            result[id] = enemy
        end
    end
    return result
end

-- Get random enemy by difficulty (1-5)
function Enemies.getRandomByDifficulty(difficulty)
    local candidates = {}
    for id, enemy in pairs(Enemies.list) do
        if enemy.type ~= Enemies.TYPE_BOSS and enemy.difficulty <= difficulty + 1 then
            table.insert(candidates, id)
        end
    end
    if #candidates == 0 then
        return Enemies.list.goblin
    end
    local randomId = candidates[math.random(#candidates)]
    return Enemies.list[randomId]
end

return Enemies
