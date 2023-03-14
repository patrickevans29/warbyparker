SELECT *
 FROM survey
 LIMIT 10;

 SELECT question AS 'question', 
    COUNT(*) AS 'number_of_responses'
 FROM survey
 GROUP BY question;

SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;

WITH ab AS (SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on',
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id)
SELECT *
FROM ab
LIMIT 10;

/* Calculate overall conversion rates */

WITH q AS (
  SELECT '1 - Quiz' AS stage,
    COUNT(DISTINCT user_id)
  FROM quiz),
h AS (  
  SELECT '2 - Home Try On' AS stage,
    COUNT(DISTINCT user_id)
  FROM home_try_on),
p AS (
  SELECT '3 - Purchase' AS stage,
    COUNT(DISTINCT user_id)
  FROM purchase)
SELECT * 
FROM q
UNION ALL SELECT *
FROM h
UNION ALL SELECT *
FROM p;

/* Calculate difference between AB trial */
WITH ab AS (SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on',
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id)
SELECT number_of_pairs, COUNT(is_purchase) AS 'home_try', SUM(is_purchase) AS 'purchase'
FROM ab
WHERE number_of_pairs IS NOT NULL
GROUP BY 1;