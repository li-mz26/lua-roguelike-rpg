-- Color Utilities

local Color = {}

-- Predefined colors
Color.BLACK = {0, 0, 0, 1}
Color.WHITE = {1, 1, 1, 1}
Color.RED = {1, 0, 0, 1}
Color.GREEN = {0, 1, 0, 1}
Color.BLUE = {0, 0, 1, 1}
Color.YELLOW = {1, 1, 0, 1}
Color.CYAN = {0, 1, 1, 1}
Color.MAGENTA = {1, 0, 1, 1}
Color.GRAY = {0.5, 0.5, 0.5, 1}
Color.DARK_GRAY = {0.2, 0.2, 0.2, 1}
Color.LIGHT_GRAY = {0.8, 0.8, 0.8, 1}

-- Create color from hex string
function Color.fromHex(hex)
    local r = tonumber(hex:sub(1, 2), 16) / 255
    local g = tonumber(hex:sub(3, 4), 16) / 255
    local b = tonumber(hex:sub(5, 6), 16) / 255
    local a = #hex >= 8 and tonumber(hex:sub(7, 8), 16) / 255 or 1
    return {r, g, b, a}
end

-- Convert color to hex string
function Color.toHex(r, g, b, a)
    a = a or 1
    return string.format("#%02x%02x%02x",
        math.floor(r * 255), math.floor(g * 255), math.floor(b * 255))
end

-- Darken a color
function Color.darken(color, amount)
    local r = math.max(0, color[1] - amount)
    local g = math.max(0, color[2] - amount)
    local b = math.max(0, color[3] - amount)
    return {r, g, b, color[4] or 1}
end

-- Lighten a color
function Color.lighten(color, amount)
    local r = math.min(1, color[1] + amount)
    local g = math.min(1, color[2] + amount)
    local b = math.min(1, color[3] + amount)
    return {r, g, b, color[4] or 1}
end

-- Set alpha
function Color.setAlpha(color, alpha)
    return {color[1], color[2], color[3], alpha}
end

-- Interpolate between two colors
function Color.lerp(color1, color2, t)
    local r = color1[1] + (color2[1] - color1[1]) * t
    local g = color1[2] + (color2[2] - color1[2]) * t
    local b = color1[3] + (color2[3] - color1[3]) * t
    local a = (color1[4] or 1) + ((color2[4] or 1) - (color1[4] or 1)) * t
    return {r, g, b, a}
end

-- Game-specific colors
Color.UI_BG = Color.fromHex("1a1a2e")
Color.UI_BORDER = Color.fromHex("4a4a6a")
Color.UI_TEXT = Color.fromHex("e8e8e8")
Color.UI_HIGHLIGHT = Color.fromHex("ffd700")
Color.HEALTH = Color.fromHex("ff4444")
Color.MANA = Color.fromHex("4488ff")
Color.EXPERIENCE = Color.fromHex("44ff44")

return Color
