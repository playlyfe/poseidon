Poseidon
========
Poseidon is a tiny module which can generate a promise layer over an existing callback API for easier programming.

The performance of the generated api is on par with simple callbacks.

```
Simple Callbacks x 762 ops/seca ±1.51% (85 runs sampled)
Poseidon x 757 ops/sec ±1.39% (87 runs sampled)
Fastest is Simple Callbacks,Poseidon
```

How to generate an API
-------------------------------

Poseidon uses a simple configuration file to generate an api. 
It creates a proxy class that holds a reference to the original object on `this.instance`.
The proxy class also has all the methods of the original object in its prototype.
Each of the proxy functions wrap the original function using Bluebird promises.
Once the api is generated you can output the generated javascript to a file. 

Sample configuration file from `poseidon-mongo`:
```
"Collection": {
    // Files to require and their location. The paths provided should be relative to the folder that the generated files are written to.
    // Bluebird promises are required by default in every generated file. It can be accessed through 'Promise'.
    "require": {
      "Mongo": "mongodb",
      "Cursor": "./cursor"
    },
    // You can write a custom constructor to wrap the original object that is passed to it. The original object should be stored on 'this.instance' always
    "constructor": {
      "params": ["collection"],
      "body": """
      if (!(collection instanceof Mongo.Collection)) {
        throw new Error('Object must be an instance of Mongo Collection');
      }
      this.instance = collection;
      return;
      """
    },
    // The instance is a simple object
    "type": "object",
    "functions": {
      "insert": {},
      "remove": {},
      "save": {},
      "update": {},
      "distinct": {},
      "count": {},
      "drop": {},
      "find": {
        // Don't wrap the find with a promise returning function
        "wrap": false,
        // Convert the return value to a Cursor class
        "return": ["Cursor"]
      },
      "findAndModify": {},
      "findAndRemove": {},
      "findOne": {},
      "createIndex": {},
      "ensureIndex": {},
      "indexInformation": {},
      "dropIndex": {},
      "dropAllIndexes": {},
      "reIndex": {},
      "mapReduce": {},
      "group": {},
      "options": {},
      "isCapped": {},
      "indexExists": {},
      "geoNear": {},
      "geoHaystackSearch": {},
      "indexes": {},
      "aggregate": {},
      "stats": {},
      "rename": {
        "return": ["Collection"]
      }
    }
  },
  "Cursor": {
    "require": {
      "Mongo": "mongodb"
    },
    "constructor": {
      "params": ["cursor"],
      "body": """
      if (cursor.constructor.name !== 'Cursor') {
        throw Error('Object must be an instance of Mongo Cursor');
      }
      this.instance = cursor;
      return;
      """
    },
    "type": "object",
    "functions": {
      "toArray": {},
      "each": {},
      "count": {},
      "nextObject": {},
      "explain": {},
      "close": {},
      "stream": {
        "wrap": false
      },
      "isClosed": {
        "wrap": false
      },
      "rewind": {
        "wrap": false,
        // The function will return a reference to the wrapping class allowing you to chain methods. Note: Chained methods should have wrap set to 'false'
        "chain": true
      },
      "sort": {
        "wrap": false,
        "chain": true
      },
      "setReadPreference": {
        "wrap": false,
        "chain": true
      },
      "skip": {
        "wrap": false,
        "chain": true
      },
      "limit": {
        "wrap": false,
        "chain": true
      },
      "batchSize": {
        "wrap": false,
        "chain": true
      }
    }
  },
  "Database": {
    "require": {
      "Driver": "./driver",
      "Collection": "./collection",
      "Cursor": "./cursor"
    },
    "constructor": {
      "params": ["connectionName"],
      "body": """
      this.connectionName = connectionName;
      this.instance = Driver.openConnection(connectionName);
      return;
      """
    },
    // The instance is a promised object
    "type": "promise",
    "functions": {
      "db": {},
      "collectionNames": {},
      "eval": {},
      "dereference": {},
      "logout": {},
      "authenticate": {},
      "addUser": {},
      "removeUser": {},
      "command": {},
      "dropCollection": {},
      "lastError": {},
      "previousErrors": {},
      "resetErrorHistory": {},
      "createIndex": {},
      "ensureIndex": {},
      "cursorInfo": {},
      "dropIndex": {},
      "reIndex": {},
      "indexInformation": {},
      "dropDatabase": {},
      "stats": {},
      "close": {},
      "collection": {
        "return": ["Collection"]
      },
      "collections": {
        "return": ["Collection"]
      },
      "createCollection": {
        "return": ["Collection"]
      },
      "renameCollection": {
        "return": ["Collection"]
      },
      "collectionsInfo": {
        "return": ["Cursor"]
      },
    }
  }
}
```



Modules using Poseidon
----------------------

* [`poseidon-mongo`](https://github.com/playlyfe/poseidon-mongo)
* [`poseidon-memcached`](https://github.com/playlyfe/poseidon-memcached)
* [`poseidon-couchbase`](https://github.com/playlyfe/poseidon-couchbase)
* [`poseidon-cassandra`](https://github.com/playlyfe/poseidon-cassandra)

If you want to get your module listed here, just let me know at
`johny@playlyfe.com`.

License
-------
[The MIT License](http://opensource.org/licenses/MIT)

Copyright(c) 2013-2014, Playlyfe Technologies, developers@playlyfe.com, http://dev.playlyfe.com/
