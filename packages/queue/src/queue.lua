--[[
1. **Queue Class Initialization**:
   - The `Queue` class is defined and made mutable using the `setmetatable`
   function.

2. **Constructor (`Queue.new()`)**:
   - A new queue instance is created with properties for `first`, `last`, and an
   empty dictionary to store elements.

3. **Push Method**:
   - Allows adding elements to the end of the queue by updating the `last`
     property and setting its value.

4. **Pop Method**:
   - Removes the first element from the queue, updates the `first` property, and
   clears the stored reference for that element.

5. **Dispatch Method (Recursive Queue Deployment)**:
   - This method dispatches an item or action recursively when a new element is
   added.

   - When pushing an element (`push()`), it creates a template object with the
   current queue instance as the data object's key and the pushed value as
   `msg.Data`.

   - It then sends this template to the queue and receives back any action,
    which allows for recursive dispatching of subsequent items.

### Usage Examples:

```lua
queue = Queue.new() -- Creates a new empty queue

queue:push("Element 1") --> The queue is now first=0, last=1,
data={ "Element 1" : nil }

result = queue:pop()
-- result will be "Element 1"

queue:dispatch(function template return "Queue Element: #{queue} and element:
#{result}" end, "Hello world")
```

This example pushes an element, pops it to get a message, and then dispatches a
    message string with the current queue instance and the popped result.

---

### Explanation of Key Methods:

- **Push (`push()`)**:
  - Adds elements to the end of the queue. It updates `last` and sets its value
  in the data dictionary.

- **Pop (`pop()`)**:
  - Removes and removes from the front of the queue. It updates `first` and
  clears the stored reference for that element.

- **Dispatch (`dispatch()`)**:
  - Handles the recursive part of dispatching items when new elements are added
  to the queue.
    - Creates a template object with the current queue instance as the data
    object's key.
    - Sends this template to the queue (recursively if needed).
    - Recipients of the action allow for further dispatching, enabling users to
    chain requests on each item in the queue.

This implementation provides a straightforward way to manage queues where items
can be added and removed with recursion capability.
]]
-- Queue Module
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

return Queue