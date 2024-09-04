DROP DATABASE IF EXISTS instagram;

create database instagram;

use instagram;

-- Tables
create table users(
    id int auto_increment primary key,
    username varchar(255) unique not null,
    createdAt timestamp default NOW()
);

create table photos(
    id int auto_increment primary key,
    imageUrl varchar(255) not null,
    userId int not null,
    foreign key(userId) references users(id),
    createdAt timestamp default now()
);

create table comments(
    id int auto_increment primary key,
    title varchar(255) not null,
    userId int not null,
    foreign key(userId) references users(id),
    photoId int not null,
    foreign key(photoId) references photos(id),
    createdAt timestamp default now()
);

create table likes(
    userId int not null,
    foreign key(userId) references users(id),
    photoId int not null,
    foreign key(photoId) references photos(id),
    primary key(userId, photoId),
    createdAt timestamp default now()
);

create table follows(
    followerId int not null,
    foreign key(followerId) references users(id),
    followeeId int not null,
    foreign key(followeeId) references users(id),
    primary key(followerId, followeeId),
    createdAt timestamp default now()
);

-- one way to implement tags is as follows
create table tags(
    tagName varchar(20) not null,
    photoId int not null,
    foreign key(photoId) references photos(id)
);

-- but same photos can have different tags (that's redundant), we optimize this using normalization as follows
create table tags(
    id int auto_increment primary key,
    tagName varchar(20) unique,
    createdAt timestamp default now()
);

create table photo_tags(
    photoId int not null,
    foreign key(photoId) references photos(id),
    tagId int not null,
    foreign key(tagId) references tags(id),
    primary key(photoId, tagId)
);