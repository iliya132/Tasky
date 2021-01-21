drop database if exists TaskyDB;
create database TaskyDB;
go

use TaskyDB;
drop table if exists files;
drop table if exists MarksToTasks;
drop table if exists Marks;
drop table if exists Comments;
drop table if exists Tasks;
drop table if exists categories;
drop table if exists users;

create table users(
	id int primary key identity (1,1),
	user_name nvarchar(20) not null unique,
	email nvarchar(100) not null
);

create table categories (
	id int primary key identity (1,1),
	name nvarchar(300) not null,
	created_by int not null,
	FOREIGN KEY (created_by) REFERENCES users(id)
);

create table Tasks(
	id int primary key identity (1,1),
	name nvarchar (500) not null,
	description nvarchar(max),
	created_by int not null,
	assignee_to int not null,
	created_at datetime not null default GetDate(),
	due_date datetime,
	remember_flag bit not null default 0,
	category_id int,
	FOREIGN KEY (category_id) REFERENCES categories(id),
	FOREIGN KEY (created_by) REFERENCES users(id),
	FOREIGN KEY (assignee_to) REFERENCES users(id)
);

create table Marks(
	id int primary key identity (1,1),
	created_by int not null,
	created_at datetime not null default GETdate(),
	FOREIGN KEY (created_by) REFERENCES users(id)
);

create table MarksToTasks(
	mark_id int not null,
	task_id int not null,
	primary key (mark_id, task_id),
	foreign key (mark_id) references Marks(id),
	foreign key (task_id) references Tasks(id)
);

create table Comments(
	id int primary key identity (1,1),
	text nvarchar(max) not null,
	task_id int not null,
	created_at datetime not null default getdate(),
	created_by int not null,
	FOREIGN KEY (created_by) REFERENCES users(id),
	foreign key (task_id) references Tasks(id)
);

create table files(
	id int primary key identity (1,1),
	task_id int not null,
	binary_data varbinary(max) not null,
	file_name nvarchar(100) not null,
	foreign key (task_id) references Tasks(id)
);