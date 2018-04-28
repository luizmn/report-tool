/* Here is all the code used to create the views */
/* Execute it after importing/creating the database */
/* Create function to calculate error percentage */

CREATE OR REPLACE FUNCTION error_ratio(v1 decimal, v2 decimal)
RETURNS decimal AS $$
BEGIN
  RETURN ROUND(((v1 / v2) * 100.0)::numeric,2);
END;
$$ LANGUAGE PLPGSQL;

/* Create view with most read articles */
CREATE VIEW top_articles AS (
  SELECT a.title,
         COUNT(PATH) AS views
  FROM log l,
       articles a
  WHERE (SPLIT_PART(l.path, '/', 3)) = a.slug
  GROUP BY l.path,
           a.title
  ORDER BY views DESC
);

/* Create view with most read authors */
CREATE VIEW top_authors AS (
  SELECT n.name,
         COUNT(n.name) AS views
  FROM log l,
       articles a,
       authors n
  WHERE n.id=a.author
  and L.PATH=CONCAT('/article/', a.slug)
  GROUP BY n.name
  ORDER BY views DESC
);

/* Create view with all access by days */
CREATE VIEW total_views AS (
  SELECT COUNT(status) AS numviews,
         time::TIMESTAMP::date AS date
  FROM log
  GROUP BY date
);

/* Create view with access, and error rates ordered by errors value */
CREATE VIEW access_info AS (
  SELECT TO_CHAR((l.time::TIMESTAMP::date), 'Month DD,YYYY') AS access_date,
         tv.numviews,
         COUNT(l.status) AS total_errors,
         error_ratio(COUNT(l.status),
         tv.numviews) AS rate
  FROM log l,
       total_views tv
  WHERE status!='200 OK'
  AND tv.date=(l.time::TIMESTAMP::date)
  GROUP BY access_date,
           tv.numviews,
           tv.date
  HAVING (error_ratio(COUNT(l.status), tv.numviews)) >= 1
  ORDER BY total_errors DESC
);
