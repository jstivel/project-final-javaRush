--liquibase formatted sql

--changeset your_name:1-initial-drops
DROP TABLE IF EXISTS USER_ROLE;
DROP TABLE IF EXISTS CONTACT;
DROP TABLE IF EXISTS MAIL_CASE;
DROP TABLE IF EXISTS PROFILE;
DROP TABLE IF EXISTS TASK_TAG;
DROP TABLE IF EXISTS USER_BELONG;
DROP TABLE IF EXISTS ACTIVITY;
DROP TABLE IF EXISTS TASK;
DROP TABLE IF EXISTS SPRINT;
DROP TABLE IF EXISTS PROJECT;
DROP TABLE IF EXISTS REFERENCE;
DROP TABLE IF EXISTS ATTACHMENT;
DROP TABLE IF EXISTS USERS;

--changeset your_name:2-create-tables
create table PROJECT
(
  ID bigint auto_increment primary key,
  CODE        varchar(32)   not null unique,
  TITLE       varchar(1024) not null,
  DESCRIPTION varchar(4096) not null,
  TYPE_CODE   varchar(32)   not null,
  STARTPOINT  timestamp,
  ENDPOINT    timestamp,
  PARENT_ID   bigint,
  constraint FK_PROJECT_PARENT foreign key (PARENT_ID) references PROJECT (ID) on delete cascade
);

create table MAIL_CASE
(
  ID bigint auto_increment primary key,
  EMAIL     varchar(255) not null,
  NAME      varchar(255) not null,
  DATE_TIME timestamp    not null,
  RESULT    varchar(255) not null,
  TEMPLATE  varchar(255) not null
);

create table SPRINT
(
  ID bigint auto_increment primary key,
  STATUS_CODE varchar(32)   not null,
  STARTPOINT  timestamp,
  ENDPOINT    timestamp,
  TITLE       varchar(1024) not null,
  PROJECT_ID  bigint        not null,
  constraint FK_SPRINT_PROJECT foreign key (PROJECT_ID) references PROJECT (ID) on delete cascade
);

create table REFERENCE
(
  ID bigint auto_increment primary key,
  CODE       varchar(32)   not null,
  REF_TYPE   smallint      not null,
  ENDPOINT   timestamp,
  STARTPOINT timestamp,
  TITLE      varchar(1024) not null,
  AUX        varchar(255),
  constraint UK_REFERENCE_REF_TYPE_CODE unique (REF_TYPE, CODE)
);

create table USERS
(
  ID bigint auto_increment primary key,
  DISPLAY_NAME varchar(32)  not null unique,
  EMAIL        varchar(128) not null unique,
  FIRST_NAME   varchar(32)  not null,
  LAST_NAME    varchar(32),
  PASSWORD     varchar(128) not null,
  ENDPOINT     timestamp,
  STARTPOINT   timestamp
);

create table PROFILE
(
  ID                 bigint primary key,
  LAST_LOGIN         timestamp,
  LAST_FAILED_LOGIN  timestamp,
  MAIL_NOTIFICATIONS bigint,
  constraint FK_PROFILE_USERS foreign key (ID) references USERS (ID) on delete cascade
);

create table CONTACT
(
  ID    bigint       not null,
  CODE  varchar(32)  not null,
  VALUE varchar(256) not null,
  primary key (ID, CODE),
  constraint FK_CONTACT_PROFILE foreign key (ID) references PROFILE (ID) on delete cascade
);

create table TASK
(
  ID bigint auto_increment primary key,
  TITLE         varchar(1024) not null,
  DESCRIPTION   varchar(4096) not null,
  TYPE_CODE     varchar(32)   not null,
  STATUS_CODE   varchar(32)   not null,
  PRIORITY_CODE varchar(32)   not null,
  ESTIMATE      integer,
  UPDATED       timestamp,
  PROJECT_ID    bigint        not null,
  SPRINT_ID     bigint,
  PARENT_ID     bigint,
  STARTPOINT    timestamp,
  ENDPOINT      timestamp,
  constraint FK_TASK_SPRINT foreign key (SPRINT_ID) references SPRINT (ID) on delete set null,
  constraint FK_TASK_PROJECT foreign key (PROJECT_ID) references PROJECT (ID) on delete cascade,
  constraint FK_TASK_PARENT_TASK foreign key (PARENT_ID) references TASK (ID) on delete cascade
);

create table ACTIVITY
(
  ID bigint auto_increment primary key,
  AUTHOR_ID     bigint not null,
  TASK_ID       bigint not null,
  UPDATED       timestamp,
  COMMENT       varchar(4096),
  TITLE         varchar(1024),
  DESCRIPTION   varchar(4096),
  ESTIMATE      integer,
  TYPE_CODE     varchar(32),
  STATUS_CODE   varchar(32),
  PRIORITY_CODE varchar(32),
  constraint FK_ACTIVITY_USERS foreign key (AUTHOR_ID) references USERS (ID),
  constraint FK_ACTIVITY_TASK foreign key (TASK_ID) references TASK (ID) on delete cascade
);

create table TASK_TAG
(
  TASK_ID bigint      not null,
  TAG     varchar(32) not null,
  constraint UK_TASK_TAG unique (TASK_ID, TAG),
  constraint FK_TASK_TAG foreign key (TASK_ID) references TASK (ID) on delete cascade
);

create table USER_BELONG
(
  ID bigint auto_increment primary key,
  OBJECT_ID      bigint      not null,
  OBJECT_TYPE    smallint    not null,
  USER_ID        bigint      not null,
  USER_TYPE_CODE varchar(32) not null,
  STARTPOINT     timestamp,
  ENDPOINT       timestamp,
  constraint FK_USER_BELONG foreign key (USER_ID) references USERS (ID)
);
create unique index UK_USER_BELONG on USER_BELONG (OBJECT_ID, OBJECT_TYPE, USER_ID, USER_TYPE_CODE);
create index IX_USER_BELONG_USER_ID on USER_BELONG (USER_ID);

create table ATTACHMENT
(
  ID bigint auto_increment primary key,
  NAME        varchar(128)  not null,
  FILE_LINK   varchar(2048) not null,
  OBJECT_ID   bigint        not null,
  OBJECT_TYPE smallint      not null,
  USER_ID     bigint        not null,
  DATE_TIME   timestamp,
  constraint FK_ATTACHMENT foreign key (USER_ID) references USERS (ID)
);

create table USER_ROLE
(
  USER_ID bigint   not null,
  ROLE    smallint not null,
  constraint UK_USER_ROLE unique (USER_ID, ROLE),
  constraint FK_USER_ROLE foreign key (USER_ID) references USERS (ID) on delete cascade
);

--changeset your_name:3-initial-references
-- (los inserts los dejamos iguales porque funcionan en H2)
insert into REFERENCE (CODE, TITLE, REF_TYPE) values (...);

--changeset your_name:4-update-sprint-and-task
alter table SPRINT rename column TITLE to CODE;
alter table SPRINT alter column CODE varchar(32) not null;
create unique index UK_SPRINT_PROJECT_CODE on SPRINT (PROJECT_ID, CODE);

alter table TASK drop column DESCRIPTION;
alter table TASK drop column PRIORITY_CODE;
alter table TASK drop column ESTIMATE;
alter table TASK drop column UPDATED;

--changeset your_name:5-update-references-and-constraints
-- (igual que en tu script, funciona en H2)

--changeset your_name:6-update-task-type-and-index
-- Nota: H2 no soporta índices filtrados (where ENDPOINT is null)
-- Creamos índice normal
drop index UK_USER_BELONG;
create unique index UK_USER_BELONG on USER_BELONG (OBJECT_ID, OBJECT_TYPE, USER_ID, USER_TYPE_CODE);
