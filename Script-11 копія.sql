drop table if exists class_enrollments cascade;
drop table if exists gym_visits cascade;
drop table if exists schedule cascade;
drop table if exists group_classes cascade;
drop table if exists coaches cascade;
drop table if exists memberships cascade;
drop table if exists fitness_profiles cascade;
drop table if exists members cascade;

create table members (
	id varchar(50) primary key,
	first_name varchar(200) not null,
	last_name varchar(200) not null,
	email varchar(200) not null unique,
	phone varchar(20) not null unique,
	active boolean default true
);

create table fitness_profiles (
	id varchar(50) primary key,
	member_id varchar(50) not null unique references members(id),
	calorie_goal int check (calorie_goal > 0),
	protein_goal int check (protein_goal > 0),
	carbs_goal int check (carbs_goal > 0),
	fat_goal int check (fat_goal > 0),
	current_weight decimal(5,2) check (current_weight > 0)
);

create table memberships (
	id varchar(50) primary key,
	member_id varchar(50) not null references members(id),
	type varchar(50) not null,
	start_date date not null,
	end_date date not null,
	is_active boolean default true,
	constraint check_dates check (end_date >= start_date)
);

create table coaches (
	id varchar(50) primary key,
	first_name varchar(200) not null,
	last_name varchar(200) not null,
	specialization varchar(100)
);

create table group_classes (
	id varchar(50) primary key,
	name varchar(100) not null,
	description varchar(500),
	max_participants int check (max_participants > 0)
);

create table schedule (
	id varchar(50) primary key,
	class_id varchar(50) not null references group_classes(id),
	coach_id varchar(50) not null references coaches(id),
	class_date date not null,
	start_time time not null,
	end_time time not null,
	constraint check_time check (end_time >= start_time)
);

create table class_enrollments (
	member_id varchar(50) not null references members(id),
	schedule_id varchar(50) not null references schedule(id),
	primary key (member_id, schedule_id)
);

create table gym_visits (
	id varchar(50) primary key,
	member_id varchar(50) not null references members(id),
	entry_time timestamp not null,
	exit_time timestamp,
	constraint check_visit_time check (exit_time >= entry_time)
)
















