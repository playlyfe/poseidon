ModuleB = require './module_b'

class ModuleA

  constructor: ->

  callbackFunction: (cb) ->
    cb(null, 'foo')

  callbackFunction2: (val, cb) ->
    if val is 1 then cb(null, 'foo')
    else cb(new Error('Module error'), null)

  callbackFunction3: (val, cb) ->
    cb(null , new ModuleB())

  synchronousFunction: ->
    true
    return

  chainableFunction: ->
    @

module.exports = ModuleA
