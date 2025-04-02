# Lua Queue Library

A lightweight queue implementation in Lua. It provides basic operations such as creating a new queue, pushing and popping elements, clearing the queue, and recursively dispatching queued items.

## Features

- **Create a new queue**: Initialize a queue with `Queue.new()`.
- **Push elements**: Add elements to the end using `Queue:push(value)`.
- **Pop elements**: Remove and return the first element with `Queue:pop()`. Returns `nil` if the queue is empty.
- **Clear the queue**: Reset the queue using `Queue:clear()`.
- **Dispatch items**: Recursively process each item in the queue with `Queue:dispatch(template, action, idx)`. This method uses external functions (`Send` and `Receive`), so ensure they're defined in your environment.

## Usage

```lua
local Queue = require("@rakis/queue")  -- Adjust the path as needed

-- Create a new queue instance
local myQueue = Queue.new()

-- Push some values
myQueue:push("item1")
myQueue:push("item2")
myQueue:push("item3")

-- Pop a value
local firstItem = myQueue:pop()
print("Popped:", firstItem)

-- Clear the queue
myQueue:clear()

-- Dispatch example (ensure Send and Receive functions exist in your code)
local template = { Total = 3 }  -- Customize as needed
local action = "processItem"
myQueue:dispatch(template, action, 1)
```

## Test

```bash
cd test
npm i && npm t
```
