

-- module: "allocator.calcvalue"
local function _loaded_mod_allocator_calcvalue()
--[[
  this function calculates the value of units given price
  with an optional yield, if no yield is provided it calculates
  the total cost, if yield is provide it calculates the total yield
  of a given item.
]]
local bint = require('.bint')(256)
-- @param amount the amount in units of a priced item
-- @param price the unit price of an item denominated by 4
-- @param yield the percent gain of a given item based on a specific price over time
local calculateValue = function(amount, price, yield)
  assert(bint(amount), 'amount is required')
  assert(bint(price), 'unit price is required')
  -- print('calc: ' .. amount .. ':' .. price .. ':' .. yield)
  if not yield then yield = 1 end
  return bint(amount) * (bint(price) * bint.ipow(10, 14)) * bint(yield)
end

return calculateValue
end

_G.package.loaded["allocator.calcvalue"] = _loaded_mod_allocator_calcvalue()

-- module: "allocator.distribute"
local function _loaded_mod_allocator_distribute()
local bint = require('.bint')(256)

-- distribute a reward using weighted distribution 
-- Higher Order Function 
-- @param reward Amount of Units you want to distribute
-- @param scoreTotal The total score of the accounts in the list
-- @param scoreProp The name of the property to read the score from
-- @param rewardProp The name of the property to set the reward to
local function distribute(reward, scoreTotal, scoreProp, rewardProp)
  assert(bint(reward), "reward must be able to be parsed as a bint")
  assert(bint(scoreTotal), "score Total must be able to parsed by a bint")
  -- set defaults
  if not scoreProp then scoreProp = 'Score' end
  if not rewardProp then rewardProp = 'Reward' end

  -- we calculate the score reward unit by dividing the scoreTotal by the reward 
  local scoreRewardUnit = bint(scoreTotal) // (bint(reward))
  
  -- returned function to receive a table with a score property to calcuate the reward
  -- @param acct - table containing a score property
  return function (acct)
    assert(type(acct) == "table", 'acct must be a table')
    assert(type(acct[scoreProp]) == "string", 'score property is required')
    -- print('distribute: ' .. acct[scoreProp] .. ':' .. tostring(scoreRewardUnit))
    -- to determine the reward we divide using integer division the score by the reward units
    acct[rewardProp] = tostring(bint(acct[scoreProp]) // scoreRewardUnit)
    return acct
  end
end

return distribute
end

_G.package.loaded["allocator.distribute"] = _loaded_mod_allocator_distribute()

-- module: "allocator.helpers"
local function _loaded_mod_allocator_helpers()
local bint = require('.bint')(256)

local helpers = { _version = "0.0.1" }

-- gets the sum of a specific property in a list of tables
-- @param prop the name of the proper
-- @param list the list of table items
function helpers.sum(prop, list)
  return tostring(Utils.reduce(
    function (a,b) return bint(a) + bint(b) end,
    "0", 
    Utils.map(Utils.prop(prop), list)
  ))
end

function helpers.take(n, tbl)
  local result = {}
  for i = 1, math.min(n, #tbl) do
      table.insert(result, tbl[i])
  end
  return result
end

return helpers
end

_G.package.loaded["allocator.helpers"] = _loaded_mod_allocator_helpers()

local bint = require('.bint')(256)
local calcValue = require('allocator.calcvalue')
local distribute = require('allocator.distribute')
local helpers = require('allocator.helpers')

--[[
  allocate rewards based on a list of deposits
]]
local allocate = { _version = "0.0.2" }

-- @param deposits is a table of table objects with an amount and token property
-- @param reward is a bint compatable number or string to distribute
-- @param prices is a lookup table of prices denominated by 4 by token
-- @param yields is a lookup table of yields denominated by 4 by token
-- @returns a table of items with a score and reward property
function allocate.compute(deposits, reward, prices, yields)
  -- takes a deposit gets the price and yield and calcuates a score
  -- @param deposit
  local function calcScore(deposit)
    assert(type(deposit), 'deposit must be table')
    assert(deposit.Token ~= nil, 'deposit must have a token symbol')
    assert(deposit.Amount ~= nil, 'deposit must have an amount')

    deposit.Price = prices.get(deposit.Token).price
    deposit.Yield = yields.get(deposit.Token).yield
    -- print(deposit)
    deposit.Score = tostring(calcValue(deposit.Amount, deposit.Price, deposit.Yield))
    return deposit
  end
  
  assert(type(deposits) == "table", 'deposits must be a table')
  assert(bint(reward), 'reward must be bint')
  assert(type(prices) == "table", 'prices must be table')
  assert(type(yields) == "table", 'yields must be table')

  local scores = Utils.map(calcScore, deposits)
  local totalScores = helpers.sum('Score', scores)
  return Utils.map(distribute(reward, totalScores), scores)

  -- this would be a good either
  -- of(deposits)
  --   :map(Utils.map(calcScore))
  --   :map(... get and map totalScores )
  --   :map(Utils.map(distribute(reward)))
  --   :fold(error, success)
end

return allocate