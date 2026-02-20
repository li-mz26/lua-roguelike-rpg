-- Heroes Data Configuration

local Heroes = {}

-- Hero types
Heroes.TYPE_STR = "strength"
Heroes.TYPE_AGI = "agility"
Heroes.TYPE_INT = "intelligence"

-- Hero definitions
Heroes.list = {
    -- Warrior - Strength type
    warrior = {
        id = "warrior",
        name = "战士",
        nameEn = "Warrior",
        type = Heroes.TYPE_STR,
        description = "坚韧的战士,拥有高生命和物理防御",
        color = {0.8, 0.2, 0.2},
        -- Base attributes
        attributes = {
            hp = 120,
            maxHp = 120,
            mp = 30,
            maxMp = 30,
            str = 12,
            agi = 8,
            int = 5,
            -- Derived
            attack = 15,
            defense = 10,
            magicResist = 3,
            attackSpeed = 1.0,
            critRate = 0.05,
            critDamage = 1.5,
            dodge = 0.03,
            speed = 100
        },
        -- Skills
        skills = {
            "strike",     -- Active: Basic attack
            "shield_bash" -- Active: Stun enemy
        },
        -- Starting equipment
        equipment = {
            weapon = "sword",
            armor = "leather",
            accessory = nil
        }
    },

    -- Rogue - Agility type
    rogue = {
        id = "rogue",
        name = "刺客",
        nameEn = "Rogue",
        type = Heroes.TYPE_AGI,
        description = "敏捷的杀手,拥有高攻击速度和闪避",
        color = {0.2, 0.8, 0.2},
        attributes = {
            hp = 80,
            maxHp = 80,
            mp = 40,
            maxMp = 40,
            str = 6,
            agi = 14,
            int = 6,
            attack = 18,
            defense = 4,
            magicResist = 4,
            attackSpeed = 1.5,
            critRate = 0.15,
            critDamage = 1.8,
            dodge = 0.15,
            speed = 120
        },
        skills = {
            "strike",
            "backstab"
        },
        equipment = {
            weapon = "dagger",
            armor = nil,
            accessory = nil
        }
    },

    -- Mage - Intelligence type
    mage = {
        id = "mage",
        name = "法师",
        nameEn = "Mage",
        type = Heroes.TYPE_INT,
        description = "强大的施法者,擅长魔法攻击",
        color = {0.2, 0.4, 0.9},
        attributes = {
            hp = 60,
            maxHp = 60,
            mp = 80,
            maxMp = 80,
            str = 4,
            agi = 6,
            int = 16,
            attack = 8,
            defense = 2,
            magicResist = 10,
            attackSpeed = 0.9,
            critRate = 0.05,
            critDamage = 1.5,
            dodge = 0.05,
            speed = 90
        },
        skills = {
            "strike",
            "fireball"
        },
        equipment = {
            weapon = "staff",
            armor = nil,
            accessory = "ring"
        }
    }
}

-- Get hero by id
function Heroes.get(id)
    return Heroes.list[id]
end

-- Get all hero ids
function Heroes.getAllIds()
    local ids = {}
    for id, _ in pairs(Heroes.list) do
        table.insert(ids, id)
    end
    return ids
end

return Heroes
