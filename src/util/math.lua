-- Math Utilities

local Math = {}

-- Clamp a value between min and max
function Math.clamp(value, min, max)
    if value < min then return min end
    if value > max then return max end
    return value
end

-- Linear interpolation
function Math.lerp(a, b, t)
    return a + (b - a) * t
end

-- Distance between two points
function Math.distance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end

-- Distance squared (faster, for comparisons)
function Math.distanceSquared(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return dx * dx + dy * dy
end

-- Check if point is in rectangle
function Math.pointInRect(px, py, rx, ry, rw, rh)
    return px >= rx and px <= rx + rw and py >= ry and py <= ry + rh
end

-- Check if two rectangles intersect
function Math.rectIntersect(r1x, r1y, r1w, r1h, r2x, r2y, r2w, r2h)
    return r1x < r2x + r2w and r1x + r1w > r2x and
           r1y < r2y + r2h and r1y + r1h > r2y
end

-- Random integer between min and max (inclusive)
function Math.randomInt(min, max)
    return math.random(min, max)
end

-- Random float between min and max
function Math.randomFloat(min, max)
    return math.random() * (max - min) + min
end

-- Sign function: -1, 0, or 1
function Math.sign(value)
    if value > 0 then return 1 end
    if value < 0 then return -1 end
    return 0
end

-- Round to nearest integer
function Math.round(value)
    return math.floor(value + 0.5)
end

-- Floor to nearest (e.g., nearest 10)
function Math.floorTo(value, nearest)
    return math.floor(value / nearest) * nearest
end

-- Ceiling to nearest
function Math.ceilTo(value, nearest)
    return math.ceil(value / nearest) * nearest
end

return Math
