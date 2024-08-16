local sqlite3 = require("lsqlite3")
local testUnit = require("@rakis/test-unit")

db = sqlite3.open_memory()

dbAdmin = require('DbAdmin').new(db)

db:exec[[
  CREATE TABLE test (id INTEGER PRIMARY KEY, content);
  INSERT INTO test VALUES (NULL, 'Hello Lua');
  INSERT INTO test VALUES (NULL, 'Hello Sqlite3');
  INSERT INTO test VALUES (NULL, 'Hello ao!!!');
]]

local t = testUnit.new("DbAdmin Tests")

t:add("List Tables", function()
  local results = dbAdmin:tables()
  assert(results[1] == "test", "found test table")
end)

t:add("Count Records", function ()
  local results = dbAdmin:count('test')
  assert(results == 3, "3 records found in test")
end)

-- Test: Apply Insert
t:add("Apply Insert", function()
  dbAdmin:apply('INSERT INTO test (content) VALUES (?);', {"Hello World"})
  local results = dbAdmin:exec('SELECT * FROM test WHERE content = "Hello World";')
  assert(#results == 1, "Expected 1 record with content 'Hello World'")
end)

-- Test: Apply Update
t:add("Apply Update", function()
  dbAdmin:apply('UPDATE test SET content = ? WHERE content = ?;', {"Updated Content", "Hello World"})
  local results = dbAdmin:exec('SELECT * FROM test WHERE content = "Updated Content";')
  assert(#results == 1, "Expected 1 record with updated content 'Updated Content'")
end)

-- Test: Apply Delete
t:add("Apply Delete", function()
  dbAdmin:apply('DELETE FROM test WHERE content = ?;', {"Updated Content"})
  local results = dbAdmin:exec('SELECT * FROM test WHERE content = "Updated Content";')
  assert(#results == 0, "Expected no records with content 'Updated Content'")
end)

return t:run()


