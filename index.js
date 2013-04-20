coffee = require('coffee-script');
module.exports = process.env.PLAYLYFE_TEST ? require('./src-cov/poseidon') : require('./src/poseidon');
