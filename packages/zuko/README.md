# Zuko – Lua Validation Library

Zuko is a lightweight Lua validation library that makes data validation straightforward, composable, and clear. It uses a simple API to define validation rules via Lua tables and generates a validator function that ensures input correctness. Zuko supports nested tables and array validations effortlessly.

## Installation

Place `zuko.lua` in your Lua path, then require it in your code:

```lua
local zuko = require('zuko')
```

## Usage

### Define Validation Rules

Validation rules are defined using Lua tables:

```lua
local rules = {
  name = { type = "string", required = true },
  age = { type = "number", min = 0, max = 120 },
  email = { type = "string", pattern = "^[%w%.%-]+@[%w%.%-]+%.%a%a+$" },
  preferences = {
    type = "table",
    schema = {
      newsletter = { type = "boolean" }
    }
  },
  tags = {
    type = "table",
    array = { type = "string", pattern = "^%a+$" }
  }
}

local validate = zuko(rules)
```

### Validate Data

Apply your validator function to input data:

```lua
local input = {
  name = "Zuko",
  age = 25,
  email = "zuko@example.com",
  preferences = { newsletter = true },
  tags = { "Lua", "validation", "example" }
}

local is_valid, errors = validate(input)

if not is_valid then
  print("Validation failed:")
  for field, err in pairs(errors) do
    print(field .. ": " .. err)
  end
else
  print("Data is valid!")
end
```

## Examples

### Nested Table Validation

```lua
local rules = {
  user = {
    type = "table",
    schema = {
      username = { type = "string", required = true },
      address = {
        type = "table",
        schema = {
          city = { type = "string", required = true },
          zip = { type = "string", pattern = "^%d%d%d%d%d$" }
        }
      }
    }
  }
}

local validate = zuko(rules)
```

### Array Validation

```lua
local rules = {
  scores = {
    type = "table",
    array = { type = "number", min = 0, max = 100 }
  }
}

local validate = zuko(rules)
```

## Supported Validation Options

| Option | Description |
|--------|-------------|
| `type` | Checks the Lua type (`"string"`, `"number"`, `"table"`, etc.) |
| `required` | Ensures the field is present (`true`/`false`) |
| `min`, `max` | Validates numerical range |
| `pattern` | Validates string against Lua patterns |
| `schema` | Defines nested validation rules for tables |
| `array` | Defines validation rules for array elements |