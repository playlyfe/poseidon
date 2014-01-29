esprima = require 'esprima'
escodegen = require 'escodegen'
Promise = require 'bluebird'
fs = require 'fs'

class Poseidon

  constructor:(configuration = {}) ->
    @configuration = configuration
    return

  generate: (path) ->
    files = []
    for className, classSchema of @configuration
      file = {}
      file.name = "#{className.toLowerCase()}.js"

      code = file.code = []

      dependencies = ["var Promise = require('bluebird');"]
      for dependency, dependencyPath of classSchema.require
        dependencies.push "var #{dependency} = require('#{dependencyPath}');"

      # Generate class constructor
      code.push """
      function #{className}(#{classSchema.constructor.params.join(", ")}) {
        #{classSchema.constructor.body}
      }
      """
      for functionName, functionSchema of classSchema.functions
        # Set default options
        functionSchema.wrap ?= true
        functionSchema.params ?= []

        # Generate class method
        hunk = ["""
          #{className}.prototype.#{functionName} = function (#{if functionSchema.body? then "#{functionSchema.params.join(", ")}){\n" else "){\n var args = arguments;"}
        """]

        if classSchema.type is 'promise'
          instanceIdentifier = "instanceValue"
        else
          instanceIdentifier = "this.instance"
        # Use custom body if specified
        if functionSchema.body?
          hunk.push(functionSchema.body)
        else
          # Create deferred and callback if wrap option is true
          if functionSchema.wrap or classSchema.type is 'promise'
            hunk.push "var deferred = Promise.pending();"

          if not functionSchema.wrap
            hunk.push "var result;"

          if classSchema.type is 'promise'
            hunk.push "this.instance.then(function (instanceValue) {"

          if functionSchema.wrap
            # Code to wrap return values
            castValues = []
            if functionSchema.return?
              for index, constructorName of functionSchema.return
                if constructorName isnt null
                  if constructorName instanceof Object
                    if constructorName.array?
                      castValues.push "arguments[#{parseInt(index)+1}] = arguments[#{parseInt(index)+1}].map(function(item) { return new #{constructorName.name}(item); });"
                  else
                    castValues.push "arguments[#{parseInt(index)+1}] = new #{constructorName}(arguments[#{parseInt(index)+1}]);"

            hunk.push """
            var callback = function () {
              if (arguments[0]) {
                if (arguments.length === 1 || arguments[1] == null) {
                  deferred.reject(arguments[0]);
                } else {
                  deferred.reject(Array.prototype.slice.call(arguments, 0));
                }
              } else {
                #{castValues.join("\n")}
                switch(arguments.length) {
                  case 0:
                    deferred.resolve();
                    break;
                  case 2:
                    deferred.resolve(arguments[1]);
                    break;
                  case 3:
                    deferred.resolve([arguments[1], arguments[2]]);
                    break;
                  case 4:
                    deferred.resolve([arguments[1], arguments[2], arguments[3]]);
                    break;
                  case 5:
                    deferred.resolve([arguments[1], arguments[2], arguments[3], arguments[4]]);
                    break;
                  case 6:
                    deferred.resolve([arguments[1], arguments[2], arguments[3], arguments[4], arguments[5]]);
                    break;
                  default:
                    deferred.resolve(Array.prototype.slice.call(null, arguments, 1));
                    break;
                }
              }
            };
            """

          # Generate optimized function call
          hunk.push """
          switch(args.length) {
            case 0:
              #{if functionSchema.wrap then "" else "result = "}#{instanceIdentifier}.#{functionName}(#{if functionSchema.wrap then "callback" else ""});
              break;
            case 1:
              #{if functionSchema.wrap then "" else "result = "}#{instanceIdentifier}.#{functionName}(args[0]#{if functionSchema.wrap then ", callback" else ""});
              break;
            case 2:
              #{if functionSchema.wrap then "" else "result = "}#{instanceIdentifier}.#{functionName}(args[0], args[1]#{if functionSchema.wrap then ", callback" else ""});
              break;
            case 3:
              #{if functionSchema.wrap then "" else "result = "}#{instanceIdentifier}.#{functionName}(args[0], args[1], args[2]#{if functionSchema.wrap then ", callback" else ""});
              break;
            case 4:
              #{if functionSchema.wrap then "" else "result = "}#{instanceIdentifier}.#{functionName}(args[0], args[1], args[2], args[3]#{if functionSchema.wrap then ", callback" else ""});
              break;
            case 5:
              #{if functionSchema.wrap then "" else "result = "}#{instanceIdentifier}.#{functionName}(args[0], args[1], args[2], args[3], args[4]#{if functionSchema.wrap then ", callback" else ""});
              break;
            default:
              #{if functionSchema.wrap then "" else "result = "}#{instanceIdentifier}.#{functionName}.apply(#{instanceIdentifier}, #{if functionSchema.wrap then "Array.prototype.slice.call(null, args).concat(callback)" else "args"});
              break;
          }
          #{if not functionSchema.wrap and classSchema.type is 'promise' and functionSchema.return? then "result = new #{functionSchema.return[0]}(result);" else ""}
          #{if not functionSchema.wrap and classSchema.type is 'promise' then "deferred.resolve(result);" else ""}
          """
          if classSchema.type is 'promise'
            hunk.push "});"

          # Return promise if wrap option is set
          if functionSchema.wrap or classSchema.type is 'promise'
            if not functionSchema.wrap and functionSchema.return?.length > 1 then throw new Error("Only 1 return value allowed when no callback is present")
            hunk.push "return deferred.promise;"
          else
            # If no wrap option is allowed only 1 value can be set in return
            if functionSchema.return?
              if functionSchema.return.length > 1 then throw new Error("Only 1 return value allowed when no callback is present")
              hunk.push "return new #{functionSchema.return[0]}(result);"
            else if functionSchema.chain
              hunk.push "return this;"
            else
              hunk.push "return result;"

        # End of function call
        hunk.push "};"
        code.push hunk.join("\n")

      code.push "module.exports = #{className};"
      try
        # Parse code to ensure generated javascript is valid
        code = "#{dependencies.join("\n")}\n#{code.join("\n")}"

        # Pretty format code
        file.code = escodegen.generate(esprima.parse(code))
        files.push file
      catch err
        codeLines = code.split("\n")
        throw new Error("Error generating class #{className}\n#{err.message}\n#{codeLines[err.lineNumber-1]}")

    if path?
      write = Promise.promisify(fs.writeFile, fs)
      Promise.map files, (file) ->
        write("#{path}/#{file.name}", file.code)
      .then ->
        Promise.resolve files
    else
      files

module.exports = Poseidon
