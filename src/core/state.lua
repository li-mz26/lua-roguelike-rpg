-- Game State Manager
-- Manages game states: start, select, dungeon, battle, gameover

local State = {}
State.__index = State

-- Game states
State.START = "start"
State.SELECT = "select"
State.DUNGEON = "dungeon"
State.BATTLE = "battle"
State.GAMEOVER = "gameover"
State.VICTORY = "victory"

function State.new()
    local self = setmetatable({}, State)
    self.current = State.START
    self.previous = nil
    self.data = {} -- State-specific data
    return self
end

function State:change(newState, data)
    self.previous = self.current
    self.current = newState
    self.data = data or {}
    return self.current
end

function State:back()
    if self.previous then
        self.current, self.previous = self.previous, self.current
    end
    return self.current
end

function State:is(state)
    return self.current == state
end

function State:canGoBack()
    return self.previous ~= nil
end

function State:get()
    return self.current
end

function State:getData()
    return self.data
end

function State:setData(key, value)
    self.data[key] = value
end

function State:getDataValue(key)
    return self.data[key]
end

return State
