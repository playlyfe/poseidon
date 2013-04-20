coffee = require('coffee-script');
var index = null;
if (process.env.PLAYLYFE_TEST) {
  try {
    index = require('./src-cov/poseidon');
  } catch(e) {
    index = require('./src/poseidon');
  }
} else {
  index = require('./src/poseidon');
}
module.exports = index;
