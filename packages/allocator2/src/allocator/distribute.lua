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