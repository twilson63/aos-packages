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