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

