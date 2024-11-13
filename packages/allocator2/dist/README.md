# allocator2

Allocator2 performs weighted distribution for large numbers with a price and yield.

Allocator2 can distribute a reward over a set of scores that are evenly calculated using a price based on a base unit like USD or BTC, and the yield in that base unit. For example, DAI is priced at 1 USD with a 3% yield, using this baseline we calculate a weighted distribution with different token balances.

## Usage

```lua
local allocator = require('allocator')
local yield = allocator.compute(deposits, reward, prices, yields)
```

## Parameters

### deposits

A collection of deposits used to calculate distribution

| Name | Description |
| ---- | ----------- |
| User | Deposit Address |
| Token | The token used to deposit |
| Amount | The token amount of the deposit |
| Recipient | The address that should receive the mint yield |

### reward

The total mint yield to distribute to depositors

### prices

A table object that contains each token and its price.

```lua
{
  "DAI" = {
    price = "10000"
  },
  "stETH" = {
    price = "31824500"
  }
}
```

### yields

A table object that contains each token and its yield.

```lua
{
  "DAI" = {
    yield = "0300"
  },
  "stETH" = {
    yield = "0600"
  }
}
```

## returns

When calling compute it returns the table of deposits with a `score` and `reward` property for each deposit record.
