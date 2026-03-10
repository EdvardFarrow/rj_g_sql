-- ==========================================
-- ЗАДАНИЕ 1
-- ==========================================

-- Создание таблиц
CREATE TABLE sessions (
    date_start TIMESTAMP,
    date_finish TIMESTAMP,
    session_id INT4,
    user_id INT4
);

CREATE TABLE payments (
    date TIMESTAMP,
    user_id INT4,
    order_id INT4,
    offer_id INT4,
    usd_price NUMERIC
);

CREATE TABLE event_offers (
    date_start DATE,
    date_finish DATE,
    offer_id INT4,
    offer_name TEXT,
    event_name TEXT
);

-- Наполнение event_offers
INSERT INTO event_offers (date_start, date_finish, offer_id, offer_name, event_name) VALUES
('2026-01-01', '2026-01-31', 101, 'Starter Pack', 'event_name_1'),
('2026-01-01', '2026-01-31', 102, 'Mega Pack', 'event_name_1'),
('2026-02-01', '2026-02-28', 201, 'New Starter Pack', 'event_name_2'),
('2026-02-01', '2026-02-28', 202, 'New Mega Pack', 'event_name_2');

-- Наполнение payments
INSERT INTO payments (date, user_id, order_id, offer_id, usd_price) VALUES
('2026-01-15 10:00:00', 1, 1, 101, 9.99),  
('2026-02-10 12:00:00', 1, 2, 201, 9.99),  

('2026-02-15 14:00:00', 2, 3, 202, 19.99), 

('2026-02-20 16:00:00', 3, 4, 201, 9.99),  

('2026-01-20 18:00:00', 4, 5, 102, 19.99); 

-- Наполнение sessions 
INSERT INTO sessions (date_start, date_finish, session_id, user_id) VALUES
('2026-01-15 09:50:00', '2026-01-15 10:30:00', 1, 1),
('2026-02-15 13:50:00', '2026-02-15 14:30:00', 2, 2);


-- ==========================================
-- ЗАДАНИЕ 2
-- ==========================================

-- Создание типа и таблицы
CREATE TYPE event_name_enum AS ENUM (
    'authorization', 'city_visit', 'hero_summon', 'payment', 
    'pve_activity', 'pvp_activity', 'reconnection', 
    'registration', 'shop_visit', 'team_edit'
);

CREATE TABLE events (
    datetime TIMESTAMP,
    user_id INT4,
    event_name event_name_enum
);

-- Наполнение events (используем динамические даты относительно "сегодня", чтобы запрос всегда работал "за вчера")
INSERT INTO events (datetime, user_id, event_name) VALUES
-- События "за вчера" (User 1)
(CURRENT_DATE - INTERVAL '1 day' + INTERVAL '10:00', 1, 'authorization'),
(CURRENT_DATE - INTERVAL '1 day' + INTERVAL '10:15', 1, 'city_visit'),    
(CURRENT_DATE - INTERVAL '1 day' + INTERVAL '10:40', 1, 'pve_activity'),  
(CURRENT_DATE - INTERVAL '1 day' + INTERVAL '11:20', 1, 'authorization'), 
(CURRENT_DATE - INTERVAL '1 day' + INTERVAL '11:30', 1, 'payment'),       

-- События "за вчера" (User 2)
(CURRENT_DATE - INTERVAL '1 day' + INTERVAL '15:00', 2, 'authorization'), -- Одиночное событие

-- События "сегодня" 
(CURRENT_DATE + INTERVAL '10:00', 3, 'authorization');


-- ==========================================
-- ЗАДАНИЕ 3
-- ==========================================

-- Таблица payments уже создана в Задании 1
-- Добавим туда данные "за прошлую неделю" для проверки 3-го задания.

INSERT INTO payments (date, user_id, order_id, offer_id, usd_price) VALUES
(CURRENT_DATE - INTERVAL '7 days' + INTERVAL '10:00', 1, 101, 101, 9.99),
(CURRENT_DATE - INTERVAL '7 days' + INTERVAL '11:00', 2, 102, 101, 9.99),

(CURRENT_DATE - INTERVAL '6 days' + INTERVAL '10:00', 1, 103, 101, 9.99),
(CURRENT_DATE - INTERVAL '6 days' + INTERVAL '15:00', 1, 104, 102, 19.99);

