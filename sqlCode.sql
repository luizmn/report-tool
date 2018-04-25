/* Here is all the code used to create the views */
/* Execute it after importing/creating the database */

/* Create function to calculate error percentage */
CREATE OR REPLACE FUNCTION error_ratio(v1 decimal, v2 decimal)
RETURNS decimal AS $$
BEGIN
RETURN round(((v1 / v2) * 100.0)::numeric,2);
END;
$$ LANGUAGE plpgsql;

/* Create view with most read articles */
CREATE VIEW top_articles as (
SELECT a.title, count(path) as views
FROM log l, articles a
WHERE (split_part(l.path, '/', 3))=a.slug
GROUP BY l.path, a.title
ORDER BY views desc
);


/* Create view with most read authors */
CREATE VIEW top_authors as (
SELECT  n.name, count(n.name) as views
FROM log l, articles a, authors n
WHERE n.id=a.author
GROUP BY n.name
ORDER BY views desc
);

/* Create view with all access by days */
CREATE VIEW total_views as (
SELECT count(status) as numviews, time::timestamp::date as date
FROM log
GROUP BY date
);

/* Create view with access, and error rates ordered by errors value */
CREATE OR REPLACE VIEW access_info as (
SELECT TO_CHAR((l.time::timestamp::date), 'Month DD,YYYY') as access_date, tv.numviews, count(l.status) as total_errors, error_ratio(count(l.status), tv.numviews) as rate
FROM log l, total_views tv
WHERE status!='200 OK'
AND tv.date=(l.time::timestamp::date)
GROUP BY access_date, tv.numviews, tv.date
HAVING (error_ratio(count(l.status), tv.numviews)) >=1
ORDER BY total_errors DESC
);
