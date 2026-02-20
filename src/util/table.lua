-- Table Utilities

local Table = {}

-- Deep copy a table
function Table.deepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[Table.deepCopy(orig_key)] = Table.deepCopy(orig_value)
        end
        setmetatable(copy, Table.deepCopy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

-- Merge two tables (shallow)
function Table.merge(t1, t2)
    local result = Table.deepCopy(t1)
    for k, v in pairs(t2) do
        result[k] = v
    end
    return result
end

-- Get table size (works for arrays and dicts)
function Table.size(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

-- Check if table contains value
function Table.contains(t, value)
    for _, v in pairs(t) do
        if v == value then return true end
    end
    return false
end

-- Get table keys as array
function Table.keys(t)
    local keys = {}
    for k, _ in pairs(t) do
        table.insert(keys, k)
    end
    return keys
end

-- Get table values as array
function Table.values(t)
    local values = {}
    for _, v in pairs(t) do
        table.insert(values, v)
    end
    return values
end

-- Find index of value in array
function Table.indexOf(t, value)
    for i, v in ipairs(t) do
        if v == value then return i end
    end
    return nil
end

-- Remove first occurrence of value from array
function Table.removeValue(t, value)
    local index = Table.indexOf(t, value)
    if index then
        table.remove(t, index)
        return true
    end
    return false
end

-- Shuffle array in place
function Table.shuffle(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end

-- Get random element from array
function Table.random(t)
    if #t == 0 then return nil end
    return t[math.random(#t)]
end

-- Filter array
function Table.filter(t, predicate)
    local result = {}
    for _, v in ipairs(t) do
        if predicate(v) then
            table.insert(result, v)
        end
    end
    return result
end

-- Map array
function Table.map(t, transform)
    local result = {}
    for i, v in ipairs(t) do
        result[i] = transform(v)
    end
    return result
end

-- Reduce array
function Table.reduce(t, reducer, initial)
    local acc = initial
    for _, v in ipairs(t) do
        acc = reducer(acc, v)
    end
    return acc
end

-- Slice array
function Table.slice(t, start, finish)
    local result = {}
    for i = start or 1, finish or #t do
        table.insert(result, t[i])
    end
    return result Create array
end

-- of n elements
function Table.create(n, value)
    local t = {}
    for i = 1, n do
        t[i] = value
    end
    return t
end

-- Check if table is empty
function Table.isEmpty(t)
    return next(t) == nil
end

return Table
