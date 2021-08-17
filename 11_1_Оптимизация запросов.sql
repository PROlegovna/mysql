-- task 1 for Оптимизация запросов

CREATE TABLE logs (
table_name VARCHAR(20) NOT NULL,
pk_id INT UNSIGNED NOT NULL,
name VARCHAR(255),
created_at DATETIME DEFAULT NOW()
ENGINE=ARCHIEVE;
)

CREATE TRIGGER users_log AFTER INSERT ON users FOR EACH ROW 
INSERT INTO logs
SET
table_name = 'users',
pk_id = NEW.id,
name = NEW.name;

CREATE TRIGGER catalogs_log AFTER INSERT ON catalogs FOR EACH ROW 
INSERT INTO logs
SET
table_name = 'catalogs',
pk_id = NEW.id,
name = NEW.name;

CREATE TRIGGER products_log AFTER INSERT ON products FOR ROW 
INSERT INTO catalogs
SET 
table_name = 'products',
pk_id = NEW.id,
name = NEW.name;

SELECT * FROM users;
SELECT * FROM logs;

INSERT INTO users (name, birthday_at)
VALUES ('Param', '1990-10-31');

SELECT * FROM users;
SELECT * FROM logs;

INSERT INTO users (name, birthday_at)
VALUES ('Pam', '1992-10-20'), ('Purum', '1998-10-10'), ('Pum', '2000-10-10'), ('Li Kim', '1999-12-01');

SELECT * FROM users;
SELECT * FROM logs;

SELECT * FROM catalogs;
SELECT * FROM logs;

INSERT INTO catalogs (name)
VALUES ('Interesting'), ('Task'), ('Is'), ('Here');

SELECT * FROM catalogs;
SELECT + FROM logs;

SELECT * FROM products;
SELECT * FROM logs;

INSERT INTO products (catalog_id, name, description, price)
VALUES (1, 'adjective', 'can be translated easily', 5000), (2, 'noun', 'is a synonym to exercise', 3000), (3, 'verb', 'form of the verb to be', 10000), (4, 'deictic', 'has adverbial use', 7000);

SELECT * FROM products;
SELECT * FROM logs;