import { test } from 'node:test'
import * as assert from 'node:assert'
import { aoslocal } from '@permaweb/loco'

test('csv from KV', async () => {
  const aos = await aoslocal()
  await aos.src('../load.lua')
  await aos.eval(`
Csv = require('@rakis/csv')
Kv = {
  addr1 = "100",
  addr2 = "200",
  addr3 = "400"
}
local pages = Csv.createKV(Kv)  
print(tostring(#pages))
`)
  .then(({Output}) => assert.equal(Output.data, "1"))

})

