create or replace procedure log_member_entry(p_visit_id varchar(50), p_member_id varchar(50))
language plpgsql as $$
begin
	insert into gym_visits (id, member_id, entry_time)
	values(
		p_visit_id,
		p_member_id,
		current_timestamp
	);
end;
$$;
