-- Event System
-- Simple event emitter for game events

local Event = {}
Event.__index = Event

function Event.new()
    local self = setmetatable({}, Event)
    self.listeners = {}
    return self
end

-- Subscribe to an event
function Event:on(eventName, callback, context)
    if not self.listeners[eventName] then
        self.listeners[eventName] = {}
    end
    table.insert(self.listeners[eventName], {
        callback = callback,
        context = context
    })
end

-- Subscribe to event once
function Event:once(eventName, callback, context)
    local wrapper = function(...)
        callback(...)
        self:off(eventName, wrapper)
    end
    self:on(eventName, wrapper, context)
end

-- Unsubscribe from an event
function Event:off(eventName, callback)
    if not self.listeners[eventName] then return end

    if callback then
        for i, listener in ipairs(self.listeners[eventName]) do
            if listener.callback == callback then
                table.remove(self.listeners[eventName], i)
                break
            end
        end
    else
        self.listeners[eventName] = {}
    end
end

-- Emit an event
function Event:emit(eventName, ...)
    if not self.listeners[eventName] then return end

    for _, listener in ipairs(self.listeners[eventName]) do
        if listener.context then
            listener.callback(listener.context, ...)
        else
            listener.callback(...)
        end
    end
end

-- Clear all listeners
function Event:clear()
    self.listeners = {}
end

-- Get listener count
function Event:count(eventName)
    if not self.listeners[eventName] then return 0 end
    return #self.listeners[eventName]
end

return Event
