import { test } from 'node:test'
import * as assert from 'node:assert'
import { aoslocal } from '@permaweb/loco'

const assoc = (k,v,o) => {
    o[k] = v
    return o
}

test('pipe', async () => {
  try {
    const sender = await aoslocal()
    const rec = await aoslocal()

    await sender.src('../load.lua')
    await rec.src('../load.lua')

     // setup receive
    await rec.eval(`
Balances = {}
require('@rakis/pipe').receive({}, function (d)
  Balances = d
  print(tostring(#Utils.keys(Balances)))
end)    
print(tostring(#Utils.keys(Balances)))
    `).then(result => {
        assert.equal(result.Output.data, "0")
        // nice 2 spaces!
    })

   // send some data
   await sender.eval(`
Balances = {
  Larry = "10",
  Curly = "20",
  Moe = "30"
}
require('@rakis/pipe').send(Balances, "REC", { template = { BatchReference = "2" }})
    `)
    .then(x => {
      const tags = x.Messages[0].Tags.reduce((a,t) => assoc(t.name, t.value, a), {})
      assert.equal(tags.BatchReference, "2")
      return x
    })
    //.then(x => (console.log(x.Output.data), x))
    .then(result => rec.send({ 
        ...result.Messages[0].Tags.reduce((a,t) => assoc(t.name, t.value, a), {}),
        Target: "TEST_PROCESS_ID", 
        Data: result.Messages[0].Data 
    }))
    .then(result => assert.equal(result.Output.data, "3") )
  } catch (e) {
    console.log(e)
  }
})
