var Promise = require('bluebird');
function PoseidonModuleB(moduleB) {
    this.instance = Promise.resolve(moduleB);
    return;
}
PoseidonModuleB.prototype.callbackFunction = function () {
    var args = arguments;
    var deferred = Promise.defer();
    this.instance.then(function (instanceValue) {
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
            instanceValue.callbackFunction(callback);
            break;
        case 1:
            instanceValue.callbackFunction(args[0], callback);
            break;
        case 2:
            instanceValue.callbackFunction(args[0], args[1], callback);
            break;
        case 3:
            instanceValue.callbackFunction(args[0], args[1], args[2], callback);
            break;
        case 4:
            instanceValue.callbackFunction(args[0], args[1], args[2], args[3], callback);
            break;
        case 5:
            instanceValue.callbackFunction(args[0], args[1], args[2], args[3], args[4], callback);
            break;
        default:
            instanceValue.callbackFunction.apply(instanceValue, Array.prototype.slice.call(null, args).concat(callback));
            break;
        }
    });
    return deferred.promise;
};
PoseidonModuleB.prototype.callbackFunction2 = function () {
    var args = arguments;
    var deferred = Promise.defer();
    this.instance.then(function (instanceValue) {
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
            instanceValue.callbackFunction2(callback);
            break;
        case 1:
            instanceValue.callbackFunction2(args[0], callback);
            break;
        case 2:
            instanceValue.callbackFunction2(args[0], args[1], callback);
            break;
        case 3:
            instanceValue.callbackFunction2(args[0], args[1], args[2], callback);
            break;
        case 4:
            instanceValue.callbackFunction2(args[0], args[1], args[2], args[3], callback);
            break;
        case 5:
            instanceValue.callbackFunction2(args[0], args[1], args[2], args[3], args[4], callback);
            break;
        default:
            instanceValue.callbackFunction2.apply(instanceValue, Array.prototype.slice.call(null, args).concat(callback));
            break;
        }
    });
    return deferred.promise;
};
PoseidonModuleB.prototype.chainableFunction = function () {
    var args = arguments;
    this.instance.then(function (instanceValue) {
        switch (args.length) {
        case 0:
            result = instanceValue.chainableFunction();
            break;
        case 1:
            result = instanceValue.chainableFunction(args[0]);
            break;
        case 2:
            result = instanceValue.chainableFunction(args[0], args[1]);
            break;
        case 3:
            result = instanceValue.chainableFunction(args[0], args[1], args[2]);
            break;
        case 4:
            result = instanceValue.chainableFunction(args[0], args[1], args[2], args[3]);
            break;
        case 5:
            result = instanceValue.chainableFunction(args[0], args[1], args[2], args[3], args[4]);
            break;
        default:
            result = instanceValue.chainableFunction.apply(instanceValue, args);
            break;
        }
    });
    return this;
};
module.exports = PoseidonModuleB;
