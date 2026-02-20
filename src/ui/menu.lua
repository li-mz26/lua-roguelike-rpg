-- Menu UI Component

local Button = require("src.ui.button")
local Panel = require("src.ui.panel")

local Menu = {}
Menu.__index = Menu

function Menu.new(x, y, options)
    local self = setmetatable({}, Menu)
    self.x = x or 0
    self.y = y or 0
    self.visible = true
    self.enabled = true
    self.selectedIndex = 1

    -- Menu items
    self.items = {}
    self.buttons = {}

    -- Appearance
    self.itemHeight = 50
    self.itemWidth = 200
    self.padding = 10

    -- Colors
    self.bgColor = {0.1, 0.1, 0.15, 0.95}
    self.borderColor = {0.4, 0.4, 0.5, 1}
    self.title = ""
    self.titleColor = {1, 0.9, 0.5, 1}

    -- Panel for background
    self.panel = Panel.new(x, y, self.itemWidth, 100, {bgColor = self.bgColor, borderColor = self.borderColor})

    -- Callback
    self.onSelect = nil

    -- Options
    if options then
        for k, v in pairs(options) do
            self[k] = v
        end
    end

    return self
end

function Menu:addItem(text, callback, data)
    local index = #self.items + 1
    local item = {
        text = text,
        callback = callback,
        data = data,
        index = index
    }
    table.insert(self.items, item)

    -- Create button for this item
    local buttonY = self.y + (index - 1) * self.itemHeight
    local button = Button.new(text, self.x, buttonY, self.itemWidth, self.itemHeight - self.padding, {
        bgColor = {0.15, 0.15, 0.25, 1},
        hoverColor = {0.25, 0.25, 0.35, 1},
        onClick = function(btn)
            if self.onSelect then
                self.onSelect(index, item)
            end
            if callback then
                callback(index, item)
            end
        end
    })

    self.buttons[index] = button
    self.panel.height = #self.items * self.itemHeight

    return item
end

function Menu:removeItem(index)
    if index < 1 or index > #self.items then return end

    table.remove(self.items, index)
    table.remove(self.buttons, index)

    -- Recreate buttons with correct positions
    for i, item in ipairs(self.items) do
        item.index = i
        self.buttons[i]:setPosition(self.x, self.y + (i - 1) * self.itemHeight)
    end

    self.panel.height = #self.items * self.itemHeight
end

function Menu:clear()
    self.items = {}
    self.buttons = {}
    self.panel:clear()
    self.panel.height = 100
    self.selectedIndex = 1
end

function Menu:setPosition(x, y)
    self.x = x
    self.y = y
    self.panel:setPosition(x, y)

    for i, button in ipairs(self.buttons) do
        button:setPosition(x, y + (i - 1) * self.itemHeight)
    end
end

function Menu:setTitle(title)
    self.title = title
end

function Menu:setSelectedIndex(index)
    if index >= 1 and index <= #self.items then
        self.selectedIndex = index
    end
end

function Menu:getSelectedIndex()
    return self.selectedIndex
end

function Menu:getSelectedItem()
    return self.items[self.selectedIndex]
end

function Menu:selectNext()
    if #self.items > 0 then
        self.selectedIndex = self.selectedIndex % #self.items + 1
    end
end

function Menu:selectPrevious()
    if #self.items > 0 then
        self.selectedIndex = self.selectedIndex - 1
        if self.selectedIndex < 1 then
            self.selectedIndex = #self.items
        end
    end
end

function Menu:confirm()
    local item = self.items[self.selectedIndex]
    if item then
        if self.onSelect then
            self.onSelect(self.selectedIndex, item)
        end
        if item.callback then
            item.callback(self.selectedIndex, item)
        end
    end
end

function Menu:update(dt, mouseX, mouseY)
    if not self.visible then return end

    for _, button in ipairs(self.buttons) do
        button:update(dt, mouseX, mouseY)
    end
end

function Menu:draw()
    if not self.visible then return end

    -- Draw panel background
    self.panel:draw()

    -- Draw title if set
    if self.title and self.title ~= "" then
        love.graphics.setColor(self.titleColor)
        love.graphics.setFont(love.graphics.newFont(24))
        love.graphics.print(self.title, self.x + 10, self.y + 10)
    end

    -- Draw buttons
    for _, button in ipairs(self.buttons) do
        button:draw()
    end
end

function Menu:mousePressed(x, y, button)
    if not self.visible or not self.enabled then return false end

    for _, b in ipairs(self.buttons) do
        if b:mousePressed(x, y, button) then
            return true
        end
    end
    return false
end

function Menu:mouseReleased(x, y, button)
    if not self.visible or not self.enabled then return end

    for _, b in ipairs(self.buttons) do
        b:mouseReleased(x, y, button)
    end
end

function Menu:setVisible(visible)
    self.visible = visible
    self.panel:setVisible(visible)
end

return Menu
