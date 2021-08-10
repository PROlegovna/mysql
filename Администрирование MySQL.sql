-- Администрирование MySQL
-- task 1. Создайте двух пользователей которые имеют доступ к базе данных shop. Первому пользователю shop_read должны быть доступны только запросы на чтение данных, второму пользователю shop — любые операции в пределах базы данных shop.

-- First user


DROP USER IF EXISTS 'shop_reader'@'localhost';
CREATE USER 'shop_reader'@'localhost' IDENTIFIED WITH user1_password BY '123';
GRANT SELECT ON shop_online.* TO 'shop_reader'@'localhost';

INSERT INTO catalogs(name)

VALUES('New catalog');

SELECT * FROM catalogs;

-- Second user


DROP USER IF EXISTS 'shop'@'localhost';
CREATE USER 'shop'@'localhost' IDENTIFIED WITH user2_password BY '456';
GRANT ALL ON shop_online.* TO 'shop'@'localhost';
GRANT OPTION ON shop_online.* TO 'shop'@'localhost';

INSERT INTO catalogs(name)

VALUES('New catalog');

SELECT * FROM catalogs;

# task 2. Пусть имеется таблица accounts содержащая три столбца id, name, password, содержащие первичный ключ, имя пользователя и его пароль. Создайте представление username таблицы accounts, предоставляющий доступ к столбца id и name. Создайте пользователя user_read, который бы не имел доступа к таблице accounts, однако, мог бы извлекать записи из представления username.

