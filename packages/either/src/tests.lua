local Either = require("main")
local TestUnit = require('@rakis/test-unit')

local eitherTests = TestUnit.new("either-tests")

-- helper functions
local function always(v) return function() return v end end
local function identity(v) return v end
local function add(x) return function(y) return x + y end end
local function subtract(x) return function(y) return y - x end end
local function multiply(x) return function(y) return x * y end end

eitherTests:add("Either of Constructor", function () 
  local result = Either.of(42)
    :fold(
      always(0),
      identity
    )
  assert(result == 42, 'Result is 42')
end)

eitherTests:add("map on right", function () 
  local result = Either.of(1)
    :map(add(1))
    :map(multiply(4))
    :map(subtract(3))
    :fold(
      always(0),
      identity
    )
  assert(result == 5, 'result should equal 5 not ' .. result)
end)

eitherTests:add("map on Left", function ()
  local result = Either.of(1)
    :map(add(1))
    :chain(function(v) return Either.Left(0) end)
    :map(add(5))
    :mapLeft(always(42))
    :fold(
      identity,
      identity
    )
  assert(result == 42, 'result should be 42 not ' .. result)
end)

eitherTests:add("chain on Right", function()
  local result = Either.of(42)
    :chain(function(v) return Either.Right(add(1)(v)) end)
    :chain(function(v) return Either.Right(add(1)(v)) end)
    :chain(function(v) return Either.Left(subtract(2)(v)) end)
    :fold(
      identity,
      always(0)
    )
  assert(result == 42, 'result should be 42 not ' .. result)
end)

return eitherTests:run()


-- local function divide(a, b)
--     if b == 0 then
--         return Either.Left("Cannot divide by zero")
--     else
--         return Either.Right(a / b)
--     end
-- end

-- local function addOne(value)
--     return Either.Right(value + 1)
-- end

-- local function multiplyByTwo(value)
--     return Either.Right(value * 2)
-- end

-- local result = Either.Right(10)
--     :chain(multiplyByTwo)
--     :fold(
--       function(err) print("Error: " .. err) end,
--       function(value) print("Result: " .. value) end
--     )

-- local identity = function (v) return v end

-- local v = Either.of(1)
--   :map(function (v) return v + 1 end)
--   :chain(function (v) return Either.Left(7) end)
--   :chain(multiplyByTwo)
--   :chain(multiplyByTwo)
--   :fold(
--     identity,
--     identity
--   )

-- print("Result2: " .. v)

-- return ao.outbox.Output.data