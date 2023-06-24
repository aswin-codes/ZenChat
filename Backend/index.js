const express = require('express');
const { v4: uuidv4 } = require('uuid');
const server = express();
const path = require('path');
const fs = require('fs')
const cors = require('cors');
const pool = require('./db');
const bcrypt = require('bcrypt');

//Middleware
//server.use(cors());
server.use(express.json());
server.use(express.static(path.join(__dirname, "profileStorage")))

function saveImageFromBase64(base64String) {
    const directoryPath = path.join(__dirname, "profileStorage")
    const base64Data = base64String.replace(/^data:image\/[^;]+;base64,/, '');
    const imageData = Buffer.from(base64Data, 'base64');
    const filename = `${uuidv4()}.png`;
    const filePath = path.join(directoryPath, filename)//`${directoryPath}/${filename}`;  
    // Save the image to the specified file path
    fs.writeFileSync(filePath, imageData);

    // Return the file path
    return filename;
}

//Return hashed password if its successful else return null if there is an error
async function hashPassword(plainPassword) {
    try {
        const hash = await bcrypt.hash(plainPassword, 10);
        console.log('Hashed password:', hash);
        return hash;
    } catch (err) {
        console.error(err);
        return null
    }
}

//Return true if the password is correct, false if its incorrect and null if there is an error
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

async function isValid(email, password) {
    try {
        const creds = await pool.query("SELECT email, password FROM \"user\" WHERE email = $1", [email]);
        const userCredentials = creds.rows[0];

        if (userCredentials) {
            const hashedPassword = userCredentials.password;
            const isValid = await comparePwd(password, hashedPassword);
           
            if (isValid) {
                return 1
            } else if (isValid == false) {
                return 2
            }
            else {
                return 3
            }
        } 
        else {
            console.log('User not found');
            return 4 // Return null if the user is not found
        }
    } catch (error) {
        console.log(error);
        return 5; // Return null if an error occurs during the query
    }
}
server.get('/api/test', async (req,res) => {
    res.send("HI");
})

server.post(
    '/api/signin',
    async (req, res) => {
        try {
            const { userName, email, password, img } = req.body;
            console.log(req.body)
            const hashedPassword = await hashPassword(password);
            if (img == null) {
                const addUser = await pool.query("INSERT INTO \"user\" (username,email,password,profilePath) VALUES ($1,$2,$3,$4) RETURNING *", [userName, email, hashedPassword, null]);
                console.log(addUser.rows[0]);
                const {password,...data} = addUser.rows[0]
                res.status(200).json({
                    success: true,
                    msg: "Account created Successfully",
                    data: data
                });
            }
            else {
                var imageName = saveImageFromBase64(img);
                const addUser = await pool.query("INSERT INTO \"user\" (username,email,password,profilePath) VALUES ($1,$2,$3,$4) RETURNING *", [userName, email, hashedPassword, imageName]);
                console.log(addUser.rows[0]);
                const {password,...data} = addUser.rows[0]
                res.status(200).json({
                    success: true,
                    msg: "Account created Successfully",
                    data: data
                });

            }
            //const addUser= await pool.query('INSERT INTO')

        } catch (error) {
            console.log(error);
            if (error.code == 23505)
                res.status(502).json({
                    success: false,
                    msg: "Account is already created with same email"
                });
            else{
                res.status(502).json({
                    success : false,
                    msg : "There is a server error. Error Code (E002)"
                })
            }
        }
    }
)

server.post('/api/login', async (req,res) => {
    const {email,password} = req.body;
    
    try {
        const code = await isValid(email, password);
        if (code == 1) {
            const creds = await pool.query('SELECT  * FROM \"user\" WHERE email = $1',[email])
            const { password, ...data} = creds.rows[0]
            res.json({
                success : true,
                msg: "Logged In Successfully",
                data: data
            })
        }
        else if (code == 2){
            res.status(401).json({
                success : false,
                msg : "Incorrect Password"
            })
        }
        else if (code == 3) {
            res.status(502).json({
                success : false,
                msg : "Sorry, there is server error. Error Code (E0001)"
            })
        }
        else if (code == 4) {
            res.status(404).json({
                success : false,
                msg : "Account is not yet created from this email"
            })
        }

        else if (code == 5) {
            res.json({
                success : false,
                msg : "Sorry, there is a server error. Error Code : E002"
            })
        }
        
    } catch (error) {
        console.log(error);
        res.json({
            success : false,
            msg : "Sorry, there is a server error. Error Code : E002"
        })
    }
})

server.listen(5000, () => {
    console.log("server listening at port 5000");
})
