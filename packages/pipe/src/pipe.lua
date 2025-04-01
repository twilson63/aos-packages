local csv = require("csv")  -- External CSV library should provide createFromTable and parse functions.
local pipe = {}

-- Dummy queue implementation (for demonstration)
local queues = {}

local function pushToQueue(target, csvLine)
  queues[target] = queues[target] or {}
  table.insert(queues[target], csvLine)
end

local function popQueue(target)
  local q = queues[target] or {}
  queues[target] = {}  -- Clear the queue after fetching the batch.
  return q
end

--- 
-- Sends data by converting a table to CSV strings and pushing them to the specified target queue.
-- @param dataTable A table of data to convert.
-- @param target The destination queue identifier.
function pipe.send(dataTable, target)
  local csvStrings = csv.createFromTable(dataTable)
  for _, line in ipairs(csvStrings) do
    pushToQueue(target, line)
  end
end

---
-- Returns a handler function that processes a batch of CSV strings from the queue.
-- The handler filters the CSV lines using an optional patternMatcher, concatenates them,
-- parses them into a table, and then calls the provided handler.
--
-- @param handler A function that will be called with the parsed table.
-- @param patternMatcher (Optional) A function that takes a CSV line and returns true if the line should be processed.
function pipe.receive(handler, patternMatcher)
  return function(target)
    local csvBatch = popQueue(target)
    local filtered = {}
    for _, line in ipairs(csvBatch) do
      if not patternMatcher or patternMatcher(line) then
        table.insert(filtered, line)
      end
    end
    if #filtered > 0 then
      local concatenatedCSV = table.concat(filtered, "\n")
      local parsedTable = csv.parse(concatenatedCSV)
      handler(parsedTable)
    end
  end
end

return pipe