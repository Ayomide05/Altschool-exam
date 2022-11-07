#!/bin/bash
create role Justina with login;

create database hello_postgres with owner Justina;

\c hello_postgres Justina;

create table hello(
    tag_name varchar(32),
    tag_value text
);


insert into hello (tag_name, tag_value) values('Hey', 'Gabriel-Justina');