Poseidon = require '../index'
Promise = require 'bluebird'
ModuleA = require '../benchmarks/module_a'
ModuleB = require '../benchmarks/module_b'
schema = require '../benchmarks/schema'

describe 'The Poseidon generator', ->

  beforeEach (next) ->
    sinon.spy(ModuleA.prototype, 'callbackFunction')
    sinon.spy(ModuleA.prototype, 'callbackFunction2')
    sinon.spy(ModuleA.prototype, 'callbackFunction3')
    sinon.spy(ModuleA.prototype, 'synchronousFunction')
    sinon.spy(ModuleA.prototype, 'chainableFunction')
    sinon.spy(ModuleB.prototype, 'callbackFunction')
    sinon.spy(ModuleB.prototype, 'callbackFunction2')
    sinon.spy(ModuleB.prototype, 'chainableFunction')

    generator = new Poseidon(schema)
    generator.generate("#{__dirname}")
    .then (output) =>
      @PoseidonModuleA = require './poseidonmodulea'
      @PoseidonModuleB = require './poseidonmoduleb'
      @moduleA = new @PoseidonModuleA(new ModuleA())
      @moduleB = new @PoseidonModuleB(new ModuleB())
      expect(Promise.is(@moduleB.instance)).to.equal true
      next()

  afterEach ->
    ModuleA.prototype.callbackFunction.restore()
    ModuleA.prototype.callbackFunction2.restore()
    ModuleA.prototype.callbackFunction3.restore()
    ModuleA.prototype.synchronousFunction.restore()
    ModuleA.prototype.chainableFunction.restore()
    ModuleB.prototype.callbackFunction.restore()
    ModuleB.prototype.callbackFunction2.restore()
    ModuleB.prototype.chainableFunction.restore()


  it 'can wrap a simple function', (next) ->
    promise = @moduleA.callbackFunction()
    expect(Promise.is(promise)).to.equal.true
    promise.then ->
      expect(ModuleA.prototype.callbackFunction).to.have.been.calledOnce
      next()
    .done()
    return

  it 'can wrap return values', (next) ->
    @moduleA.callbackFunction3(true)
    .then (moduleB) =>
      expect(ModuleA.prototype.callbackFunction3).to.have.been.calledOnce
      expect(moduleB).to.be.instanceof @PoseidonModuleB
      moduleB.instance.then (instance) ->
        expect(instance).to.be.instanceof ModuleB
        next()
    .done()
    return

  it 'can wrap synchronous functions', ->
    @moduleA.synchronousFunction()
    expect(ModuleA.prototype.synchronousFunction).to.have.been.calledOnce
    return

  it 'can wrap chainable functions', ->
    expect(@moduleA.chainableFunction()).to.deep.equal @moduleA
    @moduleA.chainableFunction().chainableFunction()
    expect(ModuleA.prototype.chainableFunction).to.have.been.calledThrice
    return

  it 'can wrap a simple function on a promised object', (next) ->
    promise = @moduleB.callbackFunction()
    expect(Promise.is(promise)).to.equal.true
    promise.then ->
      expect(ModuleB.prototype.callbackFunction).to.have.been.calledOnce
      next()
    .done()

