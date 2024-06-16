# ntime

The `ntime` module provides a function to convert time intervals in the format `{n}-{interval unit(s)}` into seconds. 

## Features

- Convert various time intervals such as seconds, minutes, hours, days, and weeks into seconds.
- Handles different plural forms of time units.

## Supported Time Units

- `sec`, `secs`, `second`, `seconds`
- `min`, `mins`, `minute`, `minutes`
- `hr`, `hrs`, `hour`, `hours`
- `day`, `days`
- `week`, `weeks`

## Installation

```lua
APM.install('@rakis/ntime')
```

## Usage

1. Require the `ntime` module in your Lua script.
2. Use the `toseconds` function to convert time formats to seconds.

### Example

```lua
-- main.lua

local ntime = require("@rakis/ntime")

local function test_time_converter()
    local time_formats = {"1-hr", "5-minutes", "10-seconds", "2-days", "3-weeks"}

    for _, format in ipairs(time_formats) do
        local seconds = ntime.toseconds(format)
        print(format .. " is " .. seconds .. " seconds")
    end
end

test_time_converter()
