DROP DATABASE IF EXISTS vk;

CREATE DATABASE IF NOT EXISTS vk;

USE vk;

SHOW tables;

CREATE TABLE users(
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(145) NOT NULL,
    last_name VARCHAR(145) NOT NULL,
    email VARCHAR(145) NOT NULL UNIQUE,
    phone CHAR(11) NOT NULL,
    password_hash CHAR(65) DEFAULT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- NOW()
    INDEX (phone),
    INDEX (email)
);

INSERT INTO users VALUES (DEFAULT, 'Petya', 'Petukhov', 'petya@mail.com', '89274826749', DEFAULT, DEFAULT);
INSERT INTO users VALUES (DEFAULT, 'Vasya', 'Vasilkov', 'vasya@mail.com', '89253745274', DEFAULT, DEFAULT);

SELECT * FROM users;

DESCRIBE users;

SHOW CREATE TABLE users;

CREATE TABLE profiles(
    user_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
    gender ENUM('f', 'm', 'x') NOT NULL, 
    birthday DATE NOT NULL,
    photo_id INT UNSIGNED, 
    city VARCHAR(130),
    country VARCHAR(130),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

ALTER TABLE profiles MODIFY COLUMN photo_id BIGINT UNSIGNED;

DESCRIBE profiles;

ALTER TABLE profiles ADD COLUMN passport_number VARCHAR(10);

ALTER TABLE profiles MODIFY COLUMN passport_number VARCHAR(20);

ALTER TABLE profiles RENAME COLUMN passport_number TO passport;

ALTER TABLE profiles ADD KEY passport_idx (passport);

ALTER TABLE profiles DROP INDEX passport_idx;

ALTER TABLE profiles DROP COLUMN passport;

INSERT INTO profiles VALUES (1, 'm', '1997-12-01', NULL, 'Moscow', 'Russia');
INSERT INTO profiles VALUES (2, 'm', '1988-11-02', NULL, 'Moscow', 'Russia');

SELECT * FROM profiles;

CREATE TABLE messages(
    id SERIAL PRIMARY KEY,
    from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    txt TEXT NOT NULL,
    is_delivered BOOLEAN DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
    INDEX messages_from_user_id_idx (from_user_id),
    INDEX messages_to_user_id_idx (to_user_id),
    CONSTRAINT fk_messages_from_user_id FOREIGN KEY (from_user_id) REFERENCES users (id),
    CONSTRAINT fk_messages_to_user_id FOREIGN KEY (to_user_id) REFERENCES users (id)
);

DESCRIBE messages;

INSERT INTO messages VALUES (DEFAULT, 1, 2, 'Hi!', 1, DEFAULT, DEFAULT);
INSERT INTO messages VALUES (DEFAULT, 1, 2, 'Vasya!', 1, DEFAULT, DEFAULT);
INSERT INTO messages VALUES (DEFAULT, 2, 1, 'Hi, Petya!', 1, DEFAULT, DEFAULT);

SELECT * FROM messages;

CREATE TABLE friend_requests(
    from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    accepted BOOLEAN DEFAULT FALSE,
    PRIMARY KEY(from_user_id, to_user_id),
    INDEX friend_requests_from_user_id_idx (from_user_id),
    INDEX friend_requests_to_user_id_idx (to_user_id),
    CONSTRAINT fk_friend_requests_from_user_id FOREIGN KEY (from_user_id) REFERENCES users (id),
    CONSTRAINT fk_friend_requests_to_user_id FOREIGN KEY (to_user_id) REFERENCES users (id)
);

INSERT INTO friend_requests VALUES (1, 2, 1);

SELECT * FROM friend_requests;

INSERT INTO friend_requests (from_user_id, to_user_id) VALUES (2, 1);

CREATE TABLE communities(
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description VARCHAR(255),
    admin_id BIGINT UNSIGNED NOT NULL,
    KEY (admin_id),
    FOREIGN KEY (admin_id) REFERENCES users(id)
);

INSERT INTO communities VALUES (DEFAULT, 'Number1', 'I am number one', 1);
INSERT INTO communities VALUES (DEFAULT, 'Number2', 'I am number two', 1);

SELECT * FROM communities;

CREATE TABLE communities_users(
    community_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(community_id, user_id),
    KEY (community_id),
    KEY (user_id),
    FOREIGN KEY (community_id) REFERENCES communities (id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO communities_users VALUES (1, 2, DEFAULT);

SELECT * FROM communities_users;

CREATE TABLE media_types(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO media_types VALUES (DEFAULT, 'image');
INSERT INTO media_types VALUES (DEFAULT, 'music');
INSERT INTO media_types VALUES (DEFAULT, 'documents');

SELECT * FROM media_types;

CREATE TABLE media (
    id SERIAL PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    media_types_id INT UNSIGNED NOT NULL,
    file_name VARCHAR(255) COMMENT '/files/folder/img.png',
    file_size BIGINT UNSIGNED,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY (media_types_id),
    KEY (user_id),
    FOREIGN KEY (media_types_id) REFERENCES media_types(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO media VALUES (DEFAULT, 1, 1, 'im.jpg', 100, DEFAULT);
INSERT INTO media VALUES (DEFAULT, 1, 1, 'im1.jpg', 78, DEFAULT);
INSERT INTO media VALUES (DEFAULT, 2, 3, 'doc.docx', 1024, DEFAULT);

SELECT * FROM media;

DESCRIBE media;

CREATE TABLE posts (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    txt TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    INDEX user_idx (user_id),
    CONSTRAINT user_posts_fk FOREIGN KEY (user_id) REFERENCES users (id)
);

INSERT INTO posts VALUES (DEFAULT, 1, 'Hello', DEFAULT, DEFAULT);
INSERT INTO posts VALUES (DEFAULT, 1, 'This is my post.', DEFAULT, DEFAULT);

SELECT * FROM posts;

CREATE TABLE posts_likes (
    post_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    like_type BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (post_id, user_id),
    INDEX post_idx (post_id),
    INDEX user_idx (user_id),
    CONSTRAINT posts_likes_fk FOREIGN KEY (post_id) REFERENCES posts (id),
    CONSTRAINT users_likes_fk FOREIGN KEY (user_id) REFERENCES users (id)
);

INSERT INTO posts_likes VALUES (1, 2, DEFAULT);
INSERT INTO posts_likes VALUES (1, 1, DEFAULT);

SELECT * FROM posts_likes;
