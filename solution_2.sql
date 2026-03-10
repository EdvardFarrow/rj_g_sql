-- Комментарий к решению Задания 2:
-- 1. Сначала отфильтровываем события строго "за вчера" (используем оптимизированный для индексов поиск по диапазону).
-- 2. В lag_table находим время предыдущего события для каждого пользователя.
-- 3. В session_flags размечаем начала новых сессий: ставим 1, если это первое событие или разрыв больше 30 минут.
-- 4. В session_table через оконную функцию SUM генерируем уникальный session_id для каждого блока событий.
-- 5. В duration_table схлопываем данные до уровня сессии и вычисляем ее длину.
-- 6. В основном запросе считаем среднюю длину сессии по всем пользователям.



with raw_events as (
    select *
    from events
    where datetime >= current_date - interval '1 day'
        and datetime < current_date
),
lag_table as (
	select 
		*,
		lag(datetime) over(partition by user_id order by datetime) as lag_date
	from raw_events
),
flags_table as (
	select
		*,
		case 
			when lag_date is null then 1
			when (datetime - lag_date) > interval '30 minutes' then 1
			else 0
		end as new_session
	from lag_table
),
session_table as (
	select 
		*,
		sum(new_session) over(partition by user_id order by datetime) as session_id
	from flags_table
),
duration_table as (
	select 	
		user_id,
		session_id,
		max(datetime) - min(datetime) as session_time
	from session_table
	group by user_id, session_id
)
select 	
	avg(session_time) as avg_session
from duration_table
