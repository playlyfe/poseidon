Poseidon = require '../index'
configuration = require './schema'

generator = new Poseidon(configuration)

generator.generate("#{__dirname}")
.then (output) =>
  console.log "Written to files"


