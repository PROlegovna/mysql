-- ЛитРес
-- курсовая работа 
-- site menu

DROP DATABASE IF EXISTS LitRes;
CREATE DATABASE LitRes;
USE LitRes;

DROP TABLE IF EXISTS booknames;
CREATE TABLE booknames (
id SERIAL PRIMARY KEY, 
bookname VARCHAR(200) UNIQUE NOT NULL
);

DROP TABLE IF EXISTS countries;
CREATE TABLE countries (
id SERIAL PRIMARY KEY,
country VARCHAR(200) UNIQUE NOT NULL
);

DROP TABLE IF EXISTS genres;
CREATE TABLE genres (
id SERIAL PRIMARY KEY,
genre VARCHAR(200) UNIQUE NOT NULL
);

DROP TABLE IF EXISTS images;
CREATE TABLE images (
id SERIAL PRIMARY KEY,
filename VARCHAR(200) NOT NULL,
PATH VARCHAR(200) NOT NULL
);

DROP TABLE IF EXISTS languages;
CREATE TABLE languages (
id SERIAL PRIMARY KEY,
book_language VARCHAR(200) UNIQUE NOT NULL
);

DROP TABLE IF EXISTS authors;
CREATE TABLE authors (
id SERIAL PRIMARY KEY,
author VARCHAR(200) UNIQUE NOT NULL
);

DROP TABLE IF EXISTS book_types;
CREATE TABLE book_types (
id SERIAL PRIMARY KEY,
book_type VARCHAR(200) UNIQUE NOT NULL
);


-- site users

DROP TABLE IF EXISTS administration;
CREATE TABLE administration (
id SERIAL PRIMARY KEY,
admin_name VARCHAR(50) UNIQUE,
email VARCHAR(100) UNIQUE,
admin_password VARCHAR(100)
);

DROP TABLE IF EXISTS users;
CREATE TABLE users (
id SERIAL PRIMARY KEY,
created_at TIMESTAMP DEFAULT now(),
username VARCHAR(100) UNIQUE,
email VARCHAR(100) UNIQUE,
phone_number BIGINT UNSIGNED UNIQUE,
user_password VARCHAR(100)
);

DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
id SERIAL PRIMARY KEY,
user_id BIGINT UNSIGNED,
updated_at TIMESTAMP DEFAULT now(),
profile_photo BIGINT UNSIGNED DEFAULT 1,
name VARCHAR(100) DEFAULT ' ',
surname VARCHAR(100) DEFAULT ' ',
gender ENUM ('m', 'f', 'x') DEFAULT 'x',
date_of_birth DATE,
country_id BIGINT UNSIGNED,
extra VARCHAR(400) DEFAULT ' ', 

private BIT DEFAULT 0, 
sold_books BIGINT DEFAULT NULL,

INDEX full_user_name (name, surname),

FOREIGN KEY (user_id) REFERENCES profiles (id)
ON DELETE RESTRICT
ON UPDATE CASCADE,
FOREIGN KEY (profile_photo) REFERENCES images (id)
ON DELETE SET NULL ON UPDATE CASCADE,
FOREIGN KEY (country_id) REFERENCES countries (id)
ON DELETE SET NULL
ON UPDATE CASCADE
);

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
id SERIAL PRIMARY KEY,
from_user BIGINT UNSIGNED,
to_administration BIGINT UNSIGNED,
created_at TIMESTAMP DEFAULT now(),

body_text TEXT NOT NULL,

FOREIGN KEY (from_user) REFERENCES users (id)
ON DELETE SET NULL 
ON UPDATE CASCADE,
FOREIGN KEY (to_administration) REFERENCES administration (id)
ON DELETE SET NULL 
ON UPDATE CASCADE
);

-- books information

DROP TABLE IF EXISTS books;
CREATE TABLE books (
id SERIAL PRIMARY KEY,
book VARCHAR(100) NOT NULL,
original_name VARCHAR(100) DEFAULT ' ',
INDEX (book),
INDEX (original_name)
);

DROP TABLE IF EXISTS book_info;
CREATE TABLE book_info (
id SERIAL PRIMARY KEY,
book_id BIGINT UNSIGNED,
book_genre_id BIGINT UNSIGNED DEFAULT 1,
book_cover BIGINT UNSIGNED DEFAULT 2,
authors VARCHAR(200) DEFAULT ' ',
translators VARCHAR(400) DEFAULT ' ',
synopsis VARCHAR(800) DEFAULT ' ',
date_of_release DATE,
age_restrictions ('6+', '12+', '18+', 'NAR') DEFAULT 'NAR',

INDEX (date_of_release),

FOREIGN KEY (book_id) REFERENCES books (id)
ON DELETE RESTRICT
ON UPDATE CASCADE,
FOREIGN KEY (book_genre_id) REFERENCES book_genre (id)
ON DELETE SET NULL 
ON UPDATE CASCADE,
FOREIGN KEY (book_cover) REFERENCES images (id)
ON DELETE SET NULL 
ON UPDATE CASCADE
);

-- additional information 

DROP TABLE IF EXISTS book_country;
CREATE TABLE book_country (
id SERIAL PRIMARY KEY,
book_id BIGINT UNSIGNED,
country_id BIGINT UNSIGNED,

FOREIGN KEY (book_id) REFERENCES books (id)
ON DELETE RESTRICT
ON UPDATE CASCADE,
FOREIGN KEY (country_id) REFERENCES countries (id)
ON DELETE SET NULL 
ON UPDATE CASCADE
);

DROP TABLE IF EXISTS authors;
CREATE TABLE authors (
id SERIAL PRIMARY KEY,
name VARCHAR(150),
surname VARCHAR(150),
life_period DATE DEFAULT NULL,
photo BIGINT UNSIGNED,
country_id BIGINT UNSIGNED, 

INDEX author_name_id (name, surname),

FOREIGN KEY (photo) REFERENCES images (id)
ON DELETE SET NULL
ON UPDATE CASCADE,
FOREIGN KEY (country_id) REFERENCES countries (id)
ON DELETE SET NULL 
ON UPDATE CASCADE
);

DROP TABLE IF EXISTS translators;
CREATE TABLE translators (
id SERIAL PRIMARY KEY,
book_id BIGINT UNSIGNED,
book_language_id BIGINT UNSIGNED,
author_id BIGINT UNSIGNED,

FOREIGN KEY (book_id) REFERENCES books (id)
ON DELETE RESTRICT
ON UPDATE CASCADE,
FOREIGN KEY (book_language_id) REFERENCES book_language (id)
ON DELETE SET NULL
ON UPDATE CASCADE,
FOREIGN KEY (author_id) REFERENCES authors (id)
ON DELETE SET NULL 
ON UPDATE CASCADE
);


-- books info: reviews, likes, dislikes

DROP TABLE IF EXISTS reviews;
CREATE TABLE reviews (
id SERIAL PRIMARY KEY,
user_id BIGINT UNSIGNED,
review VARCHAR(300) UNIQUE,
created_at TIMESTAMP DEFAULT now(),

FOREIGN KEY (user_id) REFERENCES users (id)
ON DELETE RESTRICT 
ON UPDATE CASCADE
);

DROP TABLE IF EXISTS likes_on_genre;
CREATE TABLE likes_on_genre (
id SERIAL PRIMARY KEY,
book_id BIGINT UNSIGNED,
genre_id BIGINT UNSIGNED NOT NULL,
user_id BIGINT UNSIGNED,
likes BIT DEFAULT 1,
created_at TIMESTAMP DEFAULT now(),

sold_books BIGINT DEFAULT NULL,

FOREIGN KEY (book_id) REFERENCES books (id)
ON DELETE RESTRICT
ON UPDATE CASCADE,
FOREIGN KEY (genre_id) REFERENCES reviews (id)
ON DELETE RESTRICT
ON UPDATE CASCADE,
FOREIGN KEY (user_id) REFERENCES users (id)
ON DELETE RESTRICT
ON UPDATE CASCADE
);

DROP TABLE IF EXISTS rating;
CREATE TABLE rating (
id SERIAL PRIMARY KEY,
book_id BIGINT UNSIGNED,
user_id BIGINT UNSIGNED,
rating TINYINT UNSIGNED NOT NULL DEFAULT 0,
created_at TIMESTAMP DEFAULT now(),
updated_at TIMESTAMP DEFAULT now(),

sold_books BIGINT DEFAULT NULL,

INDEX (rating),

FOREIGN KEY (book_id) REFERENCES books (id)
ON DELETE RESTRICT
ON UPDATE CASCADE,
FOREIGN KEY (user_id) REFERENCES users (id)
ON DELETE RESTRICT
ON UPDATE CASCADE
);

DROP TABLE IF EXISTS reviews;
CREATE TABLE reviews (
id SERIAL PRIMARY KEY,
book_id BIGINT UNSIGNED,
user_id BIGINT UNSIGNED,
body VARCHAR(800),
positive BIT DEFAULT 1,
created_at TIMESTAMP DEFAULT now(),

sold_books BIGINT DEFAULT NULL,

INDEX (positive),

FOREIGN KEY (book_id) REFERENCES books (id)
ON DELETE RESTRICT
ON UPDATE CASCADE,
FOREIGN KEY (user_id) REFERENCES users (id)
ON DELETE RESTRICT
ON UPDATE CASCADE
);

DROP TABLE IF EXISTS likes_on_reviews;
CREATE TABLE likes_on_revies (
id SERIAL PRIMARY KEY,
review_id BIGINT UNSIGNED NOT NULL,
user_id BIGINT UNSIGNED,
les BIT,
created_at TIMESTAMP DEFAULT now(),

sold_books BIGINT DEFAULT NULL,

FOREIGN KEY (review_id) REFERENCES reviews (id)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (user_id) REFERENCES users (id)
ON DELETE RESTRICT
ON UPDATE CASCADE
);



-- users' additional information

DROP TABLE IF EXISTS watchlist;
CREATE TABLE watchlist (
id SERIAL PRIMARY KEY,
book_id BIGINT UNSIGNED,
user_id BIGINT UNSIGNED,
seen BIT DEFAULT 0,
created_at TIMESTAMP DEFAULT now(),
updated_at TIMESTAMP DEFAULT now(),

sold_books BIGINT DEFAULT NULL,

FOREIGN KEY (book_id) REFERENCES books (id)
ON DELETE RESTRICT
ON UPDATE CASCADE,
FOREIGN KEY (user_id) REFERENCES users (id)
ON DELETE RESTRICT
ON UPDATE CASCADE
);

DROP TABLE IF EXISTS user_lists;
CREATE TABLE user_lists (
id SERIAL PRIMARY KEY,
user_id BIGINT UNSIGNED,
list_name VARCHAR(50) DEFAULT ' ',
description VARCHAR(150) DEFAULT ' ',
private BIT DEFAULT 0,
created_at TIMESTAMP DEFAULT now(),

sold_books BIGINT DEFAULT NULL,

INDEX (list_name),
INDEX (private),

FOREIGN KEY (user_id) REFERENCES users (id)
ON DELETE RESTRICT
ON UPDATE CASCADE
);

DROP TABLE IF EXISTS user_list_books;
CREATE TABLE user_list_books (
id SERIAL PRIMARY KEY,
list_id BIGINT UNSIGNED NOT NULL,
book_id BIGINT UNSIGNED,
created_at TIMESTAMP DEFAULT now(),

FOREIGN KEY (list_id) REFERENCES user_lists (id)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (book_id) REFERENCES books (id)
ON DELETE RESTRICT
ON UPDATE CASCADE
);

-- deferred goods

DROP TABLE IF EXISTS deferred_books;
CREATE TABLE deferred_books;
id SERIAL PRIMARY KEY,
book_id BIGINT UNSIGNED NOT NULL,
reserved_id BIGINT UNSIGNED NOT NULL,
created_at TIMESTAMP DEFAULT now(),
updated_at TIMESTAMP DEFAULT now(),

FOREIGN KEY (book_id) REFERENCES books (id)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (reserved_id) REFERENCES users (id)
ON DELETE CASCADE
ON UPDATE CASCADE
);

DROP TABLE IF EXISTS deferred_genre;
CREATE TABLE deferred_genre (
id SERIAL PRIMARY KEY,
user_id BIGINT UNSIGNED,
genre_id BIGINT UNSIGNED NOT NULL,
created_at TIMESTAMP DEFAULT now(),
updated_at TIMESTAMP DEFAULT now(),

sold_books BIGINT DEFAULT NULL,

FOREIGN KEY (user_id) REFERENCES users (id)
ON DELETE RESTRICT
ON UPDATE CASCADE,
FOREIGN KEY (genre_id) REFERENCES genres (id)
ON DELETE CASCADE
ON UPDATE CASCADE
);

DROP TABLE IF EXISTS deferred_list;
CREATE TABLE deferred_list (
id SERIAL PRIMARY KEY,
user_id BIGINT UNSIGNED,
list_id BIGINT UNSIGNED NOT NULL,
created_at TIMESTAMP DEFAULT now(),
updated_at TIMESTAMP DEFAULT now(),

sold_books BIGINT DEFAULT NULL,

FOREIGN KEY (user_id) REFERENCES users (id)
ON DELETE RESTRICT
ON UPDATE CASCADE,
FOREIGN KEY (list_id) REFERENCES user_lists (id)
ON DELETE CASCADE
ON UPDATE CASCADE
);


-- books which have been bought out and can appear on sale again

DROP TABLE IF EXISTS sold_books;
CREATE TABLE sold_books (
id SERIAL PRIMARY KEY,
book_id BIGINT UNSIGNED NOT NULL UNIQUE,
created_at DATETIME,
deleted_at TIMESTAMP DEFAULT now()
);


-- genre relevance

DROP FUNCTION IF EXISTS g_relevance;
DELIMITER //
CREATE FUNCTION g_relevance(b_id INT UNSIGNED, g_id INT UNSIGNED)
RETURNS INT DETERMINISTIC
BEGIN 
	RETURN (SELECT likes.c - dislikes.c
	FROM (
	SELECT count(vote) AS c
	FROM likes_on_genre
	WHERE likes = 1 AND book_id = b_id AND genre_id = g_id
	) AS likes 
	JOIN (
	SELECT count(likes) AS c
	FROM likes_on_genre
	WHERE likes = 0 AND book_id = b_id AND genre_id = g_id
	) AS dislikes
	);
END;
//
DELIMITER ;

-- rating 

DROP FUNCTION IF EXISTS review_rate;
DELIMITER //
CREATE FUNCTION review_rate(r_id INT UNSIGNED)
RETURNS INT DETERMINISTIC
BEGIN
	RETURN (SELECT likes.c - dislikes.c
	FROM (
	SELECT count(likes) AS c
	FROM likes_on_reviews
	WHERE likes = 1 AND review_id = r_id
	) AS likes 
	JOIN (
	SELECT count(likes) AS c
	FROM likes_on_reviews
	WHERE likes = 0 AND review_id = r_id
	) AS dislikes
	);
END; 
//
DELIMITER ;
