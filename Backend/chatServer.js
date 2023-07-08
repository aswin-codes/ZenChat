const pool = require('./db');
const io = require('socket.io')(3000)

const Clients = new Map()

io.on('connection', (socket) => {
    console.log('New connection made');

    socket.on('new-user',(data) => {
      Clients.set(socket.id, JSON.parse(data).id)
      console.log(Clients);
    })

    socket.on('chat-message',async (data) => {
      const {receiver_id, sender_id, message} = JSON.parse(data);
      try {
        const addChat = await pool.query('INSERT INTO chats (sender_id, receiver_id, message) VALUES ($1,$2,$3)',[sender_id, receiver_id,message]);
        Clients.forEach((value, key)=>{
          if (value == receiver_id){
            socket.to(key).emit('new-message',message);
          }
        })
      } catch (error) {
        console.log(error);
      }
      
    })
        
    socket.on('disconnect', () => {
      Clients.forEach((value, key) =>{
        if (key === socket.id){
          Clients.delete(key)
          console.log(`User with ${key} disconnected`)
        }
      })
      console.log('Client disconnected');
    });
  
    socket.emit('chat-message', 'Hello World');
  });