explain analyze
select 
	m.first_name,
	m.last_name,
	m.email,
	count(v.id) as total_visits,
	avg(v.exit_time - v.entry_time) as avg_workout_duration
from gym_visits v
join members m on v.member_id = m.id
where v.entry_time >= '2025-10-01 00:00:00' and v.entry_time <= '2025-10-07 23:59:59'
group by m.id, m.first_name, m.last_name, m.email
order by total_visits desc;

create index if not exists idx_gym_visits_entry_time on gym_visits(entry_time);
create index if not exists idx_gym_visits_member_id on gym_visits(member_id);

