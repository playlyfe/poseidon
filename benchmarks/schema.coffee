module.exports = {
  "PoseidonModuleA": {
    "require": {
      "PoseidonModuleB": "./poseidonmoduleb"
    },
    "constructor": {
      "params": ["moduleA"],
      "body": """
      this.instance = moduleA;
      return;
      """
    }
    "type": "object"
    "functions": {
      "callbackFunction": {}
      "callbackFunction2": {}
      "callbackFunction3": {
        "return": ["PoseidonModuleB"]
      }
      "synchronousFunction": {
        "wrap": false
      }
      "chainableFunction": {
        "wrap": false
        "chain": true
      }
    }
  }
  "PoseidonModuleB": {
    "require": {
    }
    "constructor": {
      "params": ["moduleB"],
      "body": """
      this.instance = Promise.resolve(moduleB);
      return;
      """
    }
    "type": "promise"
    "functions": {
      "callbackFunction": {}
      "callbackFunction2": {}
      "chainableFunction": {
        "wrap": false
        "chain": true
      }
    }
  }
}
