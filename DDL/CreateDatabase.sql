--Create database Tasky_TestDb;
go
use Tasky_TestDb;

drop table if exists room_members;
drop table if exists user_roles;
drop table if exists card_history;
drop table if exists card_field_values;
drop table if exists room_card_fields;
drop table if exists card_schemas;
drop table if exists cards;
drop table if exists workflow_steps;
drop table if exists workflows;
drop table if exists rooms;
drop table if exists Users;

create table users(
	id int primary key identity(1,1),
	name nvarchar(100) unique not null,
	displayed_name nvarchar(150) not null,
);

create table rooms(
	id int primary key identity(1,1),
	name nvarchar(100) not null,
	created_by int not null,
	created_at datetime not null default GetDate(),
	card_schema int not null,
	is_deleted bit not null default 0,
	foreign key(created_by) references users(id)
);

create table user_roles(
	id int primary key identity(1,1),
	name nvarchar(100) not null
);

create table room_members(
	user_id int not null,
	room int not null,
	join_at datetime not null default GetDate(),
	invited_by int,
	user_role int not null default 1,
	primary key (user_id, room),
	foreign key (user_role) references user_roles(id),
	foreign key (user_id) references users(id),
	foreign key (invited_by) references users(id),
	foreign key (room) references rooms(id)
);

create table workflows(
	id int primary key identity(1,1),
	name nvarchar(150) not null,
	created_by int not null,
	created_at datetime not null default GetDate(),
	foreign key (created_by) references users(id)
);

create table workflow_steps(
	id int primary key identity(1,1),
	name nvarchar(150) not null,
	workflow int not null,
	next_step int,
	prev_step int,
	foreign key (workflow) references workflows(id),
	foreign key (next_step) references workflow_steps(id),
	foreign key (prev_step) references workflow_steps(id),
);

create table cards(
	id int primary key identity(1,1),
	name nvarchar(max) not null,
	created_by int not null,
	created_at datetime not null default GetDate(),
	updated_at datetime not null default GetDate(),
	room int not null,
	current_workflow_step int not null,
	foreign key (created_by) references users(id),
	foreign key (current_workflow_step) references workflow_steps(id),
	foreign key (room) references rooms(id)
);

create table card_history(
	id int primary key identity(1,1),
	new_workflow int not null,
	created_by int not null,
	created_at datetime not null default GetDate(),
	comment nvarchar(max),
	foreign key (created_by) references users(id),
	foreign key (new_workflow) references workflow_steps(id)
);

create table card_schemas(
	id int primary key identity(1,1),
	name nvarchar(100) not null,
	created_by int not null,
	created_at datetime not null default GetDate(),
	foreign key (created_by) references users(id)
);

create table room_card_fields(
	id int primary key identity(1,1),
	card_schema int not null,
	field_type nvarchar(20) not null,
	field_name nvarchar(100) not null,
	foreign key (card_schema) references card_schemas(id)
);

create table card_field_values(
	card_id int not null,
	card_field int not null,
	card_value varbinary(max) not null,
	foreign key (card_id) references cards(id),
	foreign key (card_field) references room_card_fields(id),
	primary key (card_id, card_field)
);

go
create trigger on_card_update on cards
after UPDATE 
as
update cards set updated_at = GetDate()
where id in (select id from inserted);
go
