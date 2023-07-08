const express = require('express');
const { v4: uuidv4 } = require('uuid');
const server = express();
const path = require('path');
const fs = require('fs')
const cors = require('cors');
const pool = require('./db');
const bcrypt = require('bcrypt');
const otpGenerator = require('otp-generator');
const sendOTP = require('./controllers/sendMail');
const bodyParser = require('body-parser')
const multer = require('multer');
const socketIO = require('socket.io')





//Middleware
server.use(cors());
server.use(express.json());
server.use(express.static(path.join(__dirname, "profileStorage")))
server.use(bodyParser.json({ limit: ' 10mb' }))

let otp = '';



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

const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, 'profileStorage/');
    },
    filename: function (req, file, cb) {
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        const filename = uniqueSuffix + '.png'; // Save the file as PNG format
        cb(null, filename);
    }
})

const upload = multer({ storage });

server.post('/api/signin', upload.single('image'), async (req, res) => {
    try {
        if (!req.file) {
            return res.status(400).json({
                success: false,
                msg: 'No file uploaded'
            });
        }

        const { email, userName, password } = req.body;


        const hashedPassword = await hashPassword(password);
        // Store the filename and file path in the database
        const filename = req.file.filename;

        if (true) {
            const addUser = await pool.query("INSERT INTO \"user\" (username,email,password,profilePath) VALUES ($1,$2,$3,$4) RETURNING *", [userName, email, hashedPassword, filename]);
            console.log(addUser.rows[0]);
            const { password, ...data } = addUser.rows[0]
            res.status(200).json({
                success: true,
                msg: "Account created Successfully",
                data: data
            });
        }


    } catch (error) {
        console.log(error);
        res.status(500).json({
            success: false,
            msg: "There is a server error. Error Code (E002)"
        })
    }
})

server.post('/api/login', async (req, res) => {
    const { email, password } = req.body;

    try {
        const code = await isValid(email, password);
        if (code == 1) {
            const creds = await pool.query('SELECT  * FROM \"user\" WHERE email = $1', [email])
            const { password, ...data } = creds.rows[0]
            res.json({
                success: true,
                msg: "Logged In Successfully",
                data: data
            })
        }
        else if (code == 2) {
            res.status(401).json({
                success: false,
                msg: "Incorrect Password"
            })
        }
        else if (code == 3) {
            res.status(502).json({

                success: false,
                msg: "Sorry, there is server error. Error Code E001"
            })
        }
        else if (code == 4) {
            res.status(404).json({
                success: false,
                msg: "Account is not yet created from this email"
            })
        }

        else if (code == 5) {
            res.json({
                success: false,
                msg: "Sorry, there is a server error. Error Code : E002"
            })
        }

    } catch (error) {
        console.log(error);
        res.json({
            success: false,
            msg: "Sorry, there is a server error. Error Code : E002"
        })
    }
})

//Request to check whether an email is already there are not 
server.get('/api/email/:email', async (req, res) => {
    try {
        const { email } = req.params;
        const noOfEmail = await pool.query('SELECT COUNT(*) FROM "user" WHERE email = $1', [email]);
        if (noOfEmail.rows[0].count == '1') {
            res.status(200).json({
                success: true,
                isEmailRegistered: true,
                msg: "Given email is registered"
            })
        }
        else {
            res.status(200).json({
                success: true,
                isEmailRegistered: false,
                msg: "Given email is not yet registered"
            })
        }

    } catch (error) {
        res.status(500).json({
            success: false,
            msg: "Sorry, there is a server error. Error Code : E003"
        })
    }
})

//Request for OTP generation
server.get('/api/generate-otp/:email', async (req, res) => {
    try {

        const { email } = req.params;
        otp = otpGenerator.generate(4, { digits: true, lowerCaseAlphabets: false, upperCaseAlphabets: false, specialChars: false });
        console.log("Generated OTP : ", otp);
        await sendOTP(otp, email);
        res.status(200).json({
            success: true,
            msg: "OTP Sent Successfully"
        })
    } catch (error) {
        console.log(error);
        res.status(500).json({
            success: false,
            msg: "Sorry, there is a server error. Error Code : E004"
        })
    }
})

server.post('/api/verify-otp', async (req, res) => {
    try {
        const { givenOtp } = req.body;
        if (givenOtp == otp) {
            //OTP is correct
            res.status(200).json({
                success: true,
                isOTPCorrect: true,
                msg: "OTP entered correctly"
            })
        }
        else {
            //OTP is incorrect
            res.status(401).json({
                success: true,
                isOTPCorrect: false,
                msg: "Wrong OTP entered. Kindly check the email and enter again"
            });
        }

    } catch (error) {
        console.log(error);
        res.status(500).json({
            success: false,
            msg: "Sorry, there is a server error. Error Code : E005"
        })
    }
})

server.post('/api/reset-password', async (req, res) => {
    try {
        const { email, password } = req.body;
        const hashedPassword = await hashPassword(password);
        const updatePassword = await pool.query('UPDATE "user" SET password = $1 WHERE email = $2', [hashedPassword, email]);
        res.status(200).json({
            success: true,
            msg: "Password updated successfully"
        })

    } catch (error) {
        res.status(500).json({
            success: false,
            msg: "Sorry, there is a server error. Error Code : E006"
        })
    }
})

server.get('/api/users/:id/search', async (req, res) => {
    try {
        const { id } = req.params;
        const { query } = req.query;

        const result = await pool.query(
            'SELECT username, email, profilepath,id FROM "user" WHERE id <> $2 AND (username ILIKE $1 OR email ILIKE $1)  LIMIT 10', [`%${query}%`, id]
        )

        const users = result.rows;



        res.status(200).json({
            success: true,
            msg: "Users fetched successfully",
            data: users
        })

    } catch (error) {
        console.log(error);
        res.status(500).json({
            success: false,
            msg: "Sorry, there is a server error. Error Code : E007"
        });
    }
})

server.get('/api/users/random/:id', async (req, res) => {
    try {

        const { id } = req.params;
        const result = await pool.query(
            'SELECT username, email, profilepath,id FROM "user" WHERE id <> $1 ORDER BY RANDOM() LIMIT 10 ', [id]
        )

        const users = result.rows;
        console.log(users);

        res.status(200).json({
            success: true,
            msg: "Users fetched successfully",
            data: users
        })

    } catch (error) {
        console.log(error);
        res.status(500).json({
            success: false,
            msg: "Sorry, there is a server error. Error Code : E007"
        });
    }
})
const store = multer({ storage });

server.patch('/api/users/:id', store.single('image'), async (req, res) => {
    try {
        const { id } = req.params;
        const { email, userName } = req.body;
        const filename = req.file.filename;
        const storedFileName = await pool.query('SELECT profilepath FROM "user" WHERE id = $1', [id]);
        const filePath = path.join(__dirname, `profileStorage/${storedFileName.rows[0].profilepath}`);
        fs.unlink(filePath, (err) => {
            if (err) {
                console.log("Error deleting file : ", err);
            } else {
                console.log(`File ${storedFileName} deleted successfully`);
            }
        });

        const updateUser = await pool.query('UPDATE "user" SET username = $1, email =$2, profilepath =$3 WHERE id=$4 RETURNING id,email,username,profilepath', [userName, email, filename, id]);



        console.log(storedFileName.rows[0].profilepath);
        console.log(id, email, userName);
        res.json({
            success: true,
            msg: "Details updated successfully.",
            data: updateUser.rows[0]
        })

    } catch (error) {
        console.log(error);
        res.status(500).json({
            success: false,
            msg: "Sorry, there is a server error. Error Code : E008"
        });
    }
});

server.post('/api/verify', async (req, res) => {
    try {
        const { email, password } = req.body;
        const code = await isValid(email, password);
        if (code == 1) {
            res.status(200).json({
                success: true,
                isValid: true,
                msg: "Password is entered correct"
            })
        } else {
            res.status(401).json({
                success: true,
                isValid: false,
                msg: "Password is incorrect. Try again or click forgot password"
            })
        }
    } catch (error) {
        console.log(error)
        res.status(500).json({
            success: false,
            msg: "Sorry, there is a server error. Error Code : E009"
        });
    }
})

server.get('/api/chats/user1/:id1/user2/:id2', async (req, res) => {
    try {
        const { id1, id2 } = req.params;
        const chats = await pool.query("SELECT sender_id, receiver_id, message, timestamp from chats WHERE (sender_id=$1 AND receiver_id = $2) OR (sender_id=$2 AND receiver_id = $1) ORDER BY timestamp ASC;", [id1, id2])
        console.log(chats.rows);
        res.json({
            success: true,
            msg: 'Fetched chats successfully',
            chats: chats.rows
        })

    } catch (error) {
        console.log(error);
        res.status(500).json({
            success: false,
            msg: "Sorry, there is a server error. Error Code : E010"
        });
    }
})

server.get('/api/chatlist/:id', async (req,res) =>{
    try {
        const {id} = req.params;
        const chatList = await pool.query('SELECT u.id, u.username, u.email,  u.profilepath, c.message, c.timestamp FROM "user" u JOIN ( SELECT MAX(timestamp) AS max_timestamp, CASE WHEN sender_id = $1 THEN receiver_id WHEN receiver_id = $1 THEN sender_id END AS chat_partner_id FROM chats  WHERE sender_id = $1 OR receiver_id = $1 GROUP BY CASE WHEN sender_id = $1 THEN receiver_id WHEN receiver_id = $1 THEN sender_id END) c_max ON u.id = c_max.chat_partner_id JOIN chats c ON c_max.chat_partner_id = CASE WHEN c.sender_id = $1 THEN c.receiver_id WHEN c.receiver_id = $1 THEN c.sender_id END AND c_max.max_timestamp = c.timestamp ORDER BY c.timestamp DESC',[id]);
        res.json({
            success : true,
            msg : "Fetched chat list successfully",
            chatlist : chatList.rows
        })
        
    } catch (error) {
        console.log(error);
        res.status(500).json({
            success: false,
            msg: "Sorry, there is a server error. Error Code : E011"
        });
    }
})

server.listen(5000, () => {
    console.log("server listening at port 5000");
})



