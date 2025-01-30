/**
  @ForpoS7
*/
 
insert into users (nickname, email, password)
select first_part || second_part,
       (first_part || second_part) || '@mail.ru',
       md5(random()::text)
from (select unnest(array[
    'Dark',
    'Shadow',
    'Ghost',
    'Storm',
    'Fire',
    'Ice',
    'Phantom',
    'Sonic',
    'Midnight',
    'Raven',
    'Wolf',
    'Dragon',
    'Star',
    'Moon',
    'Sunset',
    'Night',
    'Frost',
    'Thunder',
    'Lightning'
    ]) as first_part) as f
         cross join
     (select unnest(array[
         'Lord',
         'Master',
         'Hunter',
         'Chaser',
         'Fly',
         'Queen',
         'Pain',
         'Boom',
         'Sun',
         'Black',
         'Pack',
         'Born',
         'Light',
         'Beam',
         'Dream',
         'Shade',
         'Bite',
         'Bolt',
         'Strike'
         ]) as second_part) as s
order by random();

INSERT INTO guides (nickname, description)
SELECT first_part_nickname || second_part_nickname,
       first_part_description || second_part_description
FROM (SELECT unnest(array[
    'Dark',
    'Shadow',
    'Ghost',
    'Storm',
    'Fire'
    ]) as first_part_nickname) as fn
         CROSS JOIN
     (SELECT unnest(array[
         'Lord',
         'Master',
         'Hunter',
         'Chaser',
         'Fly'
         ]) as second_part_nickname) as sn
         CROSS JOIN
     (SELECT unnest(array[
         'Опытный',
         'Профессиональный',
         'Квалифицированный',
         'Лучший',
         'Высококвалифицированный'
         ]) as first_part_description) as fd
         CROSS JOIN
     (SELECT unnest(array[
         ' гид по городу',
         ' гид по стране',
         ' гид по миру',
         ' гид по истории',
         ' гид по культуре'
         ]) as second_part_description) as sd;

INSERT INTO guide_channels (link, logo, guide_id)
WITH generated_links AS (
    SELECT
        'https://' || first_part_link || '.' || second_part_link AS link,
        '/images/logos/' || first_part_logo || second_part_logo || '.png' AS logo,
        ROW_NUMBER() OVER () AS rn
    FROM (SELECT unnest(array['youtube', 'twitch', 'facebook', 'instagram', 'tiktok']) AS first_part_link) AS fli
             CROSS JOIN (SELECT unnest(array['com', 'ru', 'net', 'io', 'tv']) AS second_part_link) AS sli
             CROSS JOIN (SELECT unnest(array['logo_', 'icon_', 'image_', 'picture_', 'avatar_']) AS first_part_logo) AS flo
             CROSS JOIN (SELECT unnest(array['1', '2', '3', '4', '5']) AS second_part_logo) AS slo
),
     random_guides AS (
         SELECT id, ROW_NUMBER() OVER (ORDER BY RANDOM()) as rn
         FROM guides
         LIMIT 150
     )
SELECT gl.link, gl.logo, rg.id
FROM generated_links gl
         JOIN random_guides rg ON gl.rn = rg.rn;

INSERT INTO regions (rus_name, description_path, eng_name, short_description)
SELECT rus_name, '/regions/descriptions/' || eng_name || '.txt', eng_name, short_description
FROM (SELECT unnest(array[
    'Токио',
    'Киото',
    'Осака',
    'Хиросима',
    'Фукуока',
    'Саппоро',
    'Нагоя',
    'Кобе',
    'Йокогама',
    'Сендай',
    'Кумамото',
    'Оита',
    'Миядзаки'
    ]) as rus_name) as r
         CROSS JOIN
     (SELECT unnest(array[
         'Крупнейший город Японии',
         'Культурная столица Японии',
         'Город гурманов',
         'Город мира',
         'Город замков',
         'Снежная столица',
         'Город автомобилей',
         'Город моды',
         'Город портов',
         'Город фестивалей',
         'Город вулканов',
         'Город горячих источников',
         'Город пляжей'
         ]) as short_description) as s
         CROSS JOIN LATERAL (
    SELECT CASE
               WHEN rus_name = 'Токио' THEN 'Tokyo'
               WHEN rus_name = 'Киото' THEN 'Kyoto'
               WHEN rus_name = 'Осака' THEN 'Osaka'
               WHEN rus_name = 'Хиросима' THEN 'Hiroshima'
               WHEN rus_name = 'Фукуока' THEN 'Fukuoka'
               WHEN rus_name = 'Саппоро' THEN 'Sapporo'
               WHEN rus_name = 'Нагоя' THEN 'Nagoya'
               WHEN rus_name = 'Кобе' THEN 'Kobe'
               WHEN rus_name = 'Йокогама' THEN 'Yokohama'
               WHEN rus_name = 'Сендай' THEN 'Sendai'
               WHEN rus_name = 'Кумамото' THEN 'Kumamoto'
               WHEN rus_name = 'Оита' THEN 'Oita'
               WHEN rus_name = 'Миядзаки' THEN 'Miyazaki'
               END as eng_name
    ) as e;

INSERT INTO prefectures (name, description, capital, region_id, population, area)
WITH generated_prefectures as (
    SELECT name, description, capital, ROW_NUMBER() OVER () AS rn, population, area
    FROM (SELECT unnest(array[
        'Айти',
        'Вакаяма',
        'Гифу',
        'Ибараки',
        'Кагосима'
        ]) as name) as n
             CROSS JOIN
         (SELECT unnest(array[
             'Крупнейшая префектура Японии',
             'Префектура с самым большим количеством островов',
             'Префектура с средним уровнем жизни'
             ]) as description) as d
             CROSS JOIN
         (SELECT unnest(array[
             'Нагоя',
             'Акита',
             'Вакаяма'
             ]) as capital) as c
             CROSS JOIN
         (SELECT unnest(array[
             1000000,
             2000000
             ]) as population) as p
             CROSS JOIN
         (SELECT unnest(array[
             1000.0,
             3000.0
             ]) as area) as a
),
     random_regions AS (
         SELECT id, ROW_NUMBER() OVER (ORDER BY RANDOM()) as rn
         FROM regions
         LIMIT 169
     )
SELECT gp.name, gp.description, gp.capital, rr.id, gp.population, gp.area
FROM generated_prefectures gp
         JOIN random_regions rr ON gp.rn = rr.rn;
