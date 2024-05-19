import { test } from 'node:test'
import * as assert from 'node:assert'
import { Send } from './aos.helper.js'
import fs from 'node:fs'

test('load dbAdmin', async () => {

  const code = fs.readFileSync('./src/main.lua', 'utf-8')
  const data = `
local function _load()
  ${code}
end
_G.package.loaded["DbAdmin"] = _load()  
return "loaded.."
`
  const result = await Send({ Action: "Eval", Data: data })
  assert.equal(result.Output.data.output, 'loaded..')

})

test('example', async () => {
  const code = fs.readFileSync('./src/example.lua', 'utf-8')
  const result = await Send({ Action: "Eval", Data: code })
  assert.equal(result.Output.data.output, '{ \x1B[32m"test"\x1B[0m }')
})

test('example2', async () => {
  const code = fs.readFileSync('./src/example.lua', 'utf-8')
  const result = await Send({ Action: "Eval", Data: `dbAdmin:count('test')` })
  assert.equal(result.Output.data.output, '3')
})

test('example2', async () => {
  const code = fs.readFileSync('./src/example.lua', 'utf-8')
  const result = await Send({ Action: "Eval", Data: `require('json').encode(dbAdmin:exec('SELECT * FROM test'))` })
  assert.equal(result.Output.data.output, '[{"content":"Hello Lua","id":1},{"content":"Hello Sqlite3","id":2},{"content":"Hello ao!!!","id":3}]')
})