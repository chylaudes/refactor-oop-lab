DROP DATABASE IF EXISTS weekendlab;
CREATE DATABASE weekendlab;

\connect weekendlab

CREATE TABLE IF NOT EXISTS squads (
  id serial PRIMARY KEY,
  name varchar(50),
  mascot varchar(50)
);

CREATE TABLE IF NOT EXISTS students (
  id serial PRIMARY KEY,
  squad_id integer REFERENCES squads (id) ON DELETE NO ACTION,
  name varchar(50),
  age integer,
  spirit_animal varchar(50) 
);
