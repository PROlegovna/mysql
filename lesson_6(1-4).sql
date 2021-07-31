# task 1. Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользоваетелем.

USE vk;

SELECT COUNT(*) mess, friend FROM
(SELECT user_id, to_user_id AS friend FROM messages WHERE from_user_id = 1 UNION SELECT user_id, from_user_id AS friend FROM messages WHERE to_user_id = 1) AS history
GROUP BY friend
ORDER BY mess DESC 
LIMIT 1;


# task 2. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.

SELECT * FROM media 
WHERE user_id IN (SELECT * FROM (SELECT user_id FROM profiles ORDER BY birthday DESC LIMIT 10) AS user_id);

SELECT count(*) AS total_likes FROM media AS m WHERE id IN (SELECT id FROM media WHERE user_id IN (SELECT * FROM (SELECT user_id FROM profiles ORDER BY birthday DESC LIMIT 10) AS user_id));

# task 3. Определить кто больше поставил лайков (всего) - мужчины или женщины?

SELECT COUNT(*) AS posts_likes, gender FROM posts_likes, profiles 
WHERE posts_likes.user_id = profiles.user_id 
GROUP BY gender;

# task 4. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.

SELECT id, SUM(active) AS total_activity FROM (
SELECT * FROM (
-- Media files activity
(SELECT id, 0 AS active FROM users WHERE id NOT IN (SELECT user_id FROM media GROUP BY user_id)) 
UNION 
(SELECT user_id AS id, count(*) AS active FROM media AS m GROUP BY user_id)
) AS tmp_media
UNION ALL 
SELECT * FROM (
-- Messages activity
(SELECT id, 0 AS active FROM users WHERE id NOT IN (SELECT from_user_id FROM messages GROUP BY from_user_id))
UNION
(SELECT from_user_id AS id, COUNT(*) AS active FROM messages GROUP BY from_user_id)
) AS tmp_messages
UNION ALL 
SELECT * FROM (
-- Likes activity
(SELECT id, 0 AS active FROM users WHERE id NOT IN (SELECT user_id FROM posts_likes GROUP BY user_id))
UNION 
(SELECT user_id AS id, COUNT(*) AS active FROM posts_likes GROUP BY user_id)
) AS tmp_likes
) AS tmp_total 
GROUP BY id
ORDER BY total_activity
LIMIT 10;
