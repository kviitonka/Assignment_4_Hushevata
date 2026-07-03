create or replace view daily_schedule as 
select
	s.class_date as date,
	s.start_time,
	s.end_time,
	c.name as class_name,
	c.max_participants
from schedule s
join group_classes c on s.class_id = c.id
join coaches co on s.coach_id = co.id
order by s.class_date, s.start_time;
