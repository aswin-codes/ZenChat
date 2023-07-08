CREATE DATABASE zenchat; --Creating database

CREATE TABLE "user" (  --Creating table for storing user info
    id SERIAL PRIMARY KEY,
    username VARCHAR(255),
    email VARCHAR(255) UNIQUE,
    password TEXT,
    profilePath TEXT
);

CREATE TABLE chats ( --Creating table for storing chats
  chat_id SERIAL PRIMARY KEY,
  sender_id INT NOT NULL,
  receiver_id INT NOT NULL,
  message TEXT NOT NULL,
  timestamp TIMESTAMPTZ DEFAULT NOW(),
  FOREIGN KEY (sender_id) REFERENCES "user" (id),
  FOREIGN KEY (receiver_id) REFERENCES "user" (id)
);

--Retriving data for homescreen
SELECT u.id, u.username, u.email, u.profilepath, c.message, c.timestamp FROM "user" u JOIN ( SELECT MAX(timestamp) AS max_timestamp, CASE WHEN sender_id = 42 THEN receiver_id WHEN receiver_id = 42 THEN sender_id END AS chat_partner_id FROM chats  WHERE sender_id = 42 OR receiver_id = 42 GROUP BY CASE WHEN sender_id = 42 THEN receiver_id WHEN receiver_id = 42 THEN sender_id END) c_max ON u.id = c_max.chat_partner_id JOIN chats c ON c_max.chat_partner_id = CASE WHEN c.sender_id = 42 THEN c.receiver_id WHEN c.receiver_id = 42 THEN c.sender_id END AND c_max.max_timestamp = c.timestamp ORDER BY c.timestamp DESC;

--Retriving chats between two user
SELECT sender_id, receiver_id, message, timestamp from chats 
WHERE (sender_id=42 AND receiver_id = 50) OR (sender_id= 50 AND receiver_id = 42) 
ORDER BY timestamp ASC;

