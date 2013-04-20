Poseidon
========
Poseidon is a tiny module which provides functions for wrapping the APIs of
existing node modules using the **Q** library to write smaller, cleaner and
simpler code free from callbacks.

    Q = require 'q'

    module.exports =

The `wrap` function is the simplest wrapping function. It returns a function
which executes the original function on the **source object** and returns a
promise instead of requiring the user to provide a callback.

      wrap: (source, func) ->
        ->
          args = Array.prototype.slice.call arguments
          Q.ninvoke.apply Q, [source, func].concat args

The `wrapReturn` function accepts a list of constructors which will be applied
to the values returned by the wrapped function. This is useful especially when
the function returns objects which have APIs that we also want to wrap using
Poseidon.

      wrapReturn: (source, func, constructors...) ->
        ->
          _result = Q.defer()
          args = Array.prototype.slice.call arguments
          Q.ninvoke.apply(Q, [source, func].concat(args))
          .then (values...) ->
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
          .fail (err) ->
            _result.reject err
            return
          .done()
          _result.promise

The `wrapPromise` function can wrap a function on a **source object** which will
 be the result of a promise. It assumes the promise will resolve to just a
 single value.

      wrapPromise: (promise, func) ->
        throw new Error('Object is not a Promise') unless Q.isPromise promise
        ->
          args = Array.prototype.slice.call arguments
          promise.then (source) ->
            Q.ninvoke.apply Q, [source, func].concat args

The `wrapPromiseReturn` is the equivalent of the `wrapReturn` when the **source
object** is represented by a promise.

      wrapPromiseReturn: (promise, func, constructors...) ->
        throw new Error('Object is not a Promise') unless Q.isPromise promise
        ->
          _result = Q.defer()
          args = Array.prototype.slice.call arguments
          promise.then (source) ->
            Q.ninvoke.apply Q, [source, func].concat args
          .then (values...) ->
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
          .fail (err) ->
            _result.reject err
            return
          .done()
          _result.promise
