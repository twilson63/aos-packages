# dbAdmin

`dbAdmin` is a Lua module designed for interacting with SQLite databases. It provides functionalities to list tables, get the record count of a table, and execute SQL queries.

## Features

- List all tables in the database
- Get the record count of a specific table
- Execute any SQL query

## Installation

Ensure you have the `lsqlite3` library installed. You can install it using LuaRocks:

Copy the `src/main.lua` file to your project directory as `DbAdmin.lua`.

## Usage

### Creating an Instance

Create a new `dbAdmin` instance by passing an SQLite database connection.

```lua
local sqlite3 = require("lsqlite3")
local dbAdmin = require("DbAdmin")

-- Open the database
local db = sqlite3.open_memory()

-- Create a new dbAdmin instance
local admin = dbAdmin.new(db)
```

### Listing Tables

List all tables in the database.

```lua
local tables = admin:tables()
print("Tables:")
for _, table in ipairs(tables) do
    print(table)
end
```

### Getting Record Count

Get the record count of a specific table.

```lua
local count = admin:count('your_table_name')
print(string.format("Record count in 'your_table_name': %d", count))
```

### Executing SQL Queries

Execute a given SQL query and retrieve the results.

```lua
local results = admin:exec("SELECT * FROM your_table_name;")
print("Query Results:")
for _, row in ipairs(results) do
    for k, v in pairs(row) do
        print(k, v)
    end
end
```

### Example

Here's a complete example demonstrating how to use the `dbAdmin` module:

```lua
local sqlite3 = require("lsqlite3")
local dbAdmin = require("DbAdmin")

-- Open the database
local db = sqlite3.open_memory()

-- Create a new dbAdmin instance
local admin = dbAdmin.new(db)

-- List all tables
local tables = admin:tables()
print("Tables:")
for _, table in ipairs(tables) do
    print(table)
end

-- Get the record count of a specific table
local count = admin:count('your_table_name')
print(string.format("Record count in 'your_table_name': %d", count))

-- Execute a query and print the results
local results = admin:exec("SELECT * FROM your_table_name;")
print("Query Results:")
for _, row in ipairs(results) do
    for k, v in pairs(row) do
        print(k, v)
    end
end
```

## Testing

```sh
aos dbadmin-tests --sqlite
```

```lua
.load-blueprint apm
APM.install('@rakis/test-unit')
.load src/run_tests.lua
```

## License

This project is licensed under the MIT License.
