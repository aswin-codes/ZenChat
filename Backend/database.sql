CREATE DATABASE zenchat; --Creating database

CREATE TABLE "user" (  --Creating table for storing user info
    id SERIAL PRIMARY KEY,
    username VARCHAR(255),
    email VARCHAR(255) UNIQUE,
    password TEXT,
    profilePath TEXT
);

