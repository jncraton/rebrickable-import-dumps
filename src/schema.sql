create table if not exists themes (
  id numeric primary key,
  name text,
  parent_id numeric
);

create table if not exists colors (
  id numeric primary key,
  name text,
  rgb text,
  is_trans text
);

create table if not exists part_categories (
  id numeric primary key,
  name text
);

create table if not exists parts (
  part_num text primary key,
  name text,
  part_cat_id text
);

create table if not exists inventories (
  id int primary key,
  version int,
  set_num text
);

create table if not exists sets (
  set_num numeric primary key,
  name text,
  year text,
  theme_id int,
  num_parts int
);

create table if not exists inventory_parts (
  inventory_id numeric,
  part_num text,
  color_id numeric,
  quantity int,
  is_spare int
);

create table if not exists inventory_sets (
  inventory_id numeric,
  set_num text,
  quantity int
);

create view if not exists set_parts
as 
select 
  set_num,
  inventory_id, 
  part_num, 
  color_id, 
  quantity, 
  is_spare
from inventory_parts 
join inventories on inventories.id = inventory_parts.inventory_id
where inventory_id in (
  select inventories.id from inventories
  inner join (
    select id, max(version) as version
    from inventories
    group by id
  ) g
  on inventories.id = g.id
  and inventories.version = g.version
);