local Either = require('@rakis/Either')
local TestUnit = require('@rakis/test-unit')
local ReaderT = require('main')

local T = TestUnit.new('Reader Tests')

local ReaderTEither = ReaderT(Either)

T:add('Basic Test', function () 
  local result = ReaderTEither.of(1)
    :map(function (v) 
      return v + 1
    end)
    :runWith(2)
    :getOrElse(0)
  assert(result == 2, 'should return 2')
end)

T:add('Test Ask function to pass env', function () 
  local result = ReaderTEither:ask(function (env)
    return env + 1
  end)
    :runWith(2)
    :getOrElse(0)
  assert(result == 3, 'should return 3 but got ' .. result)
end)

return T:run()