-- Either.lua
--[[
Either ADT

Either is an ADT that allows developers to create functional pipelines in their business
logic. The capability allows you to break your business logic into small reusable functions
that can be composed in an Either data type via the map or chain functions. The map function 
takes any unary function and returns a new value. The chain function expects any function 
to return a Left or Right type. Finally, the fold function applies a handle function for the 
Left and Right values then based on the last type returned will execute the correct function.
  
]]

local Either = { _version = "0.0.1" }
Either.__index = Either

-- Constructor for Left
function Either.Left(value)
    return setmetatable({ isLeft = true, value = value }, Either)
end

-- Constructor for Right
function Either.Right(value)
    return setmetatable({ isLeft = false, value = value }, Either)
end

-- Method to check if it's Left
function Either:isLeft()
    return self.isLeft
end

-- Method to check if it's Right
function Either:isRight()
    return not self.isLeft
end

-- Method to map over Right value
function Either:map(fn)
    if self:isRight() then
        return Either.Right(fn(self.value))
    else
        return self
    end
end

-- Method to map over Left value
function Either:mapLeft(fn)
    if self:isLeft() then
        return Either.Left(fn(self.value))
    else
        return self
    end
end

-- Method to get the value with a default
function Either:getOrElse(default)
    if self:isRight() then
        return self.value
    else
        return default
    end
end

-- Method to get the Left value with a default
function Either:getLeftOrElse(default)
    if self:isLeft() then
        return self.value
    else
        return default
    end
end

-- Method to chain operations (flatMap)
function Either:chain(fn)
    if self:isRight() then
        return fn(self.value)
    else
        return self
    end
end

-- Method to handle both cases
function Either:fold(leftFn, rightFn)
    if self.isLeft then
        return leftFn(self.value)
    else
        return rightFn(self.value)
    end
end

Either.of = Either.Right

return Either