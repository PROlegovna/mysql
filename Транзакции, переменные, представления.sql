-- Транзакции, переменные, представления
-- task 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.
USE shop_online;

START TRANSACTION;
INSERT INTO sample.users 
SELECT * FROM shop_online.users WHERE id = 1;
DELETE FROM shop_online.users WHERE id = 1;
COMMIT;
SELECT * FROM shop_online.users;
SELECT * FROM sample.users;
-- task 2. Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs.


CREATE OR REPLACE VIEW v AS
SELECT products.name AS prod_name, catalogs.name AS cat_name
FROM products, catalogs
WHERE products.catalog_id = catalog_id;

SELECT * FROM v;

-- task 3. Пусть имеется таблица с календарным полем created_at. В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1, если дата присутствует в исходном таблице и 0, если она отсутствует.


DROP TABLE IF EXISTS table3;
CREATE TABLE table3 (
id SERIAL PRIMARY KEY,
created_at date);
INSERT INTO table3 VALUES
(NULL, '2018-08-01'), (NULL, '2018-08-04'), (NULL, '2018-08-16'), (NULL, '2018-08-17');

CREATE TEMPORARY TABLE days_august (days int);

INSERT INTO days_august VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12), (13), (14), (15), (16), (17), (18), (19), (20), (21), (22), (23), (24), (25), (26), (27), (28), (29), (30), (31);

SET @start_august = '2018-07-31';

SELECT @start_august + INTERVAL days DAY AS date_august,
CASE WHEN table3.created_at IS NULL THEN 0 ELSE 1 END AS v1 FROM days_august
LEFT JOIN table3 ON @start_august + INTERVAL days DAY = table3.created_at
ORDER BY date_august;


-- task 4. Пусть имеется любая таблица с календарным полем created_at. Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.
USE shop_online;

PREPARE del_prod FROM 'DELETE FROM products ORDER BY created_at LIMIT?';
SET @ROWS = (SELECT COUNT(*)-5 FROM products);
EXECUTE del_prod USING @ROWS;

SELECT * FROM products;