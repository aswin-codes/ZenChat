const Pool = require('pg').Pool;

const pool = new Pool({
    user: "postgres",
    password: "aswin",
    host: "localhost",
    port: 5432,
    database: "zenchat"
});

module.exports = pool;