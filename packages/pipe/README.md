# Pipe Library

Pipe is a lightweight Lua library for handling CSV data with two main functions: `send` and `receive`.

## Overview

- **send:**  
  Converts a Lua table into an array of CSV strings using `csv.createFromTable` or `csv.createKV`, then pushes these CSV strings onto a queue and dispatches them to a target.

- **receive:**  
  Sets up a handler to receive batched CSV data strings, concatenates and parses them into a table, and calls the provided handler with the fully parsed table. Additionally, it accepts a `patternMatcher` argument to customize how the piped data is matched before processing.

## Installation

Simply drop the `pipe.lua` file in your project directory and require it:

```lua
.load-blueprint apm
apm.install [[@rakis/pipe]]
local pipe = require("@rakis/pipe")
```

## Usage

### Sending Data

```lua
local data = {
  {
    name = "Alice",
    age = 30
  },
  {
    name = "Bob",
    age = 25
  }
}

local target = "AO_Process_Identifier"
pipe.send(data, target)
```

### Receiving Data

```lua
local function dataHandler(parsedTable)
  print("Received data:")
  for i, row in ipairs(parsedTable) do
    print(table.concat(row, ", "))
  end
end

pipe.receive({ From = "AO_Process_Id"}, datahandler)
```

In this example, the receive function sets up a handler that waits for a batch of CSV data strings, uses myPatternMatcher to filter or match the data, then concatenates and parses them into a Lua table before calling your dataHandler.

## API

pipe.send(dataTable, target, options?)

Parameters:

* dataTable: A table of data to be converted to CSV.
* target: The destination queue or identifier.
* options (_optional_): 
  - page-size: the number of rows to include in each page, default is 10,000
  - labels: table array of specific properties from a table object you like to include
  - template: a table you want merged into the dispatch of each page
  - action: specify a custom action used to dispatch pages

pipe.receive(handler, patternMatcher)

Parameters:

* patternMatcher: A table or function to customize the matching of piped data strings before processing.
* handler: A function that processes the parsed table.
* options (_optional_): 
  - format: 'key-value' or 'normal'
  - action: specify a custom action for handler

## Testing

Dependencies: NodeJS

```bash
cd test
yarn
yarn test
```

License

This project is licensed under the MIT License.