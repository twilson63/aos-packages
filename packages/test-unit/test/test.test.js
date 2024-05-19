import { test } from 'node:test'
import * as assert from 'node:assert'
import { Send } from './aos.helper.js'
import fs from 'node:fs'

test('load source', async () => {

  const code = fs.readFileSync('./src/test.lua', 'utf-8')
  const data = `
local function _load()
  ${code}
end
_G.package.loaded["Test"] = _load()  
return "loaded.."
`
  const result = await Send({ Action: "Eval", Data: data })
  assert.equal(result.Output.data.output, 'loaded..')

})

test('load test', async () => {

  const code = fs.readFileSync('./src/example.lua', 'utf-8')
  const result = await Send({ Action: "Eval", Data: code })

  assert.equal(result.Output.data.output, 'Running tests for example tests\n✔ ok\nPassed: 1, Failed: 0\n')

})

test('failing test', async () => {
  const result = await Send({
    Action: "Eval", Data: `
local Test = require("Test")

local myTests = Test.new('example tests')

myTests:add("ok", function () assert(false, 'failing test') end)

return myTests:run()
  ` })
  assert.ok(result.Output.data.output.includes('Failed: 1'))

})