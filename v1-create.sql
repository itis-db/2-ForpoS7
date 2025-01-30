/**
 @ForpoS7
*/

CREATE TABLE users (
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    id SERIAL PRIMARY KEY,
    nickname VARCHAR(50)
);

CREATE TABLE guides (
    nickname VARCHAR(255) NOT NULL,
    description TEXT,
    id SERIAL PRIMARY KEY
);

CREATE TABLE regions (
    rus_name VARCHAR(50) NOT NULL,
    description_path TEXT,
    eng_name VARCHAR(50) NOT NULL,
    short_description VARCHAR(255),
    id SERIAL PRIMARY KEY
);

CREATE TABLE prefectures (
    name VARCHAR(50) NOT NULL,
    description TEXT,
    capital VARCHAR(50),
    region_id INTEGER REFERENCES regions(id),
    population INTEGER,
    area DOUBLE PRECISION,
    id SERIAL PRIMARY KEY
);

CREATE TABLE guide_channels (
    link VARCHAR(255) NOT NULL,
    logo VARCHAR(255),
    guide_id INTEGER REFERENCES guides(id),
    id SERIAL PRIMARY KEY
);
