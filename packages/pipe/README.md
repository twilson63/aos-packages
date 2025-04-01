# Pipe Library

Pipe is a lightweight Lua library for handling CSV data with two main functions: `send` and `receive`.

## Overview

- **send:**  
  Converts a Lua table into an array of CSV strings using `csv.createFromTable`, then pushes these CSV strings onto a queue and dispatches them to a target.

- **receive:**  
  Sets up a handler to receive batched CSV data strings, concatenates and parses them into a table, and calls the provided handler with the fully parsed table. Additionally, it accepts a `patternMatcher` argument to customize how the piped data is matched before processing.

## Installation

Simply drop the `pipe.lua` file in your project directory and require it:

```lua
local pipe = require("pipe")
```

## Usage

### Sending Data

```lua
local data = {
  {"name", "age"},
  {"Alice", 30},
  {"Bob", 25}
}

local target = "queue_identifier"
pipe.send(data, target)
```

This call uses csv.createFromTable internally to convert the table into CSV strings, which are then queued and dispatched to the specified target.

### Receiving Data

```lua
local function dataHandler(parsedTable)
  print("Received data:")
  for i, row in ipairs(parsedTable) do
    print(table.concat(row, ", "))
  end
end

local function myPatternMatcher(csvString)
  -- Customize matching logic here; return true if it matches the desired pattern
  return csvString:find("pattern") ~= nil
end

pipe.receive(dataHandler, myPatternMatcher)
```

In this example, the receive function sets up a handler that waits for a batch of CSV data strings, uses myPatternMatcher to filter or match the data, then concatenates and parses them into a Lua table before calling your dataHandler.

## API

pipe.send(dataTable, target)
	•	Parameters:
	•	dataTable: A table of data to be converted to CSV.
	•	target: The destination queue or identifier.
	•	Behavior:
Uses csv.createFromTable to generate CSV strings from dataTable, which are then pushed onto the queue for the given target.

pipe.receive(handler, patternMatcher)
	•	Parameters:
	•	handler: A function that processes the parsed table.
	•	patternMatcher: A function to customize the matching of piped data strings before processing.
	•	Behavior:
Receives a batch of CSV data strings, uses the patternMatcher to filter or match the appropriate data, concatenates and parses the matched CSV strings into a Lua table, and passes this table to the handler function.

License

This project is licensed under the MIT License.