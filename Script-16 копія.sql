create role gym_admin login password 'admin_1234';
create role gym_coach login password 'coach_1234';
create role gym_receptionist login password 'rec_1234';

grant all privileges on all tables in schema public to gym_admin;
grant select on schedule, group_classes, coaches to gym_coach;
grant select, insert, update on members, gym_visits, memberships to gym_receptionist;
