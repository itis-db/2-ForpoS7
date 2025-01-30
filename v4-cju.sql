/**
  @ForpoS7
 */

SELECT r.rus_name AS region_info, p.name AS additional_info
FROM prefectures p
         JOIN regions r ON p.region_id = r.id
WHERE p.population > 100000
UNION
SELECT r.description_path AS region_info, r.eng_name AS additional_info
FROM regions r
         JOIN prefectures p ON r.id = p.region_id
WHERE r.id < 10;
