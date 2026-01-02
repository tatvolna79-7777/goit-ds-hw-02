-- 1. Отримати всі завдання певного користувача
SELECT *
FROM tasks
WHERE user_id = 3;

-- 2. Вибрати завдання за певним статусом
SELECT *
FROM tasks
WHERE status_id = (SELECT id FROM status WHERE name = 'new');

-- 3. Оновити статус конкретного завдання
UPDATE tasks
SET status_id = (SELECT id FROM status WHERE name = 'in progress')
WHERE id = 1;

SELECT id, title, status_id
FROM tasks
WHERE id = 1;

-- 4. Отримати список користувачів, які не мають жодного завдання
SELECT *
FROM users
WHERE id NOT IN (SELECT DISTINCT user_id FROM tasks);

-- 5. Додати нове завдання для конкретного користувача
INSERT INTO tasks (title, description, status_id, user_id)
VALUES (
    'Prepare presentation',
    'Quarterly project presentation',
    (SELECT id FROM status WHERE name = 'new'),
    3
);

SELECT *
FROM tasks
WHERE user_id = 2
ORDER BY id DESC
LIMIT 5;

-- Всі завдання користувача з назвою статусу_власний запит
SELECT 
    t.id,
    t.title,
    t.description,
    s.name AS status,
    t.user_id
FROM tasks t
JOIN status s ON t.status_id = s.id
WHERE t.user_id = 2;

-- 6. Всі завдання, які ще не завершено
SELECT 
    t.id,
    t.title,
    t.description,
    s.name AS status,
    t.user_id
FROM tasks t
JOIN status s ON t.status_id = s.id
WHERE s.name != 'completed';

-- 7. Видалити конкретне завдання
DELETE FROM tasks
WHERE id = 2;

SELECT *
FROM tasks
WHERE id = 2;

SELECT *
FROM tasks
ORDER BY id;


-- 8. Знайти користувачів з певною електронною поштою
SELECT *
FROM users
WHERE email LIKE '%@example.com';

-- 9. Оновити ім'я користувача
UPDATE users
SET fullname = 'New Name'
WHERE id = 1;

SELECT *
FROM users
WHERE id = 1;

-- 10. Отримати кількість завдань для кожного статусу
SELECT s.name, COUNT(t.id) AS task_count
FROM tasks t
JOIN status s ON t.status_id = s.id
GROUP BY s.name;

-- 11. Завдання користувачів з певними доменами email
SELECT u.fullname,
       u.email,
       COUNT(t.id) AS task_count
FROM users u
LEFT JOIN tasks t ON t.user_id = u.id
WHERE u.email LIKE '%@example.net'
   OR u.email LIKE '%@example.org'
GROUP BY u.id, u.fullname, u.email
ORDER BY task_count DESC;

-- 12. Список завдань без опису
SELECT id, title, status_id, user_id
FROM tasks
WHERE description IS NULL OR description = '';

-- 13. Користувачі та їхні завдання у статусі 'in progress'
SELECT u.fullname, t.title, s.name AS status
FROM users u
JOIN tasks t ON u.id = t.user_id
JOIN status s ON t.status_id = s.id
WHERE s.name = 'in progress';

-- 14. Користувачі та кількість їхніх завдань
SELECT u.fullname,
       COUNT(t.id) AS task_count
FROM users u
LEFT JOIN tasks t ON u.id = t.user_id
GROUP BY u.id, u.fullname
ORDER BY task_count DESC;
