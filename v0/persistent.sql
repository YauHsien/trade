
create database perstest;

create user perstestuser;
alter user perstestuser with encrypted password '123@123@123';

\connect perstest

create extension if not exists "uuid-ossp";

create table "user" (
  id uuid default uuid_generate_v4(),
  primary key (id)
);

-- 採購單
create table procurement (
  id uuid default uuid_generate_v4(),
  "type" smallint not null, -- 1:旅遊代購 2:發貨處
  created_at timestamp,
  started_at timestamp, -- 旅遊代購：啟程時間 發貨處：團購開始時間
  ontime_at timestamp, -- 旅遊代購：返程結束時間 發貨處：團購結束時間
  due_at timestamp, -- ｛旅遊代購，發貨處｝：發貨結束時間
  user_id uuid,
  primary key (id)
);

create table procurement_item (
  id uuid default uuid_generate_v4(),
  procurement_id uuid,
  item varchar(64),
  bought_from varchar(64),
  "count" smallint,
  price money, -- 真實價格
  lowest_price money, -- 揭露的最低價格
  highest_price money, -- 揭露的最高價格
  primary key (id)
);

-- 需求單
create table requirement (
  id uuid default uuid_generate_v4(),
  created_at timestamp,
  user_id uuid,
  primary key (id)
);

create table requirement_item (
  id uuid default uuid_generate_v4(),
  requirement_id uuid,
  item varchar(64),
  bought_from varchar(64),
  "count" smallint,
  pay_amount money, -- 真實費用
  lowest_pay_amount money, -- 揭露的最低費用
  highest_pay_amount money, -- 揭露的最高費用
  primary key (id)
);

-- 採購單想滿足需求單的場合
create table procurement_matching_requirement (
  procurement_id uuid,
  requirement_id uuid,
  create_at timestamp,
  consent_due_at timestamp, -- 限時同意時間
  consented_at timestamp, -- 成交時間
  unique (procurement_id, requirement_id)
);

-- 需求單想滿足採購單的場合
create table requirement_matching_procurement (
  requirement_id uuid,
  procurement_id uuid,
  create_at timestamp,
  consent_due_at timestamp, -- 限時同意時間
  consented_at timestamp, -- 成交時間
  unique (requirement_id, procurement_id)
);

grant all privileges on all tables in schema public to perstestuser;
