const pool = require('./db');
const bcrypt = require('bcrypt')

async function comparePwd(providedPassword, storedHashedPassword) {
    try {
        const isMatch = await bcrypt.compare(providedPassword, storedHashedPassword);
        if (isMatch) {
            return true
        } else {
            return false
        }
    } catch (err) {
        console.error(err);
        return null;
    }

}


//Return 1 if its valid, return 2 if its in valid, return 3 if encryption error, if 4 user not found, if 5 server error
async function isValid(email, password) {
    try {
        const creds = await pool.query("SELECT email, password FROM \"user\" WHERE email = $1", [email]);
        const userCredentials = creds.rows[0];

        if (userCredentials) {
            const hashedPassword = userCredentials.password;
            const isValid = await comparePwd(password, hashedPassword);
            console.log(isValid);
            if (isValid) {
                return 1
            } else if (isValid == false) {
                return 2
            }
            else {
                return 3
            }
        } else {
            console.log('User not found');
            return 4 // Return null if the user is not found
        }
    } catch (error) {
        console.log(error);
        return 5; // Return null if an error occurs during the query
    }
}

isValid('aswinraaj@xmail.com', 'password123');
