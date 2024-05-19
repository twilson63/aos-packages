local sqlite3 = require("lsqlite3")
 
db = sqlite3.open_memory()
dbAdmin = require('DbAdmin').new(db)

db:exec[[
  CREATE TABLE test (id INTEGER PRIMARY KEY, content);
  INSERT INTO test VALUES (NULL, 'Hello Lua');
  INSERT INTO test VALUES (NULL, 'Hello Sqlite3');
  INSERT INTO test VALUES (NULL, 'Hello ao!!!');
]]

return dbAdmin:tables()
-- return "ok"

