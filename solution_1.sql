-- Комментарий к решению Задания 1:
-- 1. С помощью CTE агрегируем данные до уровня пользователя, 
--    подсчитывая количество покупок в рамках каждого из ивентов.
-- 2. В основном запросе отфильтровываем только целевую аудиторию (тех, кто покупал во 2-м ивенте).
-- 3. Считаем долю: количество юзеров без покупок в 1-м ивенте делим на общее количество юзеров в ЦА.
-- 4. Используем приведение к типу numeric, чтобы избежать целочисленного деления.


select * from sessions

select * from payments

select * from event_offers


with event_stats as (
	select
		user_id,
		count(*) filter (where e.event_name = 'event_name_1') as e_1,
		count(*) filter (where e.event_name = 'event_name_2') as e_2
	from payments p
		join event_offers e 
		on e.offer_id = p.offer_id
	group by user_id
)
select 
	round(count(user_id) filter (where e_1 = 0)::numeric / count(user_id), 2) as exclusive_event_2
from event_stats
where e_2 > 0
