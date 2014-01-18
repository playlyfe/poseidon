Promise = require 'bluebird'
poseidon = require '../index'

describe 'The wrap function', ->

  beforeEach ->
    @api = {
      foo: (cb)-> cb(null, true)
      bar: (cb)-> cb(null, false)
      barfoo: (cb)-> cb(new Error('omg!'), null)
    }
    sinon.spy @api, 'foo'
    sinon.spy @api, 'bar'
    sinon.spy @api, 'barfoo'

  afterEach ->
    @api.foo.restore()
    @api.bar.restore()
    @api.barfoo.restore()

  it 'calls the original API function', (next) ->
    self = @
    wrappedApi = {}
    wrappedApi['foo'] = poseidon.wrap(@api, 'foo')
    wrappedApi.foo()
    .then ->
      expect(self.api.foo).to.have.been.calledOnce
      expect(self.api.foo).to.have.been.calledOn self.api
      next()
    .done()

  it 'returns a Promise promise with the resolved value', (next) ->
    self = @
    wrappedApi = {}
    wrappedApi['foo'] = poseidon.wrap(@api, 'foo')
    wrappedApi['bar'] = poseidon.wrap(@api, 'bar')
    wrappedApi['barfoo'] = poseidon.wrap(@api, 'barfoo')
    result = wrappedApi.foo()
    expect(Promise.is(result)).to.equal true
    result.then (value) ->
      expect(value).to.equal true
      wrappedApi.bar()
    .then (value) ->
      expect(value).to.equal false
      wrappedApi.barfoo()
    .catch (err) ->
      expect(err).to.be.instanceof Error
      expect(err.message).to.equal 'omg!'
      next()
    .done()

describe 'The wrapReturn function', ->

  beforeEach ->
    @api = {
      foo: (cb)-> cb(null, true)
      bar: (cb)-> cb(null, false)
      foobar: (cb)-> cb(null, [true, true])
      barfoo: (cb)-> cb(new Error('omg!'), null)
    }
    @obj = (bool) ->
      if bool then @x = 1
      else @y = 1
      return
    sinon.spy @api, 'foo'
    sinon.spy @api, 'bar'
    sinon.spy @api, 'foobar'
    sinon.spy @api, 'barfoo'

  afterEach ->
    @api.foo.restore()
    @api.bar.restore()
    @api.foobar.restore()
    @api.barfoo.restore()

  it 'calls the original API function', (next) ->
    self = @
    wrappedApi = {}
    wrappedApi['foo'] = poseidon.wrapReturn(@api, 'foo', @obj)
    wrappedApi.foo()
    .then ->
      expect(self.api.foo).to.have.been.calledOnce
      expect(self.api.foo).to.have.been.calledOn self.api
      next()
    .done()

  it 'returns a Promise promise with the resolved value passed to the constructor', (next) ->
    self = @
    wrappedApi = {}
    wrappedApi['foo'] = poseidon.wrapReturn(@api, 'foo', @obj)
    wrappedApi['bar'] = poseidon.wrapReturn(@api, 'bar', @obj)
    wrappedApi['foobar'] = poseidon.wrapReturn(@api, 'foobar', @obj)
    wrappedApi['barfoo'] = poseidon.wrapReturn(@api, 'barfoo', @obj)
    result = wrappedApi.foo()
    expect(Promise.is(result)).to.equal true
    result.then (value) ->
      expect(value).to.be.instanceof self.obj
      expect(value.x).to.equal 1
      wrappedApi.bar()
    .then (value) ->
      expect(value).to.be.instanceof self.obj
      expect(value.y).to.equal 1
      wrappedApi.foobar()
    .then (values) ->
      expect(values).to.be.instanceof Array
      for value in values
        expect(value).to.be.instanceof self.obj
        expect(value.x).to.be.equal 1

      wrappedApi.barfoo()
    .catch (err) ->
      expect(err).to.be.instanceof Error
      expect(err.message).to.equal 'omg!'
      next()
    .done()

describe 'the wrapPromise function', ->

  beforeEach ->
    @api = {
      foo: (cb)-> cb(null, true)
      bar: (cb)-> cb(null, false)
      barfoo: (cb)-> cb(new Error('omg!'), null)
    }
    sinon.spy @api, 'foo'
    sinon.spy @api, 'bar'
    sinon.spy @api, 'barfoo'
    _source = Promise.pending()
    _source.resolve @api
    @promise = _source.promise

  afterEach ->
    @api.foo.restore()
    @api.bar.restore()
    @api.barfoo.restore()

  it 'calls the original API function', (next) ->
    self = @
    wrappedApi = {}
    wrappedApi['foo'] = poseidon.wrapPromise(@promise, 'foo')
    wrappedApi.foo()
    .then ->
      expect(self.api.foo).to.have.been.calledOnce
      expect(self.api.foo).to.have.been.calledOn self.api
      next()
    .done()

  it 'returns a Bluebird promise with the resolved value', (next) ->
    self = @
    wrappedApi = {}
    wrappedApi['foo'] = poseidon.wrapPromise(@promise, 'foo')
    wrappedApi['bar'] = poseidon.wrapPromise(@promise, 'bar')
    wrappedApi['barfoo'] = poseidon.wrapPromise(@promise, 'barfoo')
    result = wrappedApi.foo()
    expect(Promise.is(result)).to.equal true
    result.then (value) ->
      expect(value).to.equal true
      wrappedApi.bar()
    .then (value) ->
      expect(value).to.equal false
      wrappedApi.barfoo()
    .catch (err) ->
      expect(err).to.be.instanceof Error
      expect(err.message).to.equal 'omg!'
      next()
    .done()

  it 'throws an error if the source is not a promise', ->
    invalidCall = ->
      poseidon.wrapPromise({ foo: -> }, 'foo')
    expect(invalidCall).to.throw Error, 'Object is not a Promise'

describe 'The wrapPromiseReturn function', ->

  beforeEach ->
    @api = {
      foo: (cb)-> cb(null, true)
      bar: (cb)-> cb(null, false)
      foobar: (cb)-> cb(null, [true, true])
      barfoo: (cb)-> cb(new Error('omg!'), null)
    }
    @obj = (bool) ->
      if bool then @x = 1
      else @y = 1
      return
    sinon.spy @api, 'foo'
    sinon.spy @api, 'bar'
    sinon.spy @api, 'foobar'
    sinon.spy @api, 'barfoo'
    _source = Promise.pending()
    _source.resolve @api
    @promise = _source.promise

  afterEach ->
    @api.foo.restore()
    @api.bar.restore()
    @api.foobar.restore()
    @api.barfoo.restore()

  it 'calls the original API function', (next) ->
    self = @
    wrappedApi = {}
    wrappedApi['foo'] = poseidon.wrapPromiseReturn(@promise, 'foo', @obj)
    wrappedApi.foo()
    .then ->
      expect(self.api.foo).to.have.been.calledOnce
      expect(self.api.foo).to.have.been.calledOn self.api
      next()
    .done()

  it 'returns a Promise promise with the resolved value passed to the constructor', (next) ->
    self = @
    wrappedApi = {}
    wrappedApi['foo'] = poseidon.wrapPromiseReturn(@promise, 'foo', @obj)
    wrappedApi['bar'] = poseidon.wrapPromiseReturn(@promise, 'bar', @obj)
    wrappedApi['foobar'] = poseidon.wrapPromiseReturn(@promise, 'foobar', @obj)
    wrappedApi['barfoo'] = poseidon.wrapPromiseReturn(@promise, 'barfoo', @obj)
    result = wrappedApi.foo()
    expect(Promise.is(result)).to.equal true
    result.then (value) ->
      expect(value).to.be.instanceof self.obj
      expect(value.x).to.equal 1
      wrappedApi.bar()
    .then (value) ->
      expect(value).to.be.instanceof self.obj
      expect(value.y).to.equal 1
      wrappedApi.foobar()
    .then (values) ->
      expect(values).to.be.instanceof Array
      for value in values
        expect(value).to.be.instanceof self.obj
        expect(value.x).to.be.equal 1

      wrappedApi.barfoo()
    .catch (err) ->
      expect(err).to.be.instanceof Error
      expect(err.message).to.equal 'omg!'
      next()
    .done()

  it 'throws an error if the source is not a promise', ->
    self = @
    invalidCall = ->
      poseidon.wrapPromiseReturn({ foo: -> }, 'foo', self.obj)
    expect(invalidCall).to.throw Error, 'Object is not a Promise'
