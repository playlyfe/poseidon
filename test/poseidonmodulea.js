Promise = require('poseidon').Promise;
PoseidonModuleB = require('./poseidonmoduleb');
function PoseidonModuleA(moduleA) {
    this.instance = moduleA;
    return;
}
PoseidonModuleA.prototype.callbackFunction = function () {
    var args = arguments;
    var deferred = Promise.pending();
    var callback = function () {
        if (arguments[0]) {
            deferred.reject(arguments[0]);
        } else {
            switch (arguments.length) {
            case 2:
                deferred.resolve(arguments[1]);
                break;
            case 3:
                deferred.resolve([
                    arguments[1],
                    arguments[2]
                ]);
                break;
            case 4:
                deferred.resolve([
                    arguments[1],
                    arguments[2],
                    arguments[3]
                ]);
                break;
            case 5:
                deferred.resolve([
                    arguments[1],
                    arguments[2],
                    arguments[3],
                    arguments[4]
                ]);
                break;
            case 6:
                deferred.resolve([
                    arguments[1],
                    arguments[2],
                    arguments[3],
                    arguments[4],
                    arguments[5]
                ]);
                break;
            default:
                deferred.resolve(arguments.slice(1));
                break;
            }
        }
    };
    switch (args.length) {
    case 0:
        this.instance.callbackFunction(callback);
        break;
    case 1:
        this.instance.callbackFunction(args[0], callback);
        break;
    case 2:
        this.instance.callbackFunction(args[0], args[1], callback);
        break;
    case 3:
        this.instance.callbackFunction(args[0], args[1], args[2], callback);
        break;
    case 4:
        this.instance.callbackFunction(args[0], args[1], args[2], args[3], callback);
        break;
    case 5:
        this.instance.callbackFunction(args[0], args[1], args[2], args[3], args[4], callback);
        break;
    default:
        this.instance.callbackFunction.apply(this.instance, Array.prototype.slice.call(null, args).concat(callback));
        break;
    }
    return deferred.promise;
};
PoseidonModuleA.prototype.callbackFunction2 = function () {
    var args = arguments;
    var deferred = Promise.pending();
    var callback = function () {
        if (arguments[0]) {
            deferred.reject(arguments[0]);
        } else {
            switch (arguments.length) {
            case 2:
                deferred.resolve(arguments[1]);
                break;
            case 3:
                deferred.resolve([
                    arguments[1],
                    arguments[2]
                ]);
                break;
            case 4:
                deferred.resolve([
                    arguments[1],
                    arguments[2],
                    arguments[3]
                ]);
                break;
            case 5:
                deferred.resolve([
                    arguments[1],
                    arguments[2],
                    arguments[3],
                    arguments[4]
                ]);
                break;
            case 6:
                deferred.resolve([
                    arguments[1],
                    arguments[2],
                    arguments[3],
                    arguments[4],
                    arguments[5]
                ]);
                break;
            default:
                deferred.resolve(arguments.slice(1));
                break;
            }
        }
    };
    switch (args.length) {
    case 0:
        this.instance.callbackFunction2(callback);
        break;
    case 1:
        this.instance.callbackFunction2(args[0], callback);
        break;
    case 2:
        this.instance.callbackFunction2(args[0], args[1], callback);
        break;
    case 3:
        this.instance.callbackFunction2(args[0], args[1], args[2], callback);
        break;
    case 4:
        this.instance.callbackFunction2(args[0], args[1], args[2], args[3], callback);
        break;
    case 5:
        this.instance.callbackFunction2(args[0], args[1], args[2], args[3], args[4], callback);
        break;
    default:
        this.instance.callbackFunction2.apply(this.instance, Array.prototype.slice.call(null, args).concat(callback));
        break;
    }
    return deferred.promise;
};
PoseidonModuleA.prototype.callbackFunction3 = function () {
    var args = arguments;
    var deferred = Promise.pending();
    var callback = function () {
        arguments[1] = new PoseidonModuleB(arguments[1]);
        if (arguments[0]) {
            deferred.reject(arguments[0]);
        } else {
            switch (arguments.length) {
            case 2:
                deferred.resolve(arguments[1]);
                break;
            case 3:
                deferred.resolve([
                    arguments[1],
                    arguments[2]
                ]);
                break;
            case 4:
                deferred.resolve([
                    arguments[1],
                    arguments[2],
                    arguments[3]
                ]);
                break;
            case 5:
                deferred.resolve([
                    arguments[1],
                    arguments[2],
                    arguments[3],
                    arguments[4]
                ]);
                break;
            case 6:
                deferred.resolve([
                    arguments[1],
                    arguments[2],
                    arguments[3],
                    arguments[4],
                    arguments[5]
                ]);
                break;
            default:
                deferred.resolve(arguments.slice(1));
                break;
            }
        }
    };
    switch (args.length) {
    case 0:
        this.instance.callbackFunction3(callback);
        break;
    case 1:
        this.instance.callbackFunction3(args[0], callback);
        break;
    case 2:
        this.instance.callbackFunction3(args[0], args[1], callback);
        break;
    case 3:
        this.instance.callbackFunction3(args[0], args[1], args[2], callback);
        break;
    case 4:
        this.instance.callbackFunction3(args[0], args[1], args[2], args[3], callback);
        break;
    case 5:
        this.instance.callbackFunction3(args[0], args[1], args[2], args[3], args[4], callback);
        break;
    default:
        this.instance.callbackFunction3.apply(this.instance, Array.prototype.slice.call(null, args).concat(callback));
        break;
    }
    return deferred.promise;
};
PoseidonModuleA.prototype.synchronousFunction = function () {
    var args = arguments;
    switch (args.length) {
    case 0:
        result = this.instance.synchronousFunction();
        break;
    case 1:
        result = this.instance.synchronousFunction(args[0]);
        break;
    case 2:
        result = this.instance.synchronousFunction(args[0], args[1]);
        break;
    case 3:
        result = this.instance.synchronousFunction(args[0], args[1], args[2]);
        break;
    case 4:
        result = this.instance.synchronousFunction(args[0], args[1], args[2], args[3]);
        break;
    case 5:
        result = this.instance.synchronousFunction(args[0], args[1], args[2], args[3], args[4]);
        break;
    default:
        result = this.instance.synchronousFunction.apply(this.instance, args);
        break;
    }
    return result;
};
PoseidonModuleA.prototype.chainableFunction = function () {
    var args = arguments;
    switch (args.length) {
    case 0:
        result = this.instance.chainableFunction();
        break;
    case 1:
        result = this.instance.chainableFunction(args[0]);
        break;
    case 2:
        result = this.instance.chainableFunction(args[0], args[1]);
        break;
    case 3:
        result = this.instance.chainableFunction(args[0], args[1], args[2]);
        break;
    case 4:
        result = this.instance.chainableFunction(args[0], args[1], args[2], args[3]);
        break;
    case 5:
        result = this.instance.chainableFunction(args[0], args[1], args[2], args[3], args[4]);
        break;
    default:
        result = this.instance.chainableFunction.apply(this.instance, args);
        break;
    }
    return this;
};
module.exports = PoseidonModuleA;