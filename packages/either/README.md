# Either.lua

## Overview

The `Either` ADT (Algebraic Data Type) allows developers to create functional pipelines in their business logic. This capability lets you break your business logic into small, reusable functions that can be composed in an `Either` data type via the `map` or `chain` functions. 

- The `map` function takes any unary function and returns a new value.
- The `chain` function expects any function to return a `Left` or `Right` type.
- The `fold` function applies a handler function for the `Left` and `Right` values, then based on the last type returned, will execute the correct function.

## Installation

with APM

```lua
APM.install('@rakis/Either')
```

## Usage

### Creating Either Values

Use the `Either.of` or `Either.Right` constructors to create `Right` values.

```lua
local left = Either.of(42)
local right = Either.Right(42)
```

### Mapping Functions

Use the `map` function to apply a function to the `Right` value.

```lua
local right = Either.Right(42)
local newRight = right:map(function(value) return value + 1 end) -- Either.Right(43)
```

The `mapLeft` function applies a function to the `Left` value.

```lua
local left = Either.Left("error")
local newLeft = left:mapLeft(function(value) return value .. "!" end) -- Either.Left("error!")
```

### Chaining Functions

Use the `chain` function to apply a function that returns an `Either` type.

```lua
local right = Either.Right(42)
local result = right:chain(function(value)
    return Either.Right(value * 2)
end) -- Either.Right(84)
```

### Folding Functions

Use the `fold` function to handle both `Left` and `Right` cases.

```lua
local right = Either.Right(42)
local result = right:fold(
    function(err) return "Error: " .. err end,
    function(value) return "Value: " .. value end
) -- "Value: 42"
```

### Getting Values with Defaults

Use the `getOrElse` function to get the `Right` value or a default value if it's a `Left`.

```lua
local right = Either.Right(42)
local value = right:getOrElse(0) -- 42

local left = Either.Left("error")
local value = left:getOrElse(0) -- 0
```

Use the `getLeftOrElse` function to get the `Left` value or a default value if it's a `Right`.

```lua
local left = Either.Left("error")
local value = left:getLeftOrElse("no error") -- "error"

local right = Either.Right(42)
local value = right:getLeftOrElse("no error") -- "no error"
```

## Example

Here's a full example demonstrating the usage of the `Either` library:

```lua
local Either = require("@rakis/Either")

local function divide(a, b)
    if b == 0 then
        return Either.Left("Cannot divide by zero")
    else
        return Either.Right(a / b)
    end
end

local result = Either.Right(10)
    :chain(function(value) return divide(value, 2) end)
    :map(function(value) return value + 1 end)
    :map(function(value) return value * 2 end)

result:fold(
    function(err) print("Error: " .. err) end,
    function(value) print("Result: " .. value) end
) -- Output: "Result: 12"
```

## Tests

```lua
.load src/tests.lua
```

## Version

`Either` version 0.0.1
