-- Lua Roguelike RPG - Main Entry Point
-- Uses LÖVE 2D (https://love2d.org/)

local gameState = "start" -- "start", "playing", "gameover"

function love.load()
    -- Set window title
    love.window.setTitle("Lua Roguelike RPG")
    
    -- Load fonts
    titleFont = love.graphics.newFont(48)
    subtitleFont = love.graphics.newFont(24)
    promptFont = love.graphics.newFont(18)
end

function love.update(dt)
    -- Update game logic based on state
end

function love.draw()
    if gameState == "start" then
        drawStartScreen()
    elseif gameState == "playing" then
        drawGameScreen()
    end
end

function love.keypressed(key)
    if gameState == "start" then
        if key == "return" or key == "space" then
            gameState = "playing"
        end
    elseif gameState == "playing" then
        if key == "escape" then
            gameState = "start"
        end
    end
end

function drawStartScreen()
    -- Background color (dark gray)
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
    
    -- Title
    love.graphics.setFont(titleFont)
    love.graphics.setColor(0.8, 0.2, 0.2) -- Red
    local title = "Lua Roguelike RPG"
    local titleWidth = titleFont:getWidth(title)
    love.graphics.print(title, (love.graphics.getWidth() - titleWidth) / 2, love.graphics.getHeight() / 4)
    
    -- Subtitle
    love.graphics.setFont(subtitleFont)
    love.graphics.setColor(0.7, 0.7, 0.7) -- Light gray
    local subtitle = "A Turn-Based Dungeon Crawler"
    local subtitleWidth = subtitleFont:getWidth(subtitle)
    love.graphics.print(subtitle, (love.graphics.getWidth() - subtitleWidth) / 2, love.graphics.getHeight() / 2)
    
    -- Prompt
    love.graphics.setFont(promptFont)
    love.graphics.setColor(0.9, 0.9, 0.9) -- White
    local prompt = "Press Enter or Space to Start"
    local promptWidth = promptFont:getWidth(prompt)
    love.graphics.print(prompt, (love.graphics.getWidth() - promptWidth) / 2, love.graphics.getHeight() * 3 / 4)
end

function drawGameScreen()
    -- Placeholder for game screen
    love.graphics.setBackgroundColor(0.05, 0.05, 0.05)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Game Started! Press Escape to Return to Title", 50, 50)
end
