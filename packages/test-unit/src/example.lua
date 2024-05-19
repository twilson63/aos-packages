local Test = require("Test")

local myTests = Test.new('example tests')

myTests:add("ok", function () assert(true, 'passing test') end)

return myTests:run()