/**
  @ForpoS7
*/
 
-- v1
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

-- v2
alter table users add column dtime timestamp default current_timestamp;
alter table users add constraint unique_model unique (nickname);
alter table users add column age integer default 0;
alter table users alter column age type numeric(10,2) using age::numeric(10,2);
alter table users alter column email type int using email::int;
select case
           when nickname = 'user1' then 1
           when nickname = 'user2' then 2 end, nickname
from users;

--rollback
alter table users drop column dtime;
alter table users drop constraint unique_model;
alter table users drop column age;
alter table users alter column age type integer using age::integer;
alter table users alter column email type varchar(255) using email::varchar(255);
select case
           when nickname = 1 then 'user1'
           when nickname = 2 then 'user2' end, nickname
from users;
