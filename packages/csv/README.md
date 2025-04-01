# CSV library 

A lightweight CSV utility for Lua that parses CSV strings and creates CSV content from tables as pages of csv strings.

## Features
- **CSV Parsing:** Converts CSV strings into table rows and columns.
- **CSV Creation (Records):** Generates CSV output from a table of records (each record is a table). Supports optional column labels.
- **CSV Creation (Key-Value):** Creates CSV output from a key-value table (both keys and values must be strings).
- **Paging:** Splits output into pages (default 10,000 lines per page).

## Dependencies
This module requires a **Utils** library with the following functions:
- `Utils.compose`
- `Utils.map`
- `Utils.values`
- `Utils.keys`

Ensure these are available in your project.

## Installation
1. Place the `csv.lua` file in your project directory.
2. Require the module in your Lua code:

```lua
local csv = require("@rakis/csv")
```

API Usage

Parsing CSV Strings

Convert a CSV string into a table structure.

local data = csv.parser("name,age\nAlice,30\nBob,25")
-- data becomes a table with each row split into columns.

Creating CSV from a Table of Records

Generate CSV output from a table of records. Optionally specify labels and page size.

```lua
local records = {
  { name = "Alice", age = "30" },
  { name = "Bob", age = "25" },
}
local pages = csv.createFromTable(records)
```

-- pages is an array of CSV strings.

Creating CSV from a Key-Value Table

Generate CSV output from a key-value table.

```lua
local kv = {
  id1 = "value1",
  id2 = "value2",
}
local pages = csv.createKV(kv)
-- pages is an array of CSV strings.
```

Notes
	•	The CSV parsing is basic—splitting on commas and newlines—and does not handle quoted fields.
	•	Adjust the pageSize parameter if you expect large CSV outputs.

