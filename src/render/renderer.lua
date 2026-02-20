-- Main Renderer
-- Handles all game rendering

local Isometric = require("src.render.isometric")

local Renderer = {}
Renderer.__index = Renderer

function Renderer.new(screenWidth, screenHeight)
    local self = setmetatable({}, Renderer)
    self.screenWidth = screenWidth or 800
    self.screenHeight = screenHeight or 600

    -- Isometric projection
    self.iso = Isometric.new(32, 16)
    self.iso:setOrigin(self.screenWidth / 2, 100)

    -- Camera offset
    self.cameraX = 0
    self.cameraY = 0
    self.zoom = 1

    -- Colors
    self.colors = {
        floor = {0.25, 0.25, 0.3},
        wall = {0.15, 0.15, 0.2},
        highlight = {0.4, 0.4, 0.5},
        cursor = {1, 1, 0, 0.5},
        hero = {0.2, 0.8, 0.2},
        enemy = {0.8, 0.2, 0.2}
    }

    return self
end

-- Set camera position
function Renderer:setCamera(x, y)
    self.cameraX = x or 0
    self.cameraY = y or 0
end

-- Center camera on position
function Renderer:centerOn(gridX, gridY)
    local screenX, screenY = self.iso:gridToScreen(gridX, gridY)
    self.cameraX = self.screenWidth / 2 - screenX
    self.cameraY = self.screenHeight / 2 - screenY
end

-- Get isometric projection
function Renderer:getIsometric()
    return self.iso
end

-- Draw tile
function Renderer:drawTile(gridX, gridY, tileType, isHighlighted)
    local screenX, screenY = self.iso:gridToScreen(gridX, gridY)
    screenX = screenX + self.cameraX
    screenY = screenY + self.cameraY

    local color
    if isHighlighted then
        color = self.colors.highlight
    else
        color = self.colors.floor
    end

    -- Simple diamond shape for isometric tile
    love.graphics.setColor(color)
    local w = self.iso.tileWidth / 2
    local h = self.iso.tileHeight / 2

    love.graphics.polygon("fill", {
        screenX, screenY - h,        -- Top
        screenX + w, screenY,        -- Right
        screenX, screenY + h,        -- Bottom
        screenX - w, screenY          -- Left
    })

    -- Draw outline
    love.graphics.setColor(0.1, 0.1, 0.15)
    love.graphics.polygon("line", {
        screenX, screenY - h,
        screenX + w, screenY,
        screenX, screenY + h,
        screenX - w, screenY
    })
end

-- Draw unit (hero or enemy)
function Renderer:drawUnit(gridX, gridY, color, name)
    local screenX, screenY = self.iso:gridToScreen(gridX, gridY)
    screenX = screenX + self.cameraX
    screenY = screenY + self.cameraY

    -- Draw unit as a simple circle
    love.graphics.setColor(color)
    love.graphics.circle("fill", screenX, screenY - 10, 12)

    -- Draw outline
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.circle("line", screenX, screenY - 10, 12)

    -- Draw name
    if name then
        love.graphics.setColor(1, 1, 1)
        local font = love.graphics.getFont()
        local nameWidth = font:getWidth(name)
        love.graphics.print(name, screenX - nameWidth / 2, screenY - 35)
    end
end

-- Draw health bar
function Renderer:drawHealthBar(gridX, gridY, hpPercent, maxWidth)
    local screenX, screenY = self.iso:gridToScreen(gridX, gridY)
    screenX = screenX + self.cameraX
    screenY = screenY + self.cameraY

    maxWidth = maxWidth or 30

    -- Background
    love.graphics.setColor(0.2, 0, 0)
    love.graphics.rectangle("fill", screenX - maxWidth / 2, screenY - 25, maxWidth, 4)

    -- Health
    local healthWidth = maxWidth * hpPercent
    local healthColor = hpPercent > 0.5 and {0, 0.8, 0} or (hpPercent > 0.25 and {0.8, 0.8, 0} or {0.8, 0, 0})
    love.graphics.setColor(healthColor)
    love.graphics.rectangle("fill", screenX - maxWidth / 2, screenY - 25, healthWidth, 4)
end

-- Draw cursor highlight
function Renderer:drawCursor(gridX, gridY)
    local screenX, screenY = self.iso:gridToScreen(gridX, gridY)
    screenX = screenX + self.cameraX
    screenY = screenY + self.cameraY

    love.graphics.setColor(self.colors.cursor)
    local w = self.iso.tileWidth / 2
    local h = self.iso.tileHeight / 2

    love.graphics.polygon("line", {
        screenX, screenY - h,
        screenX + w, screenY,
        screenX, screenY + h,
        screenX - w, screenY
    })
end

-- Draw floor
function Renderer:drawFloor(floor)
    local tileW, tileH = floor.width, floor.height

    for y = 1, tileH do
        for x = 1, tileW do
            local tile = floor:getTile(x, y)
            if tile == 0 then -- Floor
                self:drawTile(x, y, tile)
            end
        end
    end
end

-- Clear screen with background color
function Renderer:clear(r, g, b)
    love.graphics.setBackgroundColor(r or 0.05, g or 0.05, b or 0.08)
end

-- Get screen dimensions
function Renderer:getDimensions()
    return self.screenWidth, self.screenHeight
end

-- Set dimensions
function Renderer:setDimensions(width, height)
    self.screenWidth = width
    self.screenHeight = height
end

return Renderer
