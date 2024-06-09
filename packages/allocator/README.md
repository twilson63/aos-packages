# Allocator

Allocate a reward to a set of balances. When wanting to distribute rewards to a set of addresses based on the weight of their balance, this package does exactly that. 

## Usage


```lua
-- Example usage
local allocate = require('@rakis/Allocator').allocate
local balances = {asset1 = 10, asset2 = 5, asset3 = 0, asset4 = 15}
local reward = 100

local result = allocate(balances, reward)
for k, v in pairs(result) do
    print(k, v)
end
```

## Install

```sh
.load-blueprint apm
APM.install('@rakis/Allocator')
```

## Test

```lua
require('@rakis/allocator').test()
```

