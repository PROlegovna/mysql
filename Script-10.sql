CREATE TABLE 'storehouses_products' (
storehouse_id bigint(20) unsigned NOT NULL,
product_id bigint(20) unsigned NOT NULL, 
value char(11) NOT NULL, 
created_at datetime DEFAULT current_timestamp(),
updated_at datetime DEFAULT NULL ON UPDATE current_timestamp()
);

SELECT * FROM storehouses_products;

INSERT INTO storehouses_products
(storehouse_id, product_id, value, created_at, updated_at) VALUES
(1, 1, 2, now(), now()),
(2, 2, 1, now(), now()),
(3, 3, 5, now(), now()),
(4, 4, 0, now(), now()),
(5, 5, 4, now(), now()),
(6, 6, 3, now(), now())
;

SELECT * FROM storehouses_products ORDER BY CASE WHEN value = 0 THEN 99 ELSE value END;
