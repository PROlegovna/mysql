#task 1
USE vk;

SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())), 0) AS AVG_Age FROM users;


#task 2
SELECT DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at)))AS day FROM users;
SELECT DATE_FORMAT(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at))), '%W') AS day FROM users;
SELECT DATE_FORMAT(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at))), '%W') AS day FROM users GROUP BY day;

SELECT DATE_FORMAT(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at))), '%W') AS day;
COUNT(*) AS total FROM users GROUP BY day ORDER BY total DESC;

# task 3
CREATE TABLE integers(value SERIAL PRIMARY KEY);
INSERT INTO integers VALUES
(NULL),
(NULL),
(NULL),
(NULL),
(NULL),
(NULL);
SELECT ROUND(exp(SUM(ln(value))), 0) AS factorial FROM integers;