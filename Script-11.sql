SELECT id, first_name, last_name, email, phone, password_hash, created_at, updated_at
FROM vk.users;

UPDATE users
SET created_at = NOW();
SET updated_at = NOW();

ALTER TABLE users MODIFY COLUMN created_at varchar(150);
ALTER TABLE users MODIFY COLUMN updated_at varchar(150);

UPDATE users
SET created_at = STR_TODATE(created_at, '%d.%m.%Y %k:%i'),
updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %k:%i');

ALTER TABLE users
MODIFY COLUMN created_at DATETIME,
MODIFY COLUMN updated_at DATETIME;

UPDATE users
SET created_at = DATE_FORMAT(created_at, '%d.%m.%Y %H:%i'),
updated_at = DATE_FORMAT(updated_at, '%d.%m.%Y %H:%i');

