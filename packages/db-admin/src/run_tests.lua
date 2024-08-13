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


return t:run()


