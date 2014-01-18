###
Poseidon
========
Poseidon is a tiny module which provides functions for wrapping the APIs of
existing node modules using the **Bluebird** library to write smaller, cleaner and
simpler code free from callbacks.
###

Promise = require 'bluebird'

module.exports =
  Promise: Promise

  ###
  The `wrap` function is the simplest wrapping function. It returns a function
  which executes the original function on the **source object** and returns a
  promise instead of requiring the user to provide a callback.
  ###

  wrap: (source, func) ->
    Promise.promisify(source[func], source)

  ###
  The `wrapReturn` function accepts a list of constructors which will be applied
  to the values returned by the wrapped function. This is useful especially when
  the function returns objects which have APIs that we also want to wrap using
  Poseidon.
  ###

  wrapReturn: (source, func, constructors...) ->
    ->
      _result = Promise.pending()
      args = Array.prototype.slice.call(arguments).concat (err, values...) ->
        if err then return _result.reject err
        objs = []
        for index, value of values
          if value instanceof Array
            objVals = []
            for objVal in value
              objVals.push new constructors[index](objVal)
            objs.push objVals
          else
            objs.push new constructors[index](value)
        _result.resolve.apply _result, objs
      source[func].apply source, args
      _result.promise

  ###
  The `wrapPromise` function can wrap a function on a **source object** which will
  be the result of a promise. It assumes the promise will resolve to just a
  single value.
  ###

  wrapPromise: (promise, func) ->
    throw new Error('Object is not a Promise') unless Promise.is promise
    ->
      args = Array.prototype.slice.call arguments
      promise.then (source) ->
        Promise.promisify(source[func], source).apply(source, args)

  ###
  The `wrapPromiseReturn` is the equivalent of the `wrapReturn` when the **source
  object** is represented by a promise.
  ###

  wrapPromiseReturn: (promise, func, constructors...) ->
    throw new Error('Object is not a Promise') unless Promise.is promise
    ->
      _result = Promise.defer()
      args = Array.prototype.slice.call(arguments).concat((err, values...) ->
        if err then _result.reject err
        objs = []
        for index, value of values
          if value instanceof Array
            objVals = []
            for objVal in value
              objVals.push new constructors[index](objVal)
            objs.push objVals
          else
            objs.push new constructors[index](value)
        _result.resolve.apply _result, objs
        return
      )
      promise.then (source) ->
        source[func].apply source, args
      _result.promise
