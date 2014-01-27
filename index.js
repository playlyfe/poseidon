coffee = require('coffee-script');
var index = null;
if (process.env.PLAYLYFE_TEST) {
  try {
    index = require('./src-cov/poseidon');
  } catch(e) {
    index = require('./lib/poseidon');
  }
} else {
  index = require('./lib/poseidon');
}
module.exports = index;
