local Either = require("main")

local function divide(a, b)
    if b == 0 then
        return Either.Left("Cannot divide by zero")
    else
        return Either.Right(a / b)
    end
end

local function addOne(value)
    return Either.Right(value + 1)
end

local function multiplyByTwo(value)
    return Either.Right(value * 2)
end

local result = Either.Right(10)
    :chain(multiplyByTwo)
    :fold(
      function(err) print("Error: " .. err) end,
      function(value) print("Result: " .. value) end
    )

local identity = function (v) return v end

local v = Either.of(1)
  :map(function (v) return v + 1 end)
  :chain(function (v) return Either.Left(7) end)
  :chain(multiplyByTwo)
  :chain(multiplyByTwo)
  :fold(
    identity,
    identity
  )

print("Result2: " .. v)

return ao.outbox.Output.data