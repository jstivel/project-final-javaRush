---------  users ----------------------
-- Eliminamos en orden para respetar las claves foráneas
delete from "attachment";
delete from "user_belong";
delete from "activity";
delete from "task_tag";
delete from "task";
delete from "sprint";
delete from "user_role";
delete from "contact";
delete from "profile";
delete from "project";
delete from "users";
delete from "reference";
delete from "mail_case";

-- Ahora, reiniciamos las secuencias de las tablas con un contador automático
alter table "users" alter column "id" restart with 1;
alter table "project" alter column "id" restart with 1;
alter table "sprint" alter column "id" restart with 1;
alter table "task" alter column "id" restart with 1;
alter table "activity" alter column "id" restart with 1;
alter table "user_belong" alter column "id" restart with 1;
alter table "attachment" alter column "id" restart with 1;
alter table "reference" alter column "id" restart with 1;
alter table "mail_case" alter column "id" restart with 1;

-- El resto del archivo con tus insert statements sigue igual
insert into "reference" ("code", "title", "ref_type", "aux")
values
  -- Referencias de Tipos Padre
  ('CONTACT', 'Contact Type', 0, null),
  ('PROJECT_TYPE', 'Project Type', 1, null),
  ('TASK_TYPE', 'Task Type', 2, null),
  ('TASK_STATUS', 'Task Status', 3, null),
  ('SPRINT_STATUS', 'Sprint Status', 4, null),
  ('USER_TYPE', 'User Type', 5, null),
  ('MAIL_NOTIFICATION', 'Mail Notification Type', 6, null),
  ('PRIORITY', 'Priority Type', 7, null),
  ('NOTIFICATION', 'Notification Type', 8, null),
  ('GENDER', 'Gender Type', 9, null),
  ('USER_ROLE', 'User Role', 10, null),
  ('ACTIVITY_TYPE', 'Activity Type', 11, null),

  -- Referencias específicas
  ('skype', 'Skype', 0, null),
  ('tg', 'Telegram', 0, null),
  ('mobile', 'Mobile', 0, null),
  ('phone', 'Phone', 0, null),
  ('website', 'Website', 0, null),
  ('linkedin', 'LinkedIn', 0, null),
  ('github', 'GitHub', 0, null),

  ('scrum', 'Scrum', 1, null),
  ('task_tracker', 'Task tracker', 1, null),

  ('task', 'Task', 2, null),
  ('story', 'Story', 2, null),
  ('bug', 'Bug', 2, null),
  ('epic', 'Epic', 2, null),

  ('todo', 'ToDo', 3, 'in_progress,canceled'),
  ('in_progress', 'In progress', 3, 'ready_for_review,canceled'),
  ('ready_for_review', 'Ready for review', 3, 'review,canceled'),
  ('review', 'Review', 3, 'in_progress,ready_for_test,canceled'),
  ('ready_for_test', 'Ready for test', 3, 'test,canceled'),
  ('test', 'Test', 3, 'done,in_progress,canceled'),
  ('done', 'Done', 3, 'canceled'),
  ('canceled', 'Canceled', 3, null),

  ('planning', 'Planning', 4, null),
  ('active', 'Active', 4, null),
  ('finished', 'Finished', 4, null),

  ('author', 'Author', 5, null),
  ('developer', 'Developer', 5, null),
  ('reviewer', 'Reviewer', 5, null),
  ('tester', 'Tester', 5, null),

  ('assigned', 'Assigned', 6, '1'),
  ('three_days_before_deadline', 'Three days before deadline', 6, '2'),
  ('two_days_before_deadline', 'Two days before deadline', 6, '4'),
  ('one_day_before_deadline', 'One day before deadline', 6, '8'),
  ('deadline', 'Deadline', 6, '16'),
  ('overdue', 'Overdue', 6, '32'),

  ('critical', 'Critical', 7, null),
  ('high', 'High', 7, null),
  ('normal', 'Normal', 7, null),
  ('low', 'Low', 7, null),
  ('neutral', 'Neutral', 7, null),

  ('mail', 'Mail', 8, '1'),
  ('im', 'IM', 8, '2'),
  ('sms', 'SMS', 8, '4'),
  ('push', 'Push', 8, '8'),

  ('female', 'Female', 9, null),
  ('male', 'Male', 9, null),

  ('admin', 'Admin', 10, null),
  ('manager', 'Manager', 10, null),
  ('user', 'User', 10, null),

  ('comment', 'Comment', 11, null),
  ('update', 'Update', 11, null),
  ('create', 'Create', 11, null);
-------------------------------

insert into "users" ("email", "password", "first_name", "last_name", "display_name")
values ('user@gmail.com', '{noop}password', 'userFirstName', 'userLastName', 'userDisplayName'),
       ('admin@gmail.com', '{noop}admin', 'adminFirstName', 'adminLastName', 'adminDisplayName'),
       ('guest@gmail.com', '{noop}guest', 'guestFirstName', 'guestLastName', 'guestDisplayName'),
       ('manager@gmail.com', '{noop}manager', 'managerFirstName', 'managerLastName', 'managerDisplayName');

-- 0 DEV
-- 1 ADMIN
-- 2 MANAGER

insert into "user_role" ("user_id", "role")
values (1, 0),
       (2, 0),
       (2, 1),
       (4, 2);

insert into "profile" ("id", "last_failed_login", "last_login", "mail_notifications")
values (1, null, null, 49),
       (2, null, null, 14);

insert into "contact" ("id", "code", "value")
values (1, 'skype', 'userSkype'),
       (1, 'mobile', '+01234567890'),
       (1, 'website', 'user.com'),
       (2, 'github', 'adminGitHub'),
       (2, 'telegram', 'adminTg'),
       (2, 'facebook', 'adminFb');


insert into "project" ("code", "title", "description", "type_code", "parent_id")
values ('PR1', 'PROJECT-1', 'test project 1', 'task_tracker', null),
       ('PR2', 'PROJECT-2', 'test project 2', 'task_tracker', 1);

insert into "sprint" ("status_code", "startpoint", "endpoint", "code", "project_id")
values ('finished', '2023-05-01 08:05:10', '2023-05-07 17:10:01', 'SP-1.001', 1),
       ('active', '2023-05-01 08:06:00', null, 'SP-1.002', 1),
       ('active', '2023-05-01 08:07:00', null, 'SP-1.003', 1),
       ('planning', '2023-05-01 08:08:00', null, 'SP-1.004', 1),
       ('active', '2023-05-10 08:06:00', null, 'SP-2.001', 2),
       ('planning', '2023-05-10 08:07:00', null, 'SP-2.002', 2),
       ('planning', '2023-05-10 08:08:00', null, 'SP-2.003', 2);

insert into "task" ("title", "type_code", "status_code", "project_id", "sprint_id", "startpoint")
values ('Data', 'epic', 'in_progress', 1, 1, '2023-05-15 09:05:10'),
       ('Trees', 'epic', 'in_progress', 1, 1, '2023-05-15 12:05:10'),
       ('task-3', 'task', 'ready_for_test', 2, 5, '2023-06-14 09:28:10'),
       ('task-4', 'task', 'ready_for_review', 2, 5, '2023-06-14 09:28:10'),
       ('task-5', 'task', 'todo', 2, 5, '2023-06-14 09:28:10'),
       ('task-6', 'task', 'done', 2, 5, '2023-06-14 09:28:10'),
       ('task-7', 'task', 'canceled', 2, 5, '2023-06-14 09:28:10');


insert into "activity"("author_id", "task_id", "updated", "comment", "title", "description", "estimate", "type_code", "status_code", "priority_code")
values (1, 1, '2023-05-15 09:05:10', null, 'Data', null, 3, 'epic', 'in_progress', 'low'),
       (2, 1, '2023-05-15 12:25:10', null, 'Data', null, null, null, null, 'normal'),
       (1, 1, '2023-05-15 14:05:10', null, 'Data', null, 4, null, null, null),
       (1, 2, '2023-05-15 12:05:10', null, 'Trees', 'Trees desc', 4, 'epic', 'in_progress', 'normal');

insert into "user_belong" ("object_id", "object_type", "user_id", "user_type_code", "startpoint", "endpoint")
values (1, 2, 2, 'task_developer', '2023-06-14 08:35:10', '2023-06-14 08:55:00'),
       (1, 2, 2, 'task_reviewer', '2023-06-14 09:35:10', null),
       (1, 2, 1, 'task_developer', '2023-06-12 11:40:00', '2023-06-12 12:35:00'),
       (1, 2, 1, 'task_tester', '2023-06-14 15:20:00', null),
       (2, 2, 2, 'task_developer', '2023-06-08 07:10:00', null),
       (2, 2, 1, 'task_developer', '2023-06-09 14:48:00', null),
       (2, 2, 1, 'task_tester', '2023-06-10 16:37:00', null);
