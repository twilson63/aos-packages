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

local Queue = {}
Queue.__index = Queue

-- Constructor to create a new queue
function Queue.new()
    return setmetatable({ first = 0, last = -1, data = {} }, Queue)
end

-- Method to clear queue
function Queue:clear()
    self.data = nil 
    collectgarbage('collect')
    self.data = {}
    self.first = 0
    self.last = -1
end

-- Method to push an element to the queue
function Queue:push(value)
    local last = self.last + 1
    self.last = last
    self.data[last] = value
end

-- Method to pop an element from the queue
function Queue:pop()
    local first = self.first
    if first > self.last then
        return nil -- Queue is empty
    end
    local value = self.data[first]
    self.data[first] = nil -- Clear reference
    collectgarbage('collect')
    self.first = first + 1
    return value
end

-- Method to dispatch items in the queue recursively
function Queue:dispatch(template, action, idx)
    local next = self:pop()
    if next ~= nil then
        print("sending page " .. idx .. " of " .. (template.Total or "na"))
        local msg = template
        msg.Data = next
        if idx then
            msg.Index = tostring(idx)
        end
        Send(msg)

        Send({ Target = ao.id, Action = action })
        Receive({ Action = action })
        self:dispatch(template, action, idx + 1)
    end
end

local pipe = { _version = "0.0.3" }

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
function pipe.send(dataTable, target, options)
  local batch = Queue.new()
  local pages = {}
  local _options = {
    ['page-size'] = options and options['page-size'],
    labels = options and options['labels'] or nil
  }


  if isArray(dataTable) then
    pages = csv.createFromTable(dataTable, _options.labels, _options['page-size'])
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
function pipe.receive(patternMatcher, complete, options)
  local pages = {}
  local _options = options or { format = "none" }

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
        local results = concatTables(pages)
        if _options.format == "key-value" then
            results = Utils.reduce(function (a, r)
              a[r[1]] = r[2]
              return a
            end, {}, results)
        end
        complete(results)
        -- clear pages
        pages = nil
        collectgarbage()
        pages = {}
    end
  end)
end

return pipe