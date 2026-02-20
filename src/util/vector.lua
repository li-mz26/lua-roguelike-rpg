-- 2D Vector Utility

local Vector = {}
Vector.__index = Vector

function Vector.new(x, y)
    local self = setmetatable({}, Vector)
    self.x = x or 0
    self.y = y or 0
    return self
end

function Vector.fromAngle(angle, length)
    length = length or 1
    return Vector.new(math.cos(angle) * length, math.sin(angle) * length)
end

function Vector:clone()
    return Vector.new(self.x, self.y)
end

function Vector:add(other)
    return Vector.new(self.x + other.x, self.y + other.y)
end

function Vector:sub(other)
    return Vector.new(self.x - other.x, self.y - other.y)
end

function Vector:mul(scalar)
    return Vector.new(self.x * scalar, self.y * scalar)
end

function Vector:div(scalar)
    return Vector.new(self.x / scalar, self.y / scalar)
end

function Vector:dot(other)
    return self.x * other.x + self.y * other.y
end

function Vector:cross(other)
    return self.x * other.y - self.y * other.x
end

function Vector:length()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vector:lengthSquared()
    return self.x * self.x + self.y * self.y
end

function Vector:normalize()
    local len = self:length()
    if len > 0 then
        return self:div(len)
    end
    return Vector.new(0, 0)
end

function Vector:rotate(angle)
    local cos = math.cos(angle)
    local sin = math.sin(angle)
    return Vector.new(
        self.x * cos - self.y * sin,
        self.x * sin + self.y * cos
    )
end

function Vector:angle()
    return math.atan2(self.y, self.x)
end

function Vector:angleTo(other)
    return math.atan2(other.y - self.y, other.x - self.x)
end

function Vector:distance(other)
    return self:sub(other):length()
end

function Vector:distanceSquared(other)
    return self:sub(other):lengthSquared()
end

function Vector:lerp(other, t)
    return Vector.new(
        self.x + (other.x - self.x) * t,
        self.y + (other.y - self.y) * t
    )
end

function Vector:limit(maxLength)
    local len = self:length()
    if len > maxLength then
        return self:normalize():mul(maxLength)
    end
    return self:clone()
end

function Vector:equals(other, epsilon)
    epsilon = epsilon or 0.0001
    return math.abs(self.x - other.x) < epsilon and
           math.abs(self.y - other.y) < epsilon
end

function Vector:unpack()
    return self.x, self.y
end

-- Metamethods
function Vector.__add(a, b) return a:add(b) end
function Vector.__sub(a, b) return a:sub(b) end
function Vector.__mul(a, b)
    if type(a) == "number" then
        return b:mul(a)
    elseif type(b) == "number" then
        return a:mul(b)
    end
end
function Vector.__div(a, b) return a:div(b) end
function Vector.__unm(a) return a:mul(-1) end
function Vector.__eq(a, b) return a:equals(b) end
function Vector.__len(a) return a:length() end
function Vector.__tostring(a)
    return string.format("Vector(%.2f, %.2f)", a.x, a.y)
end

return Vector
