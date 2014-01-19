Benchmark = require 'benchmark'
ModuleA = require './module_a'
PoseidonModuleA = require './poseidonmodulea'

suite = new Benchmark.Suite()

originalModule = (deferred) ->
  x = new ModuleA()
  x.callbackFunction () ->
    x.callbackFunction2 1, () ->
      x.chainableFunction()
      .synchronousFunction()
      x.callbackFunction3 1, (err, y) ->
        y.callbackFunction () ->
          y.callbackFunction2 1, () ->
            y.chainableFunction()
            y.callbackFunction () ->
              y.callbackFunction () ->
                y.callbackFunction () ->
                  y.callbackFunction () ->
                    y.callbackFunction () ->
                      deferred.resolve()

poseidonModule = (deferred) ->
  x = new PoseidonModuleA(new ModuleA())
  x.callbackFunction()
  .then ->
    x.callbackFunction2(1)
  .then ->
    x.chainableFunction().synchronousFunction()
    x.callbackFunction3(1)
  .then (y) ->
    y.callbackFunction()
    .then ->
      y.callbackFunction2(1)
    .then ->
      y.chainableFunction()
    .then ->
      y.callbackFunction()
    .then ->
      y.callbackFunction()
    .then ->
      y.callbackFunction()
    .then ->
      y.callbackFunction()
    .then ->
      y.callbackFunction()
    .then ->
      deferred.resolve()

suite
.add('Simple Callbacks', { fn: originalModule, defer: true })
.add('Poseidon', { fn: poseidonModule, defer: true })
.on('cycle', (event) ->
  console.log(String(event.target));
)
.on('complete', () ->
  console.log('Fastest is ' + this.filter('fastest').pluck('name'));
)
suite.run()

