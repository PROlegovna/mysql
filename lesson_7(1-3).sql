# task_1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

DROP TABLE IF EXISTS users;
CREATE TABLE users (
id SERIAL PRIMARY KEY,
name VARCHAR(255) COMMENT 'Name of a Client',
birthday_at DATE COMMENT 'Birthday',
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Customers';

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
id SERIAL PRIMARY KEY,
user_id INT UNSIGNED,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
KEY index_of_user_id(user_id)
) COMMENT = 'Orders';

INSERT INTO orders VALUES
(DEFAULT, 1, DEFAULT, DEFAULT),
(DEFAULT, 1, DEFAULT, DEFAULT),
(DEFAULT, 2, DEFAULT, DEFAULT)

INSERT INTO users VALUES
(DEFAULT, 'Peter', '1992-09-19', NOW(), NOW()),
(DEFAULT, 'Martin', '2000-07-14', NOW(), NOW()),
(DEFAULT, 'Mr Smith', '1980-05-15', NOW(), NOW())

SELECT u.name
FROM users AS u INNER JOIN orders AS o ON (o.user_id = u.id)
GROUP BY u.name
HAVING COUNT(o.id) > 0

# task 2. Выведите список товаров products и разделов catalogs, который соответствует товару

DROP TABLE IF EXISTS products;
CREATE TABLE products (
id SERIAL PRIMARY KEY,
name VARCHAR(255) COMMENT 'Name',
description TEXT COMMENT 'Description',
price DECIMAL (11,2) COMMENT 'Price',
catalog_id INT UNSIGNED,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
KEY index_of_catalog_id (catalog_id)
) COMMENT = 'Item Position';

INSERT INTO products VALUES
(DEFAULT, 'Sumsung', '', 17000, 1, DEFAULT, DEFAULT),
(DEFAULT, 'HP', '', 12000, 1, DEFAULT, DEFAULT),
(DEFAULT, 'Lenovo', '', 9000, 2, DEFAULT, DEFAULT);

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
id SERIAL PRIMARY KEY,
name VARCHAR(255) COMMENT 'Division Name',
UNIQUE unique_name(name(10))
) COMMENT = 'Online Shop Divisions';

INSERT INTO catalogs VALUES
(DEFAULT, 'Tablets'),
(DEFAULT, 'Laptops'),
(DEFAULT, 'Mobile Phones');

SELECT p.name, c.name
FROM products AS p
INNER JOIN catalogs AS c ON (p.catalog_id = c.id)
GROUP BY p.id

# task 3. Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов

DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
id SERIAL PRIMARY KEY,
name_from VARCHAR(50) COMMENT 'English',
name_to VARCHAR(50) COMMENT 'English'
);

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
label VARCHAR(50) PRIMARY KEY COMMENT 'English',
name VARCHAR(50) COMMENT 'Russian'
);

ALTER TABLE flights 
ADD CONSTRAINT fk_from_label
FOREIGN KEY(name_from)
REFERENCES cities(label);

ALTER TABLE flights 
ADD CONSTRAINT fk_to_label
FOREIGN KEY(name_to)
REFERENCES cities(label);

INSERT INTO cities VALUES
('Moscow', 'Москва'),
('Irkutsk', 'Иркутск'),
('Novgorod', 'Новгород'),
('Kazan', 'Казань'),
('Omsk', 'Омск');

INSERT INTO flights VALUES
(NULL, 'Moscow', 'Omsk'),
(NULL, 'Novgorod', 'Kazan'),
(NULL, 'Irkutsk', 'Moscow'),
(NULL, 'Omsk', 'Irkutsk'),
(NULL, 'Moscow', 'Kazan');

SELECT id AS flight_id,
(SELECT name FROM cities WHERE label = name_from) AS departure,
(SELECT name FROM cities WHERE label = name_to) AS arrival
FROM flights 
ORDER BY flight_id;