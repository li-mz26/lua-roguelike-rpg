-- Input Manager
-- Handles keyboard and mouse input

local Input = {}
Input.__index = Input

function Input.new()
    local self = setmetatable({}, Input)
    self.keys = {}
    self.keysJustPressed = {}
    self.mouseButtons = {}
    self.mouseButtonsJustPressed = {}
    self.mouseX = 0
    self.mouseY = 0
    return self
end

-- Update input state (call at start of love.update)
function Input:update()
    self.keysJustPressed = {}
    self.mouseButtonsJustPressed = {}
end

-- Key pressed handler
function Input:keyPressed(key)
    if not self.keys[key] then
        self.keysJustPressed[key] = true
    end
    self.keys[key] = true
end

-- Key released handler
function Input:keyReleased(key)
    self.keys[key] = false
end

-- Mouse pressed handler
function Input:mousePressed(x, y, button)
    self.mouseX = x
    self.mouseY = y
    if not self.mouseButtons[button] then
        self.mouseButtonsJustPressed[button] = true
    end
    self.mouseButtons[button] = true
end

-- Mouse released handler
function Input:mouseReleased(x, y, button)
    self.mouseX = x
    self.mouseY = y
    self.mouseButtons[button] = false
end

-- Mouse moved handler
function Input:mouseMoved(x, y)
    self.mouseX = x
    self.mouseY = y
end

-- Check if key is down
function Input:isKeyDown(key)
    return self.keys[key] == true
end

-- Check if key was just pressed this frame
function Input:isKeyJustPressed(key)
    return self.keysJustPressed[key] == true
end

-- Check if mouse button is down
function Input:isMouseDown(button)
    return self.mouseButtons[button] == true
end

-- Check if mouse button was just pressed this frame
function Input:isMouseButtonJustPressed(button)
    return self.mouseButtonsJustPressed[button] == true
end

-- Get mouse position
function Input:getMousePosition()
    return self.mouseX, self.mouseY
end

-- Check if key is pressed (alias for isKeyDown)
function Input:pressed(key)
    return self:isKeyDown(key)
end

-- Check if key was just pressed (alias for isKeyJustPressed)
function Input:justPressed(key)
    return self:isKeyJustPressed(key)
end

-- Check if any key is down
function Input:anyKeyDown()
    for _, v in pairs(self.keys) do
        if v then return true end
    end
    return false
end

-- Clear all input state
function Input:clear()
    self.keys = {}
    self.keysJustPressed = {}
    self.mouseButtons = {}
    self.mouseButtonsJustPressed = {}
end

return Input
