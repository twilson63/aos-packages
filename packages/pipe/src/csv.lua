--[[
CSV Module for Lua

A lightweight CSV utility for Lua that can parse CSV strings and create CSV
content from tables.

Features
	•	CSV Parsing: Convert a CSV string into a table (rows and columns).
	•	CSV Creation: Generate CSV output from:
	•	A table of records (each record is a table).
	•	A key-value table (both keys and values are strings).
	•	Paging: Split output into pages (default 1000 lines per page).

Dependencies

This module uses a Utils library with functions like:
	•	Utils.compose
	•	Utils.map
	•	Utils.values
	•	Utils.keys

Make sure these are available in your project.

Installation

Place the module file (e.g., csv.lua) in your project and require it:

local csv = require("csv")

API

csv.parser(csvString)

Parses a CSV string into a table structure.

Example:

local data = csv.parser("name,age\nAlice,30\nBob,25")
-- data is a table where each entry is a row split into columns.

csv.createFromTable(data, pageSize)

Converts a table of records into CSV output. Each record should be a table.
pageSize (optional) determines the number of lines per CSV page (defaults to 1000).

Example:

local records = {
  {name = "Alice", age = "30"},
  {name = "Bob", age = "25"},
}
local pages = csv.createFromTable(records)
-- pages is an array of CSV strings.

csv.createKV(data, pageSize)

Converts a key-value table (both keys and values are strings) into CSV output.
pageSize works the same as above.

Example:

local kv = {
  id1 = "value1",
  id2 = "value2",
}
local pages = csv.createKV(kv)

Notes
	•	The CSV parsing is basic (splitting on commas and newlines) and does not handle quoted fields.
	•	Adjust pageSize as needed if you expect large CSV outputs.
]]
local csv = {}

local _NEWLINE = '\n'

local function split_by_linefeed(str)
  local result = {}
  for line in str:gmatch("[^\r\n]+") do
    table.insert(result, line)
  end
  return result
end

local function split_by_comma(str)
  local result = {}
  for line in str:gmatch("[^,]+") do
    table.insert(result, line)
  end
  return result
end

function csv.parser(csv)
  return Utils.compose(
    Utils.map(split_by_comma),
    split_by_linefeed
  )(csv)
end

-- creates a csv from table of records
function csv.createFromTable(data, labels, pageSize)
  assert(type(data) == 'table', 'input id not a table')
  if not pageSize then pageSize = 10000 end

  local pages = {}
  local currentPage = {}
  local count = 0

  local lines = Utils.map(function(record)
    assert(type(record) == 'table', 'record is not a table')
    if labels then
      return table.concat(Utils.reduce(function(line, label)
        table.insert(line, record[label])
        return line
      end, {}, labels), ',')
    else
      return table.concat(Utils.values(record), ',')
    end
  end, data
  )

  for i = 1, #lines do
    table.insert(currentPage, lines[i])
    count = count + 1
    if count == pageSize then
      table.insert(pages, table.concat(currentPage, _NEWLINE))
      currentPage = {}
      count = 0
    end
  end
  if #currentPage > 0 then
    table.insert(pages, table.concat(currentPage, _NEWLINE))
  end
  return pages
end

-- creates a csv file from a table object of key,value
function csv.createKV(data, pageSize)
  assert(type(data) == 'table', 'input id not a table')
  if not pageSize then pageSize = 10000 end

  local pages = {}
  local currentPage = {}
  local count = 0

  local lines = Utils.map(function(key)
    assert(type(key) == 'string', 'key is not string')
    assert(type(data[key]) == 'string', 'value is not string')
    return table.concat({ key, data[key] }, ',')
  end, Utils.keys(data)
  )

  for i = 1, #lines do
    table.insert(currentPage, lines[i])
    count = count + 1
    if count == pageSize then
      table.insert(pages, table.concat(currentPage, _NEWLINE))
      currentPage = {}
      count = 0
    end
  end
  if #currentPage > 0 then
    table.insert(pages, table.concat(currentPage, _NEWLINE))
  end
  return pages
end

return csv
