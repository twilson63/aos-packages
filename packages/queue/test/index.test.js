import { test } from 'node:test'
import * as assert from 'node:assert'
import { aoslocal } from '@permaweb/loco'

test('queue push and pop', async () => {
  const aos = await aoslocal()
  await aos.src('../load.lua')
  await aos.eval(`
MyQueue = require('@rakis/queue').new()
MyQueue:push({ Target = "Proc1", Data = "Hello" })
MyQueue:push({ Target = "Proc2", Data = "World" })  
`)

  await aos.eval('print(MyQueue:pop().Data)')
    .then(res => assert.equal(res.Output.data, 'Hello'))

  await aos.eval('print(MyQueue:pop().Data)')
    .then(res => assert.equal(res.Output.data, 'World'))
})

test('queue dispatch', async () => {
  const aos = await aoslocal()
  await aos.src('../load.lua')
  
  await aos.eval(`
    MyQueue = require('@rakis/queue').new()
    MyQueue:push({ Target = "Proc1", Data = "Hello" })
    MyQueue:push({ Target = "Proc2", Data = "World" })  
  `)

  await aos.eval(`
    MyQueue:dispatch({
      Target = "Test",
      Total = "2",
      Action = "Mint"
    }, "Queue-Pop", 1)
  `)
    .then(({Messages}) => {
      assert.deepEqual(Messages[0].Data, '{"Data":"Hello","Target":"Proc1"}')
      return aos.send({
        Action: 'Queue-Pop'
      })
    })
    .then(({Messages}) => {
      assert.deepEqual(Messages[0].Data, '{"Data":"World","Target":"Proc2"}')
      return aos.eval('MyQueue:clear()')
    })
    
})
