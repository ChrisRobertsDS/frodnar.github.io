SELECT
   p.id,
     ARRAY_LENGTH(p.research_org_countries) AS num_countries,
  p.research_org_countries,
  p.research_org_country_names,
  ARRAY_TO_STRING(p.research_org_country_names, " / ") AS country_list,
   p.title.preferred AS title,
   p.doi,
   COALESCE(p.journal.title, p.proceedings_title.preferred, p.book_title.preferred, p.book_series_title.preferred) AS venue,
   p.type,
   p.date_inserted,
   p.authors,
   p.altmetrics.score AS altmetrics_score,
   p.metrics.times_cited
FROM
   `covid-19-dimensions-ai.data.publications` p
WHERE
   EXTRACT(YEAR FROM date_inserted) >= 2020
   AND
     ARRAY_LENGTH(research_org_countries) > 1
  AND p.id IN (
  SELECT
    p.id
  FROM
    `covid-19-dimensions-ai.data.publications` AS p
  LEFT JOIN
    UNNEST(research_org_countries) AS countries
  WHERE
    countries = 'US')
ORDER BY
  num_countries DESC;