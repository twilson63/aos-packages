local allocator = require("main")
local testUnit = require("@rakis/test-unit")
local t = testUnit.new("Allocator Tests")
-- helper
function TableSum(T)
  local sum = 0
  for _, v in pairs(T) do sum = sum + v end
  return sum
end

t:add(
  "Allocate, no remainder", 
  function()
    local testBalances = { 
      Address1 = 1,
      Address2 = 1
    }
    local reward = 100
    local result = allocator.allocate(testBalances, reward)

    assert(result['Address1'] == "50" and result['Address2'] == "50", 'Reward should be split evenly')
    assert(TableSum(result) == reward, 'Reward should be fully distributed')
  end
)

t:add(
  "Allocate, remainder", 
  function()
    local testBalances = { 
      Address1 = 1,
      Address2 = 1
    }
    local reward = 101
    local result = allocator.allocate(testBalances, reward)

    assert(result['Address1'] == "51", 'Reward should be split evenly, address 1 gets remainder')
    assert(result['Address2'] == "50", 'Reward should be split evenly, address 2 gets no remainder')
    assert(TableSum(result) == reward, 'Reward should be fully distributed')
  end
)

t:add(
  "Allocate, multiple remainders", 
  function()
    local testBalances = { 
      Address1 = 1,
      Address2 = 1,
      Address3 = 1
    }
    local reward = 101
    local result = allocator.allocate(testBalances, reward)

    assert(result['Address1'] == "34", 'Reward should be split evenly, address 1 gets remainder')
    assert(result['Address2'] == "33", 'Reward should be split evenly, address 2 gets no remainder')
    assert(result['Address3'] == "34", 'Reward should be split evenly, address 3 gets remainder')

    assert(TableSum(result) == reward, 'Reward should be fully distributed')
  end
)
t:add(
  "Allocate, multiple remainders, rounding error", 
  function()
    local testBalances = { 
      Address1 = 11, -- (11/77) * 102 = 14.57, floors to 14 | + 1 remainder | 15
      Address2 = 21, -- (21/77) * 102 = 27.81, floors to 27 | + 0 remainder | 27
      Address3 = 45  -- (45/77) * 102 = 59.61, floors to 59 | + 1 remainder | 60
    }
    local reward = 102
    local result = allocator.allocate(testBalances, reward)

    assert(result['Address1'] == "15", 'Reward should be split percentage wise, address 1 gets remainder')
    assert(result['Address2'] == "27", 'Reward should be split percentage wise, address 2 gets no remainder')
    assert(result['Address3'] == "60", 'Reward should be split percentage wise, address 3 gets remainder')

    assert(TableSum(result) == reward, 'Reward should be fully distributed')
  end
)

return t:run()

