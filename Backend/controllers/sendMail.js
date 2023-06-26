const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "testasnode@gmail.com",
    pass: "ncbbgnwyljozujpj"
  }
});

async function sendOTP(otp,email) {
  const mailOptions = {
    from: "testasnode@gmail.com",
    to: email,
    subject: "OTP from Zenchat",
    text: `Here is your OTP for password change : ${otp}`
  }
  transporter.sendMail(mailOptions, function (error, info) {
    if (error) {
      console.log(error)
    }
    else {
      console.log("Email sent " + info.response);
    }
  })
}

module.exports = sendOTP;