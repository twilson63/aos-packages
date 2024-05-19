--[[
PackageManager Client

example: Install Package

```lua
local apm = require('apm').new(PACKAGE_MGR_ID)
apm:install('Test')

local Test = require('Test')

const myTests = Test.new('myTest Suite')

myTests:add("ok", function () 
  assert(true, 'Passing Test...')
end)

```

example: publish Package

```lua
local apm = require('apm').new(PACKAGE_MGR_ID)

apm:publish('NAME@VERSION', CODE, README)

local Test = require('Test')

const myTests = Test.new('myTest Suite')

myTests:add("ok", function () 
  assert(true, 'Passing Test...')
end)

```
]]