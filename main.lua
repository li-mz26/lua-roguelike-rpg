-- Lua Roguelike RPG - Main Entry Point
-- Uses LÖVE 2D (https://love2d.org/)

-- Core
local StateManager = require("src.core.state")
local Event = require("src.core.event")

-- Data
local Heroes = require("src.data.heroes")
local Enemies = require("src.data.enemies")

-- Character
local Hero = require("src.character.hero")
local Party = require("src.character.party")

-- Dungeon
local Dungeon = require("src.dungeon.dungeon")

-- Battle
local Battle = require("src.battle.battle")

-- UI
local UIManager = require("src.ui.manager")
local Menu = require("src.ui.menu")
local Button = require("src.ui.button")
local Label = require("src.ui.label")
local Panel = require("src.ui.panel")

-- Input
local Input = require("src.input.input")

-- Render
local Renderer = require("src.render.renderer")

-- Game Class
local Game = {}

-- Game states
Game.STATE_START = "start"
Game.STATE_SELECT = "select"
Game.STATE_DUNGEON = "dungeon"
Game.STATE_BATTLE = "battle"
Game.STATE_GAMEOVER = "gameover"
Game.STATE_VICTORY = "victory"

function Game:new()
    local self = {}

    -- Core systems
    self.state = StateManager.new()
    self.events = Event.new()

    -- Game data
    self.party = Party.new()
    self.dungeon = nil
    self.battle = nil

    -- Input and render
    self.input = Input.new()
    self.renderer = nil

    -- UI
    self.ui = nil

    -- Game state
    self.cursorX = 0
    self.cursorY = 0
    self.cursorGridX = 0
    self.cursorGridY = 0
    self.selectedHero = nil

    -- Fonts
    self.titleFont = nil
    self.subtitleFont = nil
    self.uiFont = nil

    return self
end

function Game:init()
    -- Initialize renderer
    self.renderer = Renderer.new(800, 600)
    self.renderer:clear()

    -- Load fonts
    self.titleFont = love.graphics.newFont(48)
    self.subtitleFont = love.graphics.newFont(24)
    self.uiFont = love.graphics.newFont(16)

    -- Initialize UI
    self:createUI()

    -- Set initial state
    self.state:change(Game.STATE_START)
end

function Game:createUI()
    self.ui = UIManager.new()

    -- Start Screen
    local startScreen = self:createStartScreen()
    self.ui:addScreen("start", startScreen)

    -- Select Screen
    local selectScreen = self:createSelectScreen()
    self.ui:addScreen("select", selectScreen)

    -- Dungeon Screen
    local dungeonScreen = self:createDungeonScreen()
    self.ui:addScreen("dungeon", dungeonScreen)

    -- Battle Screen
    local battleScreen = self:createBattleScreen()
    self.ui:addScreen("battle", battleScreen)

    -- Game Over Screen
    local gameoverScreen = self:createGameoverScreen()
    self.ui:addScreen("gameover", gameoverScreen)

    -- Victory Screen
    local victoryScreen = self:createVictoryScreen()
    self.ui:addScreen("victory", victoryScreen)

    -- Set initial screen
    self.ui:setScreen("start")
end

function Game:createStartScreen()
    local screen = {}

    function screen:update(dt, mx, my)
    end

    function screen:draw()
        -- Background
        love.graphics.setBackgroundColor(0.1, 0.1, 0.15)
        love.graphics.setColor(1, 1, 1)

        -- Title
        love.graphics.setFont(self.titleFont)
        love.graphics.setColor(0.9, 0.3, 0.2)
        local title = "英雄地牢"
        love.graphics.print(title, 800 / 2 - self.titleFont:getWidth(title) / 2, 150)

        -- Subtitle
        love.graphics.setFont(self.subtitleFont)
        love.graphics.setColor(0.7, 0.7, 0.7)
        local subtitle = "Heroes Dungeon"
        love.graphics.print(subtitle, 800 / 2 - self.subtitleFont:getWidth(subtitle) / 2, 210)

        -- Prompt
        love.graphics.setFont(self.uiFont)
        love.graphics.setColor(0.9, 0.9, 0.9)
        local prompt = "按 回车键 或 空格键 开始"
        love.graphics.print(prompt, 800 / 2 - self.uiFont:getWidth(prompt) / 2, 400)

        -- Controls
        love.graphics.setColor(0.5, 0.5, 0.5)
        local controls = "方向键/WASD 移动 | 空格 攻击 | ESC 返回"
        love.graphics.print(controls, 800 / 2 - self.uiFont:getWidth(controls) / 2, 500)
    end

    function screen:keyPressed(key)
        if key == "return" or key == "space" then
            self.ui:setScreen("select")
            self.state:change(Game.STATE_SELECT)
        end
    end

    function screen:mousePressed(x, y, button)
    end

    function screen:mouseReleased(x, y, button)
    end

    return screen
end

function Game:createSelectScreen()
    local screen = {}
    local heroButtons = {}
    local heroLabels = {}

    function screen:onShow()
        -- Clear old buttons
        heroButtons = {}
        heroLabels = {}
    end

    function screen:update(dt, mx, my)
        -- Update hover states
    end

    function screen:draw()
        love.graphics.setBackgroundColor(0.1, 0.1, 0.15)
        love.graphics.setColor(1, 1, 1)

        -- Title
        love.graphics.setFont(self.titleFont)
        love.graphics.setColor(0.9, 0.8, 0.3)
        local title = "选择英雄"
        love.graphics.print(title, 800 / 2 - self.titleFont:getWidth(title) / 2, 80)

        -- Draw hero options
        local heroes = Heroes.getAllIds()
        local startX = 150
        local startY = 180
        local spacing = 200

        for i, heroId in ipairs(heroes) do
            local heroData = Heroes.get(heroId)
            local x = startX + (i - 1) * spacing

            -- Hero card background
            love.graphics.setColor(0.15, 0.15, 0.2)
            love.graphics.rectangle("fill", x - 60, startY - 60, 120, 200)
            love.graphics.setColor(0.3, 0.3, 0.4)
            love.graphics.rectangle("line", x - 60, startY - 60, 120, 200)

            -- Hero name
            love.graphics.setFont(self.subtitleFont)
            love.graphics.setColor(heroData.color)
            love.graphics.print(heroData.name, x - self.subtitleFont:getWidth(heroData.name) / 2, startY - 40)

            -- Hero type
            love.graphics.setFont(self.uiFont)
            love.graphics.setColor(0.7, 0.7, 0.7)
            local typeName = heroData.type == "strength" and "力量型" or
                            (heroData.type == "agility" and "敏捷型" or "智力型")
            love.graphics.print(typeName, x - self.uiFont:getWidth(typeName) / 2, startY)

            -- Hero description
            love.graphics.setColor(0.6, 0.6, 0.6)
            local desc = heroData.description
            love.graphics.print(desc, x - 50, startY + 30, 100, "center")

            -- Stats preview
            love.graphics.setColor(0.5, 0.8, 0.5)
            local stats = string.format("HP:%d ATK:%d",
                heroData.attributes.hp,
                heroData.attributes.attack)
            love.graphics.print(stats, x - self.uiFont:getWidth(stats) / 2, startY + 70)
        end

        -- Prompt
        love.graphics.setFont(self.uiFont)
        love.graphics.setColor(0.9, 0.9, 0.9)
        local prompt = "按 1/2/3 选择英雄，或 鼠标点击"
        love.graphics.print(prompt, 800 / 2 - self.uiFont:getWidth(prompt) / 2, 480)

        -- Back prompt
        love.graphics.setColor(0.5, 0.5, 0.5)
        local back = "按 ESC 返回"
        love.graphics.print(back, 800 / 2 - self.uiFont:getWidth(back) / 2, 520)
    end

    function screen:keyPressed(key)
        local heroes = Heroes.getAllIds()
        if key == "1" then
            self:selectHero(heroes[1])
        elseif key == "2" then
            self:selectHero(heroes[2])
        elseif key == "3" then
            self:selectHero(heroes[3])
        elseif key == "escape" then
            self.ui:setScreen("start")
            self.state:change(Game.STATE_START)
        end
    end

    function screen:mousePressed(x, y, button)
        local heroes = Heroes.getAllIds()
        local startX = 150
        local startY = 180
        local spacing = 200

        for i, heroId in ipairs(heroes) do
            local x = startX + (i - 1) * spacing
            if x - 60 <= mx and mx <= x + 60 and startY - 60 <= my and my <= startY + 140 then
                self:selectHero(heroId)
                break
            end
        end
    end

    function screen:selectHero(heroId)
        local heroData = Heroes.get(heroId)
        self.selectedHero = Hero.new(heroData)

        -- Add to party
        self.party:addHero(self.selectedHero)

        -- Start dungeon
        self.dungeon = Dungeon.new(3)
        self.party:getLeader():setGridPosition(1, 1)

        self.ui:setScreen("dungeon")
        self.state:change(Game.STATE_DUNGEON)
    end

    return screen
end

function Game:createDungeonScreen()
    local screen = {}

    function screen:update(dt, mx, my)
    end

    function screen:draw()
        if not self.dungeon or not self.dungeon:getCurrentFloor() then return end

        local floor = self.dungeon:getCurrentFloor()

        -- Clear
        self.renderer:clear()

        -- Draw floor
        self:drawFloor(floor)

        -- Draw heroes
        local hero = self.party:getLeader()
        if hero then
            local gx, gy = hero:getGridPosition()
            self.renderer:drawUnit(gx, gy, {0.2, 0.8, 0.2}, hero.name)
            self.renderer:drawHealthBar(gx, gy, hero:getHpPercent())
        end

        -- Draw enemies (if in room)
        local room = floor:getCurrentRoom()
        if room then
            for _, enemy in ipairs(room:getEnemies()) do
                local gx, gy = enemy:getGridPosition()
                self.renderer:drawUnit(gx, gy, {0.8, 0.2, 0.2}, enemy.name)
                self.renderer:drawHealthBar(gx, gy, enemy:getHpPercent())
            end
        end

        -- Draw cursor
        self.renderer:drawCursor(self.cursorGridX, self.cursorGridY)

        -- Draw UI overlay
        self:drawDungeonUI()
    end

    function screen:drawDungeonUI()
        -- Top bar
        love.graphics.setColor(0.1, 0.1, 0.15, 0.9)
        love.graphics.rectangle("fill", 0, 0, 800, 40)

        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(self.uiFont)
        love.graphics.print(string.format("第 %d 层 / 共 %d 层",
            self.dungeon:getFloorNumber(), self.dungeon:getMaxFloors()), 20, 12)

        -- Hero info
        local hero = self.party:getLeader()
        if hero then
            local hpStr = string.format("HP: %d/%d", hero.attributes:get("hp"), hero.attributes:get("maxHp"))
            local mpStr = string.format("MP: %d/%d", hero.attributes:get("mp"), hero.attributes:get("maxMp"))
            love.graphics.setColor(0.8, 0.3, 0.3)
            love.graphics.print(hpStr, 200, 12)
            love.graphics.setColor(0.3, 0.5, 0.9)
            love.graphics.print(mpStr, 350, 12)
        end

        -- Instructions
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.print("方向键/WASD: 移动 | 空格: 攻击 | ESC: 退出", 450, 12)
    end

    function screen:drawFloor(floor)
        local tileW, tileH = floor.width, floor.height

        for y = 1, tileH do
            for x = 1, tileW do
                local tile = floor:getTile(x, y)
                local isHighlighted = (x == self.cursorGridX and y == self.cursorGridY)
                self.renderer:drawTile(x, y, tile, isHighlighted)
            end
        end
    end

    function screen:keyPressed(key)
        local hero = self.party:getLeader()
        if not hero then return end

        local dx, dy = 0, 0
        if key == "up" or key == "w" then dy = -1
        elseif key == "down" or key == "s" then dy = 1
        elseif key == "left" or key == "a" then dx = -1
        elseif key == "right" or key == "d" then dx = 1
        elseif key == "space" then
            self:handleAttack()
            return
        elseif key == "escape" then
            -- Return to title
            self.ui:setScreen("start")
            self.state:change(Game.STATE_START)
            return
        else
            return
        end

        -- Move hero
        local gx, gy = hero:getGridPosition()
        local newX, newY = gx + dx, gy + dy
        local floor = self.dungeon:getCurrentFloor()

        if floor:isWalkable(newX, newY) then
            hero:setGridPosition(newX, newY)
            self.renderer:centerOn(newX, newY)

            -- Check for room change
            local newRoom = floor:getRoomAt(newX, newY)
            if newRoom and newRoom ~= floor:getCurrentRoom() then
                floor:setCurrentRoom(newRoom)

                -- Check for enemies in room
                if newRoom:hasEnemies() then
                    self:startCombat(newRoom)
                end
            end

            -- Check for stairs
            local stairs = floor:getStairsPosition()
            if stairs and newX == stairs.x and newY == stairs.y then
                if self.dungeon:nextFloor() then
                    -- Move hero to new floor start
                    local newFloor = self.dungeon:getCurrentFloor()
                    local startRoom = newFloor:getRooms()[1]
                    local startPos = startRoom:getCenter()
                    hero:setGridPosition(startPos.x, startPos.y)
                    self.renderer:centerOn(startPos.x, startPos.y)
                else
                    -- Victory!
                    self.ui:setScreen("victory")
                    self.state:change(Game.STATE_VICTORY)
                end
            end
        end
    end

    function screen:handleAttack()
        local hero = self.party:getLeader()
        local floor = self.dungeon:getCurrentFloor()
        local room = floor:getCurrentRoom()

        if room and room:hasEnemies() then
            -- Attack first enemy in room
            local enemy = room:getEnemies()[1]
            if enemy then
                local damage = hero.attributes:get("attack")
                enemy:takeDamage(damage)

                -- Check if enemy died
                if not enemy:isAlive() then
                    room:removeEnemy(enemy)
                    if not room:hasEnemies() then
                        room.cleared = true
                    end
                end
            end
        end
    end

    function screen:mousePressed(x, y, button)
        self.cursorX, self.cursorY = x, y
        self.cursorGridX, self.cursorGridY = self.renderer.iso:screenToGrid(
            x - self.renderer.cameraX,
            y - self.renderer.cameraY
        )
    end

    function screen:mouseMoved(x, y)
        self.cursorX, self.cursorY = x, y
        self.cursorGridX, self.cursorGridY = self.renderer.iso:screenToGrid(
            x - self.renderer.cameraX,
            y - self.renderer.cameraY
        )
    end

    function screen:startCombat(room)
        -- Create enemies
        local enemies = {}
        local enemyCount = math.random(1, 3)

        for i = 1, enemyCount do
            local enemyData = Enemies.getRandomByDifficulty(self.dungeon:getFloorNumber())
            local enemy = {
                id = enemyData.id,
                name = enemyData.name,
                color = enemyData.color,
                attributes = enemyData.attributes
            }

            -- Position enemy
            local pos = room:getRandomPosition()
            enemy.gridX = pos.x
            enemy.gridY = pos.y

            table.insert(enemies, enemy)
        end

        -- Start battle
        self.battle = Battle.new()
        self.battle:start({hero}, enemies)

        self.ui:setScreen("battle")
        self.state:change(Game.STATE_BATTLE)
    end

    return screen
end

function Game:createBattleScreen()
    local screen = {}

    function screen:update(dt, mx, my)
    end

    function screen:draw()
        if not self.battle then
            self.ui:setScreen("dungeon")
            self.state:change(Game.STATE_DUNGEON)
            return
        end

        love.graphics.setBackgroundColor(0.1, 0.08, 0.08)

        -- Draw battle UI
        love.graphics.setFont(self.titleFont)
        love.graphics.setColor(0.9, 0.3, 0.2)
        local title = "战斗"
        love.graphics.print(title, 800 / 2 - self.titleFont:getWidth(title) / 2, 50)

        -- Draw heroes
        local heroes = self.battle:getHeroes()
        local enemies = self.battle:getEnemies()

        local startY = 150
        local spacing = 60

        love.graphics.setFont(self.subtitleFont)

        -- Heroes
        love.graphics.setColor(0.9, 0.9, 0.9)
        love.graphics.print("我方", 100, startY - 30)

        for i, hero in ipairs(heroes) do
            local y = startY + i * spacing
            love.graphics.setColor(hero.color)
            love.graphics.print(hero.name, 100, y)
            love.graphics.setColor(0.8, 0.3, 0.3)
            love.graphics.print(string.format("HP: %d/%d", hero.hp, hero.maxHp), 250, y)
        end

        -- Enemies
        love.graphics.setColor(0.9, 0.9, 0.9)
        love.graphics.print("敌方", 450, startY - 30)

        for i, enemy in ipairs(enemies) do
            local y = startY + i * spacing
            love.graphics.setColor(enemy.color)
            love.graphics.print(enemy.name, 450, y)
            love.graphics.setColor(0.8, 0.3, 0.3)
            love.graphics.print(string.format("HP: %d/%d", enemy.hp, enemy.maxHp), 600, y)
        end

        -- Instructions
        love.graphics.setFont(self.uiFont)
        love.graphics.setColor(0.7, 0.7, 0.7)
        local prompt = "按 空格 攻击 | 跳过回合按 S"
        love.graphics.print(prompt, 800 / 2 - self.uiFont:getWidth(prompt) / 2, 450)

        -- Current turn indicator
        local currentUnit = self.battle:getCurrentUnit()
        if currentUnit then
            love.graphics.setColor(1, 1, 0.8)
            local turnText = string.format("当前行动: %s", currentUnit.name)
            love.graphics.print(turnText, 800 / 2 - self.uiFont:getWidth(turnText) / 2, 500)
        end

        -- Check battle end
        if self.battle:isOver() then
            if self.battle:getState() == Battle.VICTORY then
                love.graphics.setColor(0.3, 0.9, 0.3)
                love.graphics.setFont(self.titleFont)
                love.graphics.print("胜利!", 800 / 2 - self.titleFont:getWidth("胜利!") / 2, 250)
            else
                love.graphics.setColor(0.9, 0.3, 0.3)
                love.graphics.setFont(self.titleFont)
                love.graphics.print("失败...", 800 / 2 - self.titleFont:getWidth("失败...") / 2, 250)
            end
        end
    end

    function screen:keyPressed(key)
        if not self.battle then return end

        if self.battle:isOver() then
            if key == "return" or key == "space" then
                self:handleBattleEnd()
            end
            return
        end

        local currentUnit = self.battle:getCurrentUnit()
        if not currentUnit or currentUnit.unitType ~= "hero" then
            return
        end

        if key == "space" then
            -- Attack
            local enemies = self.battle:getAliveEnemies()
            if #enemies > 0 then
                local target = enemies[1]
                self.battle:attack(currentUnit, target)

                -- Check if enemy died
                if not target:isAlive() then
                    -- Remove dead enemies from room
                end
            end

            self.battle:endTurn()

            -- Check battle end
            if self.battle:isOver() then
                return
            end

            -- Process enemy turns
            self:processEnemyTurns()
        elseif key == "s" then
            -- Skip turn
            self.battle:endTurn()
            self:processEnemyTurns()
        end
    end

    function screen:processEnemyTurns()
        -- Process enemy AI turns
        while true do
            local currentUnit = self.battle:getCurrentUnit()
            if not currentUnit or currentUnit.unitType == "hero" then
                break
            end

            -- Enemy attacks hero
            local heroes = self.battle:getAliveHeroes()
            if #heroes > 0 then
                local target = heroes[math.random(#heroes)]
                self.battle:attack(currentUnit, target)
            end

            self.battle:endTurn()

            if self.battle:isOver() then
                break
            end
        end
    end

    function screen:handleBattleEnd()
        if self.battle:getState() == Battle.VICTORY then
            -- Return to dungeon
            self.battle = nil
            self.ui:setScreen("dungeon")
            self.state:change(Game.STATE_DUNGEON)
        else
            -- Game over
            self.battle = nil
            self.ui:setScreen("gameover")
            self.state:change(Game.STATE_GAMEOVER)
        end
    end

    return screen
end

function Game:createGameoverScreen()
    local screen = {}

    function screen:update(dt, mx, my)
    end

    function screen:draw()
        love.graphics.setBackgroundColor(0.1, 0.05, 0.05)
        love.graphics.setColor(0.9, 0.2, 0.2)

        love.graphics.setFont(self.titleFont)
        local title = "游戏结束"
        love.graphics.print(title, 800 / 2 - self.titleFont:getWidth(title) / 2, 200)

        love.graphics.setFont(self.subtitleFont)
        love.graphics.setColor(0.7, 0.7, 0.7)
        local subtitle = "你倒在了地牢中..."
        love.graphics.print(subtitle, 800 / 2 - self.subtitleFont:getWidth(subtitle) / 2, 280)

        love.graphics.setFont(self.uiFont)
        love.graphics.setColor(0.9, 0.9, 0.9)
        local prompt = "按 回车键 重新开始"
        love.graphics.print(prompt, 800 / 2 - self.uiFont:getWidth(prompt) / 2, 400)
    end

    function screen:keyPressed(key)
        if key == "return" or key == "space" then
            -- Reset game
            self.party = Party.new()
            self.dungeon = nil
            self.battle = nil
            self.selectedHero = nil

            self.ui:setScreen("start")
            self.state:change(Game.STATE_START)
        end
    end

    return screen
end

function Game:createVictoryScreen()
    local screen = {}

    function screen:update(dt, mx, my)
    end

    function screen:draw()
        love.graphics.setBackgroundColor(0.05, 0.1, 0.05)
        love.graphics.setColor(0.3, 0.9, 0.3)

        love.graphics.setFont(self.titleFont)
        local title = "通关成功!"
        love.graphics.print(title, 800 / 2 - self.titleFont:getWidth(title) / 2, 200)

        love.graphics.setFont(self.subtitleFont)
        love.graphics.setColor(0.9, 0.9, 0.5)
        local subtitle = "你成功穿越了地牢!"
        love.graphics.print(subtitle, 800 / 2 - self.subtitleFont:getWidth(subtitle) / 2, 280)

        love.graphics.setFont(self.uiFont)
        love.graphics.setColor(0.9, 0.9, 0.9)
        local prompt = "按 回车键 重新开始"
        love.graphics.print(prompt, 800 / 2 - self.uiFont:getWidth(prompt) / 2, 400)
    end

    function screen:keyPressed(key)
        if key == "return" or key == "space" then
            -- Reset game
            self.party = Party.new()
            self.dungeon = nil
            self.battle = nil
            self.selectedHero = nil

            self.ui:setScreen("start")
            self.state:change(Game.STATE_START)
        end
    end

    return screen
end

-- LÖVE callbacks
function love.load()
    math.randomseed(os.time())

    Game = Game:new()
    Game:init()
end

function love.update(dt)
    local mx, my = love.mouse.getPosition()
    Game.input:update()

    if Game.ui then
        Game.ui:update(dt, mx, my)
    end
end

function love.draw()
    if Game.ui then
        Game.ui:draw()
    end
end

function love.keypressed(key)
    if Game.input then
        Game.input:keyPressed(key)
    end

    if Game.ui then
        Game.ui:keyPressed(key)
    end
end

function love.keyreleased(key)
    if Game.input then
        Game.input:keyReleased(key)
    end

    if Game.ui and Game.ui.getCurrentScreen and Game.ui.getCurrentScreen() then
        local screen = Game.ui:getCurrentScreen()
        if screen.keyReleased then
            screen:keyReleased(key)
        end
    end
end

function love.mousepressed(x, y, button)
    if Game.input then
        Game.input:mousePressed(x, y, button)
    end

    if Game.ui then
        Game.ui:mousePressed(x, y, button)
    end
end

function love.mousereleased(x, y, button)
    if Game.input then
        Game.input:mouseReleased(x, y, button)
    end

    if Game.ui then
        Game.ui:mouseReleased(x, y, button)
    end
end

function love.mousemoved(x, y)
    if Game.input then
        Game.input:mouseMoved(x, y)
    end
end
