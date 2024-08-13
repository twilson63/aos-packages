local Test = require("Test")

local myTests = Test.new('example tests')

myTests:add("ok", function () assert(true, 'passing test') end)
myTests:add("receive ok", function ()
  Handlers.once("ping", function (msg) msg.reply({Action = "pong"}) end)
  local msg = Send({Target = ao.id, Action = "ping"}).receive()
  assert(msg.Action == "pong", "received pong")
end)

return myTests:run()
