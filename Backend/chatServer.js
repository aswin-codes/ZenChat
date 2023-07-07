const io = require('socket.io')(3000)

io.on('connection', (socket) => {
    console.log('New connection made');
    
    socket.on('disconnect', () => {
      console.log('Client disconnected');
    });
  
    socket.emit('chat-message', 'Hello World');
  });