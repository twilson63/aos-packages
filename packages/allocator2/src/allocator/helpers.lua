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