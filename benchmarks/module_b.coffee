class ModuleB

  constructor: ->

  callbackFunction: (cb) ->
    cb(null, 'foo')

  callbackFunction2: (val, cb) ->
    if val is 1 then cb(null, 'foo')
    else cb(new Error('Module error'), null)

  chainableFunction: ->
    @

module.exports = ModuleB
