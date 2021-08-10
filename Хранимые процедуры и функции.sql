-- Хранимые процедуры и функции, триггеры
DELIMITER //

-- task 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
DROP FUNCTION IF EXISTS hello;
CREATE FUNCTION hello() RETURNS TEXT DETERMINISTIC 
BEGIN 
CASE
	WHEN CURTIME() BETWEEN '06:00:00' AND '12:00:00' THEN SELECT 'Доброе утро'
	WHEN CURTIME() BETWEEN '12:00:00' AND '18:00:00' THEN SELECT 'Добрый день'
	WHEN CURTIME() BETWEEN '18:00:00' AND '00:00:00' THEN SELECT 'Добрый вечер'
	ELSE 'Добрый ночи'
END CASE;
END //

DELIMITER ;

CALL hello();
-- task 2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием. Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию.
DELIMITER //

CREATE TRIGGER description_and_name BEFORE UPDATE ON products FOR EACH ROW 
BEGIN 
	IF ne.name IS NULL AND NEW.description IS NULL 
	THEN SIGNAL SQLSTATE '45001' SET message_text = 'products name or description can not be NULL';
END IF;
END; // 


-- task 3. Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. Вызов функции FIBONACCI(10) должен возвращать число 55.
SELECT 'Function';
DROP FUNCTION IF EXISTS fibonacci;
CREATE FUNCTION fibonacci(n INT)
RETURNS TEXT DETERMINISTIC
BEGIN 
	DECLARE p1 INT DEFAULT 1;
	DECLARE p2 INT DEFAULT 1;
	DECLARE i INT DEFAULT 2;
	DECLARE res INT DEFAULT 0;

IF (n <= 1) THEN RETURN n;
ELSEIF (n = 2) THEN RETURN 1;
END IF;
WHILE i < n DO
SET i = i + 1;
SET res = p1 + p2;
SET p2 = p1;
SET p1 = res;
END WHILE;
RETURN res;
END//

DELIMITER ;