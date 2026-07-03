create or replace function get_active_membership_days_left(p_member_id varchar(50))
returns int
language sql
as $$
	select coalesce(max(end_date - current_date), 0)
	from memberships
	where member_id = p_member_id
		and is_active = true
		and end_date >= current_date;
$$;
