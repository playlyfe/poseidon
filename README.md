Poseidon
========
Poseidon is a tiny module which provides functions for wrapping the APIs of
existing node modules using the **Q** library to write smaller, cleaner and
simpler code free from callbacks.

Methods
-------

###wrap(source, function)
The `wrap` function is the simplest wrapping function. It returns a function
which executes the original function on the **source object** and returns a
promise instead of requiring the user to provide a callback.

###wrapReturn(source, function, constructors...)
The `wrapReturn` function accepts a list of constructors which will be applied
to the values returned by the wrapped function. This is useful especially when
the function returns objects which have APIs that we also want to wrap using
Poseidon.

###wrapPromise(promise, function)
The `wrapPromise` function can wrap a function on a **source object** which will
be the result of a promise. It assumes the promise will resolve to just a
 single value.

###wrapPromiseReturn(promise, function, constructors...)
The `wrapPromiseReturn` is the equivalent of the `wrapReturn` when the **source
object** is represented by a promise.


License
-------
[The MIT License](http://opensource.org/licenses/MIT)

Copyright(c) 2013-2014, Playlyfe Technologies, developers@playlyfe.com, http://dev.playlyfe.com/
