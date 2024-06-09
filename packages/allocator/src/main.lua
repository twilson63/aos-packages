local allocator = { _version = "0.0.1" }

local bint = require('.bint')(256)

-- utility functions
local function reduce(func, initial, t)
    local result = initial
    for _, v in ipairs(t) do
        result = func(result, v)
    end
    return result
end

local function values(t)
    local result = {}
    for _, v in pairs(t) do
        table.insert(result, v)
    end
    return result
end

local function keys(t)
    local result = {}
    for k, _ in pairs(t) do
        table.insert(result, k)
    end
    return result
end

local function sum(t)
    return reduce(function(a, b) return a + b end, 0, t)
end

local function mergeAll(tables)
    local result = {}
    for _, t in ipairs(tables) do
        for k, v in pairs(t) do
            result[k] = v
        end
    end
    return result
end


function allocator.allocate(balances, reward)
    local function add(a, b) return bint(a) + bint(b) end

    -- Calculate total positive balances
    local total = reduce(add, bint(0), values(balances))
    
    -- Allocate rewards based on balances
    local allocation = mergeAll(
        reduce(function(a, s)
            local asset = s[1]
            local balance = bint(s[2])
            
            if balance < bint(1) then
                return a
            end
            
            local pct = (balance / total) * bint(100)
            local coins = math.floor(bint(reward) * (pct / bint(100)) + (bint(1) / bint(2))) -- Round to nearest integer
            
            table.insert(a, {[asset] = tostring(coins)})
            return a
        end, {}, (function()
            local result = {}
            for k, v in pairs(balances) do
                table.insert(result, {k, v})
            end
            return result
        end)())
    )
    
    -- Handle off by one errors
    local remainder = reward - sum(values(allocation))
    local k = keys(allocation)
    local i = 1
    while remainder > 0 do
        allocation[k[i]] = allocation[k[i]] + 1
        remainder = remainder - 1
        i = (i % #k) + 1
    end
    
    return allocation
end

return allocator


