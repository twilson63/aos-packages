local csv = require("src.csv")  -- External CSV library should provide createFromTable and parse functions.
local Queue = require('src.queue')

local pipe = {}

local function isArray(table)
    if type(table) == "table" then
        local maxIndex = 0
        for k, v in pairs(table) do
            if type(k) ~= "number" or k < 1 or math.floor(k) ~= k then
                return false -- If there's a non-integer key, it's not an array
            end
            maxIndex = math.max(maxIndex, k)
        end
        -- If the highest numeric index is equal to the number of elements, it's an array
        return maxIndex == #table
    end
    return false
end

local function concatTables(tables)
    local total = 0
    for i = 1, #tables do
        total = total + #tables[i]
    end
    local result = {}
    local pos = 1
    for i = 1, #tables do
        table.move(tables[i], 1, #tables[i], pos, result)
        pos = pos + #tables[i]
    end
    return result
end

--- 
-- Sends data by converting a table to CSV strings and pushing them to the specified target queue.
-- @param dataTable A table of data to convert.
-- @param target The destination queue identifier.
-- @param action The action value for the message.
function pipe.send(dataTable, target)
  local batch = Queue.new()
  local pages = {}
  if isArray(dataTable) then
    pages = csv.createFromTable(dataTable)
  else
    pages = csv.createKV(dataTable)
  end
  Utils.map(function (page) batch:push(page) end, pages)
  batch:dispatch({
    Format = "CSV",
    Target = target,
    Total = tostring(#pages),
    Action = "Pipe-Data"
  }, "Pipe-Next", 1)
  batch:clear()
  print('piped data to target ' .. target)
end

---
-- Returns a handler function that processes a batch of CSV strings from the queue.
-- The handler filters the CSV lines using an optional patternMatcher, concatenates them,
-- parses them into a table, and then calls the provided handler.
--
-- @param handler A function that will be called with the parsed table.
-- @param patternMatcher (Optional) A function that takes a CSV line and returns true if the line should be processed.
function pipe.receive(patternMatcher, complete)
  local pages = {}
  Handlers.add("Pipe-Data", function (msg)
    if msg.Action ~= "Pipe-Data" then 
        return false
    end
    if msg.Format ~= "CSV" then
        return false
    end
    return Utils.matchesSpec(msg, patternMatcher)
  end, function (msg)
    table.insert(pages, csv.parser(msg.Data))
    if #pages == tonumber(msg.Total) then
        -- got all
        complete(concatTables(pages))
        -- clear pages
        pages = nil
        collectgarbage()
        pages = {}
    end
  end)
end

return pipe