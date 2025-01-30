/**
  @ForpoS7
 */
 -- PK users
BEGIN TRANSACTION;
ALTER TABLE users DROP CONSTRAINT IF EXISTS users_pkey;

ALTER TABLE users ADD PRIMARY KEY (email);

ALTER TABLE users DROP COLUMN id;
COMMIT;

-- ROLLBACK PK users
BEGIN TRANSACTION;
ALTER TABLE users DROP CONSTRAINT IF EXISTS users_pkey;

ALTER TABLE users ADD COLUMN id SERIAL;

ALTER TABLE users ADD PRIMARY KEY (id);
COMMIT;

-- PK prefectures
BEGIN TRANSACTION;
ALTER TABLE prefectures DROP CONSTRAINT IF EXISTS prefectures_pkey;

ALTER TABLE prefectures ADD PRIMARY KEY (name, capital);

ALTER TABLE prefectures DROP COLUMN id;
COMMIT;

-- ROLLBACK PK prefectures
BEGIN TRANSACTION;
ALTER TABLE prefectures DROP CONSTRAINT IF EXISTS prefectures_pkey;

ALTER TABLE prefectures ADD COLUMN id serial;

ALTER TABLE prefectures ADD PRIMARY KEY (id);
COMMIT;

-- PK regions and FK prefectures
BEGIN TRANSACTION;
ALTER TABLE prefectures ADD COLUMN region_rus_name VARCHAR(50);

UPDATE prefectures p SET region_rus_name = r.rus_name
FROM regions r
WHERE r.id = p.region_id;

ALTER TABLE prefectures DROP CONSTRAINT IF EXISTS prefectures_region_id_fkey;

ALTER TABLE prefectures DROP COLUMN region_id;

ALTER TABLE regions DROP CONSTRAINT IF EXISTS regions_pkey;

ALTER TABLE regions ADD PRIMARY KEY (rus_name);

ALTER TABLE regions DROP COLUMN id;

ALTER TABLE prefectures
ADD FOREIGN KEY (region_rus_name)
REFERENCES regions(rus_name);
COMMIT;

-- ROLLBACK PK regions and FK prefectures
BEGIN TRANSACTION;
ALTER TABLE prefectures ADD COLUMN region_id int;

ALTER TABLE prefectures DROP CONSTRAINT IF EXISTS prefectures_region_rus_name_fkey;

ALTER TABLE regions DROP CONSTRAINT IF EXISTS regions_pkey;

ALTER TABLE regions ADD COLUMN id serial;

ALTER TABLE regions ADD PRIMARY KEY (id);

UPDATE prefectures p SET region_id = r.id
FROM regions r
WHERE r.rus_name = p.region_rus_name;

ALTER TABLE prefectures
ADD FOREIGN KEY (region_id)
REFERENCES regions(id);

ALTER TABLE prefectures DROP COLUMN region_rus_name;
COMMIT;

-- PK guide_channels
BEGIN TRANSACTION;
ALTER TABLE guide_channels DROP CONSTRAINT IF EXISTS guide_channels_pkey;

ALTER TABLE guide_channels ADD PRIMARY KEY (link);

ALTER TABLE guide_channels DROP COLUMN id;
COMMIT;

-- ROLLBACK PK guide_channels
BEGIN TRANSACTION;
ALTER TABLE guide_channels DROP CONSTRAINT IF EXISTS guide_channels_pkey;

ALTER TABLE guide_channels ADD COLUMN id serial;

ALTER TABLE guide_channels ADD PRIMARY KEY (id);
COMMIT;

-- PK guide and FK guide_channels
BEGIN TRANSACTION;
ALTER TABLE guide_channels ADD COLUMN guide_nickname varchar(255);
ALTER TABLE guide_channels ADD COLUMN guide_description text;

UPDATE guide_channels SET guide_nickname = g.nickname, guide_description = g.description
FROM guides g
WHERE guide_channels.guide_id = g.id;

ALTER TABLE guide_channels DROP CONSTRAINT IF EXISTS guide_channels_guide_id_fkey;

ALTER TABLE guide_channels DROP COLUMN guide_id;

ALTER TABLE guides DROP CONSTRAINT guides_pkey;

ALTER TABLE guides DROP COLUMN id;

ALTER TABLE guides ADD PRIMARY KEY (nickname, description);

ALTER TABLE guide_channels
ADD CONSTRAINT fk_guide_nickname_description
FOREIGN KEY (guide_nickname, guide_description)
REFERENCES guides(nickname, description);
COMMIT;

-- ROLLBACK PK guide and FK guide_channels
BEGIN TRANSACTION;
ALTER TABLE guide_channels ADD COLUMN guide_id int;

ALTER TABLE guide_channels DROP CONSTRAINT IF EXISTS fk_guide_nickname_description;

ALTER TABLE guides DROP CONSTRAINT guides_pkey;

ALTER TABLE guides ADD COLUMN id SERIAL;

ALTER TABLE guides ADD PRIMARY KEY (id);

UPDATE guide_channels gc SET guide_id = g.id
FROM guides g
WHERE gc.guide_nickname = g.nickname and gc.guide_description = g.description;

ALTER TABLE guide_channels
ADD FOREIGN KEY (guide_id)
REFERENCES guides(id);

ALTER TABLE guide_channels DROP COLUMN guide_nickname;
ALTER TABLE guide_channels DROP COLUMN guide_description;
COMMIT;
