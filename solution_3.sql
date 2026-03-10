-- Комментарий к решению Задания 3:
-- 1. Используем CTE users для определения целевой когорты.
-- 2. В calendar_table с помощью generate_series создаем беспрерывный ряд дат "за прошлую неделю".
--    Это гарантирует, что дни без покупок не выпадут из результата (будет выведен 0).
-- 3. В daily_buyers считаем количество уникальных покупателей из нашей когорты для каждого дня.
-- 4. В total_table получаем общее количество пользователей в когорте для знаменателя.
-- 5. Соединяем календарь с покупателями через LEFT JOIN и CROSS JOIN с общим числом юзеров,
--    затем вычисляем долю, используя COALESCE для замены NULL на 0 в дни без покупок.



select * from payments


with users as (
	select
		distinct user_id
	from payments
	where date >= current_date - interval '30 days'
),
calendar_table as (
	select
		generate_series(
			current_date - interval '7 days', 
	        current_date - interval '1 day', 
	        interval '1 day'
	    )::date as report_date
),
daily_buyers as (
	select
		p.date::date as purchase_date,
		count(distinct p.user_id) as daily_buyers_count
	from payments p
	join users u 
		on p.user_id = u.user_id
	where p.date >= current_date - interval '7 days'
		and p.date < current_date
	group by p.date::date
),
total_table as (
	select
		count(user_id) as total_users
	from users
)
select
	c.report_date,
	round(coalesce(d.daily_buyers_count, 0)::numeric / t.total_users, 2) as active_paying_share
from calendar_table c
cross join total_table t
left join daily_buyers d on
	c.report_date = d.purchase_date
order by
	c.report_date